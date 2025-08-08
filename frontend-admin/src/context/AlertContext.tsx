import { createContext, useContext, useState } from "react";
import Alert from "@/components/ui/alert/Alert";

const AlertContext = createContext();

export const AlertProvider = ({ children }) => {
  const [alert, setAlert] = useState({
    show: false,
    variant: "success",
    title: "",
    message: "",
  });

  const showAlert = (variant, title, message) => {
    setAlert({ show: true, variant, title, message });

    // auto hide setelah 3 detik
    setTimeout(() => {
      setAlert({ ...alert, show: false });
    }, 3000);
  };

  return (
    <AlertContext.Provider value={{ showAlert }}>
      {alert.show && (
        <div className="fixed top-5 right-5 z-50">
          <Alert variant={alert.variant} title={alert.title} message={alert.message} />
        </div>
      )}
      {children}
    </AlertContext.Provider>
  );
};

export const useAlert = () => useContext(AlertContext);
