export const API_BASE_URL = "http://192.168.18.51:8000/auth";

export async function loginUser(email: string, password: string) {
  const body = new URLSearchParams();
  body.append("username", email); // pakai username karena backend FastAPI-nya pakai OAuth2PasswordRequestForm
  body.append("password", password);

  const res = await fetch(`${API_BASE_URL}/login`, {
    method: "POST",
    headers: {
      "Content-Type": "application/x-www-form-urlencoded",
    },
    body: body.toString(),
  });

  if (!res.ok) {
    const err = await res.json();
    throw new Error(err.detail || "Login failed");
  }

  return res.json();
}
