# Readapt

**AI-powered reading assistant designed to make written content more accessible for people with dyslexia.**

Readapt is a full-stack accessibility application that transforms text, PDFs and photographed content into a personalized reading experience using artificial intelligence, accessible typography, syllable support, text-to-speech and synchronized reading.

<p align="center">
  <img src="docs/screenshots/home.jpg" alt="Readapt home screen" width="340">
</p>

## From content to accessible reading

Readapt is designed around a simple idea: users should be able to bring content from wherever they encounter it and turn it into something easier to read.

Users can paste text, upload a PDF, or photograph printed content. Readapt extracts and processes the content, applies an AI accessibility transformation, and presents the result using the user's preferred reading settings.

<table>
<tr>
<td align="center"><strong>Paste text</strong></td>
<td align="center"><strong>Take a photo</strong></td>
</tr>
<tr>
<td><img src="docs/screenshots/paste-text.jpg" alt="Paste text into Readapt" width="300"></td>
<td><img src="docs/screenshots/take-photo.jpg" alt="Photograph text with Readapt" width="300"></td>
</tr>
</table>

## AI-powered adaptation

Readapt uses a Large Language Model to restructure complex written content while preserving its meaning. The transformation strategy favors shorter sentences, clearer structure and controlled vocabulary simplification while preserving names, dates, numbers, quotations and important technical information.

The adapted content can then be displayed with OpenDyslexic typography and optional syllable-based visual support.

<p align="center">
  <img src="docs/screenshots/adapted-reading.jpg" alt="AI-adapted reading experience in Readapt" width="340">
</p>

## Read and listen at the same time

Readapt combines text-to-speech with speech transcription and timing information to provide synchronized assisted reading. During playback, the relevant passage can be visually highlighted so users can follow the text while listening.

<p align="center">
  <img src="docs/screenshots/synchronized-reading.jpg" alt="Synchronized text and audio reading in Readapt" width="340">
</p>

## Personalized accessibility

Reading preferences are configurable rather than imposed. Users can adjust typography, text size, spacing, syllable coloration and visual palettes to create a reading environment that works for them.

<p align="center">
  <img src="docs/screenshots/settings.jpg" alt="Readapt accessibility settings" width="340">
</p>

## Readapt Ecosystem

Readapt is built as an accessibility ecosystem with two complementary products:

- **Readapt Web** — this Rails application provides AI-powered text adaptation, PDF and image processing, text-to-speech and synchronized assisted reading.
- **Readapt Chrome Extension** — adapts typography and reading layout directly on websites, with configurable fonts, spacing and a reading ruler.

Chrome Extension repository: https://github.com/TonyLawrence85/readapt-chrome-extension

## Core Features

- AI-powered text adaptation
- Paste-to-adapt workflow
- PDF text extraction
- Multimodal image-to-text processing
- OpenDyslexic and alternative reading fonts
- Syllable-based reading support
- Text-to-speech generation
- Audio/text synchronization
- Personalized reading settings
- Saved content and favourites
- User authentication and personal library

## AI Processing Pipeline

```text
User input
   |
   +--> Copied text
   |
   +--> PDF
   |
   +--> Image
           |
           v
     AI text extraction
           |
           v
     Text normalization
           |
           v
     AI accessibility transformation
           |
           v
     Reading formatting
           |
           v
     Text-to-Speech generation
           |
           v
     Audio transcription
           |
           v
     Text / audio synchronization
```

## Under the Hood

Readapt combines a conventional full-stack Rails architecture with AI, multimodal input and asynchronous media processing.

### Backend
- Ruby
- Ruby on Rails 8
- PostgreSQL
- Active Record
- Active Job
- Solid Queue
- Devise

### Frontend
- JavaScript
- Hotwire / Turbo / Stimulus
- Bootstrap 5
- HTML / SCSS

### Artificial Intelligence
- OpenAI API
- RubyLLM
- GPT multimodal models
- Whisper speech transcription

### Audio and File Processing
- Google Cloud Text-to-Speech
- OpenAI Whisper
- Active Storage
- PDF Reader
- Cloudinary
- Image Processing

### Infrastructure and Quality
- Docker
- Kamal
- Puma
- Git / GitHub
- RuboCop
- Brakeman
- Bundler Audit
- Dependabot

## Architecture

Readapt follows Rails MVC architecture with additional service objects and background jobs.

```text
app/
├── controllers/
├── models/
├── services/
├── jobs/
├── views/
├── javascript/
└── assets/
```

Selected domain logic is separated into service objects, including text formatting, syllabification and text-to-speech. Long-running audio processing is performed asynchronously using Active Job.

## Example Workflow

1. The user uploads a PDF, photograph, or text.
2. The content is extracted.
3. The AI analyzes and restructures the text.
4. The adapted version is stored in the database.
5. Optional syllable formatting is applied.
6. An asynchronous job generates the audio version.
7. Whisper analyzes the generated audio.
8. Readapt generates timestamps.
9. The adapted text and audio can be consumed together.

## AI Prompt Strategy

The AI transformation layer uses strict accessibility-oriented rules rather than unrestricted content generation. Instructions cover maximum sentence length, one idea per sentence, preservation of important factual information, controlled vocabulary simplification, no invented information and predictable output formatting.

This strategy helps reduce hallucination risk and produces a more consistent output structure for downstream processing.

## Background Processing

```text
Article created
      |
      v
AudioGenerationJob
      |
      +--> Text-to-Speech
      |
      +--> Audio attachment
      |
      +--> Whisper transcription
      |
      +--> Timestamp generation
      |
      v
Synchronized reading experience
```

Background jobs prevent longer AI and audio operations from blocking normal page requests.

## Security

The project uses Brakeman, Bundler Audit, Dependabot, environment variables for external API credentials and Devise for user authentication. API keys should never be stored directly in the repository.

## Local Installation

### Requirements
- Ruby
- Rails
- PostgreSQL
- OpenAI API key
- Google Cloud Text-to-Speech credentials

```bash
git clone https://github.com/TonyLawrence85/readapt.git
cd readapt
bundle install
bin/rails db:create
bin/rails db:migrate
bin/dev
```

Configure the required environment variables, including `OPENAI_API_KEY`. Additional credentials may be required for Google Cloud Text-to-Speech and Cloudinary.

## Testing and Code Quality

```bash
bin/rails test
bin/brakeman
bundle exec bundler-audit
bin/rubocop
```

## Deployment

Readapt supports containerized deployment. The repository includes Docker configuration, Kamal deployment tooling, Puma and production-oriented Rails infrastructure.

## Product Challenges

### Preserving meaning while simplifying text
The AI must improve readability without summarizing, removing essential information or inventing new content. This required strict prompt engineering and controlled output formatting.

### Combining multiple AI services
Readapt combines text generation, multimodal image understanding, text-to-speech and speech transcription through a Rails application.

### Audio/text synchronization
Generated audio is transcribed using Whisper and timing information is mapped back to adapted text to support synchronized reading.

## What This Project Demonstrates

Readapt demonstrates experience with full-stack web application development, Ruby on Rails architecture, relational databases, authentication, background jobs, file uploads, AI API integration, multimodal AI, prompt engineering, speech-to-text, text-to-speech, third-party APIs, asynchronous processing, deployment and accessibility-focused product design.

## Future Improvements

- improved word-level audio synchronization
- additional accessibility profiles
- multilingual support
- OCR improvements
- AI-generated reading exercises
- reading progress analytics
- educator and parent dashboards
- API access
- stronger automated test coverage
- CI/CD with GitHub Actions

## Project Status

Readapt is currently under active development. It was created during my transition into full-stack and AI software development and continues to evolve as a real-world AI product.

## Author

**Tony Lawrence**  
Full-Stack & AI Software Developer

Focus areas: Ruby on Rails, AI-powered web applications, OpenAI API integration, workflow automation and digital marketing.

GitHub: https://github.com/TonyLawrence85

## License

This project is currently intended for portfolio and demonstration purposes. All rights reserved unless otherwise stated.
