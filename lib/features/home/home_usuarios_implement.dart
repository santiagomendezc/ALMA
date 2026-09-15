import 'package:aplicacion/assets/colores/tema.dart';
import 'package:aplicacion/features/user_management/presentation/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class Crearusuario extends StatefulWidget {
  const Crearusuario({super.key});

  @override
  State<Crearusuario> createState() => _CrearnusuarioState();
}

class _CrearnusuarioState extends State<Crearusuario> {
  final TextEditingController _nombre = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Fondopantalla(child: 
      Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: 
        Column(
          children: [
            Container(
                  color: AppColors.overlay,
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Text('Nuevo Usuario'),),
            SizedBox(
              width: double.infinity,
              height: 70,
                child: TextField(
                controller: _nombre,
                decoration: InputDecoration(
                  labelText: "Ingresa tu nombre",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                final nombre = _nombre.text;
                if (nombre.isNotEmpty) {
                  final provider = Provider.of<UserProvider>(context, listen: false);
                  final success = await provider.createUser(nombre);
                  if (success && context.mounted) {
                    Navigator.pushReplacementNamed(context, '/menu_principal');
                  }
                }
              },              
              child: const Text(" Registrar y Entrar "),
            ),
          ],
        ),
      ),
      ), 
    );
  }
}

class HomeButton extends StatelessWidget {
  const HomeButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.home, color: AppColors.textPrimary),
      tooltip: 'Menú principal',
      onPressed: () => Navigator.pushNamedAndRemoveUntil(
        context,
        '/menu_principal',
        (route) => false, 
      ),
    );
  }
}