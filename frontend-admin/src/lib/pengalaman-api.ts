const API_URL = "http://192.168.18.51:8000/pengalamans";
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

export interface Pengalaman {
  pengalaman_id: number;
  user_id: number;
  judul: string;
  instansi: string;
  tanggal_kegiatan: Date;
  keterangan: string;
  create_at: string;
  update_at: string;
  user: User	
}

// GET all data pengalamans
export async function getPengalamans(token: string): Promise<Pengalaman[]> {
  const res = await fetch(API_URL, {
    headers: {
      Authorization: `Bearer ${token}`
    }
  });
  if (!res.ok) throw new Error("Failed to fetch data pengalamans");
  return res.json();
}

// GET data pengalaman by id
export async function getPengalamanById(pengalaman_id: number, token: string): Promise<Pengalaman> {
  const res = await fetch(`${API_URL}/${pengalaman_id}`, {
    headers: {
      Authorization: `Bearer ${token}`
    }
  });
  if (!res.ok) throw new Error("Failed to fetch data pengalaman by id");
  return res.json();
}

// DELETE data pengalaman
export async function deletePengalaman(pengalaman_id: number) {
  const token = getAccessToken();
  if (!token) {
    throw new Error("Token not found");
  }

  const res = await fetch(`${API_URL}/${pengalaman_id}`, {
    method: "DELETE",
    headers: {
      Authorization: `Bearer ${token}`
    }
  });
  if (!res.ok) throw new Error("Failed to delete data pengalaman");
}

// ADD data pengalaman
export async function addPengalaman(
  data: Omit<Pengalaman, "pengalaman_id" | "create_at" | "update_at">,
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
  if (!res.ok) throw new Error("Failed to add data pengalaman");
  return res.json();
}

// EDIT data pengalaman
export async function editPengalaman(
  pengalaman_id: number,
  data: any, // bisa kamu sesuaikan dengan type yang benar nanti
  token: string
) {
  const res = await fetch(`${API_URL}/${pengalaman_id}`, {
    method: "PUT",
    headers: {
      Authorization: `Bearer ${token}`,
      "Content-Type": "application/json"
    },
    body: JSON.stringify(data),
  });

  if (!res.ok) {
    let message = "Failed to edit data pengalaman";

    try {
      const errorData = await res.json();
      console.error("Error detail from backend:", errorData);
      message += ": " + JSON.stringify(errorData);
    } catch (err) {
      console.error("Failed to parse error response from backend");
    }

    throw new Error(message);
  }

  return res.json();
}
