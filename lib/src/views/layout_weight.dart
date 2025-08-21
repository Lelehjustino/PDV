import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nubi_pdv/src/controllers/layout_weight_controller.dart';
import 'package:nubi_pdv/src/controllers/pedido.controller.dart';
import 'package:nubi_pdv/src/models/pedido_model.dart';
import 'package:nubi_pdv/src/models/products_model.dart';
import 'package:nubi_pdv/src/views/products_page.dart';
import 'package:nubi_pdv/src/views/side_bar.dart';
import 'package:nubi_pdv/src/widgets/side_nav.dart';
import 'package:provider/provider.dart';

class LayoutWeight extends StatefulWidget {
  const LayoutWeight({super.key});

  @override
  State<LayoutWeight> createState() {
    return LayoutWeightState();
  }
}

class LayoutWeightState extends State<LayoutWeight> {
  late LayoutWeightController controller;
  Map<int, Color> itemColors = {};

  List<Product> listProducts = [
    Product( nome: "Produto 1", numero: 1, valor: 5.00, unidade: 1, grupo: 0, type: '', diversidadesabores: 0, numeroTamanhoPizza_FK: 0),
    Product( nome: "Produto 2", numero: 2, valor: 10.00, unidade: 1, grupo: 0, type: '', diversidadesabores: 0, numeroTamanhoPizza_FK: 0),
    Product( nome: "Produto 3", numero: 3, valor: 15.00, unidade: 1, grupo: 0, type: '', diversidadesabores: 0, numeroTamanhoPizza_FK: 0),
    Product( nome: "Produto 4", numero: 4, valor: 20.00, unidade: 1, grupo: 0, type: '', diversidadesabores: 0, numeroTamanhoPizza_FK: 0)
  ];

  @override
  void initState() {
    super.initState();
    controller = LayoutWeightController();
    controller.stepNotifier.addListener(() { setState(() {}); });
    controller.layoutNotifier.addListener(() { setState(() {}); });
    controller.errorNotifier.addListener(() { setState(() {}); });
    loadProducts();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  //Carrega os Produtos
  void loadProducts() async {
    // listProducts = await controller.getProducts();
    setState(() {});
  }



  @override
  Widget build(BuildContext context) { 
    final pedidoController = Provider.of<PedidoController>(context, listen: false);
    controller.setPedidoController(pedidoController);
    
    Item? productKg = pedidoController.pedidoAtual?.itens.firstWhereOrNull(
      (product) => product.id == 17,
    );

    String pesoFormatado = productKg != null 
    ? productKg.quantidade.toStringAsFixed(3) 
    : '0.000';

    return Scaffold(
      drawer: SideNav(),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56),
        child: SizedBox(
          width: 100,
          child: AppBar(
            iconTheme: IconThemeData(
              color: Colors.white,
            ),
            title: controller.layout == 2 ? Text('Comanda 3', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)): null,
            backgroundColor: Theme.of(context).primaryColor,
          ),
        )
      ),
      backgroundColor: Theme.of(context).primaryColor,
      body: SizedBox.expand(
        child: Column(
          children: [
          // ====================== Layout 1 ====================
            if(controller.layout == 1)
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  //Step 1 Insira sua comanda
                  Visibility(
                    visible: controller.step == 1,

                    child: Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset('assets/FiguraCard.png'),
                              ]
                          ),
                          InkWell(
                            onTap: () {
                              controller.cardSelected();
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.greenAccent
                              ),
                              child: Text('Avance'),
                            )
                          ) 
                        ],
                      )
                    )
                  ),

                  //Step 2 Insira seu prato
                  Visibility(
                    visible: controller.step == 2,
                    child: Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset('assets/FiguraPrato.png'),
                                Image.asset('assets/FiguraSeta.gif'),
                                Image.asset('assets/FiguraBalanca.png')
                              ]),
                        ],
                      )
                    )
                  ),

                  //Step 3 Estabilizando peso
                  Visibility(
                    visible: controller.step == 3,
                    child: Column(
                      children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                  'assets/FiguraGifBalancaamarelo.gif'),
                            ]),
                      ],
                    )
                  ),

                  //Step 4 Pesagem concluida
                  Visibility(
                      visible: controller.step == 4,
                      child: Column(
                        children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                    'assets/FiguraGifComprovanteBranco.gif'),
                              ]),
                          SizedBox(height: 50),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [

                              if(pedidoController.pedidoAtual?.itens != null && pedidoController.pedidoAtual!.itens.isNotEmpty)
                              Container(
                                width: 200,
                                height: 50,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(25)
                                ),
                                child: Center(
                                    child: Text("${pesoFormatado.toString()} Kg",
                                      style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold
                                      )
                                    )
                                ),
                              ),
                              SizedBox(width: 30),

                              if(pedidoController.pedidoAtual?.itens != null && pedidoController.pedidoAtual!.itens.isNotEmpty)
                              Container(
                                width: 200,
                                height: 50,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(25)),
                                // child: Center(
                                //     child: Text(
                                //       NumberFormat.currency(
                                //         locale: 'pt_BR', 
                                //         symbol: 'R\$',
                                //         decimalDigits: 2,
                                //       ).format(productKg != null ? productKg.valor : 0),

                                //       style: TextStyle(
                                //           fontSize: 25,
                                //           fontWeight: FontWeight.bold
                                //       )
                                //     )
                                // ),
                              ),
                            ],
                          ),
                        ],
                      )
                  ),

                ],
              ),
            ),

            if(controller.layout == 1)
            //Passo a passo Circulos
            Visibility(
              child: Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    //Step 1
                    Visibility(
                      visible: controller.step == 1,
                      child: Text('1. Insira sua comanda',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 35,
                          fontWeight: FontWeight.bold
                        )
                      )
                    ),

                    //Step 2
                    Visibility(
                      visible: controller.step == 2,
                      child: Text('2. Coloque seu prato na balança.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 35,
                          fontWeight: FontWeight.bold
                        )
                      )
                    ),

                    //Step 3
                    Visibility(
                      visible: controller.step == 3,
                      child: Text('3. Aguarde... Estabilizando peso...',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 35,
                          fontWeight: FontWeight.bold
                        )
                      )
                    ),

                    //Step 4
                    Visibility(
                      visible: controller.step == 4,
                      child: Text('4. Pesagem concluida, aguarde...',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 35,
                          fontWeight: FontWeight.bold
                        )
                      )
                    ),

                    SizedBox(height: 40),

                    //Circulos dos passos
                    Container(
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          //Step 1
                          Row(
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    color: Colors.green),
                                child: Text(
                                  '1',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Container(
                                width: 25,
                                height: 5,
                                decoration: BoxDecoration(color: Colors.green),
                              )
                            ],
                          ),
                          //Step 2
                          Row(
                            children: [
                              Container(
                                width: 25,
                                height: 5,
                                decoration: BoxDecoration(
                                    color: controller.step == 2 || controller.step == 3 || controller.step == 4
                                        ? Colors.green
                                        : Colors.grey),
                              ),
                              Container(
                                width: 50,
                                height: 50,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    color: controller.step == 2 || controller.step == 3 || controller.step == 4
                                        ? Colors.green
                                        : Colors.grey),
                                child: Text(
                                  '2',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Container(
                                width: 25,
                                height: 5,
                                decoration: BoxDecoration(
                                    color: controller.step == 2 || controller.step == 3 || controller.step == 4
                                        ? Colors.green
                                        : Colors.grey
                                ),
                              )
                            ],
                          ),
                          //Step 3
                          Row(
                            children: [
                              Container(
                                width: 25,
                                height: 5,
                                decoration: BoxDecoration(
                                    color:
                                        controller.step == 3 || controller.step == 4 ? Colors.green : Colors.grey),
                              ),
                              Container(
                                width: 50,
                                height: 50,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    color:
                                        controller.step == 3 || controller.step == 4 ? Colors.green : Colors.grey),
                                child: Text(
                                  '3',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Container(
                                width: 25,
                                height: 5,
                                decoration: BoxDecoration(
                                    color: controller.step == 3 || controller.step == 4
                                        ? Colors.green
                                        : Colors.grey
                                ),
                              )
                            ],
                          ),
                          //Step 4
                          Row(
                            children: [
                              Container(
                                width: 25,
                                height: 5,
                                decoration: BoxDecoration(
                                    color:
                                        controller.step == 4 ? Colors.green : Colors.grey),
                              ),
                              Container(
                                width: 50,
                                height: 50,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: controller.step == 4 ? Colors.green : Colors.grey
                                ),
                                child: Text(
                                  '4',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            //Erro na leitura
            Visibility(
              visible: controller.err == true,
              child: (
                Container(
                  child: Text(
                    'Erro na leitura da balança',
                    style: TextStyle(color: Colors.red)
                  )
                )
              )
            ),

          // ====================== Layout 2 ====================
            if(controller.layout == 2)
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {

                    bool isMobile = constraints.maxWidth < 800;

                    return Flex(
                      direction: isMobile ? Axis.vertical : Axis.horizontal,
                      children: [
                        Expanded(
                          child: ProductsPage()
                        ),
                        ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: isMobile ? double.infinity : 500,
                            maxHeight: isMobile ? 300 : double.infinity,
                            minWidth: isMobile ? double.infinity : 400
                          ),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.4,
                            child: SideBar(weightAgain: controller.weightAgain),
                          ) ,
                        ),
                      ],
                    );
                  }
                ) 
              ),
          ],
        ),
      ),
    );
  }
}
