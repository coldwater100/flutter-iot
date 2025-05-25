from fastapi import FastAPI, Request
from pydantic import BaseModel

app = FastAPI()


class Item(BaseModel):
    id: str
    description: str


@app.get("/hello")
def say_hello():
    return {"message": "Hello from FastAPI!"}


@app.post("/data")
async def receive_data(request: Request):
    body = await request.json()
    print(f"Received from edge: {body}")
    return {"status": "ok"}


@app.post("/items", summary="Create Item", tags=["Items"])
def create_item(item: Item):
    return {"item_received": item}
