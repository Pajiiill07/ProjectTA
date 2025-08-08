const API_URL = "http://192.168.18.51:8000/deteksi";
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

export interface Deteksi {
  deteksi_id: number;
  user_id: number;
  judul: string;
  perusahaan: string;
  deskripsi: string;
  hasil: string;
  tanggal_deteksi: Date;	
  create_at: string;
  update_at: string;
  user: User;
}

// GET all data Deteksi
export async function getDeteksi(token: string): Promise<Deteksi[]> {
  const res = await fetch(API_URL, {
    headers: {
      Authorization: `Bearer ${token}`
    }
  });
  if (!res.ok) throw new Error("Failed to fetch data Deteksi");
  return res.json();
}

// GET data Deteksi by id
export async function getDeteksiById(deteksi_id: number, token: string): Promise<Deteksi> {
  const res = await fetch(`${API_URL}/${deteksi_id}`, {
    headers: {
      Authorization: `Bearer ${token}`
    }
  });
  if (!res.ok) throw new Error("Failed to fetch data Deteksi by id");
  return res.json();
}

// DELETE data user
export async function deleteDeteksi(deteksi_id: number) {
  const token = getAccessToken();
  if (!token) {
    throw new Error("Token not found");
  }

  const res = await fetch(`${API_URL}/${deteksi_id}`, {
    method: "DELETE",
    headers: {
      Authorization: `Bearer ${token}`
    }
  });
  if (!res.ok) throw new Error("Failed to delete data user");
}