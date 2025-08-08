import React from "react";
import DataUserForm from "@/components/form/DataUserForm";
import PageBreadcrumb from "@/components/common/PageBreadCrumb";

export default function AddUserPage() {
  return (
    <div>
        <PageBreadcrumb pageTitle="Form Add Data User" />

        <div className="mb-6">
            <h2 className="text-xl font-semibold text-gray-800 dark:text-white/90">Add New Data User</h2>
            <DataUserForm mode="add" />
         </div>
    </div>
    
  );
}
