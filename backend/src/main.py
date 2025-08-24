from fastapi import FastAPI, WebSocket
from typing import List
import json

app = FastAPI()

# 연결된 모든 클라이언트 저장
active_connections: List[WebSocket] = []

# 브로드캐스트 함수
async def broadcast(message: dict, sender: WebSocket = None):
    disconnected = []
    for conn in active_connections:
        if conn != sender:  # 보낸 클라이언트 제외 가능
            try:
                await conn.send_text(json.dumps(message))
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

            # 문자열을 dict로 변환 (잘못된 JSON이면 무시)
            try:
                parsed = json.loads(data)
            except Exception as e:
                print(f"[WebSocket] JSON decode error: {e}, raw={data}")
                continue

            if isinstance(parsed, dict):
                # Flat JSON 구조로 브로드캐스트
                message = {"type": "event", **parsed}
            else:
                # dict가 아니면 그냥 문자열/리스트 자체를 data로 묶음
                message = {"type": "event", "data": parsed}

            await broadcast(message, sender=websocket)

    except Exception as e:
        print(f"[WebSocket] Connection closed: {e}")
    finally:
        if websocket in active_connections:
            active_connections.remove(websocket)
