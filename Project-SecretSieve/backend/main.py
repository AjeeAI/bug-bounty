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
