"use client";

import React, { useState, useEffect } from "react";
import { useRouter } from "next/navigation";
import ComponentCard from "@/components/common/ComponentCard";
import Label from "@/components/form/Label";
import { addUser, editUser, getUserById } from "@/lib/user-api";
import { EyeCloseIcon, EyeIcon } from "@/icons";

type UserFormProps = {
  mode: "add" | "edit";
  userId?: number;
};

export default function UserForm({ mode, userId }: UserFormProps) {
  const [username, setUsername] = useState("");
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [role, setRole] = useState("");
  const [photoFile, setPhotoFile] = useState<File | null>(null);
  const [photoPreview, setPhotoPreview] = useState<string | null>(null);
  const [showPassword, setShowPassword] = useState(false);
  const router = useRouter();

  const roleOptions = [
    { value: "admin", label: "Admin" },
    { value: "user", label: "User" },
  ];

  // Fetch user data for edit mode
  useEffect(() => {
    if (mode === "edit" && userId) {
      getUserById(userId)
        .then((data) => {
          setUsername(data.username);
          setEmail(data.email);
          setPassword("");
          setRole(data.role);
          setPhotoPreview(
            `http://192.168.18.51:8000/${data.photo_url || "static/upload/default.jpeg"}`
          );
        })
        .catch((err) => {
          console.error(err);
          alert("Gagal memuat data user");
        });
    }
  }, [mode, userId]);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();

    const formData = {
      username,
      email,
      password,
      role,
      photoFile,
    };

    try {
      if (mode === "add") {
        await addUser(formData);
        alert("User berhasil ditambahkan!");
      } else {
        await editUser(userId!, formData);
        alert("User berhasil diupdate!");
      }

      router.push("/user-table");
    } catch (error) {
      console.error(error);
      alert("Terjadi kesalahan saat menyimpan data.");
    }
  };

  return (
    <ComponentCard title={mode === "add" ? "Add User" : "Edit User"}>
      <form className="space-y-6" onSubmit={handleSubmit}>
        <div>
          <Label>Username {mode === "add" && <span className="text-error-500">*</span>}</Label>
          <input
            type="text"
            value={username}
            onChange={(e) => setUsername(e.target.value)}
            placeholder="Enter Username"
            className="w-full px-3 py-2 text-sm rounded-lg border border-gray-300 dark:border-gray-600 bg-white dark:bg-gray-800 text-gray-900 dark:text-gray-100 focus:outline-none focus:ring-2 focus:ring-blue-500"
          />
        </div>

        <div>
          <Label>Email {mode === "add" && <span className="text-error-500">*</span>} </Label>
          <input
            type="text"
            value={email}
            onChange={(e) => setEmail(e.target.value)}
            placeholder="Enter Email"
            className="w-full px-3 py-2 text-sm rounded-lg border border-gray-300 dark:border-gray-600 bg-white dark:bg-gray-800 text-gray-900 dark:text-gray-100 focus:outline-none focus:ring-2 focus:ring-blue-500"
          />
        </div>

        <div>
          <Label>Password {mode === "add" && <span className="text-error-500">*</span>} </Label>
          <div className="relative">
            <input
              type="text"
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              placeholder="Enter password"
              className="w-full px-3 py-2 text-sm rounded-lg border border-gray-300 dark:border-gray-600 bg-white dark:bg-gray-800 text-gray-900 dark:text-gray-100 focus:outline-none focus:ring-2 focus:ring-blue-500"
            />
            <button
              type="button"
              onClick={() => setShowPassword(!showPassword)}
              className="absolute z-30 -translate-y-1/2 cursor-pointer right-4 top-1/2"
            >
              {showPassword ? (
                <EyeIcon className="fill-gray-500 dark:fill-gray-400" />
              ) : (
                <EyeCloseIcon className="fill-gray-500 dark:fill-gray-400" />
              )}
            </button>
          </div>
        </div>

        <div>
          <Label>Role {mode === "add" && <span className="text-error-500">*</span>} </Label>
          <select
            value={role}
            onChange={(e) => setRole(e.target.value)}
            className="w-full px-3 py-2 text-sm rounded-lg border border-gray-300 dark:border-gray-600 bg-white dark:bg-gray-800 text-gray-900 dark:text-gray-100 focus:outline-none focus:ring-2 focus:ring-blue-500"
          >
            <option value="">Pilih Role</option>
            {roleOptions.map((opt) => (
              <option key={opt.value} value={opt.value}>
                {opt.label}
              </option>
            ))}
          </select>
        </div>

        <div>
          <Label>Foto Profil</Label>

          <div className="relative w-full">
            <label
              htmlFor="photo-upload"
              className="block w-full px-4 py-2 text-sm text-gray-700 bg-gray-100 border border-gray-300 rounded cursor-pointer hover:bg-gray-200 dark:text-gray-200 dark:bg-gray-800 dark:border-gray-600 dark:hover:bg-gray-700"
            >
              Pilih Foto
            </label>
            <input
              id="photo-upload"
              type="file"
              accept="image/*"
              onChange={(e) => {
                const file = e.target.files?.[0];
                if (file) {
                  setPhotoFile(file);
                  setPhotoPreview(URL.createObjectURL(file));
                } else {
                  setPhotoFile(null);
                  setPhotoPreview(null);
                }
              }}
              className="hidden"
            />
            <p className="mt-2 text-sm text-gray-700 dark:text-gray-300">
              {photoFile?.name || "Belum ada file dipilih"}
            </p>
          </div>

          {photoPreview && (
            <div className="mt-2">
              <img
                src={photoPreview}
                alt="Preview"
                className="w-24 h-24 object-cover rounded-full"
              />
            </div>
          )}
        </div>

        <button
          type="submit"
          className="px-4 py-2 font-medium text-white bg-blue-600 rounded hover:bg-blue-700"
        >
          {mode === "add" ? "Add User" : "Update User"}
        </button>
      </form>
    </ComponentCard>
  );
}
