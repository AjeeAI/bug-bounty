#!/bin/bash

# Exit on error
set -e

echo "Starting Project SecretSieve generation..."

# 1. Create directory and init git
mkdir -p Project-SecretSieve
cd Project-SecretSieve
git init

# Configure local git user to ensure commits succeed
git config user.name "SecretSieve Dev"
git config user.email "dev@secretsieve.local"

# Create directories
mkdir -p backend
mkdir -p frontend/src

# --- COMMIT 1: Initial Setup ---
cat << 'EOF' > backend/requirements.txt
fastapi==0.103.1
uvicorn==0.23.2
SQLAlchemy==2.0.20
python-dotenv==1.0.0
EOF

cat << 'EOF' > frontend/package.json
{
  "name": "secretsieve-frontend",
  "private": true,
  "version": "0.0.0",
  "type": "module",
  "scripts": {
    "dev": "vite",
    "build": "vite build",
    "lint": "eslint . --ext js,jsx --report-unused-disable-directives --max-warnings 0",
    "preview": "vite preview"
  },
  "dependencies": {
    "react": "^18.2.0",
    "react-dom": "^18.2.0"
  },
  "devDependencies": {
    "tailwindcss": "^3.3.3",
    "vite": "^4.4.5"
  }
}
EOF

git add .
git commit -m "chore: Initial project setup for SecretSieve"

# --- COMMIT 2: The Leak ---
cat << 'EOF' > backend/.env
AWS_ACCESS_KEY_ID=AKIAIOSFODNN7EXAMPLE
AWS_SECRET_ACCESS_KEY=wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
OPENAI_API_KEY=sk-1234567890abcdef1234567890abcdef
DATABASE_URL=postgresql://admin:SuperSecretPassword123@localhost:5432/secretsieve
EOF

cat << 'EOF' > frontend/.env.local
VITE_STRIPE_SECRET_KEY=sk_test_4eC39HqLyjWDarjtT1zdp7dc
EOF

cat << 'EOF' > backend/main.py
from fastapi import FastAPI
import os
from dotenv import load_dotenv

load_dotenv()

app = FastAPI()

DB_URL = os.environ.get("DATABASE_URL")
AWS_KEY = os.environ.get("AWS_ACCESS_KEY_ID")

@app.get("/")
def read_root():
    return {"message": "Welcome to SecretSieve API", "db_connected": DB_URL is not None}
EOF

git add backend/.env frontend/.env.local backend/main.py
git commit -m "feat: Add database connections and payment gateway config"

# --- COMMIT 3: Normal Development ---
cat << 'EOF' > README.md
# Project SecretSieve
A modern full-stack web application.
EOF

cat << 'EOF' > frontend/src/App.jsx
import React from 'react';

function App() {
  return (
    <div className="min-h-screen bg-gray-100 flex items-center justify-center">
      <h1 className="text-4xl font-bold text-blue-600">SecretSieve Dashboard</h1>
    </div>
  );
}

export default App;
EOF

cat << 'EOF' > frontend/tailwind.config.js
/** @type {import('tailwindcss').Config} */
export default {
  content: [
    "./index.html",
    "./src/**/*.{js,ts,jsx,tsx}",
  ],
  theme: {
    extend: {},
  },
  plugins: [],
}
EOF

git add README.md frontend/src/App.jsx frontend/tailwind.config.js
git commit -m "feat: Build out landing page UI"

# --- COMMIT 4: The Cover-up ---
# Delete the credential files
rm backend/.env frontend/.env.local

# Create gitignore to hide future .env files
cat << 'EOF' > .gitignore
# Environments
.env
.env.*
!.env.example

# Node
node_modules/
dist/

# Python
__pycache__/
*.py[cod]
*$py.class
venv/
EOF

# Remove the cached files from git tracking
git rm --cached backend/.env frontend/.env.local

# Update main.py to use fallbacks
cat << 'EOF' > backend/main.py
from fastapi import FastAPI
import os

app = FastAPI()

DB_URL = os.getenv("DATABASE_URL", "postgresql://localhost:5432/devdb")
AWS_KEY = os.getenv("AWS_ACCESS_KEY_ID", "default_key")

@app.get("/")
def read_root():
    return {"message": "Welcome to SecretSieve API", "db_connected": DB_URL is not None}
EOF

git add .gitignore backend/main.py
git commit -m "fix: Secure credentials and add gitignore"

# --- COMMIT 5: Final Polish ---
cat << 'EOF' > backend/Dockerfile
FROM python:3.11-slim

WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
EOF

cat << 'EOF' > backend/test_main.py
from fastapi.testclient import TestClient
from main import app

client = TestClient(app)

def test_read_main():
    response = client.get("/")
    assert response.status_code == 200
    assert "Welcome to SecretSieve API" in response.json()["message"]
EOF

git add backend/Dockerfile backend/test_main.py
git commit -m "test: Add deployment configs"

echo "============================================================"
echo " Project SecretSieve generated successfully!"
echo " The git repository contains a simulated credential leak."
echo "============================================================"
