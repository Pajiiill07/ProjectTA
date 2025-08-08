import React from "react";
import KeahlianForm from "@/components/form/KeahlianForm";
import PageBreadcrumb from "@/components/common/PageBreadCrumb";

export default function AddUserPage() {
  return (
    <div>
        <PageBreadcrumb pageTitle="Form Add Keahlian" />

        <div className="mb-6">
            <h2 className="text-xl font-semibold text-gray-800 dark:text-white/90">Add New Keahlian</h2>
            <KeahlianForm mode="add" />
         </div>
    </div>
    
  );
}
