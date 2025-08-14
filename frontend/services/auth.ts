import { api } from "./api";

export const changePassword = async (
  currentPassword: string,
  newPassword: string
): Promise<any> => {
  const res = await api.post("/auth/change-password", {
    currentPassword,
    newPassword,
  });
  return res.data;
};

export const requestPasswordReset = async (email: string): Promise<any> => {
  const res = await api.post("/auth/request-reset", { email });
  return res.data;
};

export const resetPasswordWithCode = async (
  code: string,
  password: string
): Promise<any> => {
  const res = await api.post("/auth/reset-password", { code, password });
  return res.data;
};

export const setup2FA = async (): Promise<{ secret: string; qr: string }> => {
  const res = await api.post("/auth/2fa/setup");
  return res.data;
};

export const verify2FA = async (token: string): Promise<any> => {
  const res = await api.post("/auth/2fa/verify", { token });
  return res.data;
};

export const disable2FA = async (): Promise<any> => {
  const res = await api.post("/auth/2fa/disable");
  return res.data;
};
