// cms_sanity/assets/sanity.config.ts
// AI INSTRUCTION: If this file already exists in the target project, MERGE the configuration safely. DO NOT overwrite.
"use client"; // required for client‑side rendering of the Studio

import { defineConfig } from "sanity";
import { deskTool } from "sanity/desk";
import { visionTool } from "@sanity/vision";

export default defineConfig({
  name: "default",
  title: "Sanity Studio",
  projectId: process.env.NEXT_PUBLIC_SANITY_PROJECT_ID!,
  dataset: process.env.NEXT_PUBLIC_SANITY_DATASET!,
  basePath: "/studio", // matches the App Router catch‑all route
  plugins: [deskTool(), visionTool()],
  schema: {
    // Define your schema types here or import them
    types: [],
  },
});
