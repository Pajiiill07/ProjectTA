const API_URL = "http://192.168.18.51:8000/edu_kontens";
function getAccessToken(): string | null {
  const match = document.cookie.match(/access_token=([^;]+)/);
  return match ? match[1] : null;
}

export interface EduKonten {
  konten_id: number;
  judul: string;
  isi: string;
  kategori: string;
  sumber: string;
  create_at: string;
  update_at: string;
}

// GET all data EduKontens
export async function getEduKontens(token: string): Promise<EduKonten[]> {
  const res = await fetch(API_URL, {
    headers: {
      Authorization: `Bearer ${token}`
    }
  });
  if (!res.ok) throw new Error("Failed to fetch data EduKontens");
  return res.json();
}

// GET data EduKonten by id
export async function getEduKontenById(konten_id: number, token: string): Promise<EduKonten> {
  const res = await fetch(`${API_URL}/${konten_id}`, {
    headers: {
      Authorization: `Bearer ${token}`
    }
  });
  if (!res.ok) throw new Error("Failed to fetch data EduKonten by id");
  return res.json();
}

// DELETE data EduKonten
export async function deleteEduKonten(konten_id: number) {
  const token = getAccessToken();
  if (!token) {
    throw new Error("Token not found");
  }

  const res = await fetch(`${API_URL}/${konten_id}`, {
    method: "DELETE",
    headers: {
      Authorization: `Bearer ${token}`
    }
  });
  if (!res.ok) throw new Error("Failed to delete data EduKonten");
}

// ADD data EduKonten
export async function addEduKonten(
  data: Omit<EduKonten, "konten_id" | "create_at" | "update_at">,
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
  if (!res.ok) throw new Error("Failed to add data EduKonten");
  return res.json();
}

// EDIT data EduKonten
export async function editEduKonten(
  konten_id: number,
  data: Partial<EduKonten>,
  token: string
) {
  const res = await fetch(`${API_URL}/${konten_id}`, {
    method: "PUT",
    headers: {
      Authorization: `Bearer ${token}`,
      "Content-Type": "application/json"
    },
    body: JSON.stringify(data),
  });
  if (!res.ok) throw new Error("Failed to edit data EduKonten");
  return res.json();
}