import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../core/enums/user_role.dart';
import '../presentation/providers/auth_provider.dart';
import '../core/models/booking_model.dart';
import '../presentation/screens/auth/splash_screen.dart';
import '../presentation/screens/auth/login_screen.dart';
import '../presentation/screens/auth/register_screen.dart';
import '../presentation/screens/client/home_screen.dart';
import '../presentation/screens/client/services/service_list_screen.dart';
import '../presentation/screens/client/services/caregiver_profile_screen.dart' as client_cg;
import '../presentation/screens/client/booking/booking_form_screen.dart';
import '../presentation/screens/client/booking/booking_confirm_screen.dart';
import '../presentation/screens/client/booking/my_bookings_screen.dart';
import '../presentation/screens/client/profile/profile_screen.dart';
import '../presentation/screens/client/profile/edit_profile_screen.dart';
import '../presentation/screens/client/profile/pets/pets_list_screen.dart';
import '../presentation/screens/client/profile/pets/add_pet_screen.dart';
import '../presentation/screens/client/chat/chat_list_screen.dart';
import '../presentation/screens/client/chat/chat_room_screen.dart';
import '../presentation/screens/caregiver/caregiver_home_screen.dart';
import '../presentation/screens/caregiver/requests_screen.dart';
import '../presentation/screens/caregiver/active_pets_screen.dart';
import '../presentation/screens/caregiver/caregiver_profile_screen.dart' as cg_profile;
import '../presentation/screens/admin/admin_dashboard_screen.dart';
import '../presentation/screens/admin/crud/users_crud_screen.dart';
import '../presentation/screens/admin/crud/pets_crud_screen.dart';
import '../presentation/screens/admin/crud/bookings_crud_screen.dart';
import '../presentation/screens/admin/crud/services_crud_screen.dart';

/// Configuración de rutas con GoRouter.
/// Incluye rutas para los 3 roles: cliente, cuidador y admin.
final GoRouter router = GoRouter(
  initialLocation: '/splash',
  redirect: (context, state) {
    final auth = context.read<AuthProvider>();
    final isLoggedIn = auth.isAuthenticated;
    final location = state.matchedLocation;

    // Si está en splash, no redirigir aún
    if (location == '/splash') return null;

    if (!isLoggedIn && location != '/login' && location != '/register') {
      return '/login';
    }

    if (isLoggedIn && (location == '/login' || location == '/register')) {
      switch (auth.role) {
        case UserRole.admin:
          return '/admin';
        case UserRole.cuidador:
          return '/caregiver';
        default:
          return '/home';
      }
    }

    return null;
  },
  routes: [
    // ── Auth ──
    GoRoute(
      path: '/splash',
      builder: (_, __) => const SplashScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (_, __) => const LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      builder: (_, __) => const RegisterScreen(),
    ),

    // ── Cliente ──
    GoRoute(
      path: '/home',
      builder: (_, __) => const HomeScreen(),
      routes: [
        GoRoute(
          path: 'services/:categoria',
          builder: (_, state) => ServiceListScreen(
            categoria: state.pathParameters['categoria']!,
          ),
        ),
        GoRoute(
          path: 'caregiver/:uid',
          builder: (_, state) => client_cg.CaregiverProfileScreen(
            caregiverUid: state.pathParameters['uid']!,
          ),
        ),
        GoRoute(
          path: 'booking',
          builder: (_, state) => BookingFormScreen(
            extra: state.extra as Map<String, dynamic>?,
          ),
        ),
        GoRoute(
          path: 'booking-confirm',
          builder: (_, state) => BookingConfirmScreen(
            booking: state.extra as BookingModel,
          ),
        ),
        GoRoute(
          path: 'bookings',
          builder: (_, __) => const MyBookingsScreen(),
        ),
        GoRoute(
          path: 'profile',
          builder: (_, __) => const ProfileScreen(),
        ),
        GoRoute(
          path: 'edit-profile',
          builder: (_, __) => const EditProfileScreen(),
        ),
        GoRoute(
          path: 'pets',
          builder: (_, __) => const PetsListScreen(),
        ),
        GoRoute(
          path: 'add-pet',
          builder: (_, __) => const AddPetScreen(),
        ),
        GoRoute(
          path: 'chats',
          builder: (_, __) => const ChatListScreen(),
        ),
        GoRoute(
          path: 'chat/:chatId',
          builder: (_, state) {
            final chatId = state.pathParameters['chatId']!;
            final otherUid = state.uri.queryParameters['otherUid'] ?? '';
            return ChatRoomScreen(chatId: chatId, otherUid: otherUid);
          },
        ),
      ],
    ),

    // ── Cuidador ──
    GoRoute(
      path: '/caregiver',
      builder: (_, __) => const CaregiverHomeScreen(),
      routes: [
        GoRoute(
          path: 'requests',
          builder: (_, __) => const RequestsScreen(),
        ),
        GoRoute(
          path: 'active-pets',
          builder: (_, __) => const ActivePetsScreen(),
        ),
        GoRoute(
          path: 'profile',
          builder: (_, __) => const cg_profile.CaregiverProfileScreen(),
        ),
        GoRoute(
          path: 'chat/list',
          builder: (_, __) => const ChatListScreen(),
        ),
        GoRoute(
          path: 'chat/:chatId',
          builder: (_, state) {
            final chatId = state.pathParameters['chatId']!;
            final otherUid = state.uri.queryParameters['otherUid'] ?? '';
            return ChatRoomScreen(chatId: chatId, otherUid: otherUid);
          },
        ),
      ],
    ),

    // ── Admin ──
    GoRoute(
      path: '/admin',
      builder: (_, __) => const AdminDashboardScreen(),
      routes: [
        GoRoute(
          path: 'users',
          builder: (_, __) => const UsersCrudScreen(),
        ),
        GoRoute(
          path: 'pets',
          builder: (_, __) => const PetsCrudScreen(),
        ),
        GoRoute(
          path: 'bookings',
          builder: (_, __) => const BookingsCrudScreen(),
        ),
        GoRoute(
          path: 'services',
          builder: (_, __) => const ServicesCrudScreen(),
        ),
      ],
    ),
  ],
  errorBuilder: (_, __) => const Scaffold(
    body: Center(child: Text('Página no encontrada')),
  ),
);
