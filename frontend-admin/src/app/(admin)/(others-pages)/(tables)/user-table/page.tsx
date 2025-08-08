import PageBreadcrumb from "@/components/common/PageBreadCrumb";
import { PlusIcon } from "@/icons";
import Link from "next/link";
import { getUsers } from "@/lib/user-api";
import UserTable from "@/components/tables/UserTable";

export default async function UserTablesPage() {
  const users = await getUsers();

  return (
    <div> 
      <PageBreadcrumb pageTitle="User Table" />

      <div className="flex items-center justify-between mb-6">
        <h2 className="text-xl font-semibold text-gray-800 dark:text-white/90">User List</h2>
        <Link href="user-table/add">
          <button className="flex items-center gap-2 px-4 py-2 text-sm font-medium text-white bg-blue-600 rounded-md hover:bg-blue-700">
            <PlusIcon className="w-4 h-4" />
            Add New User
          </button>
        </Link>
      </div>

      <UserTable users={users} />
    </div>
  );
}
