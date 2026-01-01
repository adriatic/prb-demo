// PRB DEMO SITE 1 — CLASSIC LOGIN
// Baseline username/password flow.
// No backend; behavior is deterministic.

const form = document.getElementById("login-form");
const message = document.getElementById("message");

const DEMO_USER = {
  username: "user@example.com",
  password: "correct-horse-battery-staple"
};

form.addEventListener("submit", (event) => {
  event.preventDefault();

  const username = form.username.value;
  const password = form.password.value;

  if (username === DEMO_USER.username && password === DEMO_USER.password) {
    message.textContent = "Login successful.";
    message.style.color = "green";
  } else {
    message.textContent = "Invalid credentials. Please try again.";
    message.style.color = "red";
  }
});

