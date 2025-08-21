import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:nubi_pdv/src/controllers/global_controller.dart';
import 'package:nubi_pdv/src/controllers/layout_totem_controller.dart';
import 'package:nubi_pdv/src/controllers/pedido.controller.dart';
import 'package:nubi_pdv/src/controllers/theme_controller.dart';
import 'package:nubi_pdv/src/models/pedido_model.dart';
import 'package:nubi_pdv/src/models/products_model.dart';
import 'package:nubi_pdv/src/views/pagamento_layout.dart';
import 'package:nubi_pdv/src/views/pedido_page.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';

class CarrinhoLayout extends StatefulWidget {
  const CarrinhoLayout({super.key});

  @override
  State<CarrinhoLayout> createState() {
    return CarrinhoLayoutState();
  }
}

class CarrinhoLayoutState extends State<CarrinhoLayout> {
  final controller = GlobalController.instance.LayoutTotemcontroller;
 
  @override
  void initState() {
    super.initState();
    controller.notifier.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    // Instância de PedidoController do Provider
    final pedidoController = Provider.of<PedidoController>(context, listen: true); //esta variável pega o PedidoController (que é compartilhado por meio de provider) e coloca no contexto dessa tela 
    // final themeController = context.watch<ThemeController>(); // Escuta mudanças nas cores
    final themeController = context.read<ThemeController>();
    bool isProcessing = false;

    return Scaffold(
      backgroundColor: themeController.onTertiary,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: true, // botão de voltar

        // Text de conferir o pedido
        title: Text(
          'Seu carrinho ',
          style: TextStyle(
            color: themeController.onSecondary,
            fontSize: 22,
            fontWeight: FontWeight.w400,
          ),
        ),
        centerTitle: true,
      ),

      // Aqui cria a coluna principal do corpo da tela
      body: Column(
        children: [
          // Se houver um pedido atual, exibe a lista de produtos e o botão "Adicionar mais itens"
          if (pedidoController.pedidoAtual != null)
            Expanded( // Expanded permite que o SingleChildScrollView ocupe o espaço disponível
              child: SingleChildScrollView( // Permite que o conteúdo interno seja rolado
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Column( // Coluna que contém os itens do pedido e o novo botão
                  children: [
                    // Gera os widgets para cada item do pedido
                    ...List.generate(
                      pedidoController.pedidoAtual!.itens.length, // pega os itens e coloca dentro de uma lista
                      (index) {
                        final item = pedidoController.pedidoAtual!.itens[index];
                        final nomeCompleto = item.product.nome;
                        final partes = nomeCompleto.split('\n');
                        final nomePizza = partes.first;
                        final detalhesSabores = partes.length > 1 ? partes.sublist(1).join('\n') : '';
                        return Container(
                          
                          // Estilização dos itens da lista
                          margin: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: themeController.surface,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: themeController.tertiary,
                                blurRadius: 8,
                                offset: Offset(0, 4),
                              )
                            ],
                          ),
                          padding: EdgeInsets.all(16),
                          child: Row(
                            children: [
                              // Expanded para o nome e subtotal do produto
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Apresenta a quantidade de itens selecionados do produto x o nome do produto
                                    Text.rich(
                                      TextSpan(
                                        children: [
                                          // Quantidade da pizza / produto 
                                          TextSpan(
                                            text: '${pedidoController.pedidoAtual!.itens[index].quantidade} x ',
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w500,
                                              color: themeController.onSurface,
                                            ),
                                          ),
                                          // Nome produto / tamanho pizza
                                          TextSpan(
                                            text: nomePizza,
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: themeController.onSurface,
                                            ),
                                          ),
                                          // Se for pizza, apresenta os sabores
                                          if (detalhesSabores.isNotEmpty)
                                            TextSpan(
                                              text: '\n$detalhesSabores',
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.normal,
                                                color: themeController.onSurface,
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                   SizedBox(height: 4),
                                    // Adicionais selecionados 
                                    ...pedidoController.pedidoAtual!.itens[index].adicionais.map((adicional) {
                                      final formatador = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
                                      return Text(
                                       '${adicional.quantidade.toString()}x ${adicional.nome.toString()} (${formatador.format(adicional.valor)})',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                          color: themeController.onSurface,
                                        ),
                                      );
                                    }),
                                    
                                    // Observações selecionadas 
                                    ...pedidoController.pedidoAtual!.itens[index].observacoes.map((Observacao) {
                                      return Text(
                                       Observacao.nome.toString(),
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: themeController.onSurface,
                                        ),
                                      );
                                    }),

                                   SizedBox(height: 4),
                                    // Subtotal deste item
                                    Text(
                                      'R\$ ${pedidoController.pedidoAtual!.itens[index].totalPrice.toStringAsFixed(2)}',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: themeController.onSurface,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Container para os botões de adicionar/remover quantidade
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: themeController.tertiary),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: [
                                    // Icone para remover
                                    IconButton(
                                      icon: Icon(Icons.remove, size: 18),
                                      onPressed: () {
                                        final item = pedidoController.pedidoAtual!.itens[index];
                                        if (item.quantidade == 1) {
                                          pedidoController.showCustomDialog(
                                            context: context,
                                            icon: Icons.delete_outline, // Icone
                                            message: 'Deseja remover este produto do seu carrinho?:\n${pedidoController.pedidoAtual!.itens[index].product.nome}',
                                            cancelText: 'Cancelar', // texto de cancelar ação 
                                            confirmText: 'Remover', // texto de prosseguir ação 
                                            onConfirm: () { // quando clicar em 'Remover' 
                                              pedidoController.removeOneCounter(item);
                                              pedidoController.removeItemPizzaTotem(item);
                                              if (pedidoController.pedidoAtual!.itens.isEmpty) {
                                               Navigator.push(
                                                context,
                                                MaterialPageRoute(builder: (_) => PedidoPage()),
                                              ); // volta para o menu
                                              }
                                            }, onCancel: () { 
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(builder: (_) => CarrinhoLayout()),
                                              );
                                             }, 
                                            themeController: themeController,
                                          );
                                        } else {
                                          // Apenas reduz a quantidade
                                          // pedidoController.removeOneCounter(item); 
                                          pedidoController.removeItemPizzaTotem(item);
                                        }
                                      },
                                    ),
                                    // Mostra a quantidade de produtos selecionados
                                    Text(
                                      '${pedidoController.pedidoAtual!.itens[index].quantidade}',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    // Icone para acrescentar
                                    IconButton(
                                      icon: Icon(Icons.add, size: 18),
                                      onPressed: () {
                                        final item = pedidoController.pedidoAtual!.itens[index];
                                        pedidoController.addOneCounter(item);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ), 

                    // O botão "Adicionar mais itens"
                    AbsorbPointer(
                    absorbing: isProcessing,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8), // Pequeno padding para separar do último item
                        child: SizedBox(
                          height: 60,
                          width: double.infinity,
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
                                MaterialPageRoute(builder: (_) => PedidoPage()),
                              );
                            },
                            label: Text(
                              "Adicionar mais itens",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            icon: Icon(Icons.add),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 30,),
                    // Textos de subtotal e total 
                    if (pedidoController.pedidoAtual != null)
                      Center(
                        child: Text(
                          'Subtotal: R\$ ${pedidoController.pedidoAtual!.subtotal.toStringAsFixed(2)}', //mostra subtotal
                          style: TextStyle(fontSize: 25, fontWeight: FontWeight.w400),
                        ),
                      ),
                    SizedBox(height: 10),
                    if (pedidoController.pedidoAtual != null)
                      Center(
                        child: Text(
                          'Total: R\$ ${pedidoController.pedidoAtual!.totalPrice.toStringAsFixed(2)}', //mostra o total
                          style: TextStyle(fontSize: 25, fontWeight: FontWeight.w400),
                        ),
                      ),

                    SizedBox(height: 20),
                    // Botão "Ir para pagamento" 
                    AbsorbPointer(
                    absorbing: isProcessing,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
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
                                      MaterialPageRoute(builder: (_) => PagamentoLayout()),
                                    );
                                  },
                                  icon: Icon(Icons.payment),
                                  label: Text(
                                    "Ir para pagamento",
                                    style: TextStyle(
                                      fontSize: 18, // Ajuste o tamanho
                                      fontWeight: FontWeight.w600, // peso da fonte
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}