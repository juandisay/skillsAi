// cms_sanity/references/architecture.md
# Architecture Overview

This reference explains how to embed **Sanity Studio** inside a Next.js 14+ application that uses the **App Router**, and how to fetch data from Sanity using GROQ queries.

---

## 1. Embedding the Studio with a Catch‑All Route

Next.js App Router supports **catch‑all segments** (`[[...slug]]`).  By placing a page at `app/studio/[[...tool]]/page.tsx` we can forward **all** Studio sub‑routes (e.g. `/studio/desk`, `/studio/structure`) to a single component.

```tsx
// src/app/studio/[[...tool]]/page.tsx
import { NextStudio } from "next-sanity/studio";
import config from "../../../sanity.config";

export const dynamic = "force-static"; // static generation for the shell
export { metadata, viewport } from "next-sanity/studio";

export default function StudioPage() {
  return <NextStudio config={config} />;
}
```

### Why a catch‑all?
* **Single entry point** – All Studio URLs resolve to the same page, keeping Next.js routing simple.
* **Static shell** – `dynamic = "force-static"` ensures the HTML/CSS are pre‑rendered for the fastest first paint. Runtime data is fetched by the client‑side Studio.
* **Separate layout** – By nesting the route inside `app/studio`, you can give the Studio its own `layout.tsx` (e.g. without `SanityLive` or `VisualEditing`).

### Required file structure
```
src/
  app/
    studio/
      [[...tool]]/
        page.tsx   ← embeds the Studio
  sanity.config.ts   ← studio configuration (see next section)
```

---

## 2. Studio Configuration (`sanity.config.ts`)

The configuration tells Sanity where to find the project and which **basePath** the Studio is mounted at.  The `basePath` **must** match the route defined above (`/studio`).

```ts
// sanity.config.ts
import { defineConfig } from "sanity";

export default defineConfig({
  name: "default",
  projectId: process.env.NEXT_PUBLIC_SANITY_PROJECT_ID!,
  dataset: process.env.NEXT_PUBLIC_SANITY_DATASET!,
  basePath: "/studio", // matches the App Router route
  // Add plugins, schema types, etc. as needed
});
```

---

## 3. Fetching Content with GROQ

Sanity data is accessed via **GROQ** (Graph‑Relational Object Queries).  The `next-sanity` package provides a typed client that works with Next.js data‑fetching methods (`fetch`, `getStaticProps`, `getServerSideProps`).

### Example GROQ query
```ts
import { groq } from "next-sanity";

export const POSTS_QUERY = groq`
  *[_type == "post"] | order(_createdAt desc) {
    _id,
    title,
    slug,
    "authorName": author->name,
    mainImage,
    publishedAt
  }
`;
```

### Using the client
```ts
import { createClient } from "../sanity/client"; // see client.ts

export async function getPosts() {
  const client = createClient({
    // optionally pass {useCdn: true} for public data
  });
  return client.fetch(POSTS_QUERY);
}
```

---

## 4. Development Workflow
1. **Run `cms_sanity/scripts/setup.sh`** – safely installs `next-sanity` and scaffolds `src/sanity` without destroying existing configurations.
2. **Configure Environment** - Safely merge variables into `.env` or `.env.local` for project ID, dataset, and optional API token.
3. **Add the Studio route** (`app/studio/[[...tool]]/page.tsx`) ensuring you don't overwrite an existing Next.js catch-all route.
4. **Start the dev server** – `npm run dev`.  The Studio should be reachable at `http://localhost:3000/studio`.
5. **Query data** using the client and GROQ queries from your pages or API routes.

---

## 5. Production Considerations
* **Environment variables** – Keep `SANITY_API_TOKEN` secret; it should never be exposed to the client bundle.
* **Caching** – Use `useCdn: true` for public queries; for preview or draft content, omit it or set `useCdn: false`.
* **Deploy** – The Studio is bundled with your Next.js build, so a single Vercel/Netlify deployment serves both the front‑end and the editing UI.
