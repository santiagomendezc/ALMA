import 'package:aplicacion/assets/colores/tema.dart';
import 'package:aplicacion/features/configuracion/domain/entities/game_settings.dart';
import 'package:aplicacion/features/configuracion/presentation/providers/settings_provider.dart';
import 'package:aplicacion/features/home/home_usuarios_implement.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Configuracionvista extends StatelessWidget {
  const Configuracionvista({super.key});

  @override
  Widget build(BuildContext context) {
    return Fondopantalla(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text("Configuración"),
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: const [HomeButton()],
        ),
        body: Consumer<SettingsProvider>(
          builder: (context, provider, child) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   const Text(
                    "Velocidad ",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Slider(
                    value: provider.settings.speed,
                    min: GameSettings.minSpeed,
                    max: GameSettings.maxSpeed,
                    divisions: 5,
                    label: provider.settings.speed.toString(),
                    onChanged: (value) => provider.updateSpeed(value),),
                  
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Lento ", style: TextStyle(fontSize: 16)),
                      Text("Rápido ", style: TextStyle(fontSize: 16)),
                    ],
                  ),
                  const SizedBox(height: 30),

                  // ── SELECCIÓN DE CLAVE ─────────────────────────────
                  const Text("Clave",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 7,
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 5,
                    childAspectRatio: 0.85,
                    children: ClaveMusical.values.map((clave) {
                      final selected = provider.settings.clave == clave;
                      return GestureDetector(
                        onTap: () => provider.updateClave(clave),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          decoration: BoxDecoration(
                            color: selected
                                ? AppColors.chipSelectedBackground
                                : AppColors.chipUnselectedBackground.withOpacity(0.85),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: selected
                                  ? AppColors.chipSelectedBackground
                                  : AppColors.chipUnselectedBorder,
                              width: 2,
                            ),
                            boxShadow: selected
                                ? [BoxShadow(
                                    color: AppColors.chipSelectedBackground
                                        .withOpacity(0.3),
                                    blurRadius: 8,
                                    offset: const Offset(0, 3),
                                  )]
                                : [],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                clave.unicode,
                                style: TextStyle(
                                  fontFamily: 'Bravura',
                                  fontSize: 34,
                                  color: selected
                                      ? AppColors.chipSelectedText
                                      : AppColors.staffInkStrong,
                                  height: 1.0,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                clave.label,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: selected
                                      ? AppColors.chipSelectedText
                                      : AppColors.chipUnselectedText,
                                  height: 1.3,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 30),

                  // ── GRÁFICOS ───────────────────────────────────────

                  /*
                  const Text(
                    "Gráficos",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SwitchListTile(
                    title: const Text("Gráficos Alternativos"),
                    subtitle: const Text("Cambiar estilo de notas y respuestas"),
                    value: provider.settings.alternativeGraphics,
                    onChanged: (value) {
                      provider.toggleGraphics();
                    },
                  ),
                  */
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}