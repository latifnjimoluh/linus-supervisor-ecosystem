import React from 'react';
import { Navigate } from 'react-router-dom';

export default function ProtectedRoute({ children }) {
  const token = localStorage.getItem('token');
  const expiry = localStorage.getItem('tokenExpiry');
  if (!token || !expiry || new Date(expiry) < new Date()) {
    localStorage.removeItem('token');
    localStorage.removeItem('tokenExpiry');
    return <Navigate to="/login" replace />;
  }
  return children;
}
