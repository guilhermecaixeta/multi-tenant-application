# Multi-Tenant Application
## Table of Contents

1. [Introduction](#introduction)
2. [App Description](#app-description)
  - [Supported Modules](#supported-modules)
3. [Running Locally](#running-locally)
  - [Before Starting](#before-starting)
  - [Requirements](#requirements)
  - [Secrets](#secrets)
  - [Setup](#setup)
  - [Running the Application](#running-the-application)
4. [Deployment](#deployment)
5. [Next Goals](#next-goals)
6. [Summary](#summary)

---

## Introduction

This is a study project. To deploy it properly, consider using the [Secure Infrastructure Repo](https://github.com/guilhermecaixeta/secure-infrastructure). This repository fully supports deploying this application using CI/CD from GitHub when properly configured. Feel free to try it out and *submit suggestions*!

## App Description

This is a web application built with Rails 7, Turbo, and Stimulus. It uses [CoreUI](https://coreui.io/bootstrap/docs/getting-started/introduction/) as the admin template and [CoreUI Admin Template](https://coreui.io/bootstrap/docs/templates/admin-dashboard/) for the dashboard. The application leverages Importmap as the JavaScript package manager.

The application is modular and simplifies stock and sales management for small businesses. It supports multiple tenants, allowing several businesses to operate within a single app. Each business has its own schema for private data, ensuring security and preventing unauthorized access between tenants. Organizations and users are managed in a shared schema, along with a unified authorization system.

### Supported Modules

- **Backoffice** (Manages the application and tenants)
  - Application Management (not visible to organizations)
   - Roles
   - Permissions (read-only)
  - Catalog Management
   - Catalog Categories
   - Products
   - Services (WIP)
  - Organization Management
  - Sales Management
   - Product Sales
   - Service Sales (WIP)
  - Stock Management
   - Entries
   - Outputs (WIP)
   - Stocks
  - User Settings (not visible to organizations)

## Running Locally

This application is designed for use with Dev Containers and VS Code. It is highly recommended to use this setup, as it includes a default configuration with many useful features.

### Before Starting

Always use Unix-style line endings. If you're running the project on a Windows machine, configure Git with the following command:

```shell
git config --global core.autocrlf true
```

> ⚠️ All files in the `.devcontainers` folder must use LF line endings. CRLF endings will prevent Unix-based machines from running them.

### Requirements

- Docker or Podman
- VS Code (Recommended)
- VS Code Dev Containers extension

> ⚠️ After installing the extension, reopen VS Code to resolve any warnings or restart the extension manually.

### Secrets

The secrets are default and shared across all environments.

Secrets structure:

```yml
host:
  fallback: <localhost-fallback/>
devise:
  pepper_migration: true
  pepper: <your-pepper/>
  email_from: <default-mail-from/>  
redis:
  cache:
   url: <redis-cache-url/>
  worker:
   url: <redis-worker-url/>
postgres:
  host: postgres
  user: <your-db-user/>
  password: <your-db-password/>
  database: <your-db-database-name/>
```

### Setup

To set up the application locally, run the following command:

```shell
rails dev:setup
```

This command creates the necessary databases (if they don't already exist) and sets up all required data and users. Once completed, you can run all tests.

### Running the Application

To run the application, select the debug profile (`Ctrl + Shift + D`) and choose `[RDBG] Foreman Rails`. You can then access the application in your browser at port *3000*.

To retrieve user passwords, check the Mailcatcher interface at `http://localhost:1080`. If you cannot find the welcome emails, you can always recover the password.

Example users:
- `admin.master@acme.com`
- `operator.default@acme.com`

## Deployment

[WIP]

## Next Goals

To enhance this project, the following goals are planned:

- Complete the refactor to move validations from models to appropriate modules.
- Add support for missing fields in user and organization models.
- Finalize the output feature.
- Complete support for service-related features.
- Add CMS support (e.g., Spina or Strapi).
- Implement an order feature for products.
- Add a scheduling feature for services.
- Upgrade to the latest versions of Ruby and Rails.
- Increase test coverage.

---

## Summary

This project is a modular, multi-tenant Rails application designed to simplify stock and sales management for small businesses. It ensures data security through tenant-specific schemas and provides a unified management system for organizations and users. The application supports various modules, including catalog, sales, and stock management, with ongoing development to expand its features.

> **Tags:** `#Rails7` `#MultiTenant` `#DevContainers` `#SmallBusinessManagement` `#CoreUI`
