# 🐾 Dog Club — Guardería Canina

Aplicación móvil para gestión de guardería canina desarrollada con Flutter y Firebase.

## Descripción

Dog Club es una plataforma que conecta dueños de mascotas con cuidadores profesionales. Ofrece tres tipos de servicios: **Hospedaje**, **Guardería Diurna** y **Paseos Individuales**.

## Características

### 👤 Clientes
- Registro e inicio de sesión con email/contraseña
- Explorar cuidadores por categoría de servicio
- Ver perfil y reseñas de cuidadores
- Reservar servicios con selección de fecha, hora y mascota
- Agregar y gestionar mascotas
- Chat en tiempo real con cuidadores
- Editar perfil y foto

### 🐕 Cuidadores
- Dashboard con estadísticas (pendientes, activas, ganancias)
- Aceptar/rechazar solicitudes de reserva
- Ver mascotas activas en servicio
- Chat con clientes
- Editar perfil y biografía

### 🔧 Administrador
- Panel CRUD de usuarios (cambiar roles, eliminar)
- Panel CRUD de mascotas
- Panel CRUD de reservas (cambiar estados)
- Panel CRUD de servicios (precios, activar/desactivar)

## Tecnologías

| Tecnología | Uso |
|---|---|
| Flutter 3.24+ | Framework UI |
| Dart 3.4+ | Lenguaje |
| Firebase Auth | Autenticación |
| Cloud Firestore | Base de datos |
| Firebase Storage | Almacenamiento de imágenes |
| Provider | Gestión de estado |
| GoRouter | Navegación |

## Estructura del Proyecto

```
dog_club/
|-- .agents/
|   |-- AGENT.md
|   |-- AUTH.md
|   |-- CHECKLIST.md
|   |-- FILE_TREE.md
|   |-- FIREBASE.md
|   |-- LOGIC.md
|   |-- MODELS.md
|   |-- PROJECT.md
|   |-- SCREENS.md
|   |-- SEED.md
|   \-- WIDGETS.md
|-- assets/
|   |-- icons/
|   |   \-- .gitkeep
|   \-- images/
|       \-- .gitkeep
|-- imagenes/
|   |-- 360_F_624537727_KCb91luFQiqajZFjgGFBiCQayBOPjsPK.webp
|   |-- canva-foto-de-perfil-de-instagram-mujer-moderno-degrade-KJ7I3gc7Ths.webp
|   |-- canva-profile-picture-of-indan-man-MADIQlxicLE.webp
|   |-- canva-swiss-shepherd-dog-smiles-with-man`s-help-MAGZRaY8wLE.webp
|   |-- casa-energéticamente-eficiente-con-paneles-solares-y-batería-de-pared-para-almacenamiento-de.webp
|   |-- casa-techo-rojo-arbol-delante-ella_1221953-28213.webp
|   |-- D_NQ_NP_2X_971509-MLM110670803712_052026-E-casa-en-venta-en-bosque-de-las-lomas.webp
|   |-- dog-5019613_640.webp
|   |-- foto-de-retrato-de-hombre-asiático-sonriente.webp
|   |-- gente-disfrutando-de-la-puesta-de-sol-en-el-parque-del-barrio.webp
|   |-- lindo-perro-de-poner-su-cara-en-sus-rodillas-y-el-hombre-sonriente-de-las-manos-rascarse-el.webp
|   |-- people-sitting-in-a-park.webp
|   |-- perro-feliz.webp
|   |-- photo-1534361960057-19889db9621e.webp
|   |-- retrato-de-hombre-barbudo-con-gorra-posando-de-perfil-al-aire-libre-vista-de-perfil-de-joven.webp
|   |-- retrato-de-hombre-de-negocios-sonriendo-en-la-oficina-de-negocios.webp
|   |-- retrato-de-mujer-en-la-fiesta-de-la-azotea.webp
|   \-- train-ride-train-to-tour-the-park-mexico-latin-america-photo.webp
|-- lib/
|   |-- config/
|   |   |-- firebase_options.dart
|   |   |-- routes.dart
|   |   \-- theme.dart
|   |-- core/
|   |   |-- constants/
|   |   |   |-- app_colors.dart
|   |   |   |-- app_routes.dart
|   |   |   |-- app_strings.dart
|   |   |   \-- mock_data.dart
|   |   |-- enums/
|   |   |   |-- booking_status.dart
|   |   |   |-- pet_size.dart
|   |   |   |-- service_type.dart
|   |   |   \-- user_role.dart
|   |   |-- models/
|   |   |   |-- booking_model.dart
|   |   |   |-- chat_model.dart
|   |   |   |-- message_model.dart
|   |   |   |-- pet_model.dart
|   |   |   |-- review_model.dart
|   |   |   |-- service_model.dart
|   |   |   \-- user_model.dart
|   |   \-- utils/
|   |       |-- date_helper.dart
|   |       |-- formatters.dart
|   |       \-- validators.dart
|   |-- data/
|   |   |-- repositories/
|   |   |   |-- auth_repository.dart
|   |   |   |-- booking_repository.dart
|   |   |   |-- chat_repository.dart
|   |   |   |-- pet_repository.dart
|   |   |   |-- review_repository.dart
|   |   |   \-- user_repository.dart
|   |   \-- services/
|   |       |-- firebase_service.dart
|   |       |-- image_service.dart
|   |       \-- seed_service.dart
|   |-- presentation/
|   |   |-- providers/
|   |   |   |-- auth_provider.dart
|   |   |   |-- booking_provider.dart
|   |   |   |-- chat_provider.dart
|   |   |   \-- pet_provider.dart
|   |   |-- screens/
|   |   |   |-- admin/
|   |   |   |   |-- crud/
|   |   |   |   |   |-- bookings_crud_screen.dart
|   |   |   |   |   |-- pets_crud_screen.dart
|   |   |   |   |   |-- services_crud_screen.dart
|   |   |   |   |   \-- users_crud_screen.dart
|   |   |   |   \-- admin_dashboard_screen.dart
|   |   |   |-- auth/
|   |   |   |   |-- login_screen.dart
|   |   |   |   |-- register_screen.dart
|   |   |   |   \-- splash_screen.dart
|   |   |   |-- caregiver/
|   |   |   |   |-- active_pets_screen.dart
|   |   |   |   |-- caregiver_home_screen.dart
|   |   |   |   |-- caregiver_profile_screen.dart
|   |   |   |   \-- requests_screen.dart
|   |   |   \-- client/
|   |   |       |-- booking/
|   |   |       |   |-- booking_confirm_screen.dart
|   |   |       |   |-- booking_form_screen.dart
|   |   |       |   \-- my_bookings_screen.dart
|   |   |       |-- chat/
|   |   |       |   |-- chat_list_screen.dart
|   |   |       |   \-- chat_room_screen.dart
|   |   |       |-- profile/
|   |   |       |   |-- pets/
|   |   |       |   |   |-- add_pet_screen.dart
|   |   |       |   |   \-- pets_list_screen.dart
|   |   |       |   |-- edit_profile_screen.dart
|   |   |       |   \-- profile_screen.dart
|   |   |       |-- services/
|   |   |       |   |-- all_reviews_screen.dart
|   |   |       |   |-- caregiver_profile_screen.dart
|   |   |       |   \-- service_list_screen.dart
|   |   |       \-- home_screen.dart
|   |   \-- widgets/
|   |       |-- booking_card.dart
|   |       |-- custom_appbar.dart
|   |       |-- custom_drawer.dart
|   |       |-- empty_state.dart
|   |       |-- loading_shimmer.dart
|   |       |-- outlined_button.dart
|   |       |-- primary_button.dart
|   |       |-- rating_stars.dart
|   |       |-- service_card.dart
|   |       \-- status_badge.dart
|   |-- firebase_options.dart
|   \-- main.dart
|-- test/
|   \-- widget_test.dart
|-- web/
|   |-- icons/
|   |   |-- Icon-192.png
|   |   |-- Icon-512.png
|   |   |-- Icon-maskable-192.png
|   |   \-- Icon-maskable-512.png
|   |-- favicon.png
|   |-- index.html
|   \-- manifest.json
|-- .flutter-plugins-dependencies
|-- .gitignore
|-- .metadata
|-- analysis_options.yaml
|-- enviargithub.dart
|-- firebase.json
|-- firestore.rules
|-- proyectofinal.iml
|-- pubspec.lock
|-- pubspec.yaml
\-- README.md
```

## Configuración

### 1. Crear proyecto Firebase
1. Ve a [Firebase Console](https://console.firebase.google.com)
2. Crea un nuevo proyecto
3. Habilita **Authentication** (Email/Password)
4. Habilita **Cloud Firestore**
5. Habilita **Firebase Storage**

### 2. Configurar FlutterFire
```bash
dart pub global activate flutterfire_cli
flutterfire configure
```

### 3. Instalar dependencias
```bash
flutter pub get
```

### 4. Ejecutar
```bash
flutter run
```

## Roles y Accesos

| Rol | Acceso |
|---|---|
| **cliente** | Explorar servicios, reservar, chat, perfil, mascotas |
| **cuidador** | Dashboard, solicitudes, mascotas activas, chat, perfil |
| **admin** | CRUD completo de usuarios, mascotas, reservas y servicios |

### Cuenta Admin
El email `admin@dogclub.com` se registra automáticamente con rol `admin`.

## Datos Semilla
La app siembra automáticamente 3 servicios base en el primer inicio si la colección `services` está vacía:
- Hospedaje en Casa ($240/noche)
- Guardería Diurna ($180/día)
- Paseo Individual ($120/hora)

# Organización de Pantallas por Perfil de Usuario

# Prompt
Dentro de la carpeta .agents esta todo el contexto y prompt

## Inicio de sesión y registro

<img width="250" height="530" alt="7d2e0544-12a2-41e3-9a9c-a07ab3532e33" src="https://github.com/user-attachments/assets/90ee011a-cc00-4877-ad9c-daf6b927a0d8" />

<img width="250" height="530" alt="5d3fe8ed-3f70-4117-aa7c-67f808c2785e" src="https://github.com/user-attachments/assets/332180d1-24c4-40ac-bb17-e13b2317e4a9" />

## Vista Admin

<img width="250" height="530" alt="51719b2e-9231-4d4a-9dc5-a35e5ae9256c" src="https://github.com/user-attachments/assets/59edb150-7560-45eb-984e-4ca5fcdd3ed5" />

<img width="250" height="530" alt="f22fdc93-cc32-480e-83f2-d8815dcdf62a" src="https://github.com/user-attachments/assets/453ec0bd-9928-4c48-893f-56bd7b010e8e" />

<img width="250" height="530" alt="ee336651-fa49-4d4f-ba25-7bf1876d623d" src="https://github.com/user-attachments/assets/e1a6f1bf-9c03-46c5-8059-e9cb1a042d7e" />

<img width="250" height="530" alt="7de011ee-bf11-40ff-b49d-6db616cced84" src="https://github.com/user-attachments/assets/c8fc1cd8-8728-4f60-aba2-3dfb332a312c" />

<img width="250" height="530" alt="dd0a0cdc-cadd-4128-b03e-c6521ec3e8a1" src="https://github.com/user-attachments/assets/58522096-c4a6-40bb-88b4-3f880e5444ad" />

## Vista Cuidador

<img width="250" height="530" alt="bc823398-85be-4b3a-85bb-3fd92b78f3f1" src="https://github.com/user-attachments/assets/2d6295bb-ecd9-4e40-a1d7-abd81588ad5f" />

<img width="250" height="530" alt="9e8633b8-c535-4d3c-b8fc-9e7fd2e06cf7" src="https://github.com/user-attachments/assets/bc9fb987-76dc-4fe8-99c5-23b4d965e3d6" />

<img width="250" height="530" alt="db97bf67-33e7-47d4-8521-137877bfa88c" src="https://github.com/user-attachments/assets/975839cb-2953-4dc5-9ea2-e1bafcbb9ef4" />

<img width="250" height="880" alt="102ddd95-3c93-4278-99b7-26acd9d5b2b0" src="https://github.com/user-attachments/assets/dd19a921-9e3d-4b87-8878-9d99d6887809" />

<img width="250" height="530" alt="f81f3701-d148-40e9-82bc-915fc292d7f3" src="https://github.com/user-attachments/assets/02cb5511-4f8e-4344-a0cf-fb3d5baaddb3" />

<img width="250" height="530" alt="c2845c43-c7b8-484d-b294-e855b5a9035e" src="https://github.com/user-attachments/assets/ca3428a4-0eb5-48f5-b1f4-b10a3464e2ed" />

## Vista Cliente

<img width="250" height="530" alt="958d418f-5993-4096-9224-e985b12ef3cc" src="https://github.com/user-attachments/assets/2740a4bf-39b1-47fb-bbfb-50377ed642ca" />

<img width="250" height="530" alt="38f248e9-8b62-4a3f-a4ff-cd632b28e21d" src="https://github.com/user-attachments/assets/631369b9-77ab-4909-a8b9-087dbdc3cc0d" />

<img width="250" height="530" alt="d6ef9887-08bd-48b8-ac91-5fa56d376f89" src="https://github.com/user-attachments/assets/4a88c069-c36d-4136-a1b9-78931ed665f9" />

<img width="250" height="530" alt="d7b85f26-b2e0-4adc-be7f-796d875c671f" src="https://github.com/user-attachments/assets/e3c8b6f4-7c14-4f41-9039-843091c2eff2" />

<img width="250" height="530" alt="23d60819-3da1-43be-bc8e-1a1083810a39" src="https://github.com/user-attachments/assets/c934407b-fae3-45f3-aca6-6752667c3155" />

<img width="250" height="530" alt="1a050fe9-ab35-41d5-8295-1da57fa7816a" src="https://github.com/user-attachments/assets/d71642d7-33d0-4c5b-aced-bea995457e11" />

<img width="250" height="530" alt="153ca879-69dc-4fe1-b47d-9ae6b6852c3c" src="https://github.com/user-attachments/assets/ffb24b47-da00-4cac-bea4-97dd51e6e03c" />

<img width="250" height="530" alt="c5161979-a08c-4211-81b4-1f892c6cf7c9" src="https://github.com/user-attachments/assets/468e56f2-2e39-46a2-8486-fa2257297a17" />

<img width="250" height="530" alt="b392b368-64d8-4179-85a4-2f914d4a21a5" src="https://github.com/user-attachments/assets/fa13c807-3ffc-4898-983f-7f789de555ae" />

<img width="250" height="530" alt="33909285-7e76-4eed-8d1a-12c29c3552de" src="https://github.com/user-attachments/assets/ac159b6c-6ba2-4e3a-9509-dc05858ec63c" />

<img width="250" height="530" alt="dd809ef9-619a-402c-979a-eebc8ecbb78d" src="https://github.com/user-attachments/assets/95a697cf-35c5-4b81-b407-d96be8b95bc9" />

<img width="250" height="530" alt="412aea45-14cf-4aaf-9938-ad5da91ecd5d" src="https://github.com/user-attachments/assets/815bd586-0402-438c-8ffa-fab21d7028bc" />
