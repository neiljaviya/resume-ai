# Resume Tailoring System Blueprint

## 1. System Architecture & Technical Vision

### Overview
A multi-tier application with dedicated components for:
- User-facing web application
- Backend API services
- AI processing pipeline
- Data storage and management

### High-Level Architecture Diagram
```
┌────────────────┐       ┌────────────────┐       ┌────────────────┐
│                │       │                │       │                │
│  Web Frontend  │◄─────►│  API Backend   │◄─────►│  AI Pipeline   │
│  (React)       │       │  (Flask)       │       │  (Python)      │
│                │       │                │       │                │
└────────────────┘       └────────────────┘       └────────────────┘
        ▲                        ▲                        ▲
        │                        │                        │
        ▼                        ▼                        ▼
┌────────────────┐       ┌────────────────┐       ┌────────────────┐
│                │       │                │       │                │
│  User Auth     │       │  PostgreSQL DB │       │  Document      │
│  Service       │       │  (User/App     │       │  Storage       │
│                │       │   Data)        │       │  (Resumes)     │
└────────────────┘       └────────────────┘       └────────────────┘
```

## 2. Module Isolation Strategy

To address the constraints of chat-based development, the system is designed with highly decoupled modules that can be developed independently. This allows targeted conversation sessions without requiring the entire project context in each chat.

### Module Breakdown
1. **Core Backend Module** - `[MODULE:CORE-BE]`
   - Database models and migrations
   - Flask application setup and configuration
   - Basic utilities and middleware

2. **Authentication Module** - `[MODULE:AUTH]`
   - User registration/login/logout
   - Social authentication providers
   - JWT token management

3. **Resume Management Module** - `[MODULE:RESUME]`
   - Resume uploading and versioning
   - Resume templates and formatting
   - Basic resume CRUD operations

4. **Job Processing Module** - `[MODULE:JOB]`
   - Job description parsing
   - Keyword extraction
   - Job-to-resume matching

5. **AI Tailoring Module** - `[MODULE:AI]`
   - NLP preprocessing
   - Model interaction/fine-tuning
   - Output validation

6. **Frontend Core Module** - `[MODULE:CORE-FE]`
   - React setup and routing
   - State management and API connections
   - Authentication context

7. **Frontend UI Module** - `[MODULE:UI]`
   - Component library 
   - Page layouts
   - Responsive design implementation

8. **Subscription Module** - `[MODULE:BILLING]`
   - Payment processing
   - Subscription management
   - Usage tracking

### Module Interface Documents
For each module, create a dedicated interface document that defines:
- Public APIs and endpoints
- Expected inputs/outputs
- Dependencies on other modules
- Testing requirements

Example file name: `MODULE-INTERFACE-AUTH.md`

## 3. Tech Stack

### Frontend
- **Framework**: React.js
- **State Management**: Redux or Context API
- **UI Component Library**: Tailwind CSS + Headless UI
- **Build Tools**: Vite
- **Key Libraries**:
  - React Router for navigation
  - React Query for API data fetching
  - React Hook Form for form handling
  - Zod for validation

### Backend
- **Framework**: Flask with Flask-RESTful
- **Authentication**: Flask-JWT-Extended
- **API Documentation**: Flask-OpenAPI/Swagger
- **Task Queue**: Celery (for handling AI processing jobs)

### Database
- **Primary Database**: PostgreSQL
  - User accounts and profile data
  - Subscription/payment records
  - Resume metadata and tracking
- **Vector Database**: pgvector extension for PostgreSQL
  - For keyword matching and semantic search
- **Document Storage**: AWS S3 or equivalent for storing resume files

### AI Components
- **Base Model**: Fine-tuned GPT model (initially using OpenAI API)
- **Keyword Extraction**: spaCy NLP pipeline
- **ATS Optimization**: Custom rule-based system + ML validation

### DevOps & Infrastructure
- **Containerization**: Docker
- **Local Development**: Docker Compose
- **CI/CD**: GitHub Actions
- **Monitoring**: Prometheus + Grafana
- **Logging**: ELK Stack or Cloud-based logging service

## 4. Database Schema

### Users
```
users
- id (PK)
- email
- password_hash
- full_name
- created_at
- updated_at
- subscription_tier
- subscription_status
- last_login
```

### OAuth Connections
```
oauth_connections
- id (PK)
- user_id (FK)
- provider (google/linkedin/apple)
- provider_user_id
- access_token
- refresh_token
- expires_at
```

### User Profiles
```
user_profiles
- id (PK)
- user_id (FK)
- industry
- years_experience
- education_level
- career_goals
- preferred_job_titles
- resume_preferences
```

### Resumes
```
resumes
- id (PK)
- user_id (FK)
- title
- description
- created_at
- updated_at
- base_resume_url
- is_base_resume
```

### Resume Versions
```
resume_versions
- id (PK)
- resume_id (FK)
- version_number
- file_url
- job_description_id (FK)
- created_at
- feedback_rating
- ats_score
```

### Job Descriptions
```
job_descriptions
- id (PK)
- user_id (FK)
- title
- company
- description_text
- extracted_keywords
- created_at
```

## 5. API Endpoints

### Authentication - `[MODULE:AUTH]`
- `POST /api/auth/register` - Create a new user account
- `POST /api/auth/login` - Authenticate user
- `POST /api/auth/refresh` - Refresh JWT token
- `POST /api/auth/logout` - Logout user
- `GET /api/auth/me` - Get current user
- `POST /api/auth/oauth/{provider}` - OAuth login endpoint

### User Profile - `[MODULE:AUTH]`
- `GET /api/profile` - Get user profile
- `PUT /api/profile` - Update user profile
- `POST /api/profile/upload-photo` - Upload profile photo

### Resumes - `[MODULE:RESUME]`
- `GET /api/resumes` - List user's resumes
- `POST /api/resumes` - Create a new base resume
- `GET /api/resumes/{id}` - Get resume by ID
- `PUT /api/resumes/{id}` - Update resume
- `DELETE /api/resumes/{id}` - Delete resume
- `POST /api/resumes/{id}/upload` - Upload base resume file
- `POST /api/resumes/{id}/tailor` - Generate tailored resume

### Job Descriptions - `[MODULE:JOB]`
- `GET /api/jobs` - List saved job descriptions
- `POST /api/jobs` - Save a new job description
- `PUT /api/jobs/{id}` - Update job description
- `DELETE /api/jobs/{id}` - Delete job description
- `POST /api/jobs/{id}/extract-keywords` - Extract keywords from job description

### Subscription & Billing - `[MODULE:BILLING]`
- `GET /api/subscription` - Get subscription details
- `POST /api/subscription/upgrade` - Upgrade to paid plan
- `POST /api/subscription/cancel` - Cancel subscription

## 6. File Structure

The file structure is organized by module to enable focused development work:

### Frontend

```
resume-tailor-frontend/
├── public/
├── src/
│   ├── assets/                      # [MODULE:CORE-FE]
│   ├── components/
│   │   ├── auth/                    # [MODULE:AUTH]
│   │   ├── common/                  # [MODULE:UI]
│   │   ├── dashboard/               # [MODULE:UI]
│   │   ├── resume/                  # [MODULE:RESUME]
│   │   └── job/                     # [MODULE:JOB]
│   ├── contexts/                    # [MODULE:CORE-FE]
│   │   ├── AuthContext.js
│   │   └── ResumeContext.js
│   ├── hooks/                       # [MODULE:CORE-FE]
│   │   ├── useAuth.js
│   │   ├── useResume.js
│   │   └── useJob.js
│   ├── pages/
│   │   ├── auth/                    # [MODULE:AUTH]
│   │   ├── dashboard/               # [MODULE:UI]
│   │   ├── resume/                  # [MODULE:RESUME]
│   │   └── job/                     # [MODULE:JOB]
│   ├── services/
│   │   ├── api.js                   # [MODULE:CORE-FE]
│   │   ├── auth.js                  # [MODULE:AUTH]
│   │   ├── resume.js                # [MODULE:RESUME]
│   │   └── job.js                   # [MODULE:JOB]
│   ├── utils/                       # [MODULE:CORE-FE]
│   ├── App.jsx                      # [MODULE:CORE-FE]
│   ├── main.jsx                     # [MODULE:CORE-FE]
│   └── Router.jsx                   # [MODULE:CORE-FE]
├── .env
├── .gitignore
├── package.json
└── vite.config.js
```

### Backend

```
resume-tailor-backend/
├── app/
│   ├── __init__.py                  # [MODULE:CORE-BE]
│   ├── config.py                    # [MODULE:CORE-BE]
│   ├── models/
│   │   ├── __init__.py              # [MODULE:CORE-BE]
│   │   ├── user.py                  # [MODULE:AUTH]
│   │   ├── profile.py               # [MODULE:AUTH]
│   │   ├── resume.py                # [MODULE:RESUME]
│   │   └── job.py                   # [MODULE:JOB]
│   ├── api/
│   │   ├── __init__.py              # [MODULE:CORE-BE]
│   │   ├── auth.py                  # [MODULE:AUTH]
│   │   ├── profile.py               # [MODULE:AUTH]
│   │   ├── resume.py                # [MODULE:RESUME]
│   │   └── job.py                   # [MODULE:JOB]
│   ├── services/
│   │   ├── __init__.py              # [MODULE:CORE-BE]
│   │   ├── auth_service.py          # [MODULE:AUTH]
│   │   ├── resume_service.py        # [MODULE:RESUME]
│   │   ├── storage_service.py       # [MODULE:CORE-BE]
│   │   └── subscription_service.py  # [MODULE:BILLING]
│   ├── ai/
│   │   ├── __init__.py              # [MODULE:AI]
│   │   ├── keyword_extractor.py     # [MODULE:AI]
│   │   ├── resume_generator.py      # [MODULE:AI]
│   │   └── ats_optimizer.py         # [MODULE:AI]
│   ├── utils/
│   │   ├── __init__.py              # [MODULE:CORE-BE]
│   │   ├── validators.py            # [MODULE:CORE-BE]
│   │   └── helpers.py               # [MODULE:CORE-BE]
├── migrations/                      # [MODULE:CORE-BE]
├── tests/                           # (Match module structure)
├── .env
├── .gitignore
├── requirements.txt
├── Dockerfile
└── wsgi.py                          # [MODULE:CORE-BE]
```

### AI Pipeline

```
resume-tailor-ai/
├── data/                            # [MODULE:AI]
│   ├── training/
│   └── evaluation/
├── models/                          # [MODULE:AI]
│   ├── __init__.py
│   ├── keyword_extractor.py
│   ├── resume_generator.py
│   └── ats_scorer.py
├── training/                        # [MODULE:AI]
│   ├── __init__.py
│   ├── data_processor.py
│   ├── train_keyword_extractor.py
│   └── fine_tune_generator.py
├── utils/                           # [MODULE:AI]
│   ├── __init__.py
│   ├── evaluation.py
│   └── preprocessing.py
├── app.py                           # [MODULE:AI]
├── config.py                        # [MODULE:AI]
├── requirements.txt
└── Dockerfile
```

## 7. Chat Session Tracking System

### Session Management Documents
Create standardized documents for each chat session:

#### Session Opener Document
```markdown
# Development Session: [MODULE:AUTH] - JWT Token Implementation

## Previous Sessions Reference
- Session #1: Database Schema Implementation [COMPLETED]
- Session #2: User Model Implementation [COMPLETED]

## Current Session Goals
1. Implement JWT token generation
2. Create refresh token mechanism
3. Set up token blacklisting

## Relevant Files
- app/models/user.py (previously implemented)
- app/services/auth_service.py (to be implemented)
- app/api/auth.py (to be implemented)

## Dependencies
- Flask-JWT-Extended (version 4.5.2)
```

#### Session Closer Document
```markdown
# Session Summary: [MODULE:AUTH] - JWT Token Implementation

## Completed Items
1. JWT token generation ✅
2. Refresh token mechanism ✅
3. Token blacklisting ✅

## Created Files
- app/services/auth_service.py
- app/api/auth.py
- tests/test_auth_service.py

## Next Steps
1. Implement password reset flow
2. Add email verification
3. Create OAuth provider integration

## Known Issues
- Need to optimize token expiration handling
```

### Code Version Tracking
Create a living document to track implementation status:

```markdown
# Resume Tailoring System - Implementation Status

## Backend Core [MODULE:CORE-BE]
- [x] Flask application setup
- [x] Database connection
- [x] Migration system
- [ ] Error handling middleware
- [ ] Logging system

## Authentication [MODULE:AUTH]
- [x] User model
- [x] JWT token implementation
- [ ] Social authentication
- [ ] Password reset
- [ ] Email verification

...etc for each module
```

## 8. AI Implementation Strategy

### Initial MVP Approach
1. **Model Selection**: 
   - Start with OpenAI GPT API (gpt-3.5-turbo/gpt-4)
   - Transition to fine-tuned model as data collection grows

2. **Data Collection Strategy**:
   - Start with synthetic data generation (create resume-job pairs)
   - Implement user feedback collection on generated resumes
   - Create a training dataset from manual resume-job pairs
   - Consider public resume datasets with appropriate licensing

3. **Keyword Extraction**:
   - Build a spaCy-based extractor to identify:
     - Technical skills
     - Soft skills
     - Job requirements
     - Industry-specific terminology

4. **Resume Generation Pipeline**:
   - Parse base resume
   - Analyze job description
   - Generate tailored content with emphasis on matching keywords
   - Structure output into professional template

5. **Evaluation Metrics**:
   - ATS compatibility score
   - Keyword match ratio
   - User satisfaction rating
   - A/B testing different generation strategies

### Long-term AI Roadmap
1. **Model Improvement**:
   - Fine-tune on collected data pairs
   - Implement RLHF (Reinforcement Learning from Human Feedback)
   - Create specialized models for different industries

2. **Advanced Features**:
   - Cover letter generation
   - Interview preparation suggestions
   - Career path recommendations

## 9. Module Interface Specification Example

### Authentication Module Interface [MODULE:AUTH]

```markdown
# Authentication Module Interface Specification

## Purpose
This module handles all aspects of user authentication, including registration, login, token management, and social authentication.

## External Dependencies
- Flask-JWT-Extended
- Flask-Mail (for verification emails)
- OAuth libraries for social providers

## Internal Dependencies
- Core Backend Module [MODULE:CORE-BE]

## Public Interfaces

### Models
- User
  - Required fields: email, password_hash, created_at
  - Methods: verify_password(), generate_auth_token()

### Services
- AuthService
  - register_user(email, password, name)
  - login_user(email, password)
  - refresh_token(refresh_token)
  - logout_user(user_id)
  - social_auth_login(provider, token)

### API Endpoints
- POST /api/auth/register
  - Request: { email, password, name }
  - Response: { user, token }
- POST /api/auth/login
  - Request: { email, password }
  - Response: { user, token, refresh_token }

## Integration Points
- Requires User model from Core Backend
- Exposes AuthContext for Frontend modules
- Provides auth middleware for protecting other endpoints

## Testing Requirements
- Unit tests for all service methods
- Integration tests for API endpoints
- Mock OAuth provider responses
```

## 10. Development Workflow & Chat Session Strategy

### Initial Setup Phase
1. Create all module interface documents first
2. Establish the core architecture files
3. Set up the project repository with module structure
4. Document dependencies between modules

### Module Development Phase
For each module:
1. Start a new chat session with the module interface document
2. Reference any previously completed modules as needed
3. Focus on implementing one module per session
4. End each session with a summary document

### Inter-Module Integration Phase
Once modules are individually developed:
1. Start integration sessions focusing on specific module pairs
2. Use interface documents to guide integration
3. Create integration tests to verify module boundaries

### Session Planning Guidelines
- Limit each session to a single logical module
- Begin each session with clear context (module + goals)
- End each session with a summary of progress
- Maintain a separate tracking document for overall progress

## 11. Code Style Guide

### General Principles
- Clear, descriptive naming
- Consistent formatting
- Thorough documentation
- Unit test coverage >80%

### Python Style
- Follow PEP 8
- Type hints on all functions
- Docstrings for all modules and functions

### JavaScript/React Style
- ESLint with Airbnb config
- Component organization by feature
- Functional components with hooks
- Prop validation with PropTypes

## 12. Development Roadmap & Milestones

### Phase 1: Foundation (Weeks 1-4)
- Basic architecture setup
- Authentication system
- User profile management
- Database schema implementation

### Phase 2: Core Features (Weeks 5-8)
- Resume upload and management
- Job description parsing
- Keyword extraction implementation
- Basic resume tailoring with GPT API

### Phase 3: Advanced Features (Weeks 9-12)
- Enhanced UI/UX
- Subscription management
- Advanced resume tailoring
- ATS optimization

### Phase 4: Refinement & Scale (Weeks 13-16)
- User feedback incorporation
- AI model optimization
- Performance optimization
- Analytics and monitoring


# Resume Tailoring System Blueprint - Updates and Notes

This document contains updates, clarifications, and additional notes for the Resume Tailoring System blueprint based on the initial implementation work.

## Last Updated: March 15, 2025

## Architecture Updates

The initial implementation has validated the core architecture described in the blueprint, with a few additional notes:

### Backend Architecture
- The modular approach with separate services for each domain (auth, resume, job, AI) has proven effective for maintaining clean separation of concerns.
- Service layers effectively abstract business logic from API endpoints, making the code more maintainable and testable.
- The Flask application factory pattern works well for initializing extensions and registering blueprints.

### Database Schema
- The current implementation has followed the blueprint database schema with minor adjustments:
  - Added `file_type` and `file_size` fields to the Resume and ResumeVersion models for better file tracking
  - Added `content` and `content_format` fields for storing structured resume data
  - Added `changes` field to ResumeVersion to track modifications from base resume

### AI Implementation
- The two-tiered approach (rule-based + LLM) provides a good balance of reliability and advanced capabilities:
  - Rule-based systems with spaCy and NLTK provide consistent baseline functionality
  - OpenAI integration allows for more sophisticated tailoring when available
  - Fallback mechanisms ensure the system works even if LLM services are unavailable

## Development Process Adjustments

### Module Development
- The module isolation strategy has worked well for focused development sessions
- The interface documents have been valuable for maintaining clear boundaries between modules
- Services should be developed before API endpoints to ensure business logic is properly encapsulated

### Testing Strategy
- Add unit tests for service methods as the next priority
- Implement integration tests for API endpoints
- Create test fixtures for common test data (users, resumes, jobs)

## Additional Requirements

Based on the initial implementation, several additional requirements have been identified:

### Storage Service
- A dedicated StorageService needs to be implemented for file handling
- Initially can use local filesystem, but should be designed for easy migration to S3 or other cloud storage
- Should handle file uploads, downloads, and URL generation

### Email Service
- A proper EmailService should be implemented for sending verification emails and password resets
- Should support templates for different email types
- Should be configurable for different email providers

### Document Processing
- More robust document parsing for various resume formats (PDF, DOCX, etc.)
- Consider using specialized libraries for each format or a unified document parsing service

### Frontend Components
- Implement a comprehensive component library with Tailwind CSS
- Ensure all components have proper accessibility attributes
- Create form components that integrate with React Hook Form and Zod validation

## Next Phase Planning

For the next phase of development, priorities should include:

1. Complete the remaining service implementations
   - JobService
   - StorageService
   - EmailService

2. Develop core UI components and pages
   - Common component library
   - Registration and profile pages
   - Resume editor and job input forms
   - Dashboard with metrics

3. Implement the subscription and billing module
   - Stripe integration
   - Usage tracking
   - Plan management

4. Add comprehensive testing
   - Unit tests for services
   - Integration tests for API endpoints
   - End-to-end tests for critical flows
