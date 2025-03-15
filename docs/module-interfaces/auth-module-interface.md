# Authentication Module Interface Specification [MODULE:AUTH]

## Purpose
This module handles all aspects of user authentication, including registration, login, token management, and social authentication.

## External Dependencies
- Flask-JWT-Extended
- Flask-Mail (for verification emails)
- OAuth libraries for social providers (Authlib)
- Argon2 (for password hashing)

## Internal Dependencies
- Core Backend Module [MODULE:CORE-BE]

## Public Interfaces

### Models

#### User
```python
class User:
    id: int  # Primary key
    email: str  # Unique
    password_hash: str  # Argon2 hash
    full_name: str
    created_at: datetime
    updated_at: datetime
    subscription_tier: str  # 'free', 'premium', etc.
    subscription_status: str  # 'active', 'canceled', etc.
    last_login: datetime
    is_active: bool
    is_verified: bool

    # Methods
    def verify_password(password: str) -> bool
    def generate_auth_token() -> str
    def generate_refresh_token() -> str
    def generate_verification_token() -> str
    def verify_email(token: str) -> bool
```

#### OAuthConnection
```python
class OAuthConnection:
    id: int  # Primary key
    user_id: int  # Foreign key to User
    provider: str  # 'google', 'linkedin', 'apple'
    provider_user_id: str
    access_token: str
    refresh_token: str
    expires_at: datetime

    # Methods
    def is_expired() -> bool
    def refresh() -> bool
```

#### UserProfile
```python
class UserProfile:
    id: int  # Primary key
    user_id: int  # Foreign key to User
    industry: str
    years_experience: int
    education_level: str
    career_goals: str
    preferred_job_titles: List[str]
    resume_preferences: Dict
```

### Services

#### AuthService
```python
class AuthService:
    def register_user(email: str, password: str, name: str) -> Tuple[User, str]
    def login_user(email: str, password: str) -> Tuple[User, str, str]
    def refresh_token(refresh_token: str) -> str
    def logout_user(user_id: int) -> bool
    def verify_token(token: str) -> Optional[User]
    def send_verification_email(user: User) -> bool
    def verify_email(token: str) -> bool
    def request_password_reset(email: str) -> bool
    def reset_password(token: str, new_password: str) -> bool
```

#### SocialAuthService
```python
class SocialAuthService:
    def get_oauth_url(provider: str) -> str
    def handle_oauth_callback(provider: str, code: str) -> Tuple[User, str]
    def link_social_account(user: User, provider: str, code: str) -> bool
    def unlink_social_account(user: User, provider: str) -> bool
```

### API Endpoints

#### Authentication
- `POST /api/auth/register`
  - Request: `{ email, password, name }`
  - Response: `{ user, token }`

- `POST /api/auth/login`
  - Request: `{ email, password }`
  - Response: `{ user, token, refresh_token }`

- `POST /api/auth/refresh`
  - Request: `{ refresh_token }`
  - Response: `{ token }`

- `POST /api/auth/logout`
  - Request: `{}`
  - Response: `{ success }`

- `GET /api/auth/me`
  - Response: `{ user }`

#### Email Verification
- `POST /api/auth/send-verification`
  - Response: `{ success }`

- `POST /api/auth/verify-email`
  - Request: `{ token }`
  - Response: `{ success }`

#### Password Reset
- `POST /api/auth/forgot-password`
  - Request: `{ email }`
  - Response: `{ success }`

- `POST /api/auth/reset-password`
  - Request: `{ token, new_password }`
  - Response: `{ success }`

#### Social Authentication
- `GET /api/auth/oauth/{provider}`
  - Response: Redirect to OAuth provider

- `GET /api/auth/oauth/{provider}/callback`
  - Response: `{ user, token }`

- `POST /api/auth/oauth/{provider}/link`
  - Response: `{ success }`

- `POST /api/auth/oauth/{provider}/unlink`
  - Response: `{ success }`

#### User Profile
- `GET /api/profile`
  - Response: `{ profile }`

- `PUT /api/profile`
  - Request: `{ profile_data }`
  - Response: `{ profile }`

## Integration Points

### Exposes
- AuthMiddleware: For protecting API endpoints
- current_user: For accessing the authenticated user in other modules
- require_auth: Decorator for protecting routes
- AuthContext: For frontend authentication state

### Consumes
- Core Backend Database connection
- Core Backend Error handling

## Testing Requirements

### Unit Tests
- User model password hashing and verification
- Token generation and validation
- All AuthService and SocialAuthService methods

### Integration Tests
- Complete authentication flow (register, login, access protected route)
- Social authentication flow
- Password reset flow
- Email verification flow

### Mock Requirements
- OAuth provider responses
- Email sending service

## Security Considerations
- Use Argon2 for password hashing
- Implement rate limiting for authentication endpoints
- Implement JWT token rotation
- Securely store OAuth tokens
- Implement proper CORS for frontend requests
- Add protection against CSRF attacks

## Frontend Components
This module will provide the following React components:

- `<AuthProvider>`: Context provider for authentication state
- `<ProtectedRoute>`: Route component that requires authentication
- `<LoginForm>`: Form component for user login
- `<RegisterForm>`: Form component for user registration
- `<SocialLoginButtons>`: Buttons for social authentication
- `<ProfileForm>`: Form for editing user profile
- `<PasswordResetForm>`: Form for resetting password

## Implementation Notes
- Email verification should be required before allowing full access
- Social auth should merge accounts if email already exists
- Consider implementing two-factor authentication in the future
- Use refresh token rotation for enhanced security
- Implement proper error handling with user-friendly messages
