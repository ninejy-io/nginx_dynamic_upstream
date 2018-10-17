from flask import Flask, request


app = Flask(__name__)


@app.route('/test')
def aaa():
    return "url is /test\n"

@app.route('/test/1')
def a1():
    return "url is /test/1\n"


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8000, debug=True)