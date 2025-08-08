"use client";

import React from "react";
import KeahlianForm from "@/components/form/KeahlianForm";
import { useParams } from "next/navigation";

export default function EditUserPage() {
    const params = useParams();
    const idParam = params.id as string;
    const keahlianId = parseInt(idParam, 10);
  return (
    <div>
        <div>
            <h2 className="text-xl font-semibold text-gray-800 dark:text-white/90">Edit Keahlian</h2>
        </div>
        <KeahlianForm mode="edit" keahlianId={keahlianId}/>
    </div>
  );
}
