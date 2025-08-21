import 'package:flutter/material.dart';
import 'package:nubi_pdv/src/controllers/global_controller.dart';
import 'package:nubi_pdv/src/views/layout_admin.dart';
import 'package:nubi_pdv/src/views/layout_totem.dart';
import 'package:nubi_pdv/src/views/layout_whatsapp.dart';
import 'package:nubi_pdv/src/views/layout_weight.dart';
import 'package:nubi_pdv/src/views/layout.dart';
import 'package:google_fonts/google_fonts.dart';

class App extends StatelessWidget{
  const App({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
    title: 'Nubi PDV',
    theme: ThemeData(
      textTheme: GoogleFonts.montserratTextTheme(),

      useMaterial3: true, // Habilita o Material 3 (necessário para o ColorScheme funcionar corretamente)

      colorScheme: ColorScheme.fromSeed(
        seedColor: Color.fromRGBO(76, 175, 80, 1), // cor primária usada como base para o restante do esquema
        brightness: Brightness.light, // Tema claro
      ).copyWith(
        primary: Color.fromRGBO(76, 175, 80, 1), // cor primária
        onPrimary: Color.fromRGBO(255, 255, 255, 1), // contraste da primária

        secondary: Color.fromRGBO(224, 235, 255, 1.0), // cor secundária
        onSecondary: Color.fromRGBO(0, 0, 0, 1), // contraste da secundária
  
        tertiary: Color.fromRGBO(224, 224, 224, 1), // cinza 
        onTertiary: Color.fromRGBO(249, 248, 245, 1), // backgroud

        surface:Color.fromRGBO(255, 255, 255, 1), // superfícies elevadas
        onSurface:Color.fromRGBO(0, 0, 0, 1), // contraste sobre surface

        error: Color.fromRGBO(103, 58, 183, 1), // cor usada para erros (temporariamente verde)
        errorContainer: Color.fromRGBO(209, 196, 233, 1),
        onError: Color.fromRGBO(244, 67, 54, 1), // contraste sobre erro
      ),
    ),
    initialRoute: '/auto-weight',
    routes: {
        '/': (context) => Layout(),
        '/auto-weight': (context) => LayoutWeight(),
        '/layout-whatsapp': (context) => LayoutWhatsapp(),
        '/layout-pedeaqui': (context) => LayoutPedeaqui(),
        '/layout-toten': (context) => LayoutTotem(), 
      },
    );
  }
}

