const API_URL = "http://192.168.18.51:8000/keahlians";
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

export interface Keahlian {
  keahlian_id: number;
  user_id: number;
  nama_skill: string;
  kategori: string;
  create_at: string;
  update_at: string;
  user: User	
}

// GET all data keahlians
export async function getKeahlians(token: string): Promise<Keahlian[]> {
  const res = await fetch(API_URL, {
    headers: {
      Authorization: `Bearer ${token}`
    }
  });
  if (!res.ok) throw new Error("Failed to fetch data keahlians");
  return res.json();
}

// GET data keahlian by id
export async function getKeahlianById(keahlian_id: number, token: string): Promise<Keahlian> {
  const res = await fetch(`${API_URL}/${keahlian_id}`, {
    headers: {
      Authorization: `Bearer ${token}`
    }
  });
  if (!res.ok) throw new Error("Failed to fetch data keahlian by id");
  return res.json();
}

// DELETE data keahlian
export async function deleteKeahlian(keahlian_id: number) {
  const token = getAccessToken();
  if (!token) {
    throw new Error("Token not found");
  }

  const res = await fetch(`${API_URL}/${keahlian_id}`, {
    method: "DELETE",
    headers: {
      Authorization: `Bearer ${token}`
    }
  });
  if (!res.ok) throw new Error("Failed to delete data keahlian");
}

// ADD data keahlian
export async function addKeahlian(
  data: Omit<Keahlian, "keahlian_id" | "create_at" | "update_at">,
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
  if (!res.ok) throw new Error("Failed to add data keahlian");
  return res.json();
}

// EDIT data keahlian
export async function editKeahlian(
  keahlian_id: number,
  data: Partial<Keahlian>,
  token: string
) {
  const res = await fetch(`${API_URL}/${keahlian_id}`, {
    method: "PUT",
    headers: {
      Authorization: `Bearer ${token}`,
      "Content-Type": "application/json"
    },
    body: JSON.stringify(data),
  });
  if (!res.ok) throw new Error("Failed to edit data keahlian");
  return res.json();
}