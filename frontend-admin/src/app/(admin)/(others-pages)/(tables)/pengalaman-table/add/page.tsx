import React from "react";
import PengalamanForm from "@/components/form/PengalamanForm";
import PageBreadcrumb from "@/components/common/PageBreadCrumb";

export default function AddUserPage() {
  return (
    <div>
        <PageBreadcrumb pageTitle="Form Add Pengalaman" />

        <div className="mb-6">
            <h2 className="text-xl font-semibold text-gray-800 dark:text-white/90">Add New Pengalaman</h2>
            <PengalamanForm mode="add" />
         </div>
    </div>
    
  );
}
