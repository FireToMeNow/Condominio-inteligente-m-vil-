# Condominio inteligente

Prototipo Flutter para registrar incidencias del condominio con evidencia de foto o video desde el movil.

## Estado del prototipo

- Permite redactar un reporte y elegir una categoria.
- Permite tomar una foto, grabar un video o elegir un archivo de la galeria.
- Los reportes viven solo en memoria y desaparecen al cerrar la app.
- No hay cuentas, roles, envio a guardias, almacenamiento remoto ni integracion con camaras IP todavia.

## Requisitos

- Flutter SDK estable y Dart incluidos en Flutter.
- Xcode para ejecutar el simulador iOS en macOS.
- Android SDK para compilar e instalar la app en Android.

En la Mac, despues de instalar Flutter, genera las carpetas nativas de iOS y Android desde la raiz del repositorio:

```sh
flutter create --platforms=ios,android .
flutter pub get
flutter run
```

El plugin `image_picker` necesita textos de permiso en `ios/Runner/Info.plist`. Agrega estas claves dentro del elemento `<dict>` antes de probar la camara y el microfono:

```xml
<key>NSCameraUsageDescription</key>
<string>Se usa para adjuntar fotos a un reporte del condominio.</string>
<key>NSMicrophoneUsageDescription</key>
<string>Se usa para grabar audio en videos adjuntos a un reporte.</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>Se usa para elegir fotos o videos para un reporte.</string>
```

Android solicita los permisos mediante el plugin. Antes de distribuir la app, se deben revisar las politicas de privacidad y permisos de ambas plataformas.
# Condominio-inteligente-m-vil-