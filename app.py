from flask import Flask

app = Flask(__name__)

@app.route('/')
def home():
    return "Hello from Flask inside Docker!"

if __name__ == '__main__':
    # Binding to 0.0.0.0 is critical for Docker networking
    app.run(host='0.0.0.0', port=5000)
