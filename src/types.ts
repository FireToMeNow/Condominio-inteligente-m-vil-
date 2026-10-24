export type UserRole = 'resident' | 'guard' | 'administrator';

export type ReportCategory =
  | 'Vehículo'
  | 'Mascota'
  | 'Área común'
  | 'Objeto perdido'
  | 'Visitante'
  | 'Otro';

export type ReportStatus = 'Pendiente' | 'En revisión' | 'Resuelto';

export type Profile = {
  id: string;
  fullName: string;
  role: UserRole;
  residence?: string;
};

export type Report = {
  id: string;
  category: ReportCategory;
  details: string;
  evidenceUri?: string;
  evidenceName?: string;
  evidenceType?: string;
  status: ReportStatus;
  createdAt: string;
  createdBy?: string;
};

export const roleLabels: Record<UserRole, string> = {
  resident: 'Residente',
  guard: 'Guardia',
  administrator: 'Administrador',
};
