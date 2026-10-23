import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const CondominioApp());
}

class CondominioApp extends StatelessWidget {
  const CondominioApp({super.key});

  @override
  Widget build(BuildContext context) {
    const ink = Color(0xFF18312C);
    const canvas = Color(0xFFF4F5F0);

    return MaterialApp(
      title: 'Condominio',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: canvas,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF246B5A),
          surface: Colors.white,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: canvas,
          foregroundColor: ink,
          elevation: 0,
          centerTitle: false,
        ),
      ),
      home: const IncidentHomePage(),
    );
  }
}

class Incident {
  const Incident({
    required this.category,
    required this.description,
    required this.createdAt,
    this.media,
  });

  final String category;
  final String description;
  final DateTime createdAt;
  final XFile? media;
}

class IncidentHomePage extends StatefulWidget {
  const IncidentHomePage({super.key});

  @override
  State<IncidentHomePage> createState() => _IncidentHomePageState();
}

class _IncidentHomePageState extends State<IncidentHomePage> {
  final List<Incident> _incidents = [];

  Future<void> _openReportForm() async {
    final incident = await Navigator.of(context).push<Incident>(
      MaterialPageRoute(builder: (_) => const IncidentReportPage()),
    );

    if (incident != null && mounted) {
      setState(() => _incidents.insert(0, incident));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Reporte guardado en este dispositivo')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Condominio',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        actions: [
          IconButton(
            tooltip: 'Perfil',
            onPressed: () {},
            icon: const Icon(Icons.account_circle_outlined),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
          children: [
            const Text(
              'SEGURIDAD Y CONVIVENCIA',
              style: TextStyle(
                color: Color(0xFF58736A),
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.1,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Reportes del condominio',
              style: TextStyle(
                color: Color(0xFF18312C),
                fontSize: 25,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Registra una incidencia para que pueda revisarse.',
              style: TextStyle(color: Colors.blueGrey.shade700, height: 1.4),
            ),
            const SizedBox(height: 22),
            _NewReportPanel(onPressed: _openReportForm),
            const SizedBox(height: 28),
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Actividad reciente',
                    style: TextStyle(
                      color: Color(0xFF18312C),
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Text(
                  '${_incidents.length} reportes',
                  style: TextStyle(
                    color: Colors.blueGrey.shade700,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (_incidents.isEmpty)
              const _EmptyActivity()
            else
              ..._incidents.map((incident) => _IncidentTile(incident: incident)),
            const SizedBox(height: 16),
            const _PrototypeNotice(),
          ],
        ),
      ),
    );
  }
}

class _NewReportPanel extends StatelessWidget {
  const _NewReportPanel({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF18312C),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '¿Algo requiere atención?',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Agrega detalles y evidencia',
                  style: TextStyle(color: Color(0xFFD4E1DA), fontSize: 13),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          FilledButton.icon(
            onPressed: onPressed,
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFE8B34B),
              foregroundColor: const Color(0xFF18312C),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            icon: const Icon(Icons.add, size: 18),
            label: const Text('Reportar'),
          ),
        ],
      ),
    );
  }
}

class _EmptyActivity extends StatelessWidget {
  const _EmptyActivity();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE3E7E1)),
      ),
      child: const Row(
        children: [
          Icon(Icons.fact_check_outlined, color: Color(0xFF58736A)),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Aún no hay reportes. Los nuevos aparecerán aquí.',
              style: TextStyle(color: Color(0xFF52625C), height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}

class _PrototypeNotice extends StatelessWidget {
  const _PrototypeNotice();

  @override
  Widget build(BuildContext context) {
    return const Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.info_outline, size: 16, color: Color(0xFF58736A)),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            'Prototipo: los reportes aún no se envían a guardias ni se guardan en un servidor.',
            style: TextStyle(
              color: Color(0xFF52625C),
              fontSize: 12,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}

class _IncidentTile extends StatelessWidget {
  const _IncidentTile({required this.incident});

  final Incident incident;

  @override
  Widget build(BuildContext context) {
    final media = incident.media;

    return Card(
      margin: const EdgeInsets.only(bottom: 9),
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: Color(0xFFE3E7E1)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
        leading: CircleAvatar(
          backgroundColor: const Color(0xFFE9F0EB),
          foregroundColor: const Color(0xFF246B5A),
          child: Icon(_categoryIcon(incident.category)),
        ),
        title: Text(
          incident.category,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          media == null ? incident.description : '${incident.description}\nAdjunto: ${media.name}',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Text(
          _formatTime(incident.createdAt),
          style: TextStyle(color: Colors.blueGrey.shade600, fontSize: 11),
        ),
      ),
    );
  }
}

class IncidentReportPage extends StatefulWidget {
  const IncidentReportPage({super.key});

  @override
  State<IncidentReportPage> createState() => _IncidentReportPageState();
}

class _IncidentReportPageState extends State<IncidentReportPage> {
  static const _categories = [
    'Vehículo mal estacionado',
    'Mascota',
    'Área común',
    'Objeto perdido',
    'Visitante',
    'Otro',
  ];

  final _picker = ImagePicker();
  final _descriptionController = TextEditingController();
  String _category = _categories.first;
  XFile? _media;
  bool _isPickingMedia = false;

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickMedia({
    required ImageSource source,
    required bool video,
  }) async {
    setState(() => _isPickingMedia = true);
    try {
      final picked = video
          ? await _picker.pickVideo(source: source)
          : await _picker.pickImage(
              source: source,
              imageQuality: 85,
              maxWidth: 2000,
            );
      if (picked != null && mounted) setState(() => _media = picked);
    } on PlatformException catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No se pudo abrir la cámara o galería: ${error.message ?? 'error'}')),
        );
      }
    } finally {
      if (mounted) setState(() => _isPickingMedia = false);
    }
  }

  void _submit() {
    final description = _descriptionController.text.trim();
    if (description.isEmpty && _media == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Agrega una descripción o una evidencia')),
      );
      return;
    }

    Navigator.of(context).pop(
      Incident(
        category: _category,
        description: description.isEmpty ? 'Sin descripción' : description,
        createdAt: DateTime.now(),
        media: _media,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nuevo reporte')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          children: [
            const Text(
              'Describe lo ocurrido',
              style: TextStyle(
                color: Color(0xFF18312C),
                fontSize: 23,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Elige una categoría y agrega evidencia si la tienes.',
              style: TextStyle(color: Colors.blueGrey.shade700, height: 1.4),
            ),
            const SizedBox(height: 22),
            const _FieldLabel('Categoría'),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _category,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
              ),
              items: _categories
                  .map((category) => DropdownMenuItem(
                        value: category,
                        child: Text(category),
                      ))
                  .toList(),
              onChanged: (value) {
                if (value != null) setState(() => _category = value);
              },
            ),
            const SizedBox(height: 18),
            const _FieldLabel('Detalles'),
            const SizedBox(height: 8),
            TextField(
              controller: _descriptionController,
              minLines: 3,
              maxLines: 5,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                hintText: '¿Qué pasó y dónde?',
                alignLabelWithHint: true,
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            const _FieldLabel('Evidencia'),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _isPickingMedia
                        ? null
                        : () => _pickMedia(source: ImageSource.camera, video: false),
                    icon: const Icon(Icons.photo_camera_outlined),
                    label: const Text('Tomar foto'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _isPickingMedia
                        ? null
                        : () => _pickMedia(source: ImageSource.camera, video: true),
                    icon: const Icon(Icons.videocam_outlined),
                    label: const Text('Grabar video'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: _isPickingMedia
                    ? null
                    : () => _showGalleryOptions(context),
                icon: const Icon(Icons.photo_library_outlined, size: 18),
                label: const Text('Elegir de la galería'),
              ),
            ),
            if (_isPickingMedia) ...[
              const SizedBox(height: 8),
              const LinearProgressIndicator(),
            ],
            if (_media != null) ...[
              const SizedBox(height: 8),
              _MediaAttachment(
                file: _media!,
                onRemove: () => setState(() => _media = null),
              ),
            ],
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _isPickingMedia ? null : _submit,
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              icon: const Icon(Icons.assignment_turned_in_outlined),
              label: const Text('Guardar reporte'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showGalleryOptions(BuildContext context) async {
    final video = await showModalBottomSheet<bool>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.image_outlined),
              title: const Text('Elegir foto'),
              onTap: () => Navigator.pop(context, false),
            ),
            ListTile(
              leading: const Icon(Icons.video_library_outlined),
              title: const Text('Elegir video'),
              onTap: () => Navigator.pop(context, true),
            ),
          ],
        ),
      ),
    );
    if (video != null && mounted) {
      await _pickMedia(source: ImageSource.gallery, video: video);
    }
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        color: Color(0xFF18312C),
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class _MediaAttachment extends StatelessWidget {
  const _MediaAttachment({required this.file, required this.onRemove});

  final XFile file;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final isVideo = file.mimeType?.startsWith('video/') ??
        file.path.toLowerCase().endsWith('.mp4');

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE3E7E1)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          if (isVideo)
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: const Color(0xFFE9F0EB),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Icon(Icons.play_circle_outline, size: 30),
            )
          else
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Image.file(
                File(file.path),
                width: 56,
                height: 56,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const SizedBox(
                  width: 56,
                  height: 56,
                  child: Icon(Icons.broken_image_outlined),
                ),
              ),
            ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              file.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 13),
            ),
          ),
          IconButton(
            tooltip: 'Quitar archivo',
            onPressed: onRemove,
            icon: const Icon(Icons.close),
          ),
        ],
      ),
    );
  }
}

IconData _categoryIcon(String category) {
  return switch (category) {
    'Vehículo mal estacionado' => Icons.local_parking_outlined,
    'Mascota' => Icons.pets_outlined,
    'Área común' => Icons.meeting_room_outlined,
    'Objeto perdido' => Icons.search_outlined,
    'Visitante' => Icons.directions_walk_outlined,
    _ => Icons.report_outlined,
  };
}

String _formatTime(DateTime value) {
  final hour = value.hour.toString().padLeft(2, '0');
  final minute = value.minute.toString().padLeft(2, '0');
  return '$hour:$minute';
}