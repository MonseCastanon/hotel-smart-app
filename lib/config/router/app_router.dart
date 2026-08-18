import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hotel_smart_app/screens/splash_screen.dart';
// Las siguientes pantallas las implementarán Diego y Meño.
// Se importan aquí para que el router quede completo desde el inicio.
import 'package:hotel_smart_app/screens/home_screen.dart';
import 'package:hotel_smart_app/screens/rooms_screen.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Constantes de rutas
// ─────────────────────────────────────────────────────────────────────────────

/// Centraliza todas las rutas con nombre de la app.
///
/// Usar estas constantes en lugar de strings literales evita typos
/// y facilita refactors futuros (mismo patrón que [hotel_app]).
abstract final class AppRoutes {
  /// Pantalla de carga inicial.
  static const String splash = '/';

  /// Dashboard principal (Mockup 1).
  static const String home = '/home';

  /// Grilla de habitaciones por piso (Mockup 2).
  static const String rooms = '/rooms';
}

// ─────────────────────────────────────────────────────────────────────────────
// Router
// ─────────────────────────────────────────────────────────────────────────────

/// Instancia de [GoRouter] que gestiona la navegación de la Smart TV.
///
/// Flujo:
///   1. La app arranca en [SplashScreen] (ruta `/`).
///   2. Una vez que Firebase está listo, [SplashScreen] navega a `/home`.
///   3. Desde [HomeScreen] el usuario (o el control remoto) puede ir a `/rooms`.
///   4. [RoomsScreen] tiene un botón "Volver" que regresa a `/home`.
///
/// No se implementa autenticación aquí porque la Smart TV es un dispositivo
/// de uso interno del hotel (sin login de huésped). Si en el futuro se requiere,
/// se puede agregar un `redirect` igual al de [hotel_app].
final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.splash,
  debugLogDiagnostics: true,
  errorBuilder: (context, state) => _RouterErrorScreen(
    message: state.error?.message ?? 'Ruta no encontrada',
  ),
  routes: [
    // ── Splash ───────────────────────────────────────────────────────────────
    GoRoute(
      path: AppRoutes.splash,
      name: 'splash',
      builder: (context, state) => const SplashScreen(),
    ),

    // ── Home / Dashboard (Mockup 1) ──────────────────────────────────────────
    GoRoute(
      path: AppRoutes.home,
      name: 'home',
      builder: (context, state) => const HomeScreen(),
    ),

    // ── Habitaciones (Mockup 2) ──────────────────────────────────────────────
    GoRoute(
      path: AppRoutes.rooms,
      name: 'rooms',
      builder: (context, state) => const RoomsScreen(),
    ),
  ],
);

// ─────────────────────────────────────────────────────────────────────────────
// Pantalla de error de navegación
// ─────────────────────────────────────────────────────────────────────────────

class _RouterErrorScreen extends StatelessWidget {
  final String message;
  const _RouterErrorScreen({required this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.map_outlined, size: 72, color: Colors.orange),
            const SizedBox(height: 20),
            Text(
              '404',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontSize: 56,
                    color: Colors.orange,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => context.go(AppRoutes.home),
              icon: const Icon(Icons.home),
              label: const Text('Ir al inicio'),
            ),
          ],
        ),
      ),
    );
  }
}
