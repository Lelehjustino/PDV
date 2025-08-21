import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nubi_pdv/src/controllers/global_controller.dart';
import 'package:nubi_pdv/src/controllers/layout_totem_controller.dart';
import 'package:nubi_pdv/src/controllers/pedido.controller.dart';
import 'package:nubi_pdv/src/controllers/theme_controller.dart';
import 'package:nubi_pdv/src/models/pedido_model.dart';
import 'package:nubi_pdv/src/models/products_model.dart';
import 'package:nubi_pdv/src/views/carrinho_layout.dart';
import 'package:nubi_pdv/src/views/pedido_page.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';

class ApresentacaoProdutoPage extends StatefulWidget {
  final Product productSelected;
  const ApresentacaoProdutoPage(this.productSelected, {super.key});

  @override
  State<ApresentacaoProdutoPage> createState() =>
      ApresentacaoProdutoPageState();
}

class ApresentacaoProdutoPageState extends State<ApresentacaoProdutoPage> {
  // Classe que controla o comportamento da tela
  // final controller = LayoutTotemController();
  final controller = GlobalController.instance.LayoutTotemcontroller;
  late Product produto;
  int quantidade = 1;
  late PedidoController pedidoController;

  // LISTA DE OBSERVAÇÕES
  List<Observacao> observacoesSelecionadas = [];
  final List<Map<String, dynamic>> observacoesDisponiveis = [
    // Lista das opções de observação
    {'id': 1, 'nome': 'Observação 1'},
    {'id': 2, 'nome': 'Observação 2'},
    {'id': 3, 'nome': 'Observação 3'},
  ];

  // LISTA DE ADICIONAIS
  List<Adicional> adicionaisSelecionados = [];
  final List<Adicional> adicionaisDisponiveis = [
    Adicional(nome: 'Adicional 1', valor: 2.5, quantidade: 0),
    Adicional(nome: 'Adicional 2', valor: 3.5, quantidade: 0),
    Adicional(nome: 'Adicional 3', valor: 1, quantidade: 0),
  ];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await windowManager.setFullScreen(true);
    });

    Future.microtask(() {
      pedidoController = Provider.of<PedidoController>(context, listen: false);
    }); // Pega o controlador de pedidos para depois adicionar itens ao carrinho.

    produto = widget.productSelected; // Copia o produto passado para a variável produto para facilitar o uso.
  }

  // Função para adicinar o valor dos adicionais ao valor total do produto
  double get totalAdicionais {
    return adicionaisDisponiveis.fold(
      0.0,
      (soma, adicional) => soma + (adicional.valor * adicional.quantidade),
    );
  }

  void addOneCounter() {
    // Quando o usuário clica no botão "+", aumenta a quantidade e atualiza a tela
    setState(() {
      quantidade++;
    });
  }

  void removeOneCounter() {
    // Quando clica em "-", diminui até no mínimo 1.
    if (quantidade > 1) {
      // Diminui até 1
      setState(() {
        quantidade--;
      });
    }
  }

  void criarItem(BuildContext context) {
    // Essa função cria um item para o carrinho

    for (var i = 0; i < adicionaisDisponiveis.length; i++) {
      if (adicionaisDisponiveis[i].quantidade > 0) {
        adicionaisSelecionados.add(adicionaisDisponiveis[i]);
      }
    }

    final item = Item(
      id: 0,
      product: widget.productSelected,
      unitPrice: widget.productSelected.valor + totalAdicionais,
      totalPrice: widget.productSelected.valor + totalAdicionais * quantidade,
      quantidade: quantidade,
      adicionais: adicionaisSelecionados,
      observacoes: observacoesSelecionadas,
    );

    pedidoController.addItemTotem(item); // Adiciona o item no carrinho

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final themeController = context.watch<ThemeController>(); // Escuta mudanças nas cores
    bool isProcessing = false;

    return Scaffold(
      backgroundColor: themeController.onTertiary,
      // AppBar
      appBar: AppBar(
        backgroundColor: themeController.onTertiary,
        elevation: 0, // remove a sombra
        automaticallyImplyLeading: true, // remove botão de voltar, se necessário
        // Text de conferir o pedido
        // title: Text(
        //   widget.productSelected.nome,
        //   style: TextStyle(
        //     color: Colors.black87,
        //     fontSize: 22,
        //     fontWeight: FontWeight.w400,
        //   ),
        // ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Imagem do produto
              Expanded(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  color: themeController.tertiary,
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(20.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: SizedBox(
                            height: 200,
                            child: AspectRatio(
                              aspectRatio: 4 / 3,
                              child: Image.asset(
                                'assets/images/produto.png',
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Nome do produto
                      Center(
                        child: Text(
                          widget.productSelected.nome,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w300,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: 4),

                      // Adicionais
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 150.0, vertical: 10),
                        child: Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center, // Centraliza horizontalmente dentro da Column
                            children: [
                              Text(
                                'Adicionais',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 8),
                              ...adicionaisDisponiveis.map((adicional) {
                                final formatador = NumberFormat.currency(
                                    locale: 'pt_BR', symbol: 'R\$');
                                return Padding(
                                  padding:
                                      EdgeInsets.symmetric(vertical: 4.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          '${adicional.nome} (${formatador.format(adicional.valor)})',
                                          style: TextStyle(fontSize: 14),
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          _buildIconButton(Icons.remove, () {
                                            setState(() {
                                              if (adicional.quantidade > 0) {
                                                adicional.quantidade--;
                                              }
                                            });
                                          }),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            child:
                                                Text('${adicional.quantidade}'),
                                          ),
                                          _buildIconButton(Icons.add, () {
                                            setState(() {
                                              adicional.quantidade++;
                                            });
                                          }),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              }),
                            ],
                          ),
                        ),
                      ),

                      // Observações
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 150.0, vertical: 10),
                        child: Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Observações',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 8),
                              ...observacoesDisponiveis.map((observacao) {
                                final id = observacao['id'] as int;
                                final nome = observacao['nome'] as String;
                                // Verifica se a observação com o ID atual já está na lista de selecionadas
                                final isSelecionado = observacoesSelecionadas
                                    .any((obs) => obs.id == id);

                                return Padding(
                                  padding:
                                      EdgeInsets.symmetric(vertical: 4.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          nome,
                                          style: TextStyle(fontSize: 14),
                                        ),
                                      ),
                                      Checkbox(
                                        value: isSelecionado, 
                                        onChanged: (bool? valor) {
                                          setState(() {
                                            if (valor == true) {
                                              // Adiciona a observação completa se ela for marcada
                                              observacoesSelecionadas.add(
                                                  Observacao(id: id, nome: nome));
                                            } else {
                                              // Remove a observação completa se ela for desmarcada
                                              observacoesSelecionadas.removeWhere(
                                                      (obs) => obs.id == id);
                                            }
                                          });
                                        },
                                        activeColor:themeController.primary,
                                        checkColor: themeController.onPrimary,
                                      ),
                                    ],
                                  ),
                                );
                              }),
                            ],
                          ),
                        ),
                      ),

                      // Controlador da quantidade
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildIconButton(Icons.remove, removeOneCounter),
                          Padding(
                            padding:
                                EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text('$quantidade',
                                style: TextStyle(fontSize: 20)),
                          ),
                          _buildIconButton(Icons.add, addOneCounter),
                        ],
                      ),
                      SizedBox(height: 16),

                      // Preço do produto
                      Text(
                        'R\$ ${(produto.valor * quantidade + totalAdicionais * quantidade).toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      SizedBox(height: 15),

                      // Botão 'Adicionar ao carrinho'
                      AbsorbPointer(
                      absorbing: isProcessing,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 150.0, vertical: 5),
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: themeController.primary,
                                padding: EdgeInsets.symmetric(vertical: 30),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              onPressed: () {
                                criarItem(context);
                              },
                              child: Text(
                                'Adicionar ao carrinho',
                                style: TextStyle(color: themeController.onPrimary, fontSize: 16),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 25,),
                      
                      // Botão de voltar ao menu
                      AbsorbPointer(
                      absorbing: isProcessing,
                        child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 150.0, vertical: 5),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:themeController.secondary,
                              padding: EdgeInsets.symmetric(vertical: 30),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                             onPressed: () { Navigator.pop(context); },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.arrow_back, color: themeController.onSecondary,),
                                SizedBox(width: 8), // espaço entre ícone e texto
                                Text(
                                  'Voltar ao menu',
                                  style: TextStyle(color: themeController.onSecondary, fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        ),
                                            ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

  // Widget do icone das observações
  Widget _buildIconButton(IconData icon, VoidCallback onPressed) {
    final themeController = context.watch<ThemeController>(); // Escuta mudanças nas cores
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: themeController.surface),
        borderRadius: BorderRadius.circular(8),
        color: themeController.surface,
      ),
      child: IconButton(
        icon: Icon(icon, size: 20),
        onPressed: onPressed,
      ),
    );
  }
}
