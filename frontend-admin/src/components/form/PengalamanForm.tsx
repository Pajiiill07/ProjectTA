"use client";

import React, { useState, useEffect } from "react";
import { useRouter } from "next/navigation";
import ComponentCard from "@/components/common/ComponentCard";
import Label from "@/components/form/Label";
import { addPengalaman, editPengalaman, getPengalamanById } from "@/lib/pengalaman-api";
import { getUsers } from "@/lib/user-api";

type PengalamanFormProps = {
  mode: "add" | "edit";
  pengalamanId?: number;
};

interface UserOption {
  user_id: number;
  username: string;
}


export default function PengalamanForm({ mode, pengalamanId }: PengalamanFormProps) {
  const [user_id, setUserId] = useState("");
  const [userOptions, setUserOptions] = useState<UserOption[]>([]);

  const [judul, setJudul] = useState("");
  const [instansi, setInstansi] = useState("");
  const [tanggal_kegiatan, setTanggal] = useState("");
  const [keterangan, setKeterangan] = useState("");

  const router = useRouter();

  useEffect(() => {
    getUsers()
      .then(setUserOptions)
      .catch((err) => console.error("Gagal fetch users:", err));
  }, []);

  useEffect(() => {
    if (mode === "edit" && pengalamanId) {
      const token = localStorage.getItem("access_token");
      if (!token) {
        alert("Token tidak ditemukan, silakan login ulang.");
        router.push("/signin");
        return;
      }

      getPengalamanById(pengalamanId, token)
        .then((pengalaman) => {
          setUserId(String(pengalaman.user_id));
          setJudul(pengalaman.judul);
          setInstansi(pengalaman.instansi);
          setTanggal(String(pengalaman.tanggal_kegiatan));
          setKeterangan(pengalaman.keterangan);
        })
        .catch((err) => {
          console.error(err);
          alert("Gagal memuat pengalaman user");
        });
    }
  }, [mode, pengalamanId, router]);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();

    const token = localStorage.getItem("access_token");
    if (!token) {
      alert("Token tidak ditemukan.");
      router.push("/signin");
      return;
    }

    const formData = {
      user_id: parseInt(user_id),
      judul,
      instansi,
      tanggal_kegiatan: mode === "add" ? `${tanggal_kegiatan}-01-01` : tanggal_kegiatan,
      keterangan
    };

    try {
      if (mode === "add") {
        await addPengalaman(formData, token);
        alert("Pengalaman berhasil ditambahkan!");
      } else {
        await editPengalaman(pengalamanId!, formData, token);
        alert("Pengalaman berhasil diupdate!");
      }

      router.push("/pengalaman-table");
    } catch (error) {
      console.error(error);
      alert("Terjadi kesalahan saat menyimpan data.");
    }
  };

  return (
    <ComponentCard title={mode === "add" ? "Add pengalaman Pendidikan" : "Edit pengalaman Pendidikan"}>
      <form className="space-y-6" onSubmit={handleSubmit}>
        <div>
          <Label>User {mode === "add" && <span className="text-error-500">*</span>} </Label>
          <select
            value={user_id}
            onChange={(e) => setUserId(e.target.value)}
            className="w-full px-3 py-2 text-sm rounded-lg border border-gray-300 dark:border-gray-600 bg-white dark:bg-gray-800 text-gray-900 dark:text-gray-100 focus:outline-none focus:ring-2 focus:ring-blue-500"
          >
            <option value="">Pilih User</option>
            {userOptions.map((user) => (
              <option key={user.user_id} value={user.user_id}>
                {user.username}
              </option>
            ))}
          </select>
        </div>

        <div>
          <Label>Judul Kegiatan {mode === "add" && <span className="text-error-500">*</span>} </Label>
          <input
            type="text"
            value={judul}
            onChange={(e) => setJudul(e.target.value)}
            placeholder="Enter judul kegiatan"
            className="w-full px-3 py-2 text-sm rounded-lg border border-gray-300 dark:border-gray-600 bg-white dark:bg-gray-800 text-gray-900 dark:text-gray-100 focus:outline-none focus:ring-2 focus:ring-blue-500"
          />
        </div>

        <div>
          <Label>Instansi {mode === "add" && <span className="text-error-500">*</span>} </Label>
          <input
            type="text"
            value={instansi}
            onChange={(e) => setInstansi(e.target.value)}
            placeholder="Enter Instansi"
            className="w-full px-3 py-2 text-sm rounded-lg border border-gray-300 dark:border-gray-600 bg-white dark:bg-gray-800 text-gray-900 dark:text-gray-100 focus:outline-none focus:ring-2 focus:ring-blue-500"
          />
        </div>

        <div>
          <Label>Waktu Kegiatan {mode === "add" && <span className="text-error-500">*</span>} </Label>
          <select
            value={tanggal_kegiatan}
            onChange={(e) => setTanggal(e.target.value)}
            className="w-full px-3 py-2 text-sm rounded-lg border border-gray-300 dark:border-gray-600 bg-white dark:bg-gray-800 text-gray-900 dark:text-gray-100 focus:outline-none focus:ring-2 focus:ring-blue-500"
          >
            <option value="">Pilih Waktu Kegiatan</option>
            {Array.from({ length: 50 }, (_, i) => {
              const year = new Date().getFullYear() - i;
              return (
                <option key={year} value={year}>
                  {year}
                </option>
              );
            })}
          </select>
        </div>

        <div>
          <Label>
            Keterangan {mode === "add" && <span className="text-error-500">*</span>}
          </Label>
          <textarea
            value={keterangan}
            onChange={(e) => setKeterangan(e.target.value)}
            placeholder="Enter deskripsi kegiatan"
            rows={3}
            className="w-full px-3 py-2 text-sm rounded-lg border border-gray-300 dark:border-gray-600 bg-white dark:bg-gray-800 text-gray-900 dark:text-gray-100 focus:outline-none focus:ring-2 focus:ring-blue-500"
          />
        </div>

        <button
          type="submit"
          className="px-4 py-2 font-medium text-white bg-blue-600 rounded hover:bg-blue-700"
        >
          {mode === "add" ? "Add Pengalaman" : "Update Pengalaman"}
        </button>
      </form>
    </ComponentCard>
  );
}
