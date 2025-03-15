# Resume Tailoring System

An AI-powered application that helps users tailor their resumes to specific job descriptions by extracting keywords and generating optimized content.

## Project Overview

This system allows users to:
- Upload their base resume
- Input or paste job descriptions
- Automatically extract keywords from job postings
- Generate tailored resume content optimized for ATS systems
- Track different versions of resumes for various job applications

## Tech Stack

- **Frontend**: React.js with Tailwind CSS
- **Backend**: Flask RESTful API
- **Database**: PostgreSQL with pgvector extension
- **AI Components**: NLP with spaCy, language models for content generation
- **Authentication**: JWT with social auth options (Google, LinkedIn, Apple)

## Repository Structure

The project follows a modular architecture with clear boundaries between components:

```
├── docs/                      # Project documentation
│   ├── blueprint/             # Project blueprint documents
│   ├── module-interfaces/     # Module interface specifications
│   └── session-tracking/      # Development session tracking
├── frontend/                  # React frontend application
├── backend/                   # Flask API server
└── ai-pipeline/               # AI processing components
```

## Development Approach

This project follows a modular development approach with clear interfaces between components. See the [Project Blueprint](docs/blueprint/PROJECT-BLUEPRINT.md) for detailed architectural information and development standards.

## Getting Started

Instructions for setting up the development environment will be added as modules are implemented.

## Module Status

Current development status is tracked in [IMPLEMENTATION-STATUS.md](docs/session-tracking/IMPLEMENTATION-STATUS.md).
