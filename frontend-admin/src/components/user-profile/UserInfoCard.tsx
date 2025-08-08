"use client";
import React, { useEffect, useState } from "react";
import { useModal } from "@/hooks/useModal";
import { Modal } from "../ui/modal";
import Button from "../ui/button/Button";
import Label from "../form/Label";
import { getMyData, updateMyData } from "@/lib/datauser-api";
import { DataUser } from "@/lib/datauser-api";


export default function UserInfoCard() {
  const { isOpen, openModal, closeModal } = useModal();
  const [dataUser, setDataUser] = useState<DataUser | null>(null);

  const [form, setForm] = useState({
    nama_lengkap: "",
    no_telp: "",
    linkedin: "",
    summary: ""
  });

  const [provinsiList, setProvinsiList] = useState<{ id: string; name: string }[]>([]);
  const [kotaList, setKotaList] = useState<{ id: string; name: string }[]>([]);

  const [selectedProvinsi, setSelectedProvinsi] = useState("");
  const [selectedKota, setSelectedKota] = useState("");

  useEffect(() => {
    const token = document.cookie.match(/access_token=([^;]+)/)?.[1];
    if (!token) return;

    getMyData(token).then((data) => {
      setDataUser(data);
      setForm({
        nama_lengkap: data.nama_lengkap,
        no_telp: data.no_telp,
        linkedin: data.linkedin,
        summary: data.summary
      });

      const [kota, provinsi] = data.alamat?.split(", ") || ["", ""];
      setSelectedKota(kota);

      fetch("https://www.emsifa.com/api-wilayah-indonesia/api/provinces.json")
        .then((res) => res.json())
        .then((prov) => {
          setProvinsiList(prov);
          const found = prov.find((p: any) => p.name === provinsi);
          if (found) {
            setSelectedProvinsi(found.id);
            fetch(`https://www.emsifa.com/api-wilayah-indonesia/api/regencies/${found.id}.json`)
              .then((res) => res.json())
              .then(setKotaList);
          }
        });
    });
  }, []);

  useEffect(() => {
    if (!selectedProvinsi) return;
    fetch(`https://www.emsifa.com/api-wilayah-indonesia/api/regencies/${selectedProvinsi}.json`)
      .then((res) => res.json())
      .then(setKotaList);
  }, [selectedProvinsi]);

  const handleSave = async () => {
    const token = document.cookie.match(/access_token=([^;]+)/)?.[1];
    if (!dataUser || !token) {
      alert("Token atau data user tidak tersedia.");
      return;
    }

    const provName = provinsiList.find((p) => p.id === selectedProvinsi)?.name || "";
    const alamatGabungan = selectedKota && provName ? `${selectedKota}, ${provName}` : "";

    const payload = { ...form, alamat: alamatGabungan };

    try {
      await updateMyData(payload, token);
      const updated = await getMyData(token);
      setDataUser(updated);
      closeModal();
    } catch (err) {
      console.error("Gagal update:", err);
      alert("Gagal menyimpan data.");
    }
  };

  if (!dataUser) return <p className=" text-gray-800 dark:text-white/90 xl:text-left">Loading...</p>;

  return (
    <div className="p-5 border border-gray-200 rounded-2xl dark:border-gray-800 lg:p-6">
      <div className="flex flex-col gap-6 lg:flex-row lg:items-start lg:justify-between">
        <div>
          <h4 className="text-lg font-semibold text-gray-800 dark:text-white/90 lg:mb-6">
            Personal Information
          </h4>

          <div className="grid grid-cols-1 gap-4 lg:grid-cols-2 lg:gap-6">
            <div>
              <p className="text-xs text-gray-500">Nama Lengkap</p>
              <p className="text-sm font-medium  text-gray-800 dark:text-white/90 xl:text-left">{dataUser.nama_lengkap}</p>
            </div>
            <div>
              <p className="text-xs text-gray-500">Email</p>
              <p className="text-sm font-medium  text-gray-800 dark:text-white/90 xl:text-left">{dataUser.user.email}</p>
            </div>
            <div>
              <p className="text-xs text-gray-500">Phone</p>
              <p className="text-sm font-medium  text-gray-800 dark:text-white/90 xl:text-left">{dataUser.no_telp}</p>
            </div>
            <div>
              <p className="text-xs text-gray-500">LinkedIn</p>
              <p className="text-sm font-medium break-all  text-gray-800 dark:text-white/90 xl:text-left">{dataUser.linkedin || "-"}</p>
            </div>
            <div className="col-span-2">
              <p className="text-xs text-gray-500">Alamat</p>
              <p className="text-sm font-medium  text-gray-800 dark:text-white/90 xl:text-left">{dataUser.alamat}</p>
            </div>
            <div className="col-span-2">
              <p className="text-xs text-gray-500">Summary</p>
              <p className="text-sm font-medium  text-gray-800 dark:text-white/90 xl:text-left">{dataUser.summary}</p>
            </div>
          </div>
        </div>

        <button
            onClick={openModal}
            className="flex w-full items-center justify-center gap-2 rounded-full border border-gray-300 bg-white px-4 py-3 text-sm font-medium text-gray-700 shadow-theme-xs hover:bg-gray-50 hover:text-gray-800 dark:border-gray-700 dark:bg-gray-800 dark:text-gray-400 dark:hover:bg-white/[0.03] dark:hover:text-gray-200 lg:inline-flex lg:w-auto"
          >
            <svg
              className="fill-current"
              width="18"
              height="18"
              viewBox="0 0 18 18"
              xmlns="http://www.w3.org/2000/svg"
            >
              <path
                fillRule="evenodd"
                clipRule="evenodd"
                d="M15.0911 2.78206C14.2125 1.90338 12.7878 1.90338 11.9092 2.78206L4.57524 10.116C4.26682 10.4244 4.0547 10.8158 3.96468 11.2426L3.31231 14.3352C3.25997 14.5833 3.33653 14.841 3.51583 15.0203C3.69512 15.1996 3.95286 15.2761 4.20096 15.2238L7.29355 14.5714C7.72031 14.4814 8.11172 14.2693 8.42013 13.9609L15.7541 6.62695C16.6327 5.74827 16.6327 4.32365 15.7541 3.44497L15.0911 2.78206ZM12.9698 3.84272C13.2627 3.54982 13.7376 3.54982 14.0305 3.84272L14.6934 4.50563C14.9863 4.79852 14.9863 5.2734 14.6934 5.56629L14.044 6.21573L12.3204 4.49215L12.9698 3.84272ZM11.2597 5.55281L5.6359 11.1766C5.53309 11.2794 5.46238 11.4099 5.43238 11.5522L5.01758 13.5185L6.98394 13.1037C7.1262 13.0737 7.25666 13.003 7.35947 12.9002L12.9833 7.27639L11.2597 5.55281Z"
                fill=""
              />
            </svg>
            Edit
          </button>
      </div>

      <Modal isOpen={isOpen} onClose={closeModal} className="max-w-2xl w-full">
        <div className="p-6">
          <h3 className="mb-2 text-2xl font-semibold text-gray-800 dark:text-white/90">Edit Personal Information</h3>
          <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
            <div>
              <Label>Nama Lengkap</Label>
              <input
                className="w-full px-3 py-2 text-sm rounded-lg border border-gray-300 dark:border-gray-600 bg-white dark:bg-gray-800 text-gray-900 dark:text-gray-100 focus:outline-none focus:ring-2 focus:ring-blue-500"
                value={form.nama_lengkap}
                onChange={(e) => setForm({ ...form, nama_lengkap: e.target.value })}
              />
            </div>
            <div>
              <Label>No Telepon</Label>
              <input
                className="w-full px-3 py-2 text-sm rounded-lg border border-gray-300 dark:border-gray-600 bg-white dark:bg-gray-800 text-gray-900 dark:text-gray-100 focus:outline-none focus:ring-2 focus:ring-blue-500"
                value={form.no_telp}
                onChange={(e) => setForm({ ...form, no_telp: e.target.value })}
              />
            </div>
            <div>
              <Label>LinkedIn</Label>
              <input
                className="w-full px-3 py-2 text-sm rounded-lg border border-gray-300 dark:border-gray-600 bg-white dark:bg-gray-800 text-gray-900 dark:text-gray-100 focus:outline-none focus:ring-2 focus:ring-blue-500"
                value={form.linkedin}
                onChange={(e) => setForm({ ...form, linkedin: e.target.value })}
              />
            </div>
            <div>
              <Label>Provinsi</Label>
              <select
                className="w-full px-3 py-2 text-sm rounded-lg border border-gray-300 dark:border-gray-600 bg-white dark:bg-gray-800 text-gray-900 dark:text-gray-100 focus:outline-none focus:ring-2 focus:ring-blue-500"
                value={selectedProvinsi}
                onChange={(e) => {
                  setSelectedProvinsi(e.target.value);
                  setSelectedKota("");
                }}
              >
                <option value="">Pilih Provinsi</option>
                {provinsiList.map((p) => (
                  <option key={p.id} value={p.id}>
                    {p.name}
                  </option>
                ))}
              </select>
            </div>
            <div>
              <Label>Kota</Label>
              <select
                className="w-full px-3 py-2 text-sm rounded-lg border border-gray-300 dark:border-gray-600 bg-white dark:bg-gray-800 text-gray-900 dark:text-gray-100 focus:outline-none focus:ring-2 focus:ring-blue-500"
                value={selectedKota}
                onChange={(e) => setSelectedKota(e.target.value)}
                disabled={!selectedProvinsi}
              >
                <option value="">Pilih Kota</option>
                {kotaList.map((k) => (
                  <option key={k.id} value={k.name}>
                    {k.name}
                  </option>
                ))}
              </select>
            </div>
            <div className="md:col-span-2">
              <Label>Summary</Label>
              <textarea
                className="w-full px-3 py-2 text-sm rounded-lg border border-gray-300 dark:border-gray-600 bg-white dark:bg-gray-800 text-gray-900 dark:text-gray-100 focus:outline-none focus:ring-2 focus:ring-blue-500"
                rows={3}
                value={form.summary}
                onChange={(e) => setForm({ ...form, summary: e.target.value })}
              />
            </div>
          </div>

          <div className="flex justify-end mt-6 gap-3">
            <Button variant="outline" onClick={closeModal}>Cancel</Button>
            <Button onClick={handleSave}>Save</Button>
          </div>
        </div>
      </Modal>
    </div>
  );
}
