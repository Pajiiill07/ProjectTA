import React from "react";
import UserForm from "@/components/form/UserForm";
import PageBreadcrumb from "@/components/common/PageBreadCrumb";

export default function AddUserPage() {
  return (
    <div>
        <PageBreadcrumb pageTitle="Form Add User" />

        <div className="mb-6">
            <h2 className="text-xl font-semibold text-gray-800 dark:text-white/90">Add New User</h2>
            <UserForm mode="add" />
         </div>
    </div>
    
  );
}
