import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:nubi_pdv/src/controllers/global_controller.dart';
import 'package:nubi_pdv/src/controllers/layout_totem_controller.dart';
import 'package:nubi_pdv/src/controllers/pedido.controller.dart';
import 'package:nubi_pdv/src/controllers/theme_controller.dart';
import 'package:nubi_pdv/src/models/pedido_model.dart';
import 'package:nubi_pdv/src/models/products_model.dart';
import 'package:nubi_pdv/src/views/carrinho_layout.dart';
import 'package:nubi_pdv/src/views/layout_apresentacao_produto.dart';
import 'package:nubi_pdv/src/views/layout_pizza.dart';
import 'package:nubi_pdv/src/views/layout_totem.dart';
import 'package:provider/provider.dart';
import 'package:virtual_keyboard_2/virtual_keyboard_2.dart';
import 'package:window_manager/window_manager.dart';
import 'dart:math' as math;

class PedidoPage extends StatefulWidget {
  const PedidoPage({super.key});

  @override
  State<PedidoPage> createState() => PedidoPageState();
}

class PedidoPageState extends State<PedidoPage>
  with SingleTickerProviderStateMixin {
    
    final controller = GlobalController.instance.LayoutTotemcontroller;

    final FocusNode _searchFocusNode = FocusNode();
    final TextEditingController barraBusca = TextEditingController();

    final GlobalKey _keyboardKey = GlobalKey();

    bool _isKeyboardVisible = false;

    // Variáveis para animação no carrinho
    late AnimationController _shakeController;
    late Animation<double> _shakeAnimation;

    @override
    void initState() {
      super.initState();
      _searchFocusNode.addListener(() {
        if (_searchFocusNode.hasFocus) {
          setState(() {
            _isKeyboardVisible = true;
          });
        }
      });

      barraBusca.addListener(() {
        controller.filtrarProdutos(barraBusca.text);
      });

      controller.notifier.addListener(() {
        setState(() {});
      });

      // Animação e controller da animação 
      _shakeController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 500),
      )..repeat();

      _shakeAnimation = Tween<double>(begin: -2, end: 2).animate(
        CurvedAnimation(parent: _shakeController, curve: Curves.linear),
      );
    }

    @override
    void dispose() {
      _shakeController.dispose();
      barraBusca.dispose();
      _searchFocusNode.dispose();
      super.dispose();
    }

  @override
  Widget build(BuildContext context) {
    final pedidoController = Provider.of<PedidoController>(context, listen: true);
    final themeController = context.watch<ThemeController>(); // Escuta mudanças nas cores
    return Scaffold(
      backgroundColor: themeController.onTertiary,
      body: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(
          dragDevices: {
            PointerDeviceKind.touch,
            PointerDeviceKind.mouse,
          },
        ),
        child: Stack(
          children: [
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTapDown: (details) {
                final keyboardBox = _keyboardKey.currentContext
                    ?.findRenderObject() as RenderBox?;
                final Offset tapPosition = details.globalPosition;

                bool tappedKeyboard = false;

                if (keyboardBox != null) {
                  final keyboardRect =
                      keyboardBox.localToGlobal(Offset.zero) & keyboardBox.size;
                  if (keyboardRect.contains(tapPosition)) tappedKeyboard = true;
                }

                if (!tappedKeyboard) {
                  _searchFocusNode.unfocus();
                  setState(() {
                    _isKeyboardVisible = false;
                  });
                }
              },
              child: Row(
                children: [
                  // MENU LATERAL DE GRUPOS
                  Container(
                    padding: EdgeInsets.all(10),
                    width: MediaQuery.of(context).size.width * 0.20,
                    color: themeController.surface,
                    child: Column(
                      children: [
                        SizedBox(height: 20),
                        Expanded(
                          child: ListView.builder(
                            itemCount: controller.grupos.length,
                            itemBuilder: (context, index) {
                              final grupo = controller.grupos[index];
                              return InkWell(
                                onTap: () =>
                                    controller.selectedGroup(grupo.id, index),
                                child: Container(
                                  margin:
                                      EdgeInsets.symmetric(vertical: 10),
                                  padding: EdgeInsets.symmetric(
                                    horizontal:
                                        MediaQuery.of(context).size.width * 0.02,
                                    vertical:
                                        MediaQuery.of(context).size.height *0.02,
                                  ),
                                  decoration: BoxDecoration(
                                    color: controller.indexSelected == index
                                        ? themeController.primary
                                        : themeController.secondary,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Column(
                                    children: [
                                      Icon(grupo.icone,
                                          color: controller.indexSelected == index
                                                ? themeController.onPrimary
                                                : themeController.onSecondary),
                                      Text(
                                        grupo.name,
                                        style:TextStyle(
                                          fontSize: 10,
                                          color: controller.indexSelected == index
                                              ? themeController.onPrimary
                                              : themeController.onSecondary
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  // ÁREA DE PRODUTOS E CAMPO DE BUSCA
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.arrow_back),
                                onPressed: () {
                                  pedidoController.limparCarrinho();
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => LayoutTotem()),
                                  );
                                },
                              ),
                              // Campo de busca
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 16),
                                  decoration: BoxDecoration(
                                    color: themeController.tertiary,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: TextField(
                                    controller: barraBusca,
                                    focusNode: _searchFocusNode,
                                    readOnly: true,
                                    showCursor: true,
                                    onTap: () {
                                      FocusScope.of(context).requestFocus(_searchFocusNode);
                                    },
                                    decoration: InputDecoration(
                                      hintText: 'O que você quer hoje?',
                                      border: InputBorder.none,
                                      icon: Icon(Icons.search),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 20),
                              // Icone de sacola 
                              GestureDetector(
                                    onTap: (){Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (_) => CarrinhoLayout()),
                                    );},
                                    child: Stack(
                                      clipBehavior: Clip.none,
                                      children: [
                                        if (pedidoController.pedidoAtual != null &&
                                           pedidoController.pedidoAtual!.itens.isNotEmpty)
                                        AnimatedBuilder(
                                          animation: _shakeAnimation,
                                          builder: (context, child) {
                                            return Transform.translate(
                                              offset: Offset(
                                                math.sin(_shakeController.value * 2 * math.pi) * 2,
                                                0,
                                              ),
                                              child: child,
                                            );
                                          },
                                          child: CircleAvatar(
                                            backgroundColor: themeController.secondary,
                                            child: IconButton(
                                              icon: const Icon(Icons.shopping_cart_outlined),
                                               onPressed: () 
                                               {Navigator.push(
                                                context,
                                                MaterialPageRoute(builder: (_) => CarrinhoLayout()),
                                              );},
                                            ),
                                          ),
                                        ),

                                        if (pedidoController.pedidoAtual != null &&
                                           pedidoController.pedidoAtual!.itens.isNotEmpty)
                                          Positioned(
                                            right: -2,
                                            top: -2,
                                            child: AnimatedBuilder(
                                              animation: _shakeAnimation,
                                              builder: (context, child) {
                                                return Transform.translate(
                                                  offset: Offset(
                                                    math.sin(_shakeController.value * 2 * math.pi) * 2,
                                                    0,
                                                  ),
                                                  child: child,
                                                );
                                              },
                                              child: Container(
                                                padding: EdgeInsets.all(4),
                                                decoration: BoxDecoration(
                                                  color: themeController.onError,
                                                  shape: BoxShape.circle,
                                                ),
                                                constraints:BoxConstraints(
                                                  minWidth: 20,
                                                  minHeight: 20,
                                                ),
                                                child: Text(
                                                  '${pedidoController.pedidoAtual!.itens.length}',
                                                  style: TextStyle(
                                                    color: themeController.surface,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                       ),
                                    ),
                                  ],
                                ),
                        SizedBox(height: 20),
                        // BOTÃO IR PARA CARRINHO
                        if (!_isKeyboardVisible &&
                            pedidoController.pedidoAtual != null &&
                            pedidoController.pedidoAtual!.itens.isNotEmpty)
                          Container(
                            margin: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 0.0), // margem: esquerda, topo, direita, baixo
                            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 18), // mesmo padding interno
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: themeController.primary,
                              borderRadius: BorderRadius.circular(16), // opcional, se quiser suavizar
                            ),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => CarrinhoLayout()),
                                );
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Icon(Icons.shopping_cart, color:themeController.onPrimary,),
                                  Expanded(
                                    child: Text(
                                      'Ir para o carrinho (${pedidoController.pedidoAtual!.itens.length})',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: themeController.onPrimary,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Icon(Icons.arrow_forward_ios,
                                      size: 16, color: themeController.onPrimary,),
                                ],
                              ),
                            ),
                          ),
                          // PRODUTOS
                          Expanded(
                            child: barraBusca.text.isNotEmpty && controller.produtosFiltrado.isEmpty
                                ? Center(
                                    child: Text(
                                      'Produto não encontrado.',
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: themeController.tertiary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  )
                                : GridView.builder(
                                    padding: EdgeInsets.all(8),
                                    physics: AlwaysScrollableScrollPhysics(),
                                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      mainAxisSpacing: 12,
                                      crossAxisSpacing: 12,
                                      childAspectRatio: 3 / 4,
                                    ),
                                    itemCount: controller.produtosFiltrado.length,
                                    itemBuilder: (context, index) {
                                      final produto = controller.produtosFiltrado[index];
                                      return InkWell(
                                        onTap: () {
                                        controller.selectedItem(produto.numero);

                                        final selecionado = controller.produtosFiltrado.firstWhere(
                                          (p) => p.numero == produto.numero,
                                          orElse: () => produto,
                                        );

                                        if (selecionado.type == 'P') {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) => ApresentacaoProdutoPage(selecionado),
                                            ),
                                          );
                                        } else if (selecionado.type == 'PZ') {
                                          final pizza = Pizza.fromProduto(selecionado);
                                          pizza.nome = selecionado.nome;
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) => LayoutPizza(
                                                pizza: pizza,
                                                ),
                                            ),
                                          );
                                        }
                                      },
                                        child: Card(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(16),
                                          ),
                                          elevation: 4,
                                          child: Container(
                                            padding: EdgeInsets.all(8),
                                            child: Column(
                                              children: [
                                                Text(
                                                  produto.nome,
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w200,
                                                  ),
                                                ),
                                                SizedBox(height: 8),
                                                SizedBox(
                                                  height: MediaQuery.of(context).size.height * 0.12,
                                                  child: Image.asset(
                                                    'assets/images/produto.png',
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                                const SizedBox(height: 8),
                                                Text(
                                                  'R\$ ${produto.valor.toStringAsFixed(2) ?? '0,00'}'),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

            // TECLADO VIRTUAL
            if (_isKeyboardVisible)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  key: _keyboardKey,
                  color: themeController.shadow,
                  height: MediaQuery.of(context).size.height * 0.4,
                  child: VirtualKeyboard(
                    textColor: themeController.scrim,
                    type: VirtualKeyboardType.Alphanumeric,
                    textController: barraBusca,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
