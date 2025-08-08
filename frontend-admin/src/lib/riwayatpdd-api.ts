const API_URL = "http://192.168.18.51:8000/riwayat_pendidikans";
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

export interface RiwayatPendidikan {
  riwayat_id: number;
  user_id: number;
  jenjang: 	string;
  instansi: string;
  jurusan: string;
  tahun_mulai: Date;
  tahun_selesai: Date;
  create_at:string;
  update_at: string;
  user: User;
}

// GET all riwayat pendidikan
export async function getRiwayatPdd(token: string): Promise<RiwayatPendidikan[]> {
  const res = await fetch(API_URL, {
    headers: {
      Authorization: `Bearer ${token}`
    }
  });
  if (!res.ok) throw new Error("Failed to fetch data riwayat pendidikan");
  return res.json();
}

// GET riwayat pendidikan by id
export async function getRiwayatPddById(riwayat_id: number, token: string): Promise<RiwayatPendidikan> {
  const res = await fetch(`${API_URL}/${riwayat_id}`, {
    headers: {
      Authorization: `Bearer ${token}`
    }
  });
  if (!res.ok) throw new Error("Failed to fetch riwayat pendidikan by id");
  return res.json();
}

// DELETE riwayat pendidikan
export async function deleteRiwayatPendidikan(riwayat_id: number) {
  const token = getAccessToken();
  if (!token) {
    throw new Error("Token not found");
  }

  const res = await fetch(`${API_URL}/${riwayat_id}`, {
    method: "DELETE",
    headers: {
      Authorization: `Bearer ${token}`
    }
  });
  if (!res.ok) throw new Error("Failed to delete riwayat pendidikan");
}

// ADD riwayat pendidikan
export async function addRiwayatPdd(
  data: Omit<RiwayatPendidikan, "riwayat_id" | "create_at" | "update_at">,
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
  if (!res.ok) throw new Error("Failed to add riwayat pendidikan");
  return res.json();
}

// EDIT riwayat pendidikan
export async function editRiwayatPdd(
  riwayat_id: number,
  data: any, // bisa kamu sesuaikan dengan type yang benar nanti
  token: string
) {
  const res = await fetch(`${API_URL}/${riwayat_id}`, {
    method: "PUT",
    headers: {
      Authorization: `Bearer ${token}`,
      "Content-Type": "application/json"
    },
    body: JSON.stringify(data),
  });

  if (!res.ok) {
    let message = "Failed to edit data riwayat";

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