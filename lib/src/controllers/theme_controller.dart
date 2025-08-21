// lib/src/controllers/theme.controller.dart
import 'package:flutter/material.dart';

class ThemeController extends ChangeNotifier {
  Color primary =  Color.fromRGBO(76, 175, 80, 1);
  Color onPrimary = Color.fromRGBO(255, 255, 255, 1); // contraste da primária

  Color secondary = Color.fromRGBO(224, 235, 255, 1.0);
  Color onSecondary = Color.fromRGBO(0, 0, 0, 1); // contraste da secundária

  Color tertiary = Color.fromRGBO(224, 224, 224, 1); // cinza 
  Color onTertiary = Color.fromRGBO(249, 248, 245, 1); // backgroud

  Color surface = Color.fromRGBO(255, 255, 255, 1);
  Color onSurface = Color.fromRGBO(0, 0, 0, 1);

  Color error = Color.fromRGBO(103, 58, 183, 1);
  Color onError = Color.fromRGBO(244, 67, 54, 1); // contraste sobre erro

  Color errorContainer = Color.fromRGBO(209, 196, 233, 1); // erro mais claro 

  Color shadow = Color.fromRGBO(224, 224, 224, 1);
  Color scrim = Color.fromRGBO(0, 0, 0, 1); // Letras teclado 

  Color primaryContainer = Color.fromRGBO(105,89,205,1); // Primeiro sabor 
  Color onPrimaryContainer = Color.fromRGBO(65,105,225,1); // Primeira borda  

  Color secondaryContainer = Color.fromRGBO(0,139,139,1); // Segundo sabor  
  Color onSecondaryContainer = Color.fromRGBO(32,178,170,1); // Segunda borda
  
  Color tertiaryContainer = Color.fromRGBO(179, 57, 0, 1); // Terceiro sabor 
  Color onTertiaryContainer = Color.fromRGBO(255,228,181,1); // Terceira borda
  
  Color surfaceDim = Color.fromRGBO(70,130,180,1); // Quarto sabor 
  Color surfaceBright = Color.fromRGBO(135,206,235,1); // Quarta borda

  void updateColor({required String type, required Color color}) {
    if (type == 'Primária') {
      primary = color;
    } else if (type == 'Contraste com Primária') {
      onPrimary = color;
    } else if (type == 'Secundária') {
      secondary = color;
    } else if (type == 'Contraste com Secundária') {
      onSecondary = color;
    } else if (type == 'Cor de Fundo 2') {
      tertiary = color;
    } else if (type == 'Cor de Fundo') {
      onTertiary = color;
    } else if (type == 'Superfícies Elevadas') {
      surface = color;
    } else if (type == 'Contraste com Superfícies Elevadas') {
      onSurface = color;
    } else if (type == 'Mensagem') {
      error = color;
    } else if (type == 'Contraste com Cor Usada para Erros') {
      onError = color;
    } else if (type == 'Erros (mais claro)') {
      errorContainer = color;
    } else if (type == 'Teclado') {
      shadow = color;
    } else if (type == 'Letras teclado') {
      scrim = color;
    } else if (type == 'Primeiro sabor') {
      primaryContainer = color;
    } else if (type == 'Primeira borda') {
      onPrimaryContainer = color;
    } else if (type == 'Segundo sabor') {
      secondaryContainer = color;
    } else if (type == 'Segunda borda') {
      onSecondaryContainer = color;
    } else if (type == 'Terceiro sabor') {
      tertiaryContainer = color;
    } else if (type == 'Terceira borda') {
      onTertiaryContainer = color;
    } else if (type == 'Quarto sabor') {
      surfaceDim = color;
    } else if (type == 'Quarta borda') {
      surfaceBright = color;
    }
    notifyListeners();
  }

  ThemeData get themeData {
    return ThemeData(
      useMaterial3: true,
      textTheme: Typography.blackCupertino,
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

          shadow: Color.fromRGBO(224, 224, 224, 1), // Teclado 
          scrim: Color.fromRGBO(0, 0, 0, 1), // Letras teclado 

          // Cores para pizza 
          // Primeiro sabor 
          primaryContainer: Color.fromRGBO(105,89,205,1),
          // Primeira borda  
          onPrimaryContainer: Color.fromRGBO(65,105,225,1),

          // Segundo sabor 
          secondaryContainer: Color.fromRGBO(0,139,139,1),
          // Segunda borda 
          onSecondaryContainer: Color.fromRGBO(32,178,170,1),
          
          // Terceiro sabor
          tertiaryContainer: Color.fromRGBO(179, 57, 0, 1),
          // Terceira borda 
          onTertiaryContainer: Color.fromRGBO(255,228,181,1),
          
          // Quarto sabor 
          surfaceDim: Color.fromRGBO(70,130,180,1),
          // Quarta borda
          surfaceBright: Color.fromRGBO(135,206,235,1),
      ),
    );
  }
}
