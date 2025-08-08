import React from "react";
import RiwayatPendidikanForm from "@/components/form/RiwayatPendidikanForm";
import PageBreadcrumb from "@/components/common/PageBreadCrumb";

export default function AddUserPage() {
  return (
    <div>
        <PageBreadcrumb pageTitle="Form Add Riwayat Pendidikan User" />

        <div className="mb-6">
            <h2 className="text-xl font-semibold text-gray-800 dark:text-white/90">Add New Riwayat</h2>
            <RiwayatPendidikanForm mode="add" />
         </div>
    </div>
    
  );
}
