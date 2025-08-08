"use client";

import React, { useEffect, useState } from "react";
import Link from "next/link";
import { deleteEduKonten } from "@/lib/edukonten-api";
import { PencilIcon, TrashBinIcon } from "@/icons";

interface EduKonten {
  konten_id: number;
  judul: string;
  isi: string;
  kategori: string;
  sumber: string;
  create_at: string;
  update_at: string;
}

interface EduKontenTableProps {
  EduKontens: EduKonten[];
}

export default function EduKontenTable({ EduKontens }: EduKontenTableProps) {
  const [dataList, setEduKontenList] = useState<EduKonten[]>([]);

  useEffect(() => {
    setEduKontenList(EduKontens);
  }, [EduKontens]);

  const handleDelete = async (id: number) => {
    const confirmDelete = window.confirm("Are you sure you want to delete?");
    if (!confirmDelete) return;

    const token = localStorage.getItem("access_token");
    if (!token) {
      alert("Anda belum login!");
      return;
    }

    try {
      await deleteEduKonten(id, token);
      setEduKontenList(dataList.filter((user) => user.konten_id !== id));
    } catch (error) {
      console.error("Error deleting user:", error);
      alert("Failed to delete user.");
    }
  };

  return (
    <div className="overflow-hidden rounded-xl border border-gray-200 bg-white dark:border-white/[0.05] dark:bg-white/[0.03]">
      <div className="max-w-full overflow-x-auto">
        <table className="w-full text-sm text-left text-gray-500">
          <thead className="border-b border-gray-100 dark:border-white/[0.05]">
            <tr>
              <th className="px-5 py-3">Judul</th>
              <th className="px-5 py-3">Isi Konten</th>
              <th className="px-5 py-3">Kategori</th>
              <th className="px-5 py-3">Sumber</th>
              <th className="px-5 py-3">Action</th>
            </tr>
          </thead>
          <tbody className="divide-y divide-gray-100 dark:divide-white/[0.05]">
            {dataList.length > 0 ? (
              dataList.map((EduKonten) => (
                <tr key={EduKonten.konten_id}>
                  <td className="px-5 py-4">{EduKonten.judul}</td>
                  <td className="px-5 py-4">{EduKonten.isi}</td>
                  <td className="px-5 py-4">{EduKonten.kategori}</td>
                  <td className="px-5 py-4">{EduKonten.sumber}</td>
                  <td className="px-5 py-4">
                    <div className="flex gap-3">
                      <Link href={`/edukonten-table/edit/${EduKonten.konten_id}`}>
                        <button>
                          <PencilIcon className="w-6 h-6 text-yellow-500" />
                        </button>
                      </Link>
                      <button
                        onClick={() => handleDelete(EduKonten.konten_id)}
                      >
                        <TrashBinIcon className="w-6 h-6 text-red-500" />
                      </button>
                    </div>
                  </td>
                </tr>
              ))
            ) : (
              <tr>
                <td colSpan={7} className="px-5 py-4 text-center text-gray-400">
                  Tidak ada data ditemukan.
                </td>
              </tr>
            )}
          </tbody>
        </table>
      </div>
    </div>
  );
}
