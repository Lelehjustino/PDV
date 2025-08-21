import 'package:flutter/material.dart';
import 'package:nubi_pdv/src/controllers/pedido.controller.dart';
import 'package:nubi_pdv/src/widgets/button.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class SideBar extends StatefulWidget {
  
  const SideBar({super.key, required this.weightAgain});

  final VoidCallback weightAgain;

  @override
  State<SideBar> createState() {
    return SideBarState();
  }
}

class SideBarState extends State<SideBar> {
  @override
  Widget build(BuildContext context) {
    var pedidoController = Provider.of<PedidoController>(context);

    String formattedTotalPrice = NumberFormat.currency(
      locale: 'pt_BR',
      symbol: 'R\$',
      decimalDigits: 2,
    ).format(pedidoController.pedidoAtual?.totalPrice ?? 0.00);

    if (pedidoController.pedidoAtual == null) {
      return Container(
        width: 500,
        height: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: SizedBox.expand(
          child: Column(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(10),
                  height: double.infinity,
                  decoration: BoxDecoration(),
                  child: Center(
                    child: Text("Nenhum item no pedido"),
                  ), 
                ),
              ),
              Container(
                decoration: BoxDecoration(),
                child: Column(
                  children: [
                    Container(
                      height: 60,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(color: Color(0xFF006a71)),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            formattedTotalPrice,
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 26)
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Row(
                        children: [
                          Button(
                            width: 50,
                            height: 50,
                          )
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ));
    }
    
    return Container(
        height: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: SizedBox.expand(
          child: Column(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(10),
                  height: double.infinity,
                  decoration: BoxDecoration(
                    
                  ),
                  // child: Column(
                  //   children: [
                  //     // Flex(
                  //     //   direction: Axis.horizontal,
                  //     //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //     //   children: [
                  //     //     Flex(
                  //     //       direction: Axis.horizontal,
                  //     //       children: [
                  //     //         Container(
                  //     //           width: 50,
                  //     //           child: Text('QTDE', style: TextStyle(fontWeight: FontWeight.bold))
                  //     //         ),
                  //     //         Text('PRODUTO', style: TextStyle(fontWeight: FontWeight.bold)),
                  //     //       ],
                  //     //     ),

                  //     //     Text('VALOR', style: TextStyle(fontWeight: FontWeight.bold)),
                  //     //   ],
                  //     // ),
                  //     SizedBox(height: 10),

                  //     Column(
                  //       children: List.generate(pedidoController.pedidoAtual!.itens.length, (index) {
                  //           String formattedPrice = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$', decimalDigits: 2)
                  //           .format(pedidoController.pedidoAtual!.itens[index].valor);

                  //           String formattedTotalPrice = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$', decimalDigits: 2)
                  //           .format(pedidoController.pedidoAtual!.itens[index].totalItem);

                  //           String pesoFormatado = pedidoController.pedidoAtual!.itens[index].quantidade.toStringAsFixed(3);

                  //           return Column(
                  //             children: [
                  //               Row(
                  //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //                 crossAxisAlignment: CrossAxisAlignment.center,
                  //                 children: [

                  //                   Row(
                  //                     children: [

                  //                       SizedBox(
                  //                         width: 60,
                  //                         child:Visibility(
                  //                           visible: pedidoController.pedidoAtual!.itens[index].unidade == 1,
                  //                           child: Image.asset(
                  //                             'assets/CocaCola.png',
                  //                             width: double.infinity,
                  //                             fit: BoxFit.contain,
                  //                           )
                  //                         )
                  //                       ),
                  //                       Column(
                  //                         mainAxisAlignment: MainAxisAlignment.start,
                  //                         crossAxisAlignment: CrossAxisAlignment.start,
                  //                         children: [
                  //                           Text(
                  //                             "${pedidoController.pedidoAtual!.itens[index].nome}",
                  //                             style: TextStyle(
                  //                               fontWeight: FontWeight.w500
                  //                             ),
                  //                           ),
                  //                           Text(
                  //                             "${formattedPrice}",
                  //                             style: TextStyle(
                  //                               fontWeight: FontWeight.w400,
                  //                               color: Theme.of(context).primaryColor
                  //                             ),
                  //                           )
                  //                         ],
                  //                       ),
                  //                     ],
                  //                   ),


                  //                   Flex(
                  //                     direction: Axis.horizontal,
                  //                     mainAxisAlignment: MainAxisAlignment.center,
                  //                     children: [
                  //                       Container(
                  //                         width: 90,
                  //                         child: Flex(
                  //                           direction: Axis.horizontal,
                  //                           children: [
                  //                             if(pedidoController.pedidoAtual!.itens[index].unidade == 1)
                  //                             Counter(item: pedidoController.pedidoAtual!.itens[index]),

                  //                             if(pedidoController.pedidoAtual!.itens[index].unidade == 2)
                  //                             Text(
                  //                               "${pesoFormatado} Kg",
                  //                               style: TextStyle(
                  //                                 fontWeight: FontWeight.w500,
                  //                                 fontSize: 15
                  //                               )
                  //                             ),
                  //                           ],

                  //                         ),
                  //                       ),
                  //                       Text(
                  //                         formattedTotalPrice,
                  //                         style: TextStyle(
                  //                           fontWeight: FontWeight.w500,
                  //                           fontSize: 15,
                  //                           color: Theme.of(context).primaryColor
                  //                         ),
                  //                       ),

                  //                     ],
                  //                   ),
                  //                 ],
                  //               ),
                  //               SizedBox(height: 5),
                  //             ],
                  //           );
                  //       }),
                  //     ),


                  //   ],
                  // ) 
                ),
              ),
              Container(
                decoration: BoxDecoration(),
                child: Column(
                  children: [
                    Container(
                      height: 60,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(color: Theme.of(context).primaryColor),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Total (R\$):",
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 26)
                          ),
                          Text(
                            formattedTotalPrice,
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 26)
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: SizedBox(
                        width: double.infinity,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: (){
                                  widget.weightAgain();
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Theme.of(context).primaryColor, width: 2),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    'Pesar novamente',
                                    style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22
                                    ),
                                  ),
                                )
                              ),
                            ),

                            SizedBox(width: 10),
                            Expanded(
                              child: InkWell(
                                onTap: (){
                                  pedidoController.finalizarPedido();
                                },
                                child:Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Theme.of(context).primaryColor, width: 2),
                                    color: Theme.of(context).primaryColor,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    'Finalizar Pedido',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22
                                    ),
                                  ),
                                )
                              )
                            )

                        ],
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
