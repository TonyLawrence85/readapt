# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

```bash
bin/dev           # Start development server
bin/setup         # Initial environment setup
bin/rails db:prepare   # Prepare database
bin/rubocop       # Lint Ruby code (rubocop-rails-omakase rules)
bin/brakeman      # Security scan
bin/bundler-audit # Dependency vulnerability check
bin/jobs          # Start background job processor (Solid Queue)
bin/rails test                        # Run all tests
bin/rails test test/path/to/test.rb   # Run a single test file
```

## Architecture

**Rails 8 full-stack app** (Ruby 3.3.5, PostgreSQL) — helps people with dyslexia by AI-reformatting text into a more readable layout.

### Models

- **User** — Devise auth; `has_many :texts`, `has_one :setting` (auto-created on user creation)
- **Text** — Core entity: `content` (raw), `formatted_content` (AI HTML), `translated_content`; has one PDF via Active Storage
- **Setting** — Per-user display preferences (font family, letter-spacing, syllable colors); default font is OpenDyslexic

### Core Data Flow

1. User pastes text or uploads a PDF (`TextsController#create`)
2. If PDF: `pdf-reader` gem extracts text from the attachment
3. `ruby_llm` calls GitHub Copilot Models API (gpt-4o-mini via Azure endpoint) with a French-language dyslexia-optimization prompt
4. AI returns HTML with syllable `<span>` tags; stored in `Text#formatted_content`
5. `TextsController#show` renders with user's `Setting` (font, spacing, syllable colors)

### AI Integration

- Configured in `config/initializers/ruby_llm.rb` — uses GitHub token (`GITHUB_TOKEN` env var) to call `models.inference.ai.azure.com`
- Prompt is in `TextsController#build_prompt` (French): rewrites text for dyslexia with max-15-word sentences, syllable splitting via HTML spans, active voice, no double negatives
- Syllable spans cycle through 3 colors (red/green/blue) at display time in the view

### Frontend

- **Hotwire**: Turbo for navigation + Stimulus.js for interactivity
- **Importmap** (no bundler) for JS modules
- **Bootstrap 5.3** + custom SCSS in `app/assets/stylesheets/` (component-based: `components/`, `config/`)
- Font Awesome 6.5.0 via CDN

### Authentication

Devise manages all auth. `ApplicationController` requires authentication by default; `PagesController#home` is the only public page.

### Background / Storage

- **Solid Queue** for async jobs, **Solid Cache** for caching, **Solid Cable** for WebSockets — all DB-backed
- **Active Storage** handles PDF uploads (local storage in dev, configured in `config/storage.yml`)

### Deployment

Docker + Kamal — see `Dockerfile` and `config/deploy.yml`.

## Language Note

The UI, AI prompt, and locale files are in **French**. Keep new user-facing text in French.
