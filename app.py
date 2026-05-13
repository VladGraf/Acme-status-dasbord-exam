import os
import socket
from flask import Flask, jsonify, redirect, request, render_template_string

PORT = int(os.getenv("PORT", "5000"))
VERSION = os.getenv("VERSION", "1.0.0")
API_KEY = os.getenv("API_KEY")

if not API_KEY:
    raise RuntimeError("API_KEY environment variable is required")

app = Flask(__name__)

HTML = """
<!DOCTYPE html>
<html>
<head>
    <title>Status Dashboard</title>
</head>
<body>
    <h1>Status Dashboard</h1>
    <p>Internal service status page.</p>

    <button onclick="checkStatus()">Check Status</button>
    <pre id="result"></pre>

    <script>
        function checkStatus() {
            fetch('/api/v1/status')
                .then(response => response.json())
                .then(data => {
                    document.getElementById('result').textContent =
                        JSON.stringify(data, null, 2);
                });
        }
    </script>
</body>
</html>
"""

@app.route("/")
def index():
    return render_template_string(HTML)

@app.route("/api/status")
def api_status_redirect():
    return redirect("/api/v1/status", code=302)

@app.route("/api/v1/status")
def status():
    return jsonify({
        "status": "ok",
        "hostname": socket.gethostname(),
        "version": VERSION
    })
@app.route("api/secret")
def api_secret_redirect():
    return redirect("/api/v1/secret", code=302)

@app.route("/api/v1/secret")
def secret():
    provided_key = request.headers.get("X-API-Key")

    if provided_key != API_KEY:
        return jsonify({"error": "Unauthorized"}), 401

    return jsonify({"message": "you found the secret"})

if __name__ == "__main__":
    app.run(host="127.0.0.1", port=PORT)

