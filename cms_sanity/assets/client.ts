// cms_sanity/assets/client.ts
// AI INSTRUCTION: If a Sanity client already exists in the target project, adapt it safely instead of overwriting.
import { createClient } from "next-sanity";
import type { SanityClient } from "next-sanity";

// Configure the Sanity client for server‑side and client‑side usage
export const client = createClient({
  projectId: process.env.NEXT_PUBLIC_SANITY_PROJECT_ID!,
  dataset: process.env.NEXT_PUBLIC_SANITY_DATASET!,
  apiVersion: "2023-01-01", // stable API version
  useCdn: true, // `false` for preview/draft data
  token: process.env.SANITY_API_TOKEN,
});

export type Client = SanityClient;
export default client;
