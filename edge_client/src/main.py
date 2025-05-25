import os
import requests
import time

backend_host = os.getenv("BACKEND_HOST", "localhost")
backend_port = os.getenv("BACKEND_PORT", "8000")
url = f"http://{backend_host}:{backend_port}/data"

print("Starting edge_client...", flush=True)

while True:
    try:
        res = requests.post(url, json={"temperature": 23.5})
        print("Sent data:", res.status_code, flush=True)
    except Exception as e:
        print("Error sending data:", e, flush=True)
    time.sleep(5)
