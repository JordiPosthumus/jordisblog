# How to Add New Posts to This Blog

This guide explains how to add new blog posts to Jordi's blog.

## Blog Structure Overview

The blog is built with Astro.js and uses the following structure:
- `src/pages/posts/` - Contains all blog post markdown files
- `src/layouts/BlogPost.astro` - Layout template for blog posts
- `public/` - Directory for static assets (images, charts, etc.)

## Creating a New Blog Post

### 1. Create the Markdown File

Create a new `.md` file in `/src/pages/posts/` with a descriptive name using kebab-case:
```
/src/pages/posts/my-new-blog-post.md
```

### 2. Add Frontmatter

Each post must include frontmatter at the top of the file:

```markdown
---
layout: ../../layouts/BlogPost.astro
title: "Your Post Title"
description: "Brief description of your post (used for SEO)"
pubDate: "YYYY-MM-DD"
---
```

### 3. Write Your Content

Write your blog post content using standard Markdown syntax. The layout will automatically:
- Apply proper styling to headings, paragraphs, lists, and links
- Format the title and publication date in the hero section
- Add a "Back to All Posts" link at the bottom

### 4. Adding Images

To add images:
1. Place image files in the `/public/` directory
2. Reference them in your markdown using relative paths:

```markdown
![Alt Text](/image-name.png)
```

## Example Post Structure

```markdown
---
layout: ../../layouts/BlogPost.astro
title: "Understanding Silver Market Dynamics"
description: "An analysis of factors affecting silver prices in 2025."
pubDate: "2025-12-11"
---

# Understanding Silver Market Dynamics

Your post content here...

## Subheading

More content...
```

## How Posts Appear on the Homepage

The homepage now automatically displays all blog posts in reverse chronological order (newest first). There's no need to manually update the homepage - it dynamically loads and sorts posts based on their `pubDate` field in the frontmatter.

Posts are displayed with:
- Title (linked to the full post)
- Publication date
- Description from the frontmatter

## Deploying Changes

After adding your post:
1. Commit your changes to git
2. Run the deployment script:

```bash
./deploy.sh
```

Or for quick deploys without full build verification:

```bash
./deploy-quick.sh
```

## Best Practices

1. **File naming**: Use descriptive, SEO-friendly names in kebab-case
2. **Images**: Optimize images for web before uploading (aim for <500KB)
3. **Frontmatter**: Always include all three required fields (layout, title, description, pubDate)
4. **Content**: Use proper heading hierarchy (H1 → H2 → H3 etc.)
5. **SEO**: Include relevant keywords in titles and descriptions
6. **Dates**: Use ISO format for publication dates (YYYY-MM-DD) - posts with future dates will still appear but be clearly marked

## Troubleshooting

If your post doesn't appear:
- Check that the file has `.md` extension
- Verify frontmatter is properly formatted with `---` delimiters
- Ensure the layout path is correct: `../../layouts/BlogPost.astro`
- Confirm the pubDate is in valid ISO format (YYYY-MM-DD)

For major issues, check the Astro documentation or review existing working posts as examples.