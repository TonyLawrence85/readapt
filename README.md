# Readapt

**AI-powered reading assistant designed to make written content more accessible for people with dyslexia.**

Readapt is a full-stack web application that uses artificial intelligence to transform written content into a more accessible reading experience.

Users can import text, upload PDF documents, or extract text from an image. Readapt then uses AI to simplify and restructure the content while preserving its original meaning. The application also generates audio playback and synchronized reading support.

## Why Readapt?

Reading long or complex texts can be difficult for people with dyslexia.

Readapt was designed to reduce cognitive load by combining:

- AI-powered text adaptation
- shorter and clearer sentences
- accessible formatting
- syllable-based reading support
- text-to-speech
- synchronized audio playback
- multiple content import methods

The goal is not to summarize the source material, but to make it easier to read while preserving its meaning.

## Main Features

### AI-powered text adaptation

Readapt uses a Large Language Model to transform complex content into a more accessible version. The AI is instructed to shorten long sentences, simplify complex vocabulary when appropriate, preserve technical terms, favor active voice, preserve names/dates/numbers/quotations, and keep the original meaning intact.

### Multiple input methods

Users can create readable content from:

- copied text
- PDF documents
- images and photos containing text

For image input, Readapt uses a multimodal AI model to extract visible text before processing it.

### PDF text extraction

PDF files can be uploaded directly to the platform. The application extracts the document text and sends it through the accessibility transformation pipeline.

### Image-to-text with AI

Users can upload a photo of printed text. Readapt uses an AI vision model to extract the text from the image and convert it into processable content.

### Text-to-speech and audio synchronization

Adapted content can be converted into audio. Readapt also generates timing information using speech transcription so the displayed text can be synchronized with audio playback for a guided reading experience.

### Personalized reading settings

The application supports personalized accessibility options such as syllable-based reading, adapted text formatting, and individualized display preferences.

### User accounts

Authentication is handled with Devise. Each user can save adapted texts, access previously processed content, mark texts as favourites, and manage personal reading settings.

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

## Tech Stack

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

Selected domain logic is separated into service objects, including text formatting, syllabification, and text-to-speech. Long-running audio processing is performed asynchronously using Active Job.

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

The AI transformation layer uses strict accessibility-oriented rules rather than unrestricted content generation. Instructions cover maximum sentence length, one idea per sentence, preservation of important factual information, controlled vocabulary simplification, no invented information, and predictable output formatting.

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

The project uses:

- Brakeman for Rails security analysis
- Bundler Audit for dependency vulnerability scanning
- Dependabot for dependency updates
- environment variables for external API credentials
- Devise for user authentication

API keys should never be stored directly in the repository.

## Local Installation

### Requirements

- Ruby
- Rails
- PostgreSQL
- OpenAI API key
- Google Cloud Text-to-Speech credentials

Clone the project:

```bash
git clone https://github.com/TonyLawrence85/readapt.git
cd readapt
```

Install dependencies:

```bash
bundle install
```

Create the database:

```bash
bin/rails db:create
bin/rails db:migrate
```

Configure the required environment variables, including:

```text
OPENAI_API_KEY=your_openai_api_key
```

Additional credentials may be required for Google Cloud Text-to-Speech and Cloudinary.

Start the application:

```bash
bin/dev
```

Then open `http://localhost:3000`.

## Testing and Code Quality

Run the Rails test suite:

```bash
bin/rails test
```

Run security analysis:

```bash
bin/brakeman
```

Run dependency auditing:

```bash
bundle exec bundler-audit
```

Run RuboCop:

```bash
bin/rubocop
```

## Deployment

Readapt supports containerized deployment. The repository includes Docker configuration, Kamal deployment tooling, Puma, and production-oriented Rails infrastructure.

## Product Challenges

### Preserving meaning while simplifying text

The AI must improve readability without summarizing, removing essential information, or inventing new content. This required strict prompt engineering and controlled output formatting.

### Combining multiple AI services

Readapt combines text generation, multimodal image understanding, text-to-speech, and speech transcription through a Rails application.

### Audio/text synchronization

Generated audio is transcribed using Whisper and timing information is mapped back to adapted text to support synchronized reading.

## What This Project Demonstrates

Readapt demonstrates experience with:

- full-stack web application development
- Ruby on Rails architecture
- relational databases
- authentication
- background jobs
- file uploads
- AI API integration
- multimodal AI
- prompt engineering
- speech-to-text
- text-to-speech
- third-party API integration
- asynchronous processing
- deployment
- accessibility-focused product design

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

Focus areas: Ruby on Rails, AI-powered web applications, OpenAI API integration, workflow automation, and digital marketing.

GitHub: https://github.com/TonyLawrence85

## License

This project is currently intended for portfolio and demonstration purposes.

All rights reserved unless otherwise stated.
