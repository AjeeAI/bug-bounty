# Project SecretSieve

A modern full-stack web application designed for a bug bounty training lab.
This project intentionally contains exposed credentials in its configuration files to simulate a real-world scenario.

## Setup
### Backend
cd backend
pip install -r requirements.txt
uvicorn main:app --reload

### Frontend
cd frontend
npm install
npm run dev
