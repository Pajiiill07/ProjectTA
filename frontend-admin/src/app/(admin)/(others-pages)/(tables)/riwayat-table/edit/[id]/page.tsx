"use client";

import React from "react";
import RiwayatPendidikanForm from "@/components/form/RiwayatPendidikanForm";
import { useParams } from "next/navigation";

export default function EditUserPage() {
    const params = useParams();
    const idParam = params.id as string;
    const riwayatId = parseInt(idParam, 10);
  return (
    <div>
        <div>
            <h2 className="text-xl font-semibold text-gray-800 dark:text-white/90">Edit Riwayat</h2>
        </div>
        <RiwayatPendidikanForm mode="edit" riwayatId={riwayatId}/>
    </div>
  );
}
