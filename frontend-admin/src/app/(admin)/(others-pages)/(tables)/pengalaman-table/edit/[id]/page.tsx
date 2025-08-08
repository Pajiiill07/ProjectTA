"use client";

import React from "react";
import PengalamanForm from "@/components/form/PengalamanForm";
import { useParams } from "next/navigation";

export default function EditUserPage() {
    const params = useParams();
    const idParam = params.id as string;
    const pengalamanId = parseInt(idParam, 10);
  return (
    <div>
        <div>
            <h2 className="text-xl font-semibold text-gray-800 dark:text-white/90">Edit Pengalaman</h2>
        </div>
        <PengalamanForm mode="edit" pengalamanId={pengalamanId}/>
    </div>
  );
}
