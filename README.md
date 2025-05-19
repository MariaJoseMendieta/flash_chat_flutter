# ⚡ Flash Chat Flutter

---

## 📋 Descripción general

**Flash Chat Flutter** es una aplicación de chat en tiempo real desarrollada con Flutter y Firebase. Permite a los usuarios registrarse, iniciar sesión y enviar mensajes instantáneos que se almacenan en Firestore. La app ofrece una interfaz sencilla y amigable, con un sistema de autenticación seguro mediante correo y contraseña.

---

## 🚀 Funcionalidades principales

- 🔐 Registro de nuevos usuarios con correo electrónico y contraseña.
- 🔑 Inicio de sesión para usuarios registrados.
- 💬 Envío y recepción de mensajes en tiempo real.
- 👥 Visualización de mensajes con diferenciación clara entre mensajes enviados y recibidos.
- 🔓 Desconexión (logout) segura.
- ⏳ Indicador de carga durante procesos asíncronos (login, registro).
- 🎨 Diseño responsivo y moderno utilizando componentes personalizados como botones redondeados.

---

## 📌 Requisitos del proyecto

- 🛠 Flutter SDK (versión estable recomendada)
- 🔥 Cuenta y proyecto en Firebase con:
    - 🔐 Authentication habilitada para correo y contraseña.
    - 💾 Firestore Database configurada.
- 📱 Dispositivo o emulador para ejecutar aplicaciones Flutter.
- 🌐 Conexión a internet para autenticación y acceso a Firestore.

---

## 🧰 Tecnologías y paquetes externos utilizados

- 🦋 **Flutter**: Framework UI para desarrollo multiplataforma.
- 🔥 **Firebase Core**: Inicialización y configuración base de Firebase en Flutter.
- 🔥 **Firebase Authentication**: Manejo seguro de usuarios y autenticación.
- 💾 **Cloud Firestore**: Base de datos en tiempo real para almacenar mensajes.
- ⏳ **modal_progress_hud_nsn**: Indicador de progreso modal para mostrar carga durante operaciones.
- ✨ **animated_text_kit**: Para animaciones de texto llamativas en la interfaz.
- 🎨 **flutter/material.dart**: Componentes visuales y diseño.

---

## 🗂 Estructura del proyecto
```
images/
│
└── logo.png
lib/
│
├── components/
│ └── rounded_button.dart # Botón personalizado con diseño redondeado
│
├── constants.dart # Variables constantes para estilos y decoración
│
├── screens/
│ ├── welcome_screen.dart # Pantalla de bienvenida inicial
│ ├── login_screen.dart # Pantalla de inicio de sesión
│ ├── registration_screen.dart # Pantalla para registro de usuarios
│ └── chat_screen.dart # Pantalla principal de chat en tiempo real
│
└── main.dart # Punto de entrada principal de la app
```
---

## 👤 Autor

Desarrollado por **María José Mendieta Ortiz**   
🌐 https://github.com/MariaJoseMendieta