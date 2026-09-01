---
title: "From Git to CloudFormation: My Git Sync Infrastructure Workflow"
date: 2026-09-01T13:40:55+08:00
draft: false
description: "How I moved foundational AWS resources that were originally created in the AWS console into a Git-driven CloudFormation Git sync workflow, making later changes easier to review and maintain."
summary: "A small GitOps transition for personal AWS infrastructure: using CloudFormation templates, deployment files, and Git sync to bring manually managed foundational resources into a Git-driven workflow."
categories: [CloudFormation]
tags: [AWS, CloudFormation, Git Sync, GitOps, IAM, S3, Terraform]
author: "Camille He"
featuredImage: ""
featuredImageAlt: ""
series: []
slug: git-sync-infrastructure-workflow
---

## Overview

This article describes a small but practical GitOps transition. I did not rebuild a new AWS foundation from scratch. Instead, I moved foundational resources that had originally been created and maintained manually in the AWS portal into a Git-driven CloudFormation workflow.

Because the underlying repository is still private, this article includes the pieces needed to understand the design directly: the motivation, the scoped set of resources, the repository structure, the split between templates and deployment files, and the workflow boundaries around Git sync. The goal is not to expose the full source repository, but to explain why this migration was worth doing, how it was organized, and what changed as a result.

## Background

Creating resources manually in the console is fast, but maintaining them over time is not. Configuration ends up scattered across portal pages, and changes are often tracked through memory, screenshots, or temporary notes. For foundational resources that stay around and support later automation, that is not a great long-term operating model.

I was not trying to rebuild my whole AWS environment into a complete GitOps platform in one step. The goal was much smaller and more practical: define a few key foundational resources in CloudFormation, pair them with deployment files, and use CloudFormation Git sync so Git becomes the entry point for future changes. In this setup, Git is not just a backup of configuration. It starts to become the review boundary and the change boundary for the infrastructure.

## Architecture / Design

### What this repository manages

The scope of this effort is intentionally narrow. Right now it manages only two foundational stacks:

- a GitHub OIDC role for GitHub Actions
- an S3 backend for Terraform remote state

These resources are small in number, but important in practice. That makes them good candidates for the first Git-managed layer instead of leaving them only in the portal indefinitely.

### Why these two stacks came first

These two stacks map directly to two basic needs in later automation: identity and state storage.

If GitHub Actions needs to access AWS safely, it needs an OIDC-based IAM role. If Terraform remains part of the workflow, a remote state backend is foundational. Managing these first makes the automation entry point and the state layer more stable before expanding further.

## Implementation

### Repository structure

Here is a simplified view of the repository:

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

`stacks/` contains the CloudFormation templates, which define the resources themselves. `deployments/` contains the deployment files used by Git sync to organize template paths, parameters, and tags. `docs/` holds operational guidance, deployment notes, and the Git sync setup walkthrough. `.github/workflows/` only handles static validation and does not deploy AWS resources directly from GitHub Actions.

That structure keeps responsibilities clear: templates describe resources, deployment files describe how those definitions are wired into Git sync, and documentation explains the workflow boundaries.

### Template and deployment split

One important design choice in this repository is separating resource definitions from deployment binding data. The template focuses on the resources, while the deployment file becomes the Git sync entry point.

That means Git sync is not following an isolated template file only. It follows a deployment description that clearly identifies the template path and parameter values.

### How the Git sync workflow works

The workflow itself is simple:

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

In this model, GitHub Actions performs static validation rather than deployment. Template changes go through pull requests, linting, and security checks before they are merged into the branch monitored by Git sync. The actual AWS stack update is driven by CloudFormation Git sync, not by a direct apply step in GitHub Actions.

That split is one of the reasons I like this design. GitHub handles review and validation, while AWS handles stack synchronization and updates.

### Creating and binding Git sync

The initial Git sync setup still has to be created once in AWS. At a high level, the process looks like this:

1. Prepare the template and deployment file.
2. Create a connection to the Git repository in AWS CodeConnections.
3. Choose `Sync from Git` in CloudFormation.
4. Bind the repository, branch, and deployment file path.
5. Let Git sync continue monitoring later merges after the initial configuration is complete.

I do not expand this into a click-by-click walkthrough here because that would make the article read more like product documentation. The repository already contains a separate setup guide for that part.

## Configuration Examples

Here is a simplified deployment file example:

```yaml
template-file-path: stacks/github-oidc-role.yaml
parameters:
  GitHubOIDCRoleName: GitHubAction-AssumeRoleWithAction
tags: {}
```

The corresponding template snippet looks roughly like this:

```yaml
Resources:
  GitHubActionAssumeRole:
    Type: AWS::IAM::Role
    Properties:
      RoleName: !Ref GitHubOIDCRoleName
```

These examples are not meant to show the full template. They illustrate how this approach separates the resource definition layer from the Git sync deployment binding layer.

## Validation

The value of this work is not that I suddenly brought a large number of AWS resources under one control plane. The real value is that I started moving future changes out of portal-only operations and back into Git.

That gives future changes Git history and review. It makes the resource definitions easier to explain and reproduce. It also establishes a repeatable pattern if I decide to bring more foundational stacks under the same workflow later.

For a personal AWS environment, that kind of incremental move is more realistic than designing a large GitOps platform up front. It keeps the native CloudFormation control plane while making Git the place where infrastructure changes begin.

## Lessons Learned

- This is not a full rebuild of all infrastructure from scratch. It is a gradual move of existing manual resources into Git.
- The current scope is still small, but it is already enough to validate the workflow.
- Git sync itself still requires an initial setup step in the AWS console, so this is not an idealized zero-manual-step GitOps story.
- For personal AWS infrastructure, starting with a few critical resources is more practical than designing a large platform-first solution.

## References

- [How Git sync works with CloudFormation](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/git-sync-concepts-terms.html)
- [Syncing stacks with source code stored in a Git repository with Git sync](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/git-sync.html)
- [Create a stack from repository source code with Git sync](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/git-sync-create-stack-from-repository-source-code.html)
- [Prerequisites for syncing stacks to a Git repository using Git sync](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/git-sync-prereq.html)
