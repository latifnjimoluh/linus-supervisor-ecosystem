import React from 'react';
import { BrowserRouter, Routes, Route, Navigate } from 'react-router-dom';
import Login from './pages/Login';
import Register from './pages/Register';
import Dashboard from './pages/Dashboard';
import Users from './pages/Users';
import UserDetail from './pages/UserDetail';
import Roles from './pages/Roles';
import RoleDetail from './pages/RoleDetail';
import Permissions from './pages/Permissions';
import PermissionDetail from './pages/PermissionDetail';
import RequestReset from './pages/RequestReset';
import ResetPassword from './pages/ResetPassword';
import ResetHistory from './pages/ResetHistory';
import Logs from './pages/Logs';
import Settings from './pages/Settings';
import Vms from './pages/Vms';
import VmConversions from './pages/VmConversions';
import Templates from './pages/Templates';
import TemplateDetail from './pages/TemplateDetail';
import Monitoring from './pages/Monitoring';
import MonitoringDetail from './pages/MonitoringDetail';
import Terraform from './pages/Terraform';
import AiTools from './pages/AiTools';
import AiCache from './pages/AiCache';
import ProtectedRoute from './components/ProtectedRoute';
import Layout from './components/Layout';

export default function App() {
  return (
    <BrowserRouter>
      <Routes>
        <Route path="/login" element={<Login />} />
        <Route path="/register" element={<Register />} />
        <Route path="/request-reset" element={<RequestReset />} />
        <Route path="/reset-password" element={<ResetPassword />} />
        <Route
          element={
            <ProtectedRoute>
              <Layout />
            </ProtectedRoute>
          }
        >
          <Route path="/dashboard" element={<Dashboard />} />
          <Route path="/users" element={<Users />} />
          <Route path="/users/:id" element={<UserDetail />} />
          <Route path="/roles" element={<Roles />} />
          <Route path="/roles/:id" element={<RoleDetail />} />
          <Route path="/permissions" element={<Permissions />} />
          <Route path="/permissions/:id" element={<PermissionDetail />} />
          <Route path="/reset-history" element={<ResetHistory />} />
          <Route path="/logs" element={<Logs />} />
          <Route path="/settings" element={<Settings />} />
          <Route path="/templates" element={<Templates />} />
          <Route path="/templates/:id" element={<TemplateDetail />} />
          <Route path="/monitoring" element={<Monitoring />} />
          <Route path="/monitoring/:id" element={<MonitoringDetail />} />
          <Route path="/vms" element={<Vms />} />
          <Route path="/vms/conversions" element={<VmConversions />} />
          <Route path="/terraform" element={<Terraform />} />
          <Route path="/ai-tools" element={<AiTools />} />
          <Route path="/ai-cache" element={<AiCache />} />
          <Route path="*" element={<Navigate to="/dashboard" replace />} />
        </Route>
      </Routes>
    </BrowserRouter>
  );
}
