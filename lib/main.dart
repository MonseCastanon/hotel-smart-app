import 'package:firebase_core/firebase_core.dart'; // descomentar tras flutterfire configure
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotel_smart_app/config/router/router.dart';
import 'package:hotel_smart_app/config/theme/app_theme.dart';

// TODO: Ejecutar `flutterfire configure` para generar este archivo.
import 'firebase_options.dart';

void main() async {
  // 1. Inicializar los bindings de Flutter antes de cualquier operación async.
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Forzar orientación horizontal (landscape) — Smart TV siempre en este modo.
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  // 3. UI en modo inmersivo: oculta barras del sistema para aprovechar la pantalla completa.
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  // 4. Inicializar Firebase.
  //    Usa la misma configuración que hotel_app para compartir la base de datos
  //    en tiempo real con el resto de apps del proyecto.
  //
  //    ⚠️  PENDIENTE: ejecuta `flutterfire configure` para generar
  //    firebase_options.dart y google-services.json, luego descomenta:
  //
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // 5. Levantar la app envuelta en ProviderScope para Riverpod.
  runApp(const ProviderScope(child: HotelSmartApp()));
}

/// Widget raíz de la Smart TV.
class HotelSmartApp extends StatelessWidget {
  const HotelSmartApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Hotel Smart TV',
      debugShowCheckedModeBanner: false,

      // Tema único oscuro diseñado para pantallas grandes a distancia.
      theme: const AppTheme(isDarkMode: true).getTheme(),

      // Router declarativo con go_router (mismo paquete que hotel_app).
      routerConfig: appRouter,
    );
  }
}
