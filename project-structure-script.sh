#!/bin/bash
# Script to create the initial directory structure for the Resume Tailoring System

# Exit on error
set -e

echo "Creating Resume Tailoring System project structure..."

# Create root directories
mkdir -p resume-tailoring-system
cd resume-tailoring-system

# Documentation directory
mkdir -p docs/blueprint
mkdir -p docs/module-interfaces
mkdir -p docs/session-tracking

# Backend directory structure
mkdir -p backend/app/models
mkdir -p backend/app/api
mkdir -p backend/app/services
mkdir -p backend/app/ai
mkdir -p backend/app/utils
mkdir -p backend/migrations
mkdir -p backend/tests

# Frontend directory structure
mkdir -p frontend/public
mkdir -p frontend/src/assets
mkdir -p frontend/src/components/auth
mkdir -p frontend/src/components/common
mkdir -p frontend/src/components/dashboard
mkdir -p frontend/src/components/resume
mkdir -p frontend/src/components/job
mkdir -p frontend/src/contexts
mkdir -p frontend/src/hooks
mkdir -p frontend/src/pages/auth
mkdir -p frontend/src/pages/dashboard
mkdir -p frontend/src/pages/resume
mkdir -p frontend/src/pages/job
mkdir -p frontend/src/services
mkdir -p frontend/src/utils

# AI Pipeline directory structure
mkdir -p ai-pipeline/data/training
mkdir -p ai-pipeline/data/evaluation
mkdir -p ai-pipeline/models
mkdir -p ai-pipeline/training
mkdir -p ai-pipeline/utils

# Create placeholder files to ensure Git tracks empty directories
touch backend/app/models/__init__.py
touch backend/app/api/__init__.py
touch backend/app/services/__init__.py
touch backend/app/ai/__init__.py
touch backend/app/utils/__init__.py
touch backend/app/__init__.py
touch backend/tests/__init__.py

touch frontend/src/components/auth/.gitkeep
touch frontend/src/components/common/.gitkeep
touch frontend/src/components/dashboard/.gitkeep
touch frontend/src/components/resume/.gitkeep
touch frontend/src/components/job/.gitkeep
touch frontend/src/contexts/.gitkeep
touch frontend/src/hooks/.gitkeep
touch frontend/src/pages/auth/.gitkeep
touch frontend/src/pages/dashboard/.gitkeep
touch frontend/src/pages/resume/.gitkeep
touch frontend/src/pages/job/.gitkeep
touch frontend/src/services/.gitkeep
touch frontend/src/utils/.gitkeep

touch ai-pipeline/data/training/.gitkeep
touch ai-pipeline/data/evaluation/.gitkeep
touch ai-pipeline/models/__init__.py
touch ai-pipeline/training/__init__.py
touch ai-pipeline/utils/__init__.py

# Create basic configuration files
touch backend/.gitignore
touch frontend/.gitignore
touch ai-pipeline/.gitignore

cat > backend/.gitignore << EOL
# Python
__pycache__/
*.py[cod]
*$py.class
*.so
.Python
env/
build/
develop-eggs/
dist/
downloads/
eggs/
.eggs/
lib/
lib64/
parts/
sdist/
var/
*.egg-info/
.installed.cfg
*.egg

# Flask
instance/
.webassets-cache

# Virtual Environment
venv/
ENV/

# IDE
.idea/
.vscode/
*.swp
*.swo

# Environment variables
.env
.env.*
!.env.example

# Logs
logs/
*.log
EOL

cat > frontend/.gitignore << EOL
# Node
node_modules/
npm-debug.log
yarn-error.log
yarn-debug.log
.pnpm-debug.log

# Build
/dist
/build

# Environment variables
.env
.env.*
!.env.example

# IDE
.idea/
.vscode/
*.swp
*.swo

# OS
.DS_Store
Thumbs.db
EOL

cat > ai-pipeline/.gitignore << EOL
# Python
__pycache__/
*.py[cod]
*$py.class
*.so
.Python
env/
build/
develop-eggs/
dist/
downloads/
eggs/
.eggs/
lib/
lib64/
parts/
sdist/
var/
*.egg-info/
.installed.cfg
*.egg

# Virtual Environment
venv/
ENV/

# Data files
*.csv
*.json
*.pkl
*.h5
*.model
*.weights

# IDE
.idea/
.vscode/
*.swp
*.swo

# Environment variables
.env
.env.*
!.env.example

# Logs
logs/
*.log
EOL

echo "Project structure created successfully!"
