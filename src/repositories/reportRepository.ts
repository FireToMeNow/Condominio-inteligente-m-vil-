import AsyncStorage from '@react-native-async-storage/async-storage';
import type { Report } from '../types';

const STORAGE_KEY = '@condominio/reports';

export const reportRepository = {
  async list(): Promise<Report[]> {
    const value = await AsyncStorage.getItem(STORAGE_KEY);
    return value ? (JSON.parse(value) as Report[]) : [];
  },

  async save(report: Report): Promise<Report[]> {
    const reports = await reportRepository.list();
    const next = [report, ...reports];
    await AsyncStorage.setItem(STORAGE_KEY, JSON.stringify(next));
    return next;
  },

  async updateStatus(reportId: string, status: Report['status']): Promise<Report[]> {
    const reports = await reportRepository.list();
    const next = reports.map((report) =>
      report.id === reportId ? { ...report, status } : report,
    );
    await AsyncStorage.setItem(STORAGE_KEY, JSON.stringify(next));
    return next;
  },
};
