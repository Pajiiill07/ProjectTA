"use client";

import React from "react";
import EduKontenForm from "@/components/form/EduKontenForm";
import { useParams } from "next/navigation";

export default function EditUserPage() {
    const params = useParams();
    const idParam = params.id as string;
    const kontenId = parseInt(idParam, 10);
  return (
    <div>
        <div>
            <h2 className="text-xl font-semibold text-gray-800 dark:text-white/90">Edit Konten</h2>
        </div>
        <EduKontenForm mode="edit" kontenId={kontenId}/>
    </div>
  );
}
