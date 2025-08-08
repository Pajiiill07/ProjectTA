import { getCookie } from "@/lib/getCookie";
import { useEffect, useState } from "react";

export function useUser() {
    const [ user, setUser ] = useState<any>(null);
    const [ loading, setLoading ] = useState(true);
    const baseUrl = "http://192.168.18.51:8000";

    useEffect(() => {
        const fetchUser = async () => {
            try {
                const res = await fetch(`${baseUrl}/users/me/profile` , {
                    headers: {
                        Authorization: `Bearer ${getCookie("access_token")}`,
                    }
                });

                if (res.status === 401){
                    document.cookie = `access_token=; path=/; expires=Thu, 01 Jan 1970 00:00:00 GMT`;
                    window.location.href = "/signin";
                    return;                    
                }

                const data = await res.json();
                setUser(data);
            } catch (error) {
                console.error("Fetch error:", error);
            } finally {
                setLoading(false);
            }
        };

        fetchUser();
    }, []);

    return {user, loading};
}