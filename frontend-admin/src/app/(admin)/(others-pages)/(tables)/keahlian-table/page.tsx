"use client";

import React, { useEffect, useState } from "react";
import PageBreadcrumb from "@/components/common/PageBreadCrumb";
import BasicTableOne from "@/components/tables/KeahlianTable";
import { getKeahlians, Keahlian } from "@/lib/keahlian-api";
import { PlusIcon } from "@/icons";
import Link from "next/link";

export default function BasicTables() {
  const [keahlians, setKeahlians] = useState<Keahlian[]>([]);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    const fetchData = async () => {
      const token = localStorage.getItem("access_token");
      if (!token) {
        setError("Token not found");
        return;
      }

      try {
        const data = await getKeahlians(token);
        setKeahlians(data);
      } catch (err: any) {
        setError(err.message || "Failed to fetch keahlian");
      }
    };

    fetchData();
  }, []);

  if (error) return <p className="text-red-600">{error}</p>;

  return (
    <div>
      <PageBreadcrumb pageTitle="User Skills Tables" />
      <div className="space-y-6">
        <div className="flex items-center justify-between mb-6">
          <h2 className="text-xl font-semibold text-gray-800 dark:text-white/90">
            User Skills List
          </h2>
          <Link href="keahlian-table/add">
            <button className="flex items-center gap-2 px-4 py-2 text-sm font-medium text-white bg-blue-600 rounded-md hover:bg-blue-700">
              <PlusIcon className="w-4 h-4" />
              Add New
            </button>
          </Link>
        </div>

        <BasicTableOne Keahlians={keahlians} />
      </div>
    </div>
  );
}
