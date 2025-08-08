"use client";

import React, { useEffect, useState } from "react";
import Link from "next/link";
import { deletePengalaman } from "@/lib/pengalaman-api";
import { PencilIcon, TrashBinIcon } from "@/icons";
import { User } from "@/lib/user-api";

interface Pengalaman {
  pengalaman_id: number;
  user_id: number;
  judul: string;
  instansi: string;
  tanggal_kegiatan: string;
  keterangan: string;
  create_at: string;
  update_at: string;
  user: User
}

interface PengalamanTableProps {
  pengalamans: Pengalaman[];
}

export default function PengalamanTable({ pengalamans }: PengalamanTableProps) {
  const [dataList, setPengalamanList] = useState<Pengalaman[]>([]);

  useEffect(() => {
    setPengalamanList(pengalamans);
  }, [pengalamans]);

  const handleDelete = async (id: number) => {
    const confirmDelete = window.confirm("Are you sure you want to delete?");
    if (!confirmDelete) return;

    const token = localStorage.getItem("access_token");
    if (!token) {
      alert("Anda belum login!");
      return;
    }

    try {
      await deletePengalaman(id, token);
      setPengalamanList(dataList.filter((user) => user.pengalaman_id !== id));
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
              <th className="px-5 py-3">Judul Kegiatan</th>
              <th className="px-5 py-3">Instansi</th>
              <th className="px-5 py-3">Waktu Kegiatan</th>
              <th className="px-5 py-3">Keterangan</th>
              <th className="px-5 py-3">Action</th>
            </tr>
          </thead>
          <tbody className="divide-y divide-gray-100 dark:divide-white/[0.05]">
            {dataList.length > 0 ? (
              dataList.map((pengalaman) => (
                <tr key={pengalaman.pengalaman_id}>
                  <td className="px-5 py-4">{pengalaman.user?.username}</td>
                  <td className="px-5 py-4">{pengalaman.judul}</td>
                  <td className="px-5 py-4">{pengalaman.instansi}</td>
                  <td className="px-5 py-4">{pengalaman.tanggal_kegiatan}</td>
                  <td className="px-5 py-4">{pengalaman.keterangan}</td>
                  <td className="px-5 py-4">
                    <div className="flex gap-3">
                      <Link href={`/pengalaman-table/edit/${pengalaman.pengalaman_id}`}>
                        <button>
                          <PencilIcon className="w-6 h-6 text-yellow-500" />
                        </button>
                      </Link>
                      <button
                        onClick={() => handleDelete(pengalaman.pengalaman_id)}
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
