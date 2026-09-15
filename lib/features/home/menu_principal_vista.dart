import 'package:aplicacion/assets/colores/tema.dart';
import 'package:aplicacion/features/user_management/presentation/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MenuPrincipalScreen extends StatelessWidget {
  const MenuPrincipalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.select((UserProvider p) => p.currentUser);

    return Fondopantalla(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                color: AppColors.overlay,
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Text( "Hola, ${user?.nickname ?? 'Jugador'}"),), 
              const SizedBox(height: 30),
              ElevatedButton(
                child: Text( " Jugar "),
                onPressed: () => Navigator.pushNamed(context, '/jugar'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                child: Text( " Configuración "),
                onPressed: () => Navigator.pushNamed(context, '/confi'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                child: Text( " Cambiar Usuario " ), 
                onPressed: () {
                  context.read<UserProvider>().clearCurrentUser();
                  Navigator.pushReplacementNamed(context, '/selecionar');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
