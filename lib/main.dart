import 'package:aplicacion/assets/colores/tema.dart';
import 'package:aplicacion/features/configuracion/presentation/Vistas/confi_vista.dart';
import 'package:aplicacion/features/home/home_usuarios_implement.dart';
import 'package:aplicacion/features/home/home_vista.dart';
import 'package:aplicacion/features/home/menu_principal_vista.dart';
import 'package:aplicacion/features/game/presentation/pages/game_screen.dart';
import 'package:aplicacion/features/user_management/presentation/providers/user_provider.dart';
import 'package:aplicacion/features/configuracion/presentation/providers/settings_provider.dart';
import 'package:aplicacion/features/game/presentation/providers/game_provider.dart';
import 'package:aplicacion/injection_container.dart' as di;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  await di.init();
  runApp(const Myapp());
}

class Myapp extends StatelessWidget {
  const Myapp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => di.sl<UserProvider>()..loadUsers()),
        ChangeNotifierProvider(create: (_) => di.sl<SettingsProvider>()..loadSettings()),
        ChangeNotifierProvider(create: (_) => di.sl<GameProvider>()),
      ],
      child: MaterialApp(
        title: 'ALMA',
        theme: tema,
        home: const HomeVista(),
        routes: <String, WidgetBuilder>{
          '/crear': (BuildContext context) => const Crearusuario(),
          '/selecionar': (BuildContext context) => const HomeVista(),
          '/home': (BuildContext context) => const HomeVista(),
          '/jugar': (BuildContext context) => const GameScreen(),
          '/confi': (BuildContext context) => const Configuracionvista(),
          '/menu_principal': (BuildContext context) => const MenuPrincipalScreen(),
        },
      ),
    );
  }
}

