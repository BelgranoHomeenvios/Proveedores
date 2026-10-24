# Belgrano Home — Curitiba 2026

Aplicación móvil para registrar fabricantes, productos, fotografías y fichas imprimibles.

## Estado
Primera versión de trabajo en rama independiente. No está publicada ni conectada a una base compartida.

## Probar
Abrir index.html con un servidor estático (por ejemplo Vercel). Sin Supabase, se guarda información únicamente en el navegador: **no se comparte ni se sincroniza** y las fotos grandes pueden agotar el almacenamiento. Evitar usar datos reales hasta configurar la base privada.

## Compartir entre dos usuarios
1. Crear proyecto Supabase independiente (no usar base del ERP).
2. Ejecutar schema.sql desde SQL Editor.
3. Crear/invitar a los dos usuarios en Authentication.
4. Insertar sus IDs en curitiba_members con el SQL comentado al final del archivo.
5. Desplegar curitiba-app/index.html como sitio estático en Vercel, con HTTPS.
6. Abrir Configuración, completar URL de Supabase y clave pública y acceder con correo/contraseña.
7. Probar desde dos celulares: alta de fabricante, producto, foto y lectura desde el otro dispositivo.

**Seguridad:** jamás usar service_role en el navegador. La pertenencia a curitiba_members limita el acceso mediante RLS. Bucket de fotos privado y URLs firmadas temporales.

## Pendientes antes del viaje
- Pruebas completas en dos teléfonos.
- Verificar compatibilidad HEIC/iOS y uso de cámara.
- Mejorar manejo offline y recuperación de fotos ante mala señal.
- Confirmar impresión de fichas por fabricante y producto en papel A4.
- Configurar dominio y acceso restringido.
