"use client";

import React, { useState } from "react";
import Link from "next/link";
import { deleteUser } from "@/lib/user-api";
import { PencilIcon, TrashBinIcon } from "@/icons";

interface User {
  user_id: number;
  username: string;
  email: string;
  role: string;
  photo_url: string;
  create_at: string;
  update_at: string;
}

interface UserTableProps {
  users: User[];
}

export default function UserTable({ users }: UserTableProps) {
  const [userList, setUserList] = useState(users);

  const handleDelete = async (id: number) => {
    const confirm = window.confirm("Are you sure want to delete?");
    if (!confirm) return;

    try {
      await deleteUser(id);
      // setelah berhasil delete, update state supaya refresh data
      setUserList(userList.filter(user => user.user_id !== id));
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
              <th className="px-5 py-3">Name</th>
              <th className="px-5 py-3">Email</th>
              <th className="px-5 py-3">Role</th>
              <th className="px-5 py-3">Photo</th>
              <th className="px-5 py-3">Action</th>
            </tr>
          </thead>
          <tbody className="divide-y divide-gray-100 dark:divide-white/[0.05]">
            {userList.map((user) => (
              <tr key={user.user_id}>
                <td className="px-5 py-4">{user.username}</td>
                <td className="px-5 py-4">{user.email}</td>
                <td className="px-5 py-4">{user.role}</td>
                <td className="px-5 py-4">
                  <img
                    src={`http://192.168.18.51:8000${user.photo_url || '/static/upload/default.jpeg'}`}
                    alt="Profile Photo"
                    className="w-15 h-15 rounded-full object-cover"
                  />
                </td>
                <td className="px-5 py-4">
                  <div className="flex gap-3">
                    <Link href={`/user-table/edit/${user.user_id}`}>
                      <button>
                        <PencilIcon className="w-6 h-6 text-yellow-500" />
                      </button>
                    </Link>
                    <button
                      onClick={() => handleDelete(user.user_id)}
                    >
                      <TrashBinIcon className="w-6 h-6 text-red-500" />
                    </button>
                  </div>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );
}
