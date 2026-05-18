---
name: cms_sanity
description: A comprehensive skill package to integrate Sanity.io headless CMS into an existing Next.js application using the App Router.
---

# Sanity.io Integration Skill Package

## Description

A comprehensive skill package to integrate **Sanity.io** headless CMS into an existing Next.js application using the App Router. It provides scripts, configuration templates, a client, and documentation to quickly scaffold a Sanity Studio and connect it to your Next.js front‑end.

## Prerequisites

- Node.js >= 18
- A Next.js project (App Router) already set up
- Access to a Sanity.io project (account, dataset, project ID, and token)
- `npm` or `yarn` or `pnpm` available in the terminal

## Remote Execution (Online Loading)

This skill can be loaded directly from a remote URL (e.g., a GitHub Raw link). If you (the AI) are reading this file from a URL instead of a local directory:
1. Treat the base URL of this `SKILL.md` file as the root directory for the skill.
2. For all file references in the Execution Plan (such as `scripts/setup.sh` or `assets/sanity.config.ts`), asynchronously fetch them from the corresponding raw URLs relative to this file before applying them to ensure non-blocking resolution.

## System Prompt (for AI assistants)

```
You are a Sanity.io integrator. Your primary goal is to safely adapt and integrate Sanity into an EXISTING Next.js project. Follow the execution plan carefully.
- ALWAYS check if a file already exists before creating it (e.g., `sanity.config.ts`, `.env`, `.env.local`).
- DO NOT overwrite or destroy existing Next.js configurations or routing.
- Merge new configurations incrementally.
- Use the provided scripts and configuration templates as a baseline.
Ensure all TypeScript is strictly typed and environment variables are referenced securely. After setup, verify that `npm run dev` starts both Next.js and the Sanity Studio without errors.
```

## Environment Configuration

*For a step-by-step guide on locating these values in your Sanity dashboard, please refer to `cms_sanity/references/how-to-setup-conf.md`.*

When integrating Sanity into your Next.js project, populate `.env.local` at the root of your project with the following keys. Here is the template with all configuration names:

```env
NEXT_PUBLIC_SANITY_PROJECT_ID=[GCP_PROJECT_ID]
NEXT_PUBLIC_SANITY_DATASET=production
NEXT_PUBLIC_SANITY_API_VERSION=2025-08-07
SANITY_API_READ_TOKEN=
SANITY_API_WRITE_TOKEN=
NEXT_PUBLIC_SANITY_PROJECT_TITLE="Picket Ranch Blog"
SANITY_REVALIDATE_SECRET="RANDOM_KEYS"
SANITY_WEBHOOK=http://localhost:3000/api/revalidate
```

### Descriptions

**Public Configuration (Safe for browser):**
- `NEXT_PUBLIC_SANITY_PROJECT_ID`: The unique identifier for your Sanity.io project.
- `NEXT_PUBLIC_SANITY_DATASET`: The dataset within your Sanity project (usually `production`).
- `NEXT_PUBLIC_SANITY_API_VERSION`: The date-based API version (e.g., `2025-08-07`) to ensure API stability.
- `NEXT_PUBLIC_SANITY_PROJECT_TITLE`: The public title for your project, displayed in the Sanity Studio UI.

**Private API Tokens (Server-side ONLY):**
- `SANITY_API_READ_TOKEN`: A secure token with "Viewer" permissions, used for fetching drafts or private content.
- `SANITY_API_WRITE_TOKEN`: A highly sensitive token with "Editor" permissions, used for mutating content via the API.

**Webhook & Revalidation (ISR):**
- `SANITY_REVALIDATE_SECRET`: A secure, shared secret string used to authenticate webhook requests from Sanity.
- `SANITY_WEBHOOK`: The URL endpoint (e.g., `http://localhost:3000/api/revalidate`) where Sanity sends updates.

## Execution Plan

1. **Run the setup script** – `cms_sanity/scripts/setup.sh` will install dependencies. It is non-destructive and skips existing files.
2. **Configure the Studio** – Safely merge or copy `cms_sanity/assets/sanity.config.ts` into the project root, ensuring no existing config is overwritten.
3. **Create the data‑fetching client** – Safely copy `cms_sanity/assets/client.ts` to `src/sanity/client.ts`, checking for existence first.
4. **Add the Studio route** – In the Next.js app, create `app/studio/[[...slug]]/page.tsx`. Ensure you don't overwrite an existing Catch-All route if one exists.
5. **Verify** – Start the dev server (`npm run dev`) and confirm:
   - The Sanity Studio loads at your project's local URL (default is usually `http://localhost:3000/studio`, but adjust the port if your project uses a different one).
   - The Next.js pages can query data via the client.
6. **Read the architecture reference** – `cms_sanity/references/architecture.md` for deeper understanding.
7. **Configuration Setup Guide** – `cms_sanity/references/how-to-setup-conf.md` for a step-by-step tutorial on locating and setting up your environment variables.

After completing these steps, the Next.js project will have a fully functional Sanity Studio and typed data fetching ready for production.
