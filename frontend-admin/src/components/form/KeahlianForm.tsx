"use client";

import React, { useState, useEffect } from "react";
import { useRouter } from "next/navigation";
import ComponentCard from "@/components/common/ComponentCard";
import Label from "@/components/form/Label";
import { addKeahlian, editKeahlian, getKeahlianById } from "@/lib/keahlian-api";
import { getUsers } from "@/lib/user-api";

type KeahlianFormProps = {
  mode: "add" | "edit";
  keahlianId?: number;
};

interface UserOption {
  user_id: number;
  username: string;
}

  const kategoriOptions = [
    { value: "Soft Skill", label: "Soft Skill" },
    { value: "Hard Skill", label: "Hard Skill" },
  ];

export default function KeahlianForm({ mode, keahlianId }: KeahlianFormProps) {
  const [user_id, setUserId] = useState("");
  const [userOptions, setUserOptions] = useState<UserOption[]>([]);

  const [nama_skill, setNama] = useState("");
  const [tingkat, setTingkat] = useState("");
  const [kategori, setKategori] = useState("");

  const router = useRouter();

  useEffect(() => {
    getUsers()
      .then(setUserOptions)
      .catch((err) => console.error("Gagal fetch users:", err));
  }, []);

  useEffect(() => {
    if (mode === "edit" && keahlianId) {
      const token = localStorage.getItem("access_token");
      if (!token) {
        alert("Token tidak ditemukan, silakan login ulang.");
        router.push("/signin");
        return;
      }

      getKeahlianById(keahlianId, token)
        .then((data) => {
          setUserId(String(data.user_id));
          setNama(data.nama_skill);
          setTingkat(data.tingkat);
          setKategori(data.kategori);
        })
        .catch((err) => {
          console.error(err);
          alert("Gagal memuat keahlian user");
        });
    }
  }, [mode, keahlianId, router]);

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
      nama_skill,
      kategori
    };

    try {
      if (mode === "add") {
        await addKeahlian(formData, token);
        alert("Keahlian User berhasil ditambahkan!");
      } else {
        await editKeahlian(keahlianId!, formData, token);
        alert("Keahlian User berhasil diupdate!");
      }

      router.push("/keahlian-table");
    } catch (error) {
      console.error(error);
      alert("Terjadi kesalahan saat menyimpan data.");
    }
  };

  return (
    <ComponentCard title={mode === "add" ? "Add Data User" : "Edit Data User"}>
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
          <Label>Nama Skill {mode === "add" && <span className="text-error-500">*</span>} </Label>
          <input
              type="text"
              value={nama_skill}
              onChange={(e) => setNama(e.target.value)}
              placeholder="Enter skill"
              className="w-full px-3 py-2 text-sm rounded-lg border border-gray-300 dark:border-gray-600 bg-white dark:bg-gray-800 text-gray-900 dark:text-gray-100 focus:outline-none focus:ring-2 focus:ring-blue-500"
            />
        </div>

        <div>
          <Label>Kategori {mode === "add" && <span className="text-error-500">*</span>} </Label>
          <select
            value={kategori}
            onChange={(e) => setKategori(e.target.value)}
            className="w-full px-3 py-2 text-sm rounded-lg border border-gray-300 dark:border-gray-600 bg-white dark:bg-gray-800 text-gray-900 dark:text-gray-100 focus:outline-none focus:ring-2 focus:ring-blue-500"
          >
            <option value="">Pilih Kategori</option>
            {kategoriOptions.map((opt) => (
              <option key={opt.value} value={opt.value}>
                {opt.label}
              </option>
            ))}
          </select>
        </div>

        <button
          type="submit"
          className="px-4 py-2 font-medium text-white bg-blue-600 rounded hover:bg-blue-700"
        >
          {mode === "add" ? "Add Data User" : "Update Data User"}
        </button>
      </form>
    </ComponentCard>
  );
}
