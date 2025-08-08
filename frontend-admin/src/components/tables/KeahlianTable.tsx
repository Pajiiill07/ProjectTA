"use client";

import React, { useEffect, useState } from "react";
import Link from "next/link";
import { deleteKeahlian } from "@/lib/keahlian-api";
import { PencilIcon, TrashBinIcon } from "@/icons";
import { User } from "@/lib/user-api";

interface Keahlian {
  keahlian_id: number;
  user_id: number;
  nama_skill: string;
  kategori: string;
  create_at: string;
  update_at: string;
  user: User	
}

interface KeahlianTableProps {
  Keahlians: Keahlian[];
}

export default function KeahlianTable({ Keahlians }: KeahlianTableProps) {
  const [dataList, setKeahlianList] = useState<Keahlian[]>([]);

  useEffect(() => {
    setKeahlianList(Keahlians);
  }, [Keahlians]);

  const handleDelete = async (id: number) => {
    const confirmDelete = window.confirm("Are you sure you want to delete?");
    if (!confirmDelete) return;

    const token = localStorage.getItem("access_token");
    if (!token) {
      alert("Anda belum login!");
      return;
    }

    try {
      await deleteKeahlian(id, token);
      setKeahlianList(dataList.filter((user) => user.keahlian_id !== id));
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
              <th className="px-5 py-3">Skill</th>
              <th className="px-5 py-3">Kategori</th>
              <th className="px-5 py-3">Action</th>
            </tr>
          </thead>
          <tbody className="divide-y divide-gray-100 dark:divide-white/[0.05]">
            {dataList.length > 0 ? (
              dataList.map((Keahlian) => (
                <tr key={Keahlian.keahlian_id}>
                  <td className="px-5 py-4">{Keahlian.user?.username}</td>
                  <td className="px-5 py-4">{Keahlian.nama_skill}</td>
                  <td className="px-5 py-4">{Keahlian.kategori}</td>
                  <td className="px-5 py-4">
                    <div className="flex gap-3">
                      <Link href={`/keahlian-table/edit/${Keahlian.keahlian_id}`}>
                        <button>
                          <PencilIcon className="w-6 h-6 text-yellow-500" />
                        </button>
                      </Link>
                      <button
                        onClick={() => handleDelete(Keahlian.keahlian_id)}
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
