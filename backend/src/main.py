from fastapi import FastAPI, WebSocket
from typing import List
import json

app = FastAPI()

# 연결된 모든 클라이언트 저장
active_connections: List[WebSocket] = []

# 브로드캐스트 함수
async def broadcast(message: str, sender: WebSocket = None):
    disconnected = []
    for conn in active_connections:
        if conn != sender:  # 보낸 클라이언트 제외 가능
            try:
                await conn.send_text(message)  # ✅ 그대로 전송
            except Exception as e:
                print(f"[WebSocket] Error sending: {e}")
                disconnected.append(conn)

    # 끊어진 연결 제거
    for conn in disconnected:
        active_connections.remove(conn)

@app.websocket("/ws")
async def websocket_endpoint(websocket: WebSocket):
    await websocket.accept()
    active_connections.append(websocket)
    print("[WebSocket] Client connected")

    try:
        while True:
            data = await websocket.receive_text()
            print(f"[WebSocket] Received: {data}")

            # 그대로 브로드캐스트 (가공 없음)
            await broadcast(data, sender=websocket)

    except Exception as e:
        print(f"[WebSocket] Connection closed: {e}")
    finally:
        if websocket in active_connections:
            active_connections.remove(websocket)
