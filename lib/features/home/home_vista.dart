import 'package:aplicacion/assets/colores/tema.dart';
import 'package:aplicacion/features/user_management/presentation/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeVista extends StatefulWidget {
  const HomeVista({super.key});

  @override
  State<HomeVista> createState() => _HomeVistaState();
}

class _HomeVistaState extends State<HomeVista> {
  @override
  Widget build(BuildContext context) {
    return Fondopantalla(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Consumer<UserProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (provider.users.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      color: AppColors.overlay,
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      child: Text('Bienvenido'),),
                      const SizedBox(height: 20),
                    ElevatedButton(
                      child: Text(" Crear Usuario "),
                      //  child: Text("\u{1D11E}"),
                      onPressed: () {
                        Navigator.pushNamed(context, '/crear');
                      },
                    ),
                  ],
                ),
              );
            }

            return Column(
              children: [
                const SizedBox(height: 50),
                Container(
                  color: AppColors.overlay,
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Text('Selecciona tu Usuario'),),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: provider.users.length,
                    itemBuilder: (context, index) {
                      final user = provider.users[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: ElevatedButton(
                          child: Text(user.nickname),
                          onPressed: () {
                            provider.selectUser(user);
                            Navigator.pushReplacementNamed(
                                context, '/menu_principal');
                          },
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 30.0),
                  child: ElevatedButton(
                    child: Text(" Crear Nuevo Usuario "),
                    onPressed: () {
                      Navigator.pushNamed(context, '/crear');
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
