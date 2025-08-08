"use client";
import React, { useEffect, useState } from "react";
import { DocsIcon, EyeIcon, GroupIcon } from "@/icons";
import { getUsers } from "@/lib/user-api";
import { getDeteksi } from "@/lib/deteksi-api";
import { getEduKontens } from "@/lib/edukonten-api";

export const EcommerceMetrics = () => {
  const [userCount, setUserCount] = useState<number | null>(null);
  const [detectionCount, setDetectionCount] = useState<number | null>(null);
  const [eduCount, setEduCount] = useState<number | null>(null);

  useEffect(() => {
    const fetchData = async () => {
      try {
        const token = localStorage.getItem("access_token");

        if (!token) {
          console.error("Token not found");
          return;
        }

        const [users, detections, edukontens] = await Promise.all([
          getUsers(),
          getDeteksi(token),
          getEduKontens(token),
        ]);

        setUserCount(users.length);
        setDetectionCount(detections.length);
        setEduCount(edukontens.length);
      } catch (error) {
        console.error("Error fetching data:", error);
      }
    };

    fetchData();
  }, []);


  return (
    <div className="grid grid-cols-1 gap-4 sm:grid-cols-3 md:gap-6">
      <MetricCard
        icon={<GroupIcon className="text-gray-800 size-6 dark:text-white/90" />}
        title="Users"
        value={userCount}
      />
      <MetricCard
        icon={<EyeIcon className="text-gray-800 dark:text-white/90" />}
        title="Detections"
        value={detectionCount}
      />
      <MetricCard
        icon={<DocsIcon className="text-gray-800 dark:text-white/90" />}
        title="Education Contents"
        value={eduCount}
      />
    </div>
  );
};

const MetricCard = ({
  icon,
  title,
  value,
}: {
  icon: React.ReactNode;
  title: string;
  value: number | null;
}) => {
  return (
    <div className="rounded-2xl border border-gray-200 bg-white p-5 dark:border-gray-800 dark:bg-white/[0.03] md:p-6">
      <div className="flex items-center justify-center w-12 h-12 bg-gray-100 rounded-xl dark:bg-gray-800">
        {icon}
      </div>
      <div className="flex items-end justify-between mt-5">
        <div>
          <span className="text-sm text-gray-500 dark:text-gray-400">
            {title}
          </span>
          <h4 className="mt-2 font-bold text-gray-800 text-title-sm dark:text-white/90">
            {value !== null ? value.toLocaleString() : "Loading..."}
          </h4>
        </div>
      </div>
    </div>
  );
};
