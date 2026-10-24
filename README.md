# Condominio inteligente

Aplicacion movil con React Native, Expo y TypeScript para registrar incidencias y adjuntar evidencia desde la camara o la galeria.

## Estado actual

- Crear reportes de vehiculos, mascotas, areas comunes, objetos perdidos, visitantes u otros asuntos.
- Adjuntar una foto o un video desde la camara o la galeria.
- Consultar la actividad reciente y conservar reportes en el dispositivo.
- Alternar entre perfiles demo de residente, guardia y administrador.
- Preparar perfiles y reportes en Supabase para autenticar usuarios reales posteriormente.
- La app todavia no incluye alertas ni integracion de camaras IP.

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

## Configurar Supabase

1. Crea un proyecto en Supabase.
2. Ejecuta `supabase/schema.sql` desde el SQL Editor.
3. Copia `.env.example` como `.env` y completa URL y clave anon publicada por Supabase.
4. Reinicia Expo para cargar las nuevas variables.

La clave anon puede estar en la app porque Supabase debe proteger los datos mediante autenticacion y politicas RLS. No agregues al repositorio una clave de servicio ni claves secretas.

## Estructura inicial

El prototipo funcional esta concentrado temporalmente en `App.tsx`. Conforme aparezcan autenticacion, roles y backend, se dividira en pantallas, componentes, servicios, modelos y pruebas.

Expo gestiona los permisos de camara y galeria al generar la aplicacion nativa. El sistema solicita el permiso cuando el usuario realiza una accion por primera vez.
