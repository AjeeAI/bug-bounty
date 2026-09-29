$ErrorActionPreference = "Stop"

Write-Host "Starting Project SecretSieve generation..."

New-Item -ItemType Directory -Force -Path "Project-SecretSieve" | Out-Null
Set-Location "Project-SecretSieve"

git init
git config user.name "SecretSieve Dev"
git config user.email "dev@secretsieve.local"

New-Item -ItemType Directory -Force -Path "backend" | Out-Null
New-Item -ItemType Directory -Force -Path "frontend/src" | Out-Null

# --- COMMIT 1: Initial Setup ---
@"
fastapi==0.103.1
uvicorn==0.23.2
SQLAlchemy==2.0.20
python-dotenv==1.0.0
"@ | Out-File -FilePath "backend/requirements.txt" -Encoding ascii

@"
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
"@ | Out-File -FilePath "frontend/package.json" -Encoding ascii

git add .
git commit -m "chore: Initial project setup for SecretSieve"

# --- COMMIT 2: The Leak ---
@"
AWS_ACCESS_KEY_ID=AKIAIOSFODNN7EXAMPLE
AWS_SECRET_ACCESS_KEY=wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
OPENAI_API_KEY=sk-1234567890abcdef1234567890abcdef
DATABASE_URL=postgresql://admin:SuperSecretPassword123@localhost:5432/secretsieve
"@ | Out-File -FilePath "backend/.env" -Encoding ascii

@"
VITE_STRIPE_SECRET_KEY=sk_test_4eC39HqLyjWDarjtT1zdp7dc
"@ | Out-File -FilePath "frontend/.env.local" -Encoding ascii

@"
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
"@ | Out-File -FilePath "backend/main.py" -Encoding ascii

git add backend/.env frontend/.env.local backend/main.py
git commit -m "feat: Add database connections and payment gateway config"

# --- COMMIT 3: Normal Development ---
@"
# Project SecretSieve
A modern full-stack web application.
"@ | Out-File -FilePath "README.md" -Encoding ascii

@"
import React from 'react';

function App() {
  return (
    <div className="min-h-screen bg-gray-100 flex items-center justify-center">
      <h1 className="text-4xl font-bold text-blue-600">SecretSieve Dashboard</h1>
    </div>
  );
}

export default App;
"@ | Out-File -FilePath "frontend/src/App.jsx" -Encoding ascii

@"
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
"@ | Out-File -FilePath "frontend/tailwind.config.js" -Encoding ascii

git add README.md frontend/src/App.jsx frontend/tailwind.config.js
git commit -m "feat: Build out landing page UI"

# --- COMMIT 4: The Cover-up ---
Remove-Item "backend/.env" -Force
Remove-Item "frontend/.env.local" -Force

@"
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
"@ | Out-File -FilePath ".gitignore" -Encoding ascii

git rm --cached backend/.env frontend/.env.local

@"
from fastapi import FastAPI
import os

app = FastAPI()

DB_URL = os.getenv("DATABASE_URL", "postgresql://localhost:5432/devdb")
AWS_KEY = os.getenv("AWS_ACCESS_KEY_ID", "default_key")

@app.get("/")
def read_root():
    return {"message": "Welcome to SecretSieve API", "db_connected": DB_URL is not None}
"@ | Out-File -FilePath "backend/main.py" -Encoding ascii

git add .gitignore backend/main.py
git commit -m "fix: Secure credentials and add gitignore"

# --- COMMIT 5: Final Polish ---
@"
FROM python:3.11-slim

WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
"@ | Out-File -FilePath "backend/Dockerfile" -Encoding ascii

@"
from fastapi.testclient import TestClient
from main import app

client = TestClient(app)

def test_read_main():
    response = client.get("/")
    assert response.status_code == 200
    assert "Welcome to SecretSieve API" in response.json()["message"]
"@ | Out-File -FilePath "backend/test_main.py" -Encoding ascii

git add backend/Dockerfile backend/test_main.py
git commit -m "test: Add deployment configs"

Write-Host "============================================================"
Write-Host " Project SecretSieve generated successfully!"
Write-Host " The git repository contains a simulated credential leak."
Write-Host "============================================================"
