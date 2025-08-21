import 'package:flutter/material.dart';
import 'package:nubi_pdv/src/controllers/theme_controller.dart';
import 'package:nubi_pdv/src/views/inserir_produtos.dart';
import 'package:nubi_pdv/src/views/layout_totem.dart';
import 'package:nubi_pdv/src/views/layout_weight.dart';
import 'package:nubi_pdv/src/views/produtos_registrados_layout.dart';
import 'package:nubi_pdv/src/views/tema_totem.dart';
import 'package:provider/provider.dart';

class SenhaCorretaLayout extends StatefulWidget {
  const SenhaCorretaLayout({super.key});

  @override
  State<SenhaCorretaLayout> createState() => SenhaCorretaLayoutState();
}

class SenhaCorretaLayoutState extends State<SenhaCorretaLayout> {
  @override
  Widget build(BuildContext context) {
    final themeController = context.watch<ThemeController>(); // Escuta mudanças nas cores
    return  Scaffold(
      backgroundColor: themeController.onTertiary,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false, // botão de voltar

        // Botão manual de voltar + título
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: themeController.onSecondary,
          onPressed: () {
            Navigator.push(
              context, 
              MaterialPageRoute(
                builder: (context) => LayoutTotem(),
              ),
            );
          },
        ),

        // Text 
        title: Text(
          '',
          style: TextStyle(
            color: themeController.onSecondary,
            fontSize: 22,
            fontWeight: FontWeight.w400,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Botão "Sair do totem"
              Expanded(
                child: SizedBox(
                  height: 60,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: themeController.secondary,
                      foregroundColor: themeController.onSecondary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    // onPressed: () {
                    //   Navigator.push(
                    //     context,
                    //     MaterialPageRoute(builder: (_) => LayoutWeight()),
                    //   );
                    // },
                    onPressed: () {
                      Navigator.pushNamed(context, '/');
                    },
                    icon: Icon(Icons.door_back_door),
                    label: Text(
                      "Sair do totem",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(width: 16), // Espaço entre os botões

              // Botão "Mudar tema do totem"
              Expanded(
                child: SizedBox(
                  height: 60,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: themeController.primary,
                      foregroundColor: themeController.onPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => TemaTotem()
                        ),
                      );
                    },

                    icon: Icon(Icons.color_lens),
                    label: Text(
                      "Mudar tema do totem",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
             
             SizedBox(width: 16),

              // Botão "Vizualizar lista de produtos"
              Expanded(
                child: SizedBox(
                  height: 60,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: themeController.secondary,
                      foregroundColor: themeController.onSecondary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => 
                        ProdutosRegistradosLayout()
                        ),
                      );
                    },

                    icon: Icon(Icons.save),
                    label: Text(
                      "Lista de produtos",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(width: 16), // Espaço entre os botões
            ],
          ),
        ),
      ),
    );
  }
}

// class SenhaCorretaLayout extends StatefulWidget {
//   const SenhaCorretaLayout({super.key});

//   @override
//   State<SenhaCorretaLayout> createState() => SenhaCorretaLayoutState();
// }

// class SenhaCorretaLayoutState extends State<SenhaCorretaLayout> {
//   @override
//   Widget build(BuildContext context) {
//     final themeController = context.watch<ThemeController>(); // Escuta mudanças nas cores
//     bool isProcessing = false;
//     return  Scaffold(
//       backgroundColor: themeController.onTertiary,
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         automaticallyImplyLeading: false, // botão de voltar

//         // Botão manual de voltar + título
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back),
//           color: themeController.onSecondary,
//           onPressed: () {
//             Navigator.push(
//               context, 
//               MaterialPageRoute(
//                 builder: (context) => LayoutTotem(),
//               ),
//             );
//           },
//         ),

//         // Text 
//         title: Text(
//           '',
//           style: TextStyle(
//             color: themeController.onSecondary,
//             fontSize: 22,
//             fontWeight: FontWeight.w400,
//           ),
//         ),
//         centerTitle: true,
//       ),
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               // Botão "Sair do totem"
//               AbsorbPointer(
//               absorbing: isProcessing,
//                 child: Expanded(
//                   child: SizedBox(
//                     height: 60,
//                     child: ElevatedButton.icon(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: themeController.secondary,
//                         foregroundColor: themeController.onSecondary,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(16),
//                         ),
//                       ),
//                       // onPressed: () {
//                       //   Navigator.push(
//                       //     context,
//                       //     MaterialPageRoute(builder: (_) => LayoutWeight()),
//                       //   );
//                       // },
//                       onPressed: () {
//                         Navigator.pushNamed(context, '/');
//                       },
//                       icon: Icon(Icons.door_back_door),
//                       label: Text(
//                         "Sair do totem",
//                         style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),

//               SizedBox(width: 16), // Espaço entre os botões

//               // Botão "Mudar tema do totem"
//               AbsorbPointer(
//               absorbing: isProcessing,
//                 child: Expanded(
//                   child: SizedBox(
//                     height: 60,
//                     child: ElevatedButton.icon(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: themeController.primary,
//                         foregroundColor: themeController.onPrimary,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(16),
//                         ),
//                       ),
//                       onPressed: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(builder: (_) => TemaTotem()
//                           ),
//                         );
//                       },
                
//                       icon: Icon(Icons.color_lens),
//                       label: Text(
//                         "Mudar tema do totem",
//                         style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
             
//              SizedBox(width: 16),

//               // Botão "Vizualizar lista de produtos"
//               AbsorbPointer(
//               absorbing: isProcessing,
//                 child: Expanded(
//                   child: SizedBox(
//                     height: 60,
//                     child: ElevatedButton.icon(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: themeController.secondary,
//                         foregroundColor: themeController.onSecondary,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(16),
//                         ),
//                       ),
//                       onPressed: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(builder: (_) => 
//                           ProdutosRegistradosLayout()
//                           ),
//                         );
//                       },
                
//                       icon: Icon(Icons.save),
//                       label: Text(
//                         "Lista de produtos",
//                         style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),

//               SizedBox(width: 16), // Espaço entre os botões
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
