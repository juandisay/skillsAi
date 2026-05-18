// cms_sanity/scripts/setup.sh
#!/usr/bin/env bash

# This script automates the setup of Sanity.io integration for a Next.js project.
# It installs required packages, creates a .env.local template, and scaffolds the src/sanity directory.

set -euo pipefail

# Helper function for logging
log() {
  echo "[setup] $*"
}

# 1. Install dependencies
log "Installing next-sanity and @sanity/client..."
npm install next-sanity @sanity/client

# 2. Create .env.local template if it does not exist
ENV_FILE=".env.local"
if [ -f "$ENV_FILE" ]; then
  log ".env.local already exists – skipping creation."
else
  log "Creating .env.local template..."
  cat <<EOF > "$ENV_FILE"
# Sanity.io configuration – replace with your values
NEXT_PUBLIC_SANITY_PROJECT_ID=your_project_id
NEXT_PUBLIC_SANITY_DATASET=production
# Optional token for server‑side fetching (keep secret)
SANITY_API_TOKEN=your_api_token
EOF
  log ".env.local created."
fi

# 3. Scaffold src/sanity folder structure
SANITY_DIR="src/sanity"
if [ -d "$SANITY_DIR" ]; then
  log "src/sanity already exists – skipping scaffold."
else
  log "Scaffolding src/sanity directory..."
  mkdir -p "$SANITY_DIR"
  # Create placeholder index file
  cat <<EOF > "$SANITY_DIR/index.ts"
// Export the Sanity client for use throughout the app
export { createClient } from "./client";
EOF
  log "src/sanity scaffolded."
fi

log "Setup complete. Remember to:
  1️⃣ Fill in your actual project ID, dataset, and token in .env.local.
  2️⃣ Adjust the generated config files if needed.
  3️⃣ Add the Studio route as described in the documentation."
