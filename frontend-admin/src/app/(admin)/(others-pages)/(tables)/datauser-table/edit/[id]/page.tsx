"use client";

import React from "react";
import DataUserForm from "@/components/form/DataUserForm";
import { useParams } from "next/navigation";

export default function EditUserPage() {
    const params = useParams();
    const idParam = params.id as string;
    const dataId = parseInt(idParam, 10);
  return (
    <div>
        <div>
            <h2 className="text-xl font-semibold text-gray-800 dark:text-white/90">Edit User</h2>
        </div>
        <DataUserForm mode="edit" dataId={dataId}/>
    </div>
  );
}
