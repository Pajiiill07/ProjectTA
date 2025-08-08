"use client";

import React, { useEffect, useState } from "react";
import Link from "next/link";
import { deleteRiwayatPendidikan } from "@/lib/riwayatpdd-api";
import { PencilIcon, TrashBinIcon } from "@/icons";
import { User } from "@/lib/user-api";

interface RiwayatPendidikan {
  riwayat_id: number;
  user_id: number;
  jenjang: 	string;
  instansi: string;
  jurusan: string;
  tahun_mulai: string;
  tahun_selesai: string;
  create_at:string;
  update_at: string;
  user: User;
}

interface RiwayatPendidikanTableProps {
  RiwayatPendidikans: RiwayatPendidikan[];
}

export default function RiwayatPendidikanTable({ RiwayatPendidikans }: RiwayatPendidikanTableProps) {
  const [dataList, setRiwayatPendidikanList] = useState<RiwayatPendidikan[]>([]);

  useEffect(() => {
    setRiwayatPendidikanList(RiwayatPendidikans);
  }, [RiwayatPendidikans]);

  const handleDelete = async (id: number) => {
    const confirmDelete = window.confirm("Are you sure you want to delete?");
    if (!confirmDelete) return;

    const token = localStorage.getItem("access_token");
    if (!token) {
      alert("Anda belum login!");
      return;
    }

    try {
      await deleteRiwayatPendidikan(id, token);
      setRiwayatPendidikanList(dataList.filter((user) => user.riwayat_id !== id));
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
              <th className="px-5 py-3">Jenjang Pendidikan</th>
              <th className="px-5 py-3">Instansi</th>
              <th className="px-5 py-3">Jurusan</th>
              <th className="px-5 py-3">Tahun Mulai</th>
              <th className="px-5 py-3">Tahun Selesai</th>
              <th className="px-5 py-3">Action</th>
            </tr>
          </thead>
          <tbody className="divide-y divide-gray-100 dark:divide-white/[0.05]">
            {dataList.length > 0 ? (
              dataList.map((RiwayatPendidikan) => (
                <tr key={RiwayatPendidikan.riwayat_id}>
                  <td className="px-5 py-4">{RiwayatPendidikan.user?.username}</td>
                  <td className="px-5 py-4">{RiwayatPendidikan.jenjang}</td>
                  <td className="px-5 py-4">{RiwayatPendidikan.instansi}</td>
                  <td className="px-5 py-4">{RiwayatPendidikan.jurusan}</td>
                  <td className="px-5 py-4">{RiwayatPendidikan.tahun_mulai}</td>
                  <td className="px-5 py-4">{RiwayatPendidikan.tahun_selesai}</td>
                  <td className="px-5 py-4">
                    <div className="flex gap-3">
                      <Link href={`/riwayat-table/edit/${RiwayatPendidikan.riwayat_id}`}>
                        <button>
                          <PencilIcon className="w-6 h-6 text-yellow-500" />
                        </button>
                      </Link>
                      <button
                        onClick={() => handleDelete(RiwayatPendidikan.riwayat_id)}
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
