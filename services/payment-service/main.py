from fastapi import FastAPI
from pydantic import BaseModel
import uvicorn
import time

app = FastAPI(title="Payment Service", version="1.0.0")

class Payment(BaseModel):
    amount: float
    currency: str
    user_id: int

@app.get("/health")
def health_check():
    return {"status": "healthy", "service": "payment"}

@app.post("/process")
def process_payment(payment: Payment):
    # Logic to process payment
    return {"status": "SUCCESS", "transaction_id": f"txn-{int(time.time())}"}

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8002)
