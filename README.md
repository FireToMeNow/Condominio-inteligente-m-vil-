# Condominio inteligente

Aplicacion movil con React Native, Expo y TypeScript para registrar incidencias y adjuntar evidencia desde la camara o la galeria.

## Estado actual

- Permite redactar un reporte y elegir una categoria.
- Permite tomar una foto, grabar un video o elegir un archivo de la galeria.
- Los reportes viven solo en memoria y desaparecen al cerrar la app.
- No hay cuentas, roles, envio a guardias, almacenamiento remoto ni integracion con camaras IP todavia.

## Ejecutar en desarrollo

```sh
npm install
npm run start
```

Desde Expo Go puedes escanear el codigo QR para probar en un dispositivo. Para compilar con Xcode, usa una Mac con Xcode instalado y ejecuta `npm run ios`. Android requiere Android Studio o los Android SDK configurados.

## Comprobacion

```sh
npm run typecheck
```


## Tecnologias previstas

- React Native con Expo y TypeScript para iOS y Android.
- Expo Image Picker para fotos y videos en la etapa inicial.
- Supabase para autenticacion, PostgreSQL, almacenamiento y notificaciones.
- Servicios de vision artificial independientes para analizar clips aprobados.

El plugin anterior ya no forma parte de esta implementacion.

## Estructura inicial

El prototipo funcional esta concentrado temporalmente en `App.tsx`. Conforme aparezcan autenticacion, roles y backend, se dividira en pantallas, componentes, servicios, modelos y pruebas.

Expo gestiona los permisos de camara y galeria al generar la aplicacion nativa. El sistema solicita el permiso cuando el usuario realiza una accion por primera vez.