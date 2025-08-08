"use client";

import React, { useEffect, useState } from "react";
import Link from "next/link";
import { deleteDataUser } from "@/lib/datauser-api";
import { PencilIcon, TrashBinIcon } from "@/icons";
import { User } from "@/lib/user-api";

interface DataUser {
  data_id: number;
  user_id: number;
  nama_lengkap: string;
  no_telp: string;
  linkedin: string;
  alamat: string;
  summary: string;
  create_at: string;
  update_at: string;
  user: User;
}

interface DataUserTableProps {
  datausers: DataUser[];
}

export default function DataUserTable({ datausers }: DataUserTableProps) {
  const [dataList, setDataUserList] = useState<DataUser[]>([]);

  useEffect(() => {
    setDataUserList(datausers);
  }, [datausers]);

  const handleDelete = async (id: number) => {
    const confirmDelete = window.confirm("Are you sure you want to delete?");
    if (!confirmDelete) return;

    const token = localStorage.getItem("access_token");
    if (!token) {
      alert("Anda belum login!");
      return;
    }

    try {
      await deleteDataUser(id, token);
      setDataUserList(dataList.filter((user) => user.data_id !== id));
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
              <th className="px-5 py-3">Nama Lengkap</th>
              <th className="px-5 py-3">No Telepon</th>
              <th className="px-5 py-3">LinkedIn</th>
              <th className="px-5 py-3">Alamat</th>
              <th className="px-5 py-3">Summary</th>
              <th className="px-5 py-3">Action</th>
            </tr>
          </thead>
          <tbody className="divide-y divide-gray-100 dark:divide-white/[0.05]">
            {dataList.length > 0 ? (
              dataList.map((datauser) => (
                <tr key={datauser.data_id}>
                  <td className="px-5 py-4">{datauser.user?.username}</td>
                  <td className="px-5 py-4">{datauser.nama_lengkap}</td>
                  <td className="px-5 py-4">{datauser.no_telp}</td>
                  <td className="px-5 py-4">{datauser.linkedin}</td>
                  <td className="px-5 py-4">{datauser.alamat}</td>
                  <td className="px-5 py-4">{datauser.summary}</td>
                  <td className="px-5 py-4">
                    <div className="flex gap-3">
                      <Link href={`/datauser-table/edit/${datauser.data_id}`}>
                        <button>
                          <PencilIcon className="w-6 h-6 text-yellow-500" />
                        </button>
                      </Link>
                      <button
                        onClick={() => handleDelete(datauser.data_id)}
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
