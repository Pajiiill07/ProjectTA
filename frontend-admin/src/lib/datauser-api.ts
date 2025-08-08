const API_URL = "http://192.168.18.51:8000/data_users";
function getAccessToken(): string | null {
  const match = document.cookie.match(/access_token=([^;]+)/);
  return match ? match[1] : null;
}

interface User {
  user_id: number;
  username: string;
  email: string;
  role: string;
  photo_url: string;
  create_at: string;
  update_at: string;
}

export interface DataUser {
  data_id: number;
  user_id: number;
  nama_lengkap: string;
  no_telp: string;
  linkedin: string;
  alamat: string;
  summary: string;
  create_at: string;
  update_at: string;
  user: User;
}

// GET all data users
export async function getDataUsers(token: string): Promise<DataUser[]> {
  const res = await fetch(API_URL, {
    headers: {
      Authorization: `Bearer ${token}`
    }
  });
  if (!res.ok) throw new Error("Failed to fetch data users");
  return res.json();
}

// GET data user by id
export async function getDataUserById(data_id: number, token: string): Promise<DataUser> {
  const res = await fetch(`${API_URL}/${data_id}`, {
    headers: {
      Authorization: `Bearer ${token}`
    }
  });
  if (!res.ok) throw new Error("Failed to fetch data user by id");
  return res.json();
}

// GET my data user
export async function getMyData(token: string): Promise<DataUser> {
  const res = await fetch(`${API_URL}/me/data`, {
    headers: {
      Authorization: `Bearer ${token}`,
    },
  });
  if (!res.ok) {
    throw new Error("Failed to fetch current user");
  }
  return res.json();
}

// DELETE data user
export async function deleteDataUser(data_id: number) {
  const token = getAccessToken();
  if (!token) {
    throw new Error("Token not found");
  }

  const res = await fetch(`${API_URL}/${data_id}`, {
    method: "DELETE",
    headers: {
      Authorization: `Bearer ${token}`
    }
  });
  if (!res.ok) throw new Error("Failed to delete data user");
}

// ADD data user
export async function addDataUser(
  data: Omit<DataUser, "data_id" | "create_at" | "update_at">,
  token: string
) {
  const res = await fetch(API_URL, {
    method: "POST",
    headers: {
      Authorization: `Bearer ${token}`,
      "Content-Type": "application/json"
    },
    body: JSON.stringify(data),
  });
  if (!res.ok) throw new Error("Failed to add data user");
  return res.json();
}

// EDIT data user
export async function editDataUser(
  data_id: number,
  data: Partial<DataUser>,
  token: string
) {
  const res = await fetch(`${API_URL}/${data_id}`, {
    method: "PUT",
    headers: {
      Authorization: `Bearer ${token}`,
      "Content-Type": "application/json"
    },
    body: JSON.stringify(data),
  });
  if (!res.ok) throw new Error("Failed to edit data user");
  return res.json();
}

// PUT/ EDIT my self
export async function updateMyData(data: Partial<DataUser>, token: string): Promise<DataUser> {
  const res = await fetch(`${API_URL}/me`, {
    method: "PUT",
    headers: {
      "Content-Type": "application/json",
      Authorization: `Bearer ${token}`,
    },
    body: JSON.stringify(data),
  });

  if (!res.ok) {
    const errorText = await res.text(); // untuk debug semua jenis error
    console.error("Update error:", errorText);
    throw new Error("Failed to update current user");
  }

  return res.json();
}