"use client";

import React, { useEffect, useState } from "react";
// import Link from "next/link";
import { deleteDeteksi } from "@/lib/deteksi-api";
import { TrashBinIcon } from "@/icons";
import { User } from "@/lib/user-api";

interface Deteksi {
  deteksi_id: number;
  user_id: number;
  judul: string;
  perusahaan: string;
  deskripsi: string;
  hasil: string;
  tanggal_deteksi: string;	
  create_at: string;
  update_at: string;
  user: User;
}

interface DeteksiTableProps {
  Deteksis: Deteksi[];
}

export default function DeteksiTable({ Deteksis }: DeteksiTableProps) {
  const [dataList, setDeteksiList] = useState<Deteksi[]>([]);

  useEffect(() => {
    setDeteksiList(Deteksis);
  }, [Deteksis]);

  const handleDelete = async (id: number) => {
    const confirmDelete = window.confirm("Are you sure you want to delete?");
    if (!confirmDelete) return;

    const token = localStorage.getItem("access_token");
    if (!token) {
      alert("Anda belum login!");
      return;
    }

    try {
      await deleteDeteksi(id, token);
      setDeteksiList(dataList.filter((user) => user.deteksi_id !== id));
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
              <th className="px-5 py-3">Username</th>
              <th className="px-5 py-3">Judul Lowongan</th>
              <th className="px-5 py-3">Nama Perusahaan</th>
              <th className="px-5 py-3">Deskripsi Pekerjaan</th>
              <th className="px-5 py-3">Hasil</th>
              <th className="px-5 py-3">Tanggal Deteksi</th>
              <th className="px-5 py-3">Action</th>
            </tr>
          </thead>
          <tbody className="divide-y divide-gray-100 dark:divide-white/[0.05]">
            {dataList.length > 0 ? (
              dataList.map((deteksi) => (
                <tr key={deteksi.deteksi_id}>
                  <td className="px-5 py-4">{deteksi.user?.username}</td>
                  <td className="px-5 py-4">{deteksi.judul}</td>
                  <td className="px-5 py-4">{deteksi.perusahaan}</td>
                  <td className="px-5 py-4">{deteksi.deskripsi}</td>
                  <td className="px-5 py-4">{deteksi.hasil}</td>
                  <td className="px-5 py-4">{deteksi.tanggal_deteksi}</td>
                  <td className="px-5 py-4">
                    <div className="flex gap-3">
                      {/* <Link href={`/riwayat-table/edit/${Deteksi.deteksi_id}`}>
                        <button>
                          <PencilIcon className="w-6 h-6 text-yellow-500" />
                        </button>
                      </Link> */}
                      <button
                        onClick={() => handleDelete(deteksi.deteksi_id)}
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
