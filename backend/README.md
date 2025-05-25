# Backend (FastAPI)

This is the Python backend service built with FastAPI.

---

## 🧪 Hello World API

After starting the service, open:

```
http://localhost:8000/hello
```

You should see:

```json
{ "message": "Hello from FastAPI!" }
```

---

## ⚙️ Install & Run

### 🔹 Option 1: Using Docker Compose (Recommended)

From the project root:

```bash
docker compose up --build
```

This will build and start both the backend and the edge client containers.

### 🔹 Option 2: Run Backend Manually (Dev Mode)

From the `backend/` directory:

```bash
# 1. Create virtual environment
python3 -m venv .venv
source .venv/bin/activate  # On Windows: .venv\Scripts\activate

# 2. Install dependencies
pip install -r requirements.txt

# 3. Run server
uvicorn main:app --reload --host 0.0.0.0 --port 8000
```

---

## 📦 Requirements

- Python 3.9+
- [FastAPI](https://fastapi.tiangolo.com/)
- [Uvicorn](https://www.uvicorn.org/)
