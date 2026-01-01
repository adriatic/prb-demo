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
