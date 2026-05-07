# Fintech User Service - Principal Edition
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
import uvicorn
import os
import time

app = FastAPI(title="User Service", version="1.0.0")

class User(BaseModel):
    id: int
    username: str
    email: str

# In-memory storage for demo purposes (would be PostgreSQL in prod)
users = {
    1: User(id=1, username="admin", email="admin@fintech.io"),
    2: User(id=2, username="trader1", email="trader1@fintech.io")
}

@app.get("/health")
def health_check():
    return {"status": "healthy", "timestamp": time.time()}

@app.get("/users/{user_id}")
def get_user(user_id: int):
    if user_id not in users:
        raise HTTPException(status_code=404, detail="User not found")
    return users[user_id]

@app.get("/metrics")
def metrics():
    # Placeholder for Prometheus metrics
    return "# HELP http_requests_total Total number of HTTP requests\n# TYPE http_requests_total counter\nhttp_requests_total 42"

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000)
