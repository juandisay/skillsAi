# How to Set Up Sanity Environment Variables

This guide explains how to find and configure all necessary environment variables for your Next.js and Sanity.io integration using the [Sanity Dashboard](https://www.sanity.io/manage).

## 1. Finding Your Project ID and Dataset

1. Go to [Sanity Manage Dashboard](https://www.sanity.io/manage).
2. Select your Organization and then click on your **Project**.
3. On the project overview page, look for the **Project ID**.
   - Copy this value and assign it to `NEXT_PUBLIC_SANITY_PROJECT_ID`.
4. Click on the **Datasets** tab in the navigation menu.
5. You will see a list of your datasets (usually there is one named `production`).
   - Copy the dataset name and assign it to `NEXT_PUBLIC_SANITY_DATASET`.

## 2. Choosing an API Version

The API version is a date string that locks in the behavior of the Sanity API.
- You can typically use today's date in `YYYY-MM-DD` format (e.g., `2025-08-07`).
- Assign this date to `NEXT_PUBLIC_SANITY_API_VERSION`.

## 3. Creating API Tokens (Read and Write)

Tokens are required for the server to read draft content or mutate data.

1. In your project dashboard on [Sanity Manage](https://www.sanity.io/manage), click on the **API** tab.
2. Scroll down to the **Tokens** section and click **Add API token**.
3. **For the Read Token:**
   - Name it something like "Next.js Viewer Token".
   - Set the permissions to **Viewer**.
   - Click **Save** and copy the generated token.
   - Assign it to `SANITY_API_READ_TOKEN`.
4. **For the Write Token:**
   - Click **Add API token** again.
   - Name it something like "Next.js Editor Token".
   - Set the permissions to **Editor**.
   - Click **Save** and copy the generated token.
   - Assign it to `SANITY_API_WRITE_TOKEN`.
   - *Note: Treat this token like a password; never expose it to the browser.*

## 4. Setting the Project Title

This is simply a visual title used in the Sanity Studio UI.
- Pick a descriptive name for your CMS (e.g., `"Picket Ranch Blog"`).
- Assign it to `NEXT_PUBLIC_SANITY_PROJECT_TITLE`.

## 5. Configuring Webhooks and ISR Revalidation

Webhooks allow Sanity to tell Next.js when content changes so it can re-render static pages.

1. In your project dashboard, click on the **API** tab.
2. Scroll down to the **Webhooks** section and click **Create webhook**.
3. **Name**: e.g., "Next.js Revalidation"
4. **URL**:
   - For local development, this is typically `http://localhost:3000/api/revalidate`.
   - In production, it will be your live domain (e.g., `https://yourdomain.com/api/revalidate`).
   - Assign this URL to `SANITY_WEBHOOK` in your `.env`.
5. **Trigger on**: Select the events you want to trigger revalidation (usually Create, Update, and Delete).
6. **Filter**: Leave blank or set to `*[_type == "post"]` if you only want to revalidate specific document types.
7. **Projection**: Leave default (`{_id, _type}`).
8. **HTTP Method**: POST
9. **Secret**: 
   - Enter a random, secure string (e.g., `RANDOM_KEYS` or a generated UUID).
   - This secret ensures that only Sanity can trigger your webhook.
   - Copy this string and assign it to `SANITY_REVALIDATE_SECRET`.
10. Click **Save**.

---

### Final `.env.local` Example

Once you have completed these steps, your `.env.local` file should look like this:

```env
NEXT_PUBLIC_SANITY_PROJECT_ID=your_project_id
NEXT_PUBLIC_SANITY_DATASET=production
NEXT_PUBLIC_SANITY_API_VERSION=2025-08-07
SANITY_API_READ_TOKEN=your_viewer_token
SANITY_API_WRITE_TOKEN=your_editor_token
NEXT_PUBLIC_SANITY_PROJECT_TITLE="Picket Ranch Blog"
SANITY_REVALIDATE_SECRET="your_custom_secret_string"
SANITY_WEBHOOK=http://localhost:3000/api/revalidate
```
