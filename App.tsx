import { useState } from 'react';
import { StatusBar } from 'expo-status-bar';
import * as ImagePicker from 'expo-image-picker';
import {
  Alert,
  Modal,
  Pressable,
  SafeAreaView,
  ScrollView,
  StyleSheet,
  Text,
  TextInput,
  View,
} from 'react-native';

type ReportCategory =
  | 'Vehículo'
  | 'Mascota'
  | 'Área común'
  | 'Objeto perdido'
  | 'Visitante'
  | 'Otro';

type ReportStatus = 'Pendiente' | 'En revisión' | 'Resuelto';

type Report = {
  id: number;
  category: ReportCategory;
  details: string;
  evidenceUri?: string;
  evidenceName?: string;
  status: ReportStatus;
  createdAt: Date;
};

const categories: ReportCategory[] = [
  'Vehículo',
  'Mascota',
  'Área común',
  'Objeto perdido',
  'Visitante',
  'Otro',
];

export default function App() {
  const [reports, setReports] = useState<Report[]>([]);
  const [reportModalVisible, setReportModalVisible] = useState(false);
  const [category, setCategory] = useState<ReportCategory>('Vehículo');
  const [details, setDetails] = useState('');
  const [evidence, setEvidence] = useState<ImagePicker.ImagePickerAsset>();

  const addEvidence = async () => {
    const permission = await ImagePicker.requestMediaLibraryPermissionsAsync();
    if (!permission.granted) {
      Alert.alert('Permiso necesario', 'Autoriza el acceso a fotos y videos.');
      return;
    }

    const result = await ImagePicker.launchImageLibraryAsync({
      mediaTypes: ['images', 'videos'],
      quality: 0.8,
      videoMaxDuration: 60,
    });

    if (!result.canceled) setEvidence(result.assets[0]);
  };

  const captureEvidence = async () => {
    const permission = await ImagePicker.requestCameraPermissionsAsync();
    if (!permission.granted) {
      Alert.alert('Permiso necesario', 'Autoriza el acceso a la cámara.');
      return;
    }

    const result = await ImagePicker.launchCameraAsync({
      mediaTypes: ['images', 'videos'],
      quality: 0.8,
      videoMaxDuration: 60,
    });

    if (!result.canceled) setEvidence(result.assets[0]);
  };

  const saveReport = () => {
    if (!details.trim() && !evidence) {
      Alert.alert('Falta información', 'Agrega detalles o evidencia.');
      return;
    }

    setReports((current) => [
      {
        id: Date.now(),
        category,
        details: details.trim() || 'Sin descripción',
        evidenceUri: evidence?.uri,
        evidenceName: evidence?.fileName ?? undefined,
        status: 'Pendiente',
        createdAt: new Date(),
      },
      ...current,
    ]);
    setDetails('');
    setEvidence(undefined);
    setCategory('Vehículo');
    setReportModalVisible(false);
  };

  return (
    <SafeAreaView style={styles.safeArea}>
      <StatusBar style="dark" />
      <ScrollView contentContainerStyle={styles.content}>
        <Text style={styles.eyebrow}>SEGURIDAD Y CONVIVENCIA</Text>
        <Text style={styles.title}>Condominio</Text>
        <Text style={styles.subtitle}>Incidencias y atención comunitaria</Text>

        <View style={styles.actionPanel}>
          <View style={styles.actionCopy}>
            <Text style={styles.actionTitle}>¿Algo requiere atención?</Text>
            <Text style={styles.actionDescription}>Registra una incidencia con evidencia.</Text>
          </View>
          <Pressable
            accessibilityRole="button"
            onPress={() => setReportModalVisible(true)}
            style={styles.primaryButton}
          >
            <Text style={styles.primaryButtonText}>+ Reportar</Text>
          </Pressable>
        </View>

        <View style={styles.sectionHeader}>
          <Text style={styles.sectionTitle}>Actividad reciente</Text>
          <Text style={styles.reportCount}>{reports.length} reportes</Text>
        </View>

        {reports.length === 0 ? (
          <View style={styles.emptyState}>
            <Text style={styles.emptyTitle}>Sin reportes</Text>
            <Text style={styles.emptyText}>Los nuevos reportes aparecerán aquí.</Text>
          </View>
        ) : (
          reports.map((report) => (
            <View key={report.id} style={styles.reportCard}>
              <View style={styles.reportTopLine}>
                <Text style={styles.reportCategory}>{report.category}</Text>
                <Text style={styles.reportStatus}>{report.status}</Text>
              </View>
              <Text style={styles.reportDetails}>{report.details}</Text>
              {report.evidenceName ? (
                <Text style={styles.evidenceName}>Evidencia: {report.evidenceName}</Text>
              ) : null}
            </View>
          ))
        )}

        <Text style={styles.prototypeNote}>
          Prototipo: los reportes aún no se envían ni se guardan en un servidor.
        </Text>
      </ScrollView>

      <Modal
        animationType="slide"
        transparent
        visible={reportModalVisible}
        onRequestClose={() => setReportModalVisible(false)}
      >
        <View style={styles.modalBackdrop}>
          <View style={styles.modalSheet}>
            <View style={styles.modalHandle} />
            <Text style={styles.modalTitle}>Nuevo reporte</Text>
            <Text style={styles.label}>Categoría</Text>
            <View style={styles.categoryList}>
              {categories.map((item) => {
                const selected = item === category;
                return (
                  <Pressable
                    key={item}
                    onPress={() => setCategory(item)}
                    style={[styles.categoryChip, selected && styles.categoryChipSelected]}
                  >
                    <Text style={[styles.categoryText, selected && styles.categoryTextSelected]}>
                      {item}
                    </Text>
                  </Pressable>
                );
              })}
            </View>

            <Text style={styles.label}>Detalles</Text>
            <TextInput
              multiline
              value={details}
              onChangeText={setDetails}
              placeholder="¿Qué pasó y dónde?"
              style={styles.detailsInput}
            />

            <Text style={styles.label}>Evidencia</Text>
            <View style={styles.evidenceActions}>
              <Pressable onPress={captureEvidence} style={styles.secondaryButton}>
                <Text style={styles.secondaryButtonText}>Cámara</Text>
              </Pressable>
              <Pressable onPress={addEvidence} style={styles.secondaryButton}>
                <Text style={styles.secondaryButtonText}>Galería</Text>
              </Pressable>
            </View>
            {evidence ? (
              <Text style={styles.selectedEvidence} numberOfLines={1}>
                {evidence.fileName ?? evidence.uri.split('/').pop()}
              </Text>
            ) : null}

            <View style={styles.modalActions}>
              <Pressable onPress={() => setReportModalVisible(false)} style={styles.cancelButton}>
                <Text style={styles.cancelButtonText}>Cancelar</Text>
              </Pressable>
              <Pressable onPress={saveReport} style={styles.saveButton}>
                <Text style={styles.saveButtonText}>Guardar</Text>
              </Pressable>
            </View>
          </View>
        </View>
      </Modal>
    </SafeAreaView>
  );
}

const colors = {
  canvas: '#F4F5F0',
  ink: '#18312C',
  muted: '#58736A',
  line: '#DDE3DE',
  gold: '#E8B34B',
  green: '#246B5A',
};

const styles = StyleSheet.create({
  safeArea: { flex: 1, backgroundColor: colors.canvas },
  content: { paddingHorizontal: 20, paddingTop: 18, paddingBottom: 32 },
  eyebrow: { color: colors.muted, fontSize: 11, fontWeight: '700', letterSpacing: 1 },
  title: { marginTop: 5, color: colors.ink, fontSize: 30, fontWeight: '800' },
  subtitle: { marginTop: 6, color: '#52625C', fontSize: 15, lineHeight: 21 },
  actionPanel: {
    marginTop: 22,
    padding: 18,
    borderRadius: 8,
    backgroundColor: colors.ink,
    gap: 16,
  },
  actionCopy: { gap: 5 },
  actionTitle: { color: '#FFFFFF', fontSize: 17, fontWeight: '700' },
  actionDescription: { color: '#D4E1DA', fontSize: 13 },
  primaryButton: {
    alignSelf: 'flex-start',
    borderRadius: 6,
    backgroundColor: colors.gold,
    paddingHorizontal: 16,
    paddingVertical: 12,
  },
  primaryButtonText: { color: colors.ink, fontWeight: '700' },
  sectionHeader: { marginTop: 28, marginBottom: 12, flexDirection: 'row', alignItems: 'center' },
  sectionTitle: { flex: 1, color: colors.ink, fontSize: 17, fontWeight: '700' },
  reportCount: { color: colors.muted, fontSize: 12 },
  emptyState: { borderWidth: 1, borderColor: colors.line, borderRadius: 8, backgroundColor: '#FFFFFF', padding: 18 },
  emptyTitle: { color: colors.ink, fontSize: 15, fontWeight: '700' },
  emptyText: { marginTop: 5, color: '#52625C', lineHeight: 20 },
  reportCard: { marginBottom: 10, borderWidth: 1, borderColor: colors.line, borderRadius: 8, backgroundColor: '#FFFFFF', padding: 15 },
  reportTopLine: { flexDirection: 'row', alignItems: 'center', gap: 8 },
  reportCategory: { flex: 1, color: colors.ink, fontWeight: '700' },
  reportStatus: { color: colors.green, fontSize: 11, fontWeight: '700' },
  reportDetails: { marginTop: 7, color: '#52625C', lineHeight: 20 },
  evidenceName: { marginTop: 6, color: colors.muted, fontSize: 12 },
  prototypeNote: { marginTop: 12, color: colors.muted, fontSize: 12, lineHeight: 18 },
  modalBackdrop: { flex: 1, justifyContent: 'flex-end', backgroundColor: 'rgba(24,49,44,0.42)' },
  modalSheet: { maxHeight: '92%', borderTopLeftRadius: 8, borderTopRightRadius: 8, backgroundColor: '#FFFFFF', padding: 20 },
  modalHandle: { alignSelf: 'center', width: 42, height: 4, marginBottom: 18, borderRadius: 2, backgroundColor: '#C8CEC9' },
  modalTitle: { color: colors.ink, fontSize: 23, fontWeight: '800', marginBottom: 18 },
  label: { color: colors.ink, marginTop: 8, marginBottom: 8, fontWeight: '700' },
  categoryList: { flexDirection: 'row', flexWrap: 'wrap', gap: 8 },
  categoryChip: { borderWidth: 1, borderColor: colors.line, borderRadius: 6, paddingHorizontal: 12, paddingVertical: 9, backgroundColor: '#FFFFFF' },
  categoryChipSelected: { borderColor: colors.green, backgroundColor: '#E9F0EB' },
  categoryText: { color: '#52625C', fontSize: 13 },
  categoryTextSelected: { color: colors.green, fontWeight: '700' },
  detailsInput: { minHeight: 92, borderWidth: 1, borderColor: colors.line, borderRadius: 6, padding: 12, textAlignVertical: 'top', color: colors.ink },
  evidenceActions: { flexDirection: 'row', gap: 10 },
  secondaryButton: { flex: 1, alignItems: 'center', borderWidth: 1, borderColor: colors.line, borderRadius: 6, paddingVertical: 12 },
  secondaryButtonText: { color: colors.green, fontWeight: '700' },
  selectedEvidence: { marginTop: 10, color: colors.muted, fontSize: 12 },
  modalActions: { marginTop: 22, flexDirection: 'row', gap: 10 },
  cancelButton: { flex: 1, alignItems: 'center', borderWidth: 1, borderColor: colors.line, borderRadius: 6, paddingVertical: 14 },
  cancelButtonText: { color: '#52625C', fontWeight: '700' },
  saveButton: { flex: 1, alignItems: 'center', borderRadius: 6, backgroundColor: colors.green, paddingVertical: 14 },
  saveButtonText: { color: '#FFFFFF', fontWeight: '700' },
});
