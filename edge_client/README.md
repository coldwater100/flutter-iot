# Edge Client (Python)

This is a simple Python-based edge client intended to run on devices like Jetson Nano or Raspberry Pi.

---

## 🧪 Hello World Client

This client prints the following every 5 seconds:

```text
Hello from Edge Client!
```

---

## ⚙️ Install & Run

### 🔹 Option 1: Using Docker Compose (Recommended)

From the project root:

```bash
docker compose up --build
```

This will start the edge client along with the backend.

### 🔹 Option 2: Run Manually

From the `edge_client/` directory:

```bash
# 1. Create virtual environment (optional)
python3 -m venv .venv
source .venv/bin/activate

# 2. Install dependencies
pip install -r requirements.txt

# 3. Run the client
python hello_client.py
```

---

## 📦 Requirements

- Python 3.9+
- Optionally `psutil` if metrics or monitoring is added
