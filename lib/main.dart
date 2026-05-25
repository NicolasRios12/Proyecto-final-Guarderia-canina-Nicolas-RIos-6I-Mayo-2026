import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'config/firebase_options.dart';
import 'config/routes.dart';
import 'config/theme.dart';
import 'presentation/providers/auth_provider.dart';
import 'presentation/providers/pet_provider.dart';
import 'presentation/providers/booking_provider.dart';
import 'presentation/providers/chat_provider.dart';

/// Punto de entrada de Dog Club.
/// Inicializa Firebase y configura los providers globales.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const DogClubApp());
}

/// Raíz de la aplicación.
/// Envuelve el árbol con MultiProvider para inyección de dependencias.
class DogClubApp extends StatelessWidget {
  const DogClubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => PetProvider()),
        ChangeNotifierProvider(create: (_) => BookingProvider()),
        ChangeNotifierProvider(create: (_) => ChatProvider()),
      ],
      child: MaterialApp.router(
        title: 'Dog Club',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        routerConfig: router,
      ),
    );
  }
}
