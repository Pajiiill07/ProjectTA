"use client";

import React, { useState, useEffect } from "react";
import { useRouter } from "next/navigation";
import ComponentCard from "@/components/common/ComponentCard";
import Label from "@/components/form/Label";
import { addDataUser, editDataUser, getDataUserById } from "@/lib/datauser-api";
import { getUsers } from "@/lib/user-api";

type DataUserFormProps = {
  mode: "add" | "edit";
  dataId?: number;
};

interface UserOption {
  user_id: number;
  username: string;
}

export default function DataUserForm({ mode, dataId }: DataUserFormProps) {
  const [user_id, setUserId] = useState("");
  const [userOptions, setUserOptions] = useState<UserOption[]>([]);

  const [nama_lengkap, setNama] = useState("");
  const [no_telp, setNope] = useState("");
  const [linkedin, setLinkedin] = useState("");
  const [summary, setSummary] = useState("");

  const [provinsiList, setProvinsiList] = useState<{ id: string; name: string }[]>([]);
  const [kotaList, setKotaList] = useState<{ id: string; name: string }[]>([]);

  const [selectedProvinsi, setSelectedProvinsi] = useState("");
  const [selectedKota, setSelectedKota] = useState("");

  const router = useRouter();

  // Fetch user list
  useEffect(() => {
    getUsers()
      .then(setUserOptions)
      .catch((err) => console.error("Gagal fetch users:", err));
  }, []);

  // Fetch provinsi
  useEffect(() => {
    fetch("https://www.emsifa.com/api-wilayah-indonesia/api/provinces.json")
      .then((res) => res.json())
      .then(setProvinsiList)
      .catch((err) => console.error("Gagal fetch provinsi:", err));
  }, []);

  // Fetch kota berdasarkan provinsi
  useEffect(() => {
    if (!selectedProvinsi) return;
    fetch(`https://www.emsifa.com/api-wilayah-indonesia/api/regencies/${selectedProvinsi}.json`)
      .then((res) => res.json())
      .then(setKotaList)
      .catch((err) => console.error("Gagal fetch kota:", err));
  }, [selectedProvinsi]);

  // Fetch data untuk mode edit
  useEffect(() => {
    if (mode === "edit" && dataId) {
      const token = localStorage.getItem("access_token");
      if (!token) {
        alert("Token tidak ditemukan, silakan login ulang.");
        router.push("/signin");
        return;
      }

      getDataUserById(dataId, token)
        .then((data) => {
          setUserId(String(data.user_id));
          setNama(data.nama_lengkap);
          setNope(data.no_telp);
          setLinkedin(data.linkedin);
          setSummary(data.summary);

          const [kota, provinsi] = data.alamat.split(", ");
          setSelectedKota(kota);
          // Find provinsi ID based on name
          fetch("https://www.emsifa.com/api-wilayah-indonesia/api/provinces.json")
            .then((res) => res.json())
            .then((provList) => {
              setProvinsiList(provList);
              const found = provList.find((p) => p.name === provinsi);
              if (found) {
                setSelectedProvinsi(found.id);
              }
            });
        })
        .catch((err) => {
          console.error(err);
          alert("Gagal memuat data user");
        });
    }
  }, [mode, dataId, router]);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();

    const token = localStorage.getItem("access_token");
    if (!token) {
      alert("Token tidak ditemukan.");
      router.push("/signin");
      return;
    }

    const provinsiName = provinsiList.find(p => p.id === selectedProvinsi)?.name || "";
    const alamatGabungan = selectedKota && provinsiName ? `${selectedKota}, ${provinsiName}` : "";

    const formData = {
      user_id: parseInt(user_id),
      nama_lengkap,
      no_telp,
      linkedin,
      alamat: alamatGabungan,
      summary,
    };

    try {
      if (mode === "add") {
        await addDataUser(formData, token);
        alert("Data User berhasil ditambahkan!");
      } else {
        await editDataUser(dataId!, formData, token);
        alert("Data User berhasil diupdate!");
      }

      router.push("/datauser-table");
    } catch (error) {
      console.error(error);
      alert("Terjadi kesalahan saat menyimpan data.");
    }
  };

  return (
    <ComponentCard title={mode === "add" ? "Add Data User" : "Edit Data User"}>
      <form className="space-y-6" onSubmit={handleSubmit}>
        
        <div>
          <Label>User {mode === "add" && <span className="text-error-500">*</span>}</Label>
          <select
            value={user_id}
            onChange={(e) => setUserId(e.target.value)}
            className="w-full px-3 py-2 text-sm rounded-lg border border-gray-300 dark:border-gray-600 bg-white dark:bg-gray-800 text-gray-900 dark:text-gray-100 focus:outline-none focus:ring-2 focus:ring-blue-500"
          >
            <option value=""> Pilih User </option>
            {userOptions.map((user) => (
              <option key={user.user_id} value={user.user_id}>
                {user.username}
              </option>
            ))}
          </select>
        </div>

        <div>
          <Label>Nama Lengkap {mode === "add" && <span className="text-error-500">*</span>}</Label>
          <input
            type="text"
            value={nama_lengkap}
            onChange={(e) => setNama(e.target.value)}
            className="w-full px-3 py-2 text-sm rounded-lg border border-gray-300 dark:border-gray-600 bg-white dark:bg-gray-800 text-gray-900 dark:text-gray-100 focus:outline-none focus:ring-2 focus:ring-blue-500"
          />
        </div>

        <div>
          <Label>No Telepon {mode === "add" && <span className="text-error-500">*</span>}</Label>
          <input
            type="text"
            value={no_telp}
            onChange={(e) => setNope(e.target.value)}
            className="w-full px-3 py-2 text-sm rounded-lg border border-gray-300 dark:border-gray-600 bg-white dark:bg-gray-800 text-gray-900 dark:text-gray-100 focus:outline-none focus:ring-2 focus:ring-blue-500"
          />
        </div>

        <div>
          <Label>LinkedIn {mode === "add" && <span className="text-error-500">*</span>}</Label>
          <input
            type="text"
            value={linkedin}
            onChange={(e) => setLinkedin(e.target.value)}
            className="w-full px-3 py-2 text-sm rounded-lg border border-gray-300 dark:border-gray-600 bg-white dark:bg-gray-800 text-gray-900 dark:text-gray-100 focus:outline-none focus:ring-2 focus:ring-blue-500"
          />
        </div>

        <div>
          <Label>Provinsi {mode === "add" && <span className="text-error-500">*</span>}</Label>
          <select
            value={selectedProvinsi}
            onChange={(e) => {
              setSelectedProvinsi(e.target.value);
              setSelectedKota("");
            }}
            className="w-full px-3 py-2 text-sm rounded-lg border border-gray-300 dark:border-gray-600 bg-white dark:bg-gray-800 text-gray-900 dark:text-gray-100 focus:outline-none focus:ring-2 focus:ring-blue-500"
          >
            <option value="">Pilih Provinsi</option>
            {provinsiList.map((prov) => (
              <option key={prov.id} value={prov.id}>
                {prov.name}
              </option>
            ))}
          </select>
        </div>

        <div>
          <Label>Kota {mode === "add" && <span className="text-error-500">*</span>}</Label>
          <select
            value={selectedKota}
            onChange={(e) => setSelectedKota(e.target.value)}
            className="w-full px-3 py-2 text-sm rounded-lg border border-gray-300 dark:border-gray-600 bg-white dark:bg-gray-800 text-gray-900 dark:text-gray-100 focus:outline-none focus:ring-2 focus:ring-blue-500"
            disabled={!selectedProvinsi}
          >
            <option value="">Pilih Kota</option>  
            {kotaList.map((kota) => (
              <option key={kota.id} value={kota.name}>
                {kota.name}
              </option>
            ))}
          </select>
        </div>

        <div>
          <Label>Summary {mode === "add" && <span className="text-error-500">*</span>}</Label>
          <textarea
            value={summary}
            onChange={(e) => setSummary(e.target.value)}
            rows={3}
            className="w-full px-3 py-2 text-sm rounded-lg border border-gray-300 dark:border-gray-600 bg-white dark:bg-gray-800 text-gray-900 dark:text-gray-100 focus:outline-none focus:ring-2 focus:ring-blue-500"
          />
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
