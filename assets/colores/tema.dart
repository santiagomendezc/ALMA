import 'package:flutter/material.dart';
ThemeData get tema {
  return ThemeData(
      colorScheme: ColorScheme.fromSeed(
      seedColor: const Color.from(alpha: 0.848, red: 0, green: 0, blue: 0),
      primary: const Color.fromARGB(255, 232, 231, 231),
      secondary: const Color.fromARGB(255, 96, 144, 65),
      brightness: Brightness.dark, 
    ),    
    // Configuración de la tipografía (ej. para titulares)
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 72,
        fontWeight: FontWeight.bold,
        color: Color.fromARGB(255, 111, 189, 72),
      ),
      titleLarge: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: Color.fromARGB(255, 61, 199, 45),
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        color: Color.fromARGB(255, 42, 201, 63),
      ),
    ),    

    // Configuración de widgets específicos (ej. ElevatedButton)
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 83, 86, 89), // Color de fondo del botón
        foregroundColor: const Color.fromARGB(255, 241, 244, 239), // Color del texto del botón
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
    // 


      ),
    ),
  );
}

/*
class Titulos extends StatelessWidget {
  final String tituloRequerido;
  const Titulos({
    super.key,
    required this.tituloRequerido, 
  });

  @override
  Widget build(BuildContext context) {
      return Container(
      padding: const EdgeInsets.all(20),
      child: Text(
        ' $tituloRequerido', 
        style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
      ),
    );
  }
}  */

class Fondopantalla extends StatelessWidget {
  final Widget child;

  const Fondopantalla({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      // Aplicamos la decoración de imagen y color de respaldo
      decoration: const BoxDecoration(
        // Color de Fondo: Se ve si la imagen es transparente o como un overlay sutil.
        // color: Color(0xFF1A237E), // Un color azul oscuro, por ejemplo
        
        // Imagen de Fondo
        image: DecorationImage(
          image: AssetImage('lib/assets/imagenes/logo.jpg'), 
          fit: BoxFit.cover, // Para que la imagen cubra toda el área
        ),
      ),
      child: child, // El 'child' será tu Scaffold o la vista de la pantalla
    );
  }
}
