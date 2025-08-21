import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:nubi_pdv/core/database/mobx_store/produto_store.dart';
import 'package:nubi_pdv/src/controllers/global_controller.dart';
import 'package:nubi_pdv/src/controllers/pedido.controller.dart';
import 'package:nubi_pdv/src/controllers/theme_controller.dart';
import 'package:nubi_pdv/src/views/layout.dart';
import 'package:nubi_pdv/src/views/layout_admin.dart';
import 'package:nubi_pdv/src/views/layout_totem.dart';
import 'package:nubi_pdv/src/views/layout_weight.dart';
import 'package:nubi_pdv/src/views/layout_whatsapp.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:window_manager/window_manager.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

// // MAIN SEM WINDOWNS QUE VAI FICAR
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await windowManager.ensureInitialized();
  
//   // Inicializa o FFI para Windows/Linux/macOS
//   sqfliteFfiInit();

//   // Define factory para o FFI
//   databaseFactory = databaseFactoryFfi;
//   // Para implementação do SQLite 
//   GetIt.I.registerSingleton<ProdutoStore>(ProdutoStore());

//   Intl.defaultLocale = 'pt_BR';
  
//   debugPaintSizeEnabled = false;

//   const bool kReleaseMode = false; 

// Run app certo 
// runApp(
//   DevicePreview(
//     enabled: !kReleaseMode,
//     builder: (context) => MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (_) => PedidoController()),
//         ChangeNotifierProvider(create: (_) => ThemeController()),
//       ],
//       child: const App(),
//     ),
//   ),
// );

//   runApp(
//     MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (_) => PedidoController()),
//         ChangeNotifierProvider(create: (_) => ThemeController()),
//       ],
//       child: const App(),
//     ),
//   );
// }

// class App extends StatelessWidget {
//   const App({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final themeController = Provider.of<ThemeController>(context);

//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Nubi PDV',
//       theme: themeController.themeData,
//       initialRoute: '/auto-weight',
//       onGenerateRoute: (settings) {
//         late Widget page;
//         bool isFullscreen = false;

//         switch (settings.name) {
//           case '/auto-weight':
//             isFullscreen = false;
//             page = LayoutWeight();
//             break;
//           case '/':
//             isFullscreen = false;
//             page = Layout();
//             break;
//           case '/layout-whatsapp':
//             isFullscreen = false;
//             page = LayoutWhatsapp();
//             break;
//           case '/layout-pedeaqui':
//             isFullscreen = false;
//             page = LayoutPedeaqui();
//             break;
//           case '/layout-toten':
//             isFullscreen = true;
//             page = LayoutTotem();
//             break;
//           default:
//             isFullscreen = false;
//             page = LayoutWeight();
//             break;
//         }

//         Future.microtask(() async {
//           if (isFullscreen) {
//             await windowManager.setFullScreen(true);
//             await windowManager.setHasShadow(false);
//             await windowManager.setTitleBarStyle(TitleBarStyle.hidden);
//           } else {
//             await windowManager.setFullScreen(false);
//             await windowManager.setHasShadow(true);
//             await windowManager.setTitleBarStyle(TitleBarStyle.normal);
//           }
//         });

//         return MaterialPageRoute(builder: (_) => page);
//       },
//     );
//   }
// }

//MAIN COM windows com controller 
void main() {

   // Inicializa o FFI para Windows/Linux/macOS
  sqfliteFfiInit();

  // Define factory para o FFI
  databaseFactory = databaseFactoryFfi;
  // Para implementação do SQLite 
  GetIt.I.registerSingleton<ProdutoStore>(ProdutoStore());

  Intl.defaultLocale = 'pt_BR';
  
  debugPaintSizeEnabled = false;
  // GlobalController.instance.inicializaLayoutTotem();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PedidoController()),
        ChangeNotifierProvider(create: (_) => ThemeController()),
      ],
      child: const App(),
    ),
  );
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Provider.of<ThemeController>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Nubi PDV',
      theme: themeController.themeData,
      initialRoute: '/auto-weight',
       onGenerateRoute: (settings) {
        late Widget page;
        bool isFullscreen = false; // booleano que determina ser fullscreen

        switch (settings.name) {
          case '/':
            page = Layout();
            break;
          case '/auto-weight': 
            isFullscreen = false;
            page = LayoutWeight();
            break;
          case '/layout-whatsapp': 
            isFullscreen = false;
            page = LayoutWhatsapp();
            break;
          case '/layout-pedeaqui':
            isFullscreen = false;
            page = LayoutPedeaqui();
            break;
         case '/layout-toten': 
            isFullscreen = true;
            page = LayoutTotem();
            break;
          default:
            page = LayoutWeight(); // se der algo errado volta para a primeira página 
        }
        return MaterialPageRoute(
          builder: (_) => page,
        );
       }
    );
  }
}