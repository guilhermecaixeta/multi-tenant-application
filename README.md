# Multi-Tenant Application

This is a study project in order to deploy it properly you should consider use [Secure Infrastructure Repo](https://github.com/guilhermecaixeta/secure-infrastructure).
This repo fully support the deploy of this application using CI/CD from github if properly configured.
Feel free to try and to *submit suggestions*!

# App Description

It's a web application built in rails 7 with Turbo and Stimulus, using as admin template [core-ui](https://coreui.io/bootstrap/docs/getting-started/introduction/) and [core-ui admin template](https://coreui.io/bootstrap/docs/templates/admin-dashboard/) and importmap as js package manager.

This application is a modular application that aims simplifies the stock and sales management for small business, it's composed by several projects (some of them still being implemented). Created to support many small business in one app, making usage of multi-tenant to manage all of them as well as giving a fine grain control for each business managers and operators to controls their own business from a single point access.

Each business has their own schema where the private data is persisted without affect the overall database and giving more security and reducing the unwanted access from other business. All the organizations and users are managed by the same schema, as well as same authorization system.

The current surpported modules are:
- Backoffice (Responsible to manage the application and the tenants)
  - Application Management (not visible for orgs)
    - Roles
    - Permissions (readonly)
  - Catalogs Management
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
  - Users Settings (not visible for orgs)

## Running locally

This application was designed and developed to make usage of devcontainers and vscode, so it's highly recommended to use this setup since there is a default setup support with many useful features.

### Before start

Always use unix-style endigns, so if you're running the project in a Windows machine run the command [^1]

[^1]: https://rubystyle.guide/#crlf

```shell
git config --global core.autocrlf true
```

### Requirements

- Docker\Podman
- VSCode (Recommended)´
- VsCode extension for Devcontainers

> ⚠️ Reopen the vscode once it finishes, this will fix the extension warnings modals or you can also just restart them.

### Secrets

The secrets here a default and same  for all environments.


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

In order to run the application locally you need to run the command before:

```shell
rails dev:setup
```

It will create the databases in case they does not exists as well as setup all the data needed and users.

Once this command finishes you should be able to run all tests.

### Running Application

To run the application you first need to select the debug profile (ctrl + shif + D) select `[RDBG] Foreman Rails` you should be able to access the application from browser on port *3000*

To know which password to use for the users:

- admin.master@acme.com
- operator.default@acme.com

You should access the url :`http://localhost:1080`, this url is from Mailcatcher should be used to visualize the emails sent from the app, also in case of you cannot see the Welcome emails you can always recover the password.

## Deploy

[WIP]