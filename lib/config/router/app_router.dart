import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hotel_smart_app/screens/splash_screen.dart';
import 'package:hotel_smart_app/screens/home_screen.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Constantes de rutas
// ─────────────────────────────────────────────────────────────────────────────

/// Centraliza todas las rutas con nombre de la app.
///
/// La Smart TV solo tiene dos pantallas: splash (carga) y home (tablero Kanban).
/// La vista de habitaciones fue removida para enfocar la pantalla 100% en
/// el flujo de tareas y alertas del personal.
abstract final class AppRoutes {
  /// Pantalla de carga inicial.
  static const String splash = '/';

  /// Tablero Kanban principal — centro de mando de tareas y alertas.
  static const String home = '/home';
}

// ─────────────────────────────────────────────────────────────────────────────
// Router
// ─────────────────────────────────────────────────────────────────────────────

/// Instancia de [GoRouter] que gestiona la navegación de la Smart TV.
///
/// Flujo simplificado:
///   1. La app arranca en [SplashScreen] (ruta `/`).
///   2. Una vez que Firebase está listo, [SplashScreen] navega a `/home`.
///   3. [HomeScreen] muestra el tablero Kanban con tareas y alertas.
///
/// No se implementa autenticación aquí porque la Smart TV es un dispositivo
/// de uso interno del hotel (sin login de huésped).
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

    // ── Tablero Kanban ───────────────────────────────────────────────────────
    GoRoute(
      path: AppRoutes.home,
      name: 'home',
      builder: (context, state) => const HomeScreen(),
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
