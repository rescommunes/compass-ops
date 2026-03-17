# Design & Architecture

## Main Rule 

All changes are reproducible via the helm and project configs. 

## Project Structure

```
project/
├── values/          # Helm configurations
├── charts/          # Custom charts and configs (not in standard chart repos)
└── env/             # Environment-specific variables
```

## Directory Responsibilities

### `values/`
Contains Helm configuration files. These are the base templates that define how services are deployed.

### `charts/`
Houses custom Helm charts and configurations that aren't available in standard chart repositories. This is where project-specific chart logic lives.

### `env/`
Simple variable files for environment configuration. The goal: implementation should be as easy as changing a variable.

## Philosophy

**Opinionated defaults** — most things should work out of the box with sensible defaults.

**Environment switching** — some values need to change between environments:
- **Dev**: Minikube, local testing, minimal resources
- **Prod**: Cloud provider, production hardening, scaled resources

## Agent Guidelines

When working with this codebase:
1. Read `env/` first to understand the target environment
2. Modify `values/` for Helm config changes
3. Add custom charts to `charts/` only when standard charts don't fit
4. Keep environment variables simple — changing environments should mean changing variables, not rewriting configs

## Consistency Rules

- Don't duplicate configs across directories
- Environment-specific values live in `env/`, not in `values/` or `charts/`
- Custom charts in `charts/` should be well-documented and minimal
