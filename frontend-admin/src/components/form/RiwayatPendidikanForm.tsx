"use client";

import React, { useState, useEffect } from "react";
import { useRouter } from "next/navigation";
import ComponentCard from "@/components/common/ComponentCard";
import Label from "@/components/form/Label";
import { addRiwayatPdd, editRiwayatPdd, getRiwayatPddById } from "@/lib/riwayatpdd-api";
import { getUsers } from "@/lib/user-api";

type RiwayatPendidikanFormProps = {
  mode: "add" | "edit";
  riwayatId?: number;
};

interface UserOption {
  user_id: number;
  username: string;
}

const jenjangOptions = [
    { value: "SLTA", label: "SLTA" },
    { value: "D3", label: "D3" },
    { value: "D4/S1", label: "D4/S1" },
    { value: "S2", label: "S2" },
    { value: "S3", label: "S3" },
  ];

export default function RiwayatPendidikanForm({ mode, riwayatId }: RiwayatPendidikanFormProps) {
  const [user_id, setUserId] = useState("");
  const [userOptions, setUserOptions] = useState<UserOption[]>([]);

  const [jenjang, setJenjang] = useState("");
  const [instansi, setInstansi] = useState("");
  const [jurusan, setJurusan] = useState("");
  const [tahun_mulai, setMulai] = useState("");
  const [tahun_selesai, setSelesai] = useState("");

  const router = useRouter();

  useEffect(() => {
    getUsers()
      .then(setUserOptions)
      .catch((err) => console.error("Gagal fetch users:", err));
  }, []);

  useEffect(() => {
    if (mode === "edit" && riwayatId) {
      const token = localStorage.getItem("access_token");
      if (!token) {
        alert("Token tidak ditemukan, silakan login ulang.");
        router.push("/signin");
        return;
      }

      getRiwayatPddById(riwayatId, token)
        .then((riwayat) => {
          setUserId(String(riwayat.user_id));
          setJenjang(riwayat.jenjang);
          setInstansi(riwayat.instansi);
          setJurusan(riwayat.jurusan);
          setMulai(riwayat.tahun_mulai?.slice(0, 4));
          setSelesai(riwayat.tahun_selesai ? riwayat.tahun_selesai.slice(0, 4) : "");
        })
        .catch((err) => {
          console.error(err);
          alert("Gagal memuat riwayat pendidikan user");
        });
    }
  }, [mode, riwayatId, router]);

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
      jenjang,
      instansi,
      jurusan,
      tahun_mulai: `${tahun_mulai}-01-01`,
      tahun_selesai: tahun_selesai ? `${tahun_selesai}-01-01` : null,
    };

    try {
      if (mode === "add") {
        await addRiwayatPdd(formData, token);
        alert("Riwayat Pendidikan berhasil ditambahkan!");
      } else {
        await editRiwayatPdd(riwayatId!, formData, token);
        alert("Riwayat Pendidikan berhasil diupdate!");
      }

      router.push("/riwayat-table");
    } catch (error) {
      console.error(error);
      alert("Terjadi kesalahan saat menyimpan data.");
    }
  };

  return (
    <ComponentCard title={mode === "add" ? "Add Riwayat Pendidikan" : "Edit Riwayat Pendidikan"}>
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
          <Label>Jenjang Pendidikan {mode === "add" && <span className="text-error-500">*</span>} </Label>
          <select
            value={jenjang}
            onChange={(e) => setJenjang(e.target.value)}
            className="w-full px-3 py-2 text-sm rounded-lg border border-gray-300 dark:border-gray-600 bg-white dark:bg-gray-800 text-gray-900 dark:text-gray-100 focus:outline-none focus:ring-2 focus:ring-blue-500"
          >
            <option value="">Pilih Jenjang</option>
            {jenjangOptions.map((opt) => (
              <option key={opt.value} value={opt.value}>
                {opt.label}
              </option>
            ))}
          </select>
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
          <Label>Jurusan {mode === "add" && <span className="text-error-500">*</span>} </Label>
          <input
            type="text"
            value={jurusan}
            onChange={(e) => setJurusan(e.target.value)}
            placeholder="Enter jurusan"
            className="w-full px-3 py-2 text-sm rounded-lg border border-gray-300 dark:border-gray-600 bg-white dark:bg-gray-800 text-gray-900 dark:text-gray-100 focus:outline-none focus:ring-2 focus:ring-blue-500"
          />
        </div>

        <div>
          <Label>Tahun Mulai {mode === "add" && <span className="text-error-500">*</span>} </Label>
          <select
            value={tahun_mulai}
            onChange={(e) => setMulai(e.target.value)}
            className="w-full px-3 py-2 text-sm rounded-lg border border-gray-300 dark:border-gray-600 bg-white dark:bg-gray-800 text-gray-900 dark:text-gray-100 focus:outline-none focus:ring-2 focus:ring-blue-500"
          >
            <option value="">Pilih Tahun Mulai</option>
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
          <Label>Tahun Selesai </Label>
          <select
            value={tahun_selesai}
            onChange={(e) => setSelesai(e.target.value)}
            className="w-full px-3 py-2 text-sm rounded-lg border border-gray-300 dark:border-gray-600 bg-white dark:bg-gray-800 text-gray-900 dark:text-gray-100 focus:outline-none focus:ring-2 focus:ring-blue-500"
          >
            <option value="">Pilih Tahun Selesai</option>
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

        <button
          type="submit"
          className="px-4 py-2 font-medium text-white bg-blue-600 rounded hover:bg-blue-700"
        >
          {mode === "add" ? "Add Riwayat Pendidikan" : "Update Riwayat Pendidikan"}
        </button>
      </form>
    </ComponentCard>
  );
}
