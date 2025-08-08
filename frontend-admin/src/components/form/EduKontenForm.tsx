"use client";

import React, { useState, useEffect } from "react";
import { useRouter } from "next/navigation";
import ComponentCard from "@/components/common/ComponentCard";
import Label from "@/components/form/Label";
import { addEduKonten, editEduKonten, getEduKontenById } from "@/lib/edukonten-api";

type EduKontenFormProps = {
  mode: "add" | "edit";
  kontenId?: number;
};

export default function EduKontenForm({ mode, kontenId }: EduKontenFormProps) {
  const [judul, setJudul] = useState("");
  const [isi, setIsi] = useState("");
  const [kategori, setKategori] = useState("");
  const [sumber, setSumber] = useState("");

  const router = useRouter();

  const kategoriOptions = [
    { value: "Artikel", label: "Artikel" },
    { value: "Tips", label: "Tips" },
  ];

  useEffect(() => {
    if (mode === "edit" && kontenId) {
      const token = localStorage.getItem("access_token");
      if (!token) {
        alert("Token tidak ditemukan, silakan login ulang.");
        router.push("/signin");
        return;
      }

      getEduKontenById(kontenId, token)
        .then((data) => {
          setJudul(data.judul);
          setIsi(data.isi);
          setKategori(data.kategori);
          setSumber(data.sumber);
        })
        .catch((err) => {
          console.error(err);
          alert("Gagal memuat data user");
        });
    }
  }, [mode, kontenId, router]);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();

    const token = localStorage.getItem("access_token");
    if (!token) {
      alert("Token tidak ditemukan.");
      router.push("/signin");
      return;
    }

    const formData = {
      judul,
      isi,
      kategori,
      sumber,
    };

    try {
      if (mode === "add") {
        await addEduKonten(formData, token);
        alert("Konten berhasil ditambahkan!");
      } else {
        await editEduKonten(kontenId!, formData, token);
        alert("Konten berhasil diupdate!");
      }

      router.push("/edukonten-table");
    } catch (error) {
      console.error(error);
      alert("Terjadi kesalahan saat menyimpan data.");
    }
  };

  return (
    <ComponentCard title={mode === "add" ? "Add Konten Edukasi" : "Edit Konten Edukasi"}>
      <form className="space-y-6" onSubmit={handleSubmit}>

        <div>
          <Label>Judul Konten {mode === "add" && <span className="text-error-500">*</span>} </Label>
          <input
              type="text"
              value={judul}
              onChange={(e) => setJudul(e.target.value)}
              placeholder="Enter judul konten"
              className="w-full px-3 py-2 text-sm rounded-lg border border-gray-300 dark:border-gray-600 bg-white dark:bg-gray-800 text-gray-900 dark:text-gray-100 focus:outline-none focus:ring-2 focus:ring-blue-500"
            />
        </div>

        <div>
          <Label>
            Isi Konten {mode === "add" && <span className="text-error-500">*</span>}
          </Label>
          <textarea
            value={isi}
            onChange={(e) => setIsi(e.target.value)}
            placeholder="Enter konten"
            rows={3}
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

        <div>
          <Label>Sumber {mode === "add" && <span className="text-error-500">*</span>} </Label>
          <input
              type="text"
              value={sumber}
              onChange={(e) => setSumber(e.target.value)}
              placeholder="Enter sumber"
              className="w-full px-3 py-2 text-sm rounded-lg border border-gray-300 dark:border-gray-600 bg-white dark:bg-gray-800 text-gray-900 dark:text-gray-100 focus:outline-none focus:ring-2 focus:ring-blue-500"
            />
        </div>

        <button
          type="submit"
          className="px-4 py-2 font-medium text-white bg-blue-600 rounded hover:bg-blue-700"
        >
          {mode === "add" ? "Add Konten" : "Update Konten"}
        </button>
      </form>
    </ComponentCard>
  );
}
