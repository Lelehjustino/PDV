// import 'package:flutter/material.dart';
// import 'package:nubi_pdv/repositories/conta_repository.dart';
// import 'package:nubi_pdv/src/controllers/global_controller.dart';
// import 'package:nubi_pdv/src/controllers/pedido.controller.dart';
// import 'package:nubi_pdv/src/controllers/theme_controller.dart';
// import 'package:nubi_pdv/src/models/products_model.dart';
// import 'package:provider/provider.dart';

// class ConfiguracoesLayout extends StatefulWidget {
//   const ConfiguracoesLayout({super.key});

//   @override
//   State<ConfiguracoesLayout> createState() => _ConfiguracoesLayoutState();
// }

// class _ConfiguracoesLayoutState extends State<ConfiguracoesLayout> {
//   final controller = GlobalController.instance.LayoutTotemcontroller;
//   @override
//   Widget build(BuildContext context) {

//     final pedidoController = Provider.of<PedidoController>(context, listen: true);
//     final conta = context.watch<ContaRepository>();
//     final themeController = context.read<ThemeController>();

//     return Scaffold(
//       backgroundColor: themeController.onTertiary,
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         automaticallyImplyLeading: true, // botão de voltar

//         // Text de Configurações
//         title: Text(
//           'Configurações ',
//           style: TextStyle(
//             color: themeController.onSecondary,
//             fontSize: 22,
//             fontWeight: FontWeight.w400,
//           ),
//         ),
//         centerTitle: true,
//       ),
//       body: Padding(padding: EdgeInsets.all(12),
//         child: Column(
//           children: [
//              ElevatedButton(
//               onPressed: () {
//                 final contaRepository = context.read<ContaRepository>();

//                 // Exemplo: pegar o primeiro produto da lista
//                 if (contaRepository.produtos.isNotEmpty) {
//                   final produto = contaRepository.produtos.first;

//                   // Criar uma cópia do produto com os campos que quer mudar
//                   final produtoAtualizado = Product(
//                     numero: produto.numero, 
//                     nome: produto.nome ,
//                     valor: produto.valor, 
//                     unidade: produto.unidade,
//                     grupo: produto.grupo,
//                     type: produto.type,
//                     diversidadesabores: produto.diversidadesabores,
//                     numeroTamanhoPizza_FK: produto.numeroTamanhoPizza_FK,
//                   );

//                   contaRepository.updateProduto(produtoAtualizado);
//                 }
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: themeController.primary,
//                 padding: EdgeInsets.symmetric(horizontal: 60, vertical: 30),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(16),
//                 ),
//                 elevation: 5,
//               ),
//               child: Text(
//                 'Faça seu pedido',
//                 style: TextStyle(
//                   fontSize: 36,
//                   color: themeController.onPrimary,
//                   fontWeight: FontWeight.w200,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     ); 
//   }
// }