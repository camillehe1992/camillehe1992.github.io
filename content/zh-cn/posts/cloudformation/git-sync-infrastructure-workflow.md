---
title: "从 Git 到 CloudFormation：我的 Git Sync 基础设施工作流"
date: 2026-09-01T13:40:55+08:00
draft: false
description: "记录我如何把原本在 AWS portal 中手动创建的基础资源，逐步迁回到 Git 驱动的 CloudFormation Git Sync 工作流，并用更可审查、更可维护的方式管理后续变更。"
summary: "一次面向个人 AWS 环境的 GitOps 过渡实践：通过 CloudFormation 模板、deployment file 和 Git Sync，把手动维护的基础资源逐步纳入 Git 驱动的工作流。"
categories: [CloudFormation]
tags: [AWS, CloudFormation, Git Sync, GitOps, IAM, S3, Terraform]
author: "Camille He"
featuredImage: ""
featuredImageAlt: ""
series: []
slug: git-sync-infrastructure-workflow
---

## 概述

这篇文章记录的是一次很小但很实际的 GitOps 过渡。我没有从零重建一套新的 AWS 基础设施，而是把原本在 AWS portal 中手动创建和维护的基础资源，逐步迁回到 Git 驱动的 CloudFormation 工作流里。

因为相关仓库目前仍然是 private，正文会直接保留理解这次实践所必需的内容，包括设计动机、资源范围、目录结构、template 与 deployment 的拆分方式，以及 Git Sync 的工作流边界。重点不是展开完整源码，而是说明这次迁移为什么值得做、是如何组织起来的，以及它最终带来了什么变化。

## 背景

手动在控制台里创建资源很快，但后续维护并不轻松。配置分散在 portal 页面中，变更往往依赖记忆、截图或者临时记录。对于会长期使用、并且会被后续自动化依赖的基础资源来说，这种方式既不利于审查，也不容易复现。

我想做的并不是一次性把整个 AWS 环境重建成一套完整的 GitOps 平台，而是先从范围最小、价值最明确的部分开始：把少量关键基础资源写成 CloudFormation 模板，配上 deployment file，再通过 CloudFormation Git Sync 让 Git 成为后续变更的入口。在这里，Git 不只是配置备份，而是逐渐成为基础设施变更的边界。

## 架构 / 设计

### 这次实践当前管理什么

这次实践的范围很收敛，目前只管理两个基础 stack：

- 一个给 GitHub Actions 使用的 GitHub OIDC role
- 一个给 Terraform remote state 使用的 S3 backend

这两个 stack 对应的资源都属于“数量不多，但很关键”的基础设施。与其继续长期停留在 portal 里，更适合作为第一批被纳管进 Git 的对象。

### 为什么先从这两个 Stack 开始

这两个 stack 刚好对应了后续自动化里最基础的两个问题：身份入口和状态存储。

GitHub Actions 如果要安全地访问 AWS，就需要一个基于 OIDC 的 IAM role。只要后续继续使用 Terraform，remote state backend 就会是一个绕不过去的基础依赖。先把这两部分纳入 Git 驱动的管理方式，可以先稳定自动化的入口和状态基础，再考虑后续更大的扩展。

## 实现

### 仓库结构

下面是一个简化后的目录结构：

```text
aws-cfn-stacks/
├── stacks/
│   ├── github-oidc-role.yaml
│   └── terraform-state-backend.yaml
├── deployments/
│   ├── github-oidc-role-deployment.yaml
│   └── terraform-state-backend-deployment.yaml
├── docs/
│   ├── deployment-guide.md
│   ├── operations.md
│   └── git-sync-setup.md
└── .github/workflows/
    └── validate.yaml
```

`stacks/` 放 CloudFormation template，也就是资源定义。`deployments/` 放 Git Sync 使用的 deployment file，用来组织模板路径、参数和 tags。`docs/` 记录部署、运维和 Git Sync 的创建绑定过程。`.github/workflows/` 只做静态校验，不直接在 GitHub Actions 里部署 AWS 资源。

这种结构的好处是职责比较清楚：模板负责描述资源，deployment file 负责描述如何把这份定义接到 Git Sync 上，文档则负责解释整个工作流的边界和操作方式。

### Template 与 Deployment 的分离

这次实践里，一个关键设计是把资源定义和部署绑定信息拆开。template 专注资源定义，deployment file 则成为 Git Sync 绑定的入口。

这样 Git Sync 跟踪的不是一份孤立模板，而是一份能够明确描述模板路径和参数的部署文件。

### Git Sync 工作流如何运作

整个工作流并不复杂：

```text
Developer
    |
    v
Pull Request
    |
    v
GitHub Actions
    +--> cfn-lint
    +--> Checkov
    |
    v
Merge to main
    |
    v
CloudFormation Git Sync
    |
    v
CloudFormation Stack Update
```

在这个模型里，GitHub Actions 负责静态校验，而不是实际部署。模板变更先经过 pull request、lint 和安全扫描，再合并到 Git Sync 跟踪的分支。真正推动 AWS 中 stack 更新的，是 CloudFormation Git Sync，而不是 GitHub Actions 直接执行 apply 脚本。

这也是我比较喜欢这套流程的地方：GitHub 侧负责 review 和 validation，AWS 侧负责 stack 的同步和更新，职责边界比较清楚。

### Git Sync 的创建与绑定

Git Sync 的初始创建仍然需要在 AWS 中先完成一次绑定，高层步骤大致如下：

1. 准备好 template 和 deployment file。
2. 在 AWS CodeConnections 中创建与 Git 仓库的连接。
3. 在 CloudFormation 中选择 `Sync from Git`。
4. 绑定 repository、branch 和 deployment file path。
5. 完成首次同步配置后，让 Git Sync 持续跟踪后续 merge。

这篇文章不展开逐屏操作，因为那会让正文更像产品手册。更完整的步骤我已经单独整理进仓库文档里，这里只保留工作流视角。

## 配置示例

下面是一个简化后的 deployment file 示例：

```yaml
template-file-path: stacks/github-oidc-role.yaml
parameters:
  GitHubOIDCRoleName: GitHubAction-AssumeRoleWithAction
tags: {}
```

它对应的 template 中，真正定义资源的部分大致会像这样：

```yaml
Resources:
  GitHubActionAssumeRole:
    Type: AWS::IAM::Role
    Properties:
      RoleName: !Ref GitHubOIDCRoleName
```

这两个片段的作用不是展示完整模板语法，而是说明这次实践如何把“资源定义”和“部署绑定”分成两个层次，以便更清楚地接到 Git Sync 上。

## 验证

这次实践的价值，不在于一下子把多少 AWS 资源都纳入统一管理，而在于我开始把后续变更从 portal 页面迁回到 Git 中。

这样做首先带来了 Git 历史和 review 过程。其次，资源定义可以被写成模板和 deployment file，解释和复现都更容易。再往后看，如果还要继续把其他基础 stack 纳管进来，这里也已经有了一套可以复用的组织方式。

对个人 AWS 环境来说，这种小步推进比一开始就规划一个很大的 GitOps 平台更现实。它保留了原生 CloudFormation 的控制面，也让 Git 真正开始承担基础设施变更入口的角色。

## 经验总结

- 这并不是从零构建全部基础设施，而是把已经存在的手工资源逐步纳管进 Git。
- 当前范围仍然很小，只覆盖了两个 foundational stack，但已经足以验证这条工作流。
- Git Sync 自身的初始绑定过程依然需要在 AWS 控制台中完成，所以它不是一种“完全没有手工步骤”的理想化 GitOps。
- 对个人 AWS 环境来说，把关键资源先迁回 Git，比一开始就设计一个很大的平台化方案更现实。

## 参考资料

- [How Git sync works with CloudFormation](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/git-sync-concepts-terms.html)
- [Syncing stacks with source code stored in a Git repository with Git sync](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/git-sync.html)
- [Create a stack from repository source code with Git sync](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/git-sync-create-stack-from-repository-source-code.html)
- [Prerequisites for syncing stacks to a Git repository using Git sync](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/git-sync-prereq.html)
