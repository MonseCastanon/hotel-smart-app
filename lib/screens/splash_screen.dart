import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hotel_smart_app/config/router/app_router.dart';
// import 'package:hotel_smart_app/config/services/hotel_service.dart'; // habilitar tras flutterfire configure

/// Pantalla de carga inicial de la Smart TV.
///
/// Se muestra mientras:
///   1. Flutter finaliza la inicialización de los bindings.
///   2. Firebase / Firestore se conecta y valida la disponibilidad.
///
/// Una vez lista la conexión navega automáticamente a [HomeScreen].
/// Si la conexión falla muestra un mensaje de error con botón de reintento.
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  // ── Animación del logo ────────────────────────────────────────────────────
  late final AnimationController _controller;
  late final Animation<double> _fadeAnim;
  late final Animation<double> _scaleAnim;

  String? _errorMessage;
  bool _isRetrying = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _fadeAnim = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _scaleAnim = Tween<double>(begin: 0.80, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );

    _controller.forward();
    _init();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // ── Lógica de inicialización ──────────────────────────────────────────────

  Future<void> _init() async {
    setState(() {
      _errorMessage = null;
      _isRetrying = false;
    });

    try {
      // TODO: Cuando Firebase esté configurado (`flutterfire configure`),
      // reemplazar este delay por la verificación real de conexión:
      //
      // final service = ref.read(hotelServiceProvider);
      // await service.watchRooms().first.timeout(const Duration(seconds: 10));

      // Simula el tiempo de inicialización mientras Firebase no está configurado.
      await Future<void>.delayed(const Duration(seconds: 2));

      if (!mounted) return;
      context.go(AppRoutes.home);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage =
            'No se pudo conectar con el servidor.\nVerifica la red e intenta de nuevo.';
      });
    }
  }

  // ── UI ────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: const Color(0xFF0F1117),
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnim,
          child: ScaleTransition(
            scale: _scaleAnim,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ── Logo ────────────────────────────────────────────────────
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: colors.primary,
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: colors.primary.withAlpha(100),
                        blurRadius: 40,
                        spreadRadius: 4,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.hotel_rounded,
                    size: 64,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 28),

                // ── Nombre ──────────────────────────────────────────────────
                Text(
                  'Hotel Smart TV',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: 1.0,
                      ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Panel de gestión hotelera',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: const Color(0xFF9EA3B2),
                        fontSize: 15,
                      ),
                ),

                const SizedBox(height: 48),

                // ── Estado: cargando / error ─────────────────────────────────
                if (_errorMessage == null)
                  _buildLoader(colors)
                else
                  _buildError(colors),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoader(ColorScheme colors) {
    return Column(
      children: [
        SizedBox(
          width: 40,
          height: 40,
          child: CircularProgressIndicator(
            color: colors.primary,
            strokeWidth: 3,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Conectando con el servidor…',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }

  Widget _buildError(ColorScheme colors) {
    return Column(
      children: [
        Icon(Icons.wifi_off_rounded, size: 48, color: colors.error),
        const SizedBox(height: 12),
        Text(
          _errorMessage!,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: colors.error,
              ),
        ),
        const SizedBox(height: 20),
        ElevatedButton.icon(
          autofocus: true,
          onPressed: _isRetrying ? null : _init,
          icon: _isRetrying
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : const Icon(Icons.refresh_rounded),
          label: Text(_isRetrying ? 'Reintentando…' : 'Reintentar'),
        ),
      ],
    );
  }
}
