"use client";

import React, { useEffect, useState } from "react";
import PageBreadcrumb from "@/components/common/PageBreadCrumb";
import BasicTableOne from "@/components/tables/RiwayatPendidikanTable";
import { getRiwayatPdd, RiwayatPendidikan } from "@/lib/riwayatpdd-api";
import { PlusIcon } from "@/icons";
import Link from "next/link";

export default function BasicTables() {
  const [riwayatpendidikans, setRiwayatPendidikans] = useState<RiwayatPendidikan[]>([]);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    const fetchData = async () => {
      const token = localStorage.getItem("access_token");
      if (!token) {
        setError("Token not found");
        return;
      }

      try {
        const data = await getRiwayatPdd(token);
        setRiwayatPendidikans(data);
      } catch (err: any) {
        setError(err.message || "Failed to fetch riwayat pendidikan");
      }
    };

    fetchData();
  }, []);

  if (error) return <p className="text-red-600">{error}</p>;

  return (
    <div>
      <PageBreadcrumb pageTitle="Riwayat Pendidikan User Tables" />
      <div className="space-y-6">
        <div className="flex items-center justify-between mb-6">
          <h2 className="text-xl font-semibold text-gray-800 dark:text-white/90">
            Riwayat Pendidikan Users List
          </h2>
          <Link href="riwayat-table/add">
            <button className="flex items-center gap-2 px-4 py-2 text-sm font-medium text-white bg-blue-600 rounded-md hover:bg-blue-700">
              <PlusIcon className="w-4 h-4" />
              Add New
            </button>
          </Link>
        </div>

        <BasicTableOne RiwayatPendidikans={riwayatpendidikans} />
      </div>
    </div>
  );
}
