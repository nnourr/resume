---
name: resume
description: Write, edit, and tailor resume bullet points. Use when the user wants to add experience, rewrite bullets, tailor for a job posting, or update metrics. Triggers on resume editing, bullet writing, job tailoring, or experience updates.
user-invocable: true
argument-hint: "[action or job description URL]"
allowed-tools: Read, Edit, Write, Bash, Grep, Glob, Agent
---

# Resume Builder Skill

You are helping Nour edit his resume. The resume is a JSON-to-LaTeX pipeline.

## Architecture

- **Config**: `config/sections.json` (main content), `config/heading.json` (contact info)
- **Generator**: `src/generate_resume.py` reads JSON, auto-escapes special chars (`&`, `%`, `$`, `#`, `_`, etc.), and generates LaTeX
- **Components**: `src/components/*.tex` — LaTeX templates for sections, subheadings, items
- **Research**: `sections/*.md` — detailed impact analysis files with Git/DB/PostHog metrics for each domain of work at Decoda Health
- **Compile**: Run `docker compose up` to generate the resume PDF

## Key Rules

### Escaping
The `generate_resume.py` script auto-escapes all special LaTeX characters. **Do NOT manually escape** `&`, `%`, `$`, `#`, `_`, `~`, `^`, `|`, `<`, `>` in `sections.json`. The only LaTeX you write directly is `\textbf{}` for bolding.

### Content Rules
- **Never use file/line counts** (e.g., "162 files changed, 22K insertions") as resume metrics. Only use real-world impact metrics: users served, hours saved, revenue impact, adoption rates, conversion lifts.
- Lead every bullet with a strong action verb (Engineered, Architected, Built, Designed, Drove, Established).
- Bold key technologies and metrics with `\textbf{}`.
- Keep bullets concise — 1-2 sentences max.
- Match the formatting style of existing bullets in the target section. Do not introduce bold category prefixes unless they are already used.

### JSON Structure

`sections.json` is an array of section objects:

```json
{
  "sectionName": "Experience",
  "subheadings": [
    {
      "company": "Company Name",
      "period": "Mon YYYY - Mon YYYY",
      "position": "Title | Tech Stack",
      "location": "City, ST",
      "resumeItems": ["bullet 1", "bullet 2"]
    }
  ]
}
```

Supported subheading fields: `company`, `period`, `position`, `location`, `techstack`, `resumeItems` (array of strings), `rawText` (for summaries).

## Task: $ARGUMENTS

### If tailoring for a job posting:
1. Read the job description (from $ARGUMENTS or ask for it)
2. Read `config/sections.json` for current resume state
3. Read relevant `sections/*.md` files for detailed metrics and impact data
4. Rewrite bullets to emphasize the skills, technologies, and impact most relevant to the target role
5. Preserve real metrics — never fabricate numbers
6. Show the user what changed and why

### If adding/editing experience:
1. Read `config/sections.json`
2. If adding Decoda work, check `sections/*.md` for detailed metrics and context
3. For new metrics, query the production database or PostHog:
   - **Learn query patterns first**: Grep inside `/Users/nour/decoda/` to understand how analytics and metrics queries are structured before writing your own. Search for SQLAlchemy models, PostHog query examples, view definitions, and connection patterns (e.g., `grep -r "posthog" /Users/nour/decoda/`, `grep -r "engine\|Session\|create_engine" /Users/nour/decoda/`). Use what you find as reference for building your own queries.
   - **Database**: Use `GOOGLE_CLOUD_PROJECT=decoda-397301 STORE_HOST=127.0.0.1 /Users/nour/decoda/.venv/bin/python` with SQLAlchemy (see `sections/*.md` or `/Users/nour/decoda/notebooks/db.ipynb` for connection patterns). **Query the `public.*_all` views** (e.g., `public.conversations_all`, `public.messages_all`) to get data across all tenants rather than tenant-scoped tables.
   - **PostHog**: Use `posthog-cli exp query run "SQL"` (credentials at `~/.posthog/credentials.json`). Grep `/Users/nour/decoda/` for PostHog event names and query examples to understand available events and properties.
   - **Git**: Use `git log` in `/Users/nour/decoda/` for commit history and PR stats
4. Write the bullet, edit `sections.json`, and validate JSON

### If reviewing/improving:
1. Read the current resume
2. Check for: weak verbs, missing metrics, redundant bullets, poor scannability
3. Suggest specific rewrites with reasoning

Always validate JSON after editing: `python3 -c "import json; json.load(open('config/sections.json'))"`
