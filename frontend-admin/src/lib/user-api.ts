export interface User {
  user_id: number;
  username: string;
  email: string;
  role: string;
  photo_url: string;
  create_at: string;
  update_at: string;
}

const API_URL = "http://192.168.18.51:8000/users";
function getAccessToken(): string | null {
  const match = document.cookie.match(/access_token=([^;]+)/);
  return match ? match[1] : null;
}

// GET users
export async function getUsers(): Promise<User[]> {
  const res = await fetch(API_URL);
  if (!res.ok) {
    throw new Error("Failed to fetch users");
  }
  return res.json();
}

// GET users by id
export async function getUserById(user_id: number) {
  const res = await fetch(`${API_URL}/${user_id}`);
  if (!res.ok) {
    throw new Error("Failed to fetch user by id");
  }
  return res.json();
}

// get my user data
export async function getCurrentUser(token: string): Promise<User> {
  const res = await fetch(`${API_URL}/me/profile`, {
    headers: {
      Authorization: `Bearer ${token}`,
    },
  });
  if (!res.ok) {
    throw new Error("Failed to fetch current user");
  }
  return res.json();
}

// DELETE user
export async function deleteUser(user_id: number) {
  const token = getAccessToken();
  if (!token) {
    throw new Error("Token not found");
  }

  const res = await fetch(`${API_URL}/${user_id}`, {
    method: "DELETE",
    headers: {
      Authorization: `Bearer ${token}`,
    },
  });

  if (!res.ok) {
    const errText = await res.text();
    console.error("Backend error (deleteUser):", errText);
    throw new Error("Failed to delete user");
  }

  return res.json();
}


// ADD user dengan FormData
export async function addUser(data: {
  username: string;
  email: string;
  password: string;
  role: string;
  photoFile?: File | null;
}) {
  const token = getAccessToken();
  if (!token) {
    throw new Error("Token not found");
  }

  const formData = new FormData();
  formData.append("username", data.username);
  formData.append("email", data.email);
  formData.append("password", data.password);
  formData.append("role", data.role);
  if (data.photoFile) {
    formData.append("photo", data.photoFile);
  }

  const res = await fetch(`${API_URL}`, {
    method: "POST",
    headers: {
      Authorization: `Bearer ${token}`,
    },
    body: formData,
  });

  if (!res.ok) {
    const errText = await res.text();
    console.error("Backend error:", errText);
    throw new Error(`Failed to add user (${res.status})`);
  }

  return res.json();
}


// EDIT user dengan FormData
export async function editUser(user_id: number, data: {
  username: string;
  email: string;
  password: string;
  role: string;
  photoFile?: File | null;
}) {
  const token = getAccessToken();
  if (!token) {
    throw new Error("Token not found");
  }

  const formData = new FormData();
  formData.append("username", data.username);
  formData.append("email", data.email);
  formData.append("password", data.password);
  formData.append("role", data.role);
  if (data.photoFile) {
    formData.append("photo", data.photoFile);
  }

  const res = await fetch(`${API_URL}/${user_id}`, {
    method: "PUT",
    headers: {
      Authorization: `Bearer ${token}`,
    },
    body: formData,
  });

  if (!res.ok) {
    const errText = await res.text();
    console.error("Backend error:", errText);
    throw new Error("Failed to update user");
  }

  return res.json();
}

// PUT/ EDIT my self - pakai FormData
export async function updateMySelf(formData: FormData, token: string): Promise<User> {
  const res = await fetch(`${API_URL}/me`, {
    method: "PUT",
    headers: {
      Authorization: `Bearer ${token}`,
    },
    body: formData,
  });

  if (!res.ok) {
    const errData = await res.json();
    throw new Error(errData.detail || "Failed to update current user");
  }

  return res.json();
}
