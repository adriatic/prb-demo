#!/usr/bin/env bash
set -e

REPO_ROOT="prb-demo-sites"

echo "Initializing PRB demo sites…"

# ------------------------------------------------------------
# helpers
# ------------------------------------------------------------

mkdir_if_missing() {
  if [ ! -d "$1" ]; then
    mkdir -p "$1"
    echo "Created directory: $1"
  else
    echo "Directory exists: $1"
  fi
}

write_if_missing() {
  if [ ! -f "$1" ]; then
    cat > "$1"
    echo "Created file: $1"
  else
    echo "File exists (skipped): $1"
  fi
}

# ------------------------------------------------------------
# repo structure
# ------------------------------------------------------------

mkdir_if_missing "$REPO_ROOT"
cd "$REPO_ROOT"

mkdir_if_missing "common"
mkdir_if_missing "site-1-classic-login"
mkdir_if_missing "site-2-signup-login"
mkdir_if_missing "site-3-password-change"
mkdir_if_missing "site-4-email-verification"
mkdir_if_missing "site-5-webauthn-demo"

# ------------------------------------------------------------
# README
# ------------------------------------------------------------

write_if_missing "README.md" <<EOF
# PRB Demo Sites

Static demo websites used for PRB testing (desktop app + browser extension).

Goals:
- realistic authentication flows
- distinct HTTPS origins
- static hosting (GitHub Pages / Netlify)
- no production backends
- shared minimal UI

Each site directory is deployable independently.
EOF

# ------------------------------------------------------------
# shared CSS
# ------------------------------------------------------------

write_if_missing "common/styles.css" <<EOF
body {
  font-family: system-ui, -apple-system, BlinkMacSystemFont, sans-serif;
  background: #f6f7f9;
  margin: 0;
  padding: 2rem;
}

.container {
  max-width: 420px;
  margin: 3rem auto;
  background: white;
  padding: 2rem;
  border-radius: 6px;
  box-shadow: 0 2px 8px rgba(0,0,0,0.08);
}

h1 {
  font-size: 1.25rem;
  margin-bottom: 1.5rem;
}

label {
  display: block;
  margin-bottom: 0.25rem;
  font-weight: 500;
}

input {
  width: 100%;
  padding: 0.5rem;
  margin-bottom: 1rem;
  font-size: 0.95rem;
}

button {
  width: 100%;
  padding: 0.6rem;
  font-size: 0.95rem;
  background: #175ddc;
  color: white;
  border: none;
  border-radius: 4px;
  cursor: pointer;
}

button:hover {
  background: #144bb8;
}

.message {
  margin-top: 1rem;
  font-size: 0.9rem;
}
EOF

# ------------------------------------------------------------
# Site 1 — Classic Login
# ------------------------------------------------------------

write_if_missing "site-1-classic-login/index.html" <<EOF
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Demo Site 1 — Login</title>
  <link rel="stylesheet" href="../common/styles.css">
</head>
<body>
  <div class="container">
    <h1>Sign in</h1>

    <form id="login-form">
      <label>Email</label>
      <input type="email" name="username" autocomplete="username" required>

      <label>Password</label>
      <input type="password" name="password" autocomplete="current-password" required>

      <button type="submit">Sign in</button>
    </form>

    <div id="message" class="message"></div>
  </div>

  <script src="login.js"></script>
</body>
</html>
EOF

write_if_missing "site-1-classic-login/login.js" <<EOF
const form = document.getElementById("login-form");
const message = document.getElementById("message");

const DEMO_USER = {
  username: "user@example.com",
  password: "correct-horse-battery-staple"
};

form.addEventListener("submit", e => {
  e.preventDefault();

  const username = form.username.value;
  const password = form.password.value;

  if (username === DEMO_USER.username && password === DEMO_USER.password) {
    message.textContent = "Login successful.";
    message.style.color = "green";
  } else {
    message.textContent = "Invalid credentials.";
    message.style.color = "red";
  }
});
EOF

# ------------------------------------------------------------
# Site 2 — Signup + Login
# ------------------------------------------------------------

write_if_missing "site-2-signup-login/index.html" <<EOF
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Demo Site 2 — Signup & Login</title>
  <link rel="stylesheet" href="../common/styles.css">
</head>
<body>
  <div class="container">
    <h1 id="title">Create account</h1>

    <form id="signup-form">
      <label>Email</label>
      <input id="signup-email" type="email" autocomplete="username" required>

      <label>Password</label>
      <input id="signup-password" type="password" autocomplete="new-password" required>

      <label>Confirm password</label>
      <input id="signup-password-confirm" type="password" autocomplete="new-password" required>

      <button type="submit">Create account</button>
    </form>

    <form id="login-form" hidden>
      <label>Email</label>
      <input id="login-email" type="email" autocomplete="username" required>

      <label>Password</label>
      <input id="login-password" type="password" autocomplete="current-password" required>

      <button type="submit">Sign in</button>
    </form>

    <div id="message" class="message"></div>
  </div>

  <script src="auth.js"></script>
</body>
</html>
EOF

write_if_missing "site-2-signup-login/auth.js" <<EOF
const STORAGE_KEY = "demo-site-2-user";

const signupForm = document.getElementById("signup-form");
const loginForm  = document.getElementById("login-form");
const message    = document.getElementById("message");
const title      = document.getElementById("title");

function showLogin() {
  signupForm.hidden = true;
  loginForm.hidden = false;
  title.textContent = "Sign in";
}

signupForm.addEventListener("submit", e => {
  e.preventDefault();

  const email = signupForm.querySelector("#signup-email").value;
  const p1 = signupForm.querySelector("#signup-password").value;
  const p2 = signupForm.querySelector("#signup-password-confirm").value;

  if (p1 !== p2) {
    message.textContent = "Passwords do not match.";
    message.style.color = "red";
    return;
  }

  localStorage.setItem(STORAGE_KEY, JSON.stringify({ email, password: p1 }));
  message.textContent = "Account created. Please sign in.";
  message.style.color = "green";

  document.getElementById("login-email").value = email;
  showLogin();
});

loginForm.addEventListener("submit", e => {
  e.preventDefault();

  const stored = JSON.parse(localStorage.getItem(STORAGE_KEY));
  const email = loginForm.querySelector("#login-email").value;
  const pwd = loginForm.querySelector("#login-password").value;

  if (stored && email === stored.email && pwd === stored.password) {
    message.textContent = "Login successful.";
    message.style.color = "green";
  } else {
    message.textContent = "Invalid credentials.";
    message.style.color = "red";
  }
});
EOF

# ------------------------------------------------------------
# Sites 3–5 placeholders
# ------------------------------------------------------------

for site in site-3-password-change site-4-email-verification site-5-webauthn-demo
do
  write_if_missing "$site/README.md" <<EOF
# $site

Placeholder.

This site will be implemented as part of PRB demo testing.
EOF
done

echo "PRB demo site initialization complete."
