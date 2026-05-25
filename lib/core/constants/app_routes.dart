/// Constantes de rutas para GoRouter.
/// Evita errores tipográficos al usar strings directamente.
class AppRoutes {
  AppRoutes._();

  // Auth
  static const String splash = '/splash';
  static const String login = '/login';
  static const String register = '/register';

  // Cliente
  static const String home = '/home';
  static const String services = 'services/:categoria';
  static const String caregiverProfile = 'caregiver/:uid';
  static const String booking = 'booking';
  static const String bookingConfirm = 'booking-confirm';
  static const String profile = 'profile';
  static const String editProfile = 'edit-profile';
  static const String pets = 'pets';
  static const String addPet = 'add-pet';
  static const String chatList = 'chats';
  static const String chatRoom = 'chat/:chatId';

  // Cuidador
  static const String caregiver = '/caregiver';
  static const String caregiverRequests = 'requests';
  static const String caregiverActivePets = 'active-pets';
  static const String caregiverProfileEdit = 'profile';
  static const String caregiverChat = 'chat/:chatId';

  // Admin
  static const String admin = '/admin';
  static const String adminUsers = 'users';
  static const String adminPets = 'pets';
  static const String adminBookings = 'bookings';
  static const String adminServices = 'services';
}
