from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
import uvicorn
import time
import random

app = FastAPI(title="Trading Service", version="1.0.0")

class Order(BaseModel):
    id: str
    symbol: str
    quantity: int
    price: float
    side: str # BUY or SELL

@app.get("/health")
def health_check():
    return {"status": "healthy", "service": "trading"}

@app.post("/orders")
def place_order(order: Order):
    # Logic to save to database/redis
    return {"order_id": f"ord-{random.randint(1000, 9999)}", "status": "PENDING"}

@app.get("/orders/{order_id}")
def get_order(order_id: str):
    return {
        "id": order_id,
        "symbol": "AAPL",
        "quantity": 10,
        "price": 185.50,
        "side": "BUY",
        "status": "EXECUTED"
    }

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8001)
