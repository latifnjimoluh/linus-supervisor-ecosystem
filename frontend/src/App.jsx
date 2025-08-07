import React from 'react';
import { BrowserRouter, Routes, Route, Navigate } from 'react-router-dom';
import { ToastProvider } from './components/ToastProvider';
import Login from './pages/Login';
import Register from './pages/Register';
import Dashboard from './pages/Dashboard';
import DashboardMap from './pages/DashboardMap';
import Users from './pages/Users';
import UserDetail from './pages/UserDetail';
import UserAdd from './pages/UserAdd';
import UserEdit from './pages/UserEdit';
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
import TemplateTest from './pages/TemplateTest';
import Monitoring from './pages/Monitoring';
import MonitoringDetail from './pages/MonitoringDetail';
import Alerts from './pages/Alerts';
import Terraform from './pages/Terraform';
import AiTools from './pages/AiTools';
import AiCache from './pages/AiCache';
import Account from './pages/Account';
import Servers from './pages/Servers';
import ServerDetail from './pages/ServerDetail';
import ServerAdd from './pages/ServerAdd';
import ServerEdit from './pages/ServerEdit';
import ScriptPreview from './pages/ScriptPreview';
import Deploy from './pages/Deploy';
import ProtectedRoute from './components/ProtectedRoute';
import Layout from './components/Layout';
import Assistant from './pages/Assistant';
import SettingsNotifications from './pages/SettingsNotifications';
import Forbidden from './pages/Forbidden';
import NotFound from './pages/NotFound';
import ErrorPage from './pages/ErrorPage';

export default function App() {
  return (
    <ToastProvider>
      <BrowserRouter>
        <Routes>
        <Route path="/login" element={<Login />} />
        <Route path="/register" element={<Register />} />
        <Route path="/forgot-password" element={<RequestReset />} />
        <Route path="/reset-password" element={<ResetPassword />} />
        <Route path="/403" element={<Forbidden />} />
        <Route path="/404" element={<NotFound />} />
        <Route path="/error" element={<ErrorPage />} />
        <Route
          element={
            <ProtectedRoute>
              <Layout />
            </ProtectedRoute>
          }
        >
          <Route path="/dashboard" element={<Dashboard />} />
          <Route path="/dashboard/map" element={<DashboardMap />} />
          <Route path="/users" element={<Users />} />
          <Route path="/users/add" element={<UserAdd />} />
          <Route path="/users/:id/edit" element={<UserEdit />} />
          <Route path="/users/:id" element={<UserDetail />} />
          <Route path="/roles" element={<Roles />} />
          <Route path="/roles/:id" element={<RoleDetail />} />
          <Route path="/permissions" element={<Permissions />} />
          <Route path="/permissions/:id" element={<PermissionDetail />} />
          <Route path="/reset-history" element={<ResetHistory />} />
          <Route path="/logs" element={<Logs />} />
          <Route path="/settings" element={<Settings />} />
          <Route path="/settings/notifications" element={<SettingsNotifications />} />
          <Route path="/settings/templates/:id/test" element={<TemplateTest />} />
          <Route path="/templates" element={<Templates />} />
          <Route path="/templates/:id" element={<TemplateDetail />} />
          <Route path="/monitoring" element={<Monitoring />} />
          <Route path="/monitoring/:id" element={<MonitoringDetail />} />
          <Route path="/dashboard/alerts" element={<Alerts />} />
          <Route path="/account" element={<Account />} />
          <Route path="/servers" element={<Servers />} />
          <Route path="/servers/add" element={<ServerAdd />} />
          <Route path="/servers/:id/edit" element={<ServerEdit />} />
          <Route path="/servers/:id" element={<ServerDetail />} />
          <Route path="/scripts/preview/:serverId/:service" element={<ScriptPreview />} />
          <Route path="/deploy/:serverId" element={<Deploy />} />
          <Route path="/assistant" element={<Assistant />} />
          <Route path="/vms" element={<Vms />} />
          <Route path="/vms/conversions" element={<VmConversions />} />
          <Route path="/terraform" element={<Terraform />} />
          <Route path="/ai-tools" element={<AiTools />} />
          <Route path="/ai-cache" element={<AiCache />} />
          <Route path="*" element={<NotFound />} />
        </Route>
        <Route path="*" element={<NotFound />} />
        </Routes>
      </BrowserRouter>
    </ToastProvider>
  );
}
