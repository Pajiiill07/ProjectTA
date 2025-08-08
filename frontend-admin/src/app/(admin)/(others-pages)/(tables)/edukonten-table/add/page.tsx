import React from "react";
import EduKontenForm from "@/components/form/EduKontenForm";
import PageBreadcrumb from "@/components/common/PageBreadCrumb";

export default function AddUserPage() {
  return (
    <div>
        <PageBreadcrumb pageTitle="Form Add Edukasi Konten" />

        <div className="mb-6">
            <h2 className="text-xl font-semibold text-gray-800 dark:text-white/90">Add New Konten</h2>
            <EduKontenForm mode="add" />
         </div>
    </div>
    
  );
}
