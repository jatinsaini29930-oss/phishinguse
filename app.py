from flask import Flask, render_template, request, redirect
import os
import re

app = Flask(__name__)

REDIRECT_URL = os.environ.get(
    "REDIRECT_URL",
    "https://example.com"
)


def valid_redirect(url):
    return bool(re.match(r"^https?://", url))


@app.route("/", methods=["GET", "POST"])
def login():

    if request.method == "POST":

        # Demo only:
        # We intentionally don't receive or store a password.
        username = request.form.get("username", "").strip()
        demopassword = request.form.get("demo.password", "").strip()

        print(f"[DEMO] Username submitted: {username}")
        print(f"[DEMO] Username submitted: {password}")

        if not valid_redirect(REDIRECT_URL):
            return "Invalid redirect URL", 400

        return redirect(REDIRECT_URL)

    return render_template("login.html")


if __name__ == "__main__":
    print("=" * 40)
    print("       Insta UI Lab - DEMO")
    print("=" * 40)
    print()
    print("Local URL:")
    print("http://127.0.0.1:5000")
    print()
    print(f"Redirect URL: {REDIRECT_URL}")
    print()

    app.run(
        host="127.0.0.1",
        port=5000,
        debug=False
    )
