import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:nubi_pdv/src/controllers/global_controller.dart';
import 'package:nubi_pdv/src/controllers/layout_totem_controller.dart';
import 'package:nubi_pdv/src/controllers/pedido.controller.dart';
import 'package:nubi_pdv/src/controllers/theme_controller.dart';
import 'package:nubi_pdv/src/views/confirmar_pedido.dart';
import 'package:nubi_pdv/src/views/layout_totem.dart';
import 'package:provider/provider.dart';
import 'package:virtual_keyboard_2/virtual_keyboard_2.dart';
import 'package:window_manager/window_manager.dart';

// Confirmar seu pedido
class PagamentoLayout extends StatefulWidget {
  const PagamentoLayout({super.key});

  @override
  State<PagamentoLayout> createState() {
    return PagamentoLayoutState();
  }
}

class PagamentoLayoutState extends State<PagamentoLayout> {
  final controller = GlobalController.instance.LayoutTotemcontroller;

  bool _showKeyboardNome = false;
  bool _showKeyboardCupom = false;

  final FocusNode _nomeFocusNode = FocusNode();
  final FocusNode _cupomFocusNode = FocusNode();

  final TextEditingController cupomController = TextEditingController();
  final TextEditingController nomeController = TextEditingController();

  final GlobalKey _keyboardNomeKey = GlobalKey();
  final GlobalKey _keyboardCupomKey = GlobalKey();

  bool _cupomInvalido = false;

  bool _nomeInvalido = false;

  bool _cupomAplicado = false;

  late PedidoController _pedidoController;

  @override
  void initState() {
    super.initState();

  _pedidoController = Provider.of<PedidoController>(context, listen: false);
  cupomController.addListener(() {
  final text = cupomController.text.toUpperCase();
  // Atualiza para maiúsculo se necessário
  if (cupomController.text != text) {
    cupomController.value = cupomController.value.copyWith(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
    return;
  }

  if (_cupomInvalido) {
    setState(() {
      _cupomInvalido = false;
    });
  }

  // Evita aplicar novamente se já estiver aplicado
  if (!_cupomAplicado && controller.valededCunpom(text)) {
    setState(() {
      _pedidoController.selectCoupon(
      _pedidoController.pedidoAtual!.totalPrice,
        cupomController,
      );
      controller.cupomValidado = true;
      _cupomAplicado = true;
    });
  }

  // Se cupom foi apagado ou alterado para inválido
  if (_cupomAplicado && !controller.valededCunpom(text)) {
    setState(() {
      _cupomAplicado = false;
      controller.cupomValidado = false;
      _pedidoController.removeCoupon();
    });
  }
});

    // Para deixar com letras maiúsculas cupom 
    nomeController.addListener(() {
      final currentText = nomeController.text;
      if (currentText != currentText.toUpperCase()) {
        nomeController.value = nomeController.value.copyWith(
          text: currentText.toUpperCase(),
          selection: TextSelection.collapsed(offset: currentText.length),
        );
      }
    });

    // Resetar o erro ao digitar novamente no cupom
    nomeController.addListener(() {
      final currentText = nomeController.text.toUpperCase();
      if (nomeController.text != currentText) {
        nomeController.value = nomeController.value.copyWith(
          text: currentText,
          selection: TextSelection.collapsed(offset: currentText.length),
        );
      }

      // Corrige ao digitar qualquer coisa
      if (_nomeInvalido && currentText.trim().isNotEmpty) {
        setState(() {
          _nomeInvalido = false;
        });
      }
    });

  // teclado 
    _nomeFocusNode.addListener(() {
      if (_nomeFocusNode.hasFocus) {
        setState(() {
          _showKeyboardNome = true;
          _showKeyboardCupom = false;
        });
      }
    });

    _cupomFocusNode.addListener(() {
      if (_cupomFocusNode.hasFocus) {
        setState(() {
          _showKeyboardCupom = true;
          _showKeyboardNome = false;
        });
      }
    });

    controller.notifier.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    nomeController.dispose();
    cupomController.dispose();
    _nomeFocusNode.dispose();
    _cupomFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pedidoController = Provider.of<PedidoController>(context, listen: true);
    // final themeController = context.watch<ThemeController>(); // Escuta mudanças nas cores
    final themeController = context.read<ThemeController>();
    bool isProcessing = false;

    // Define a altura do teclado para ajustar o padding do conteúdo
    final double keyboardHeight = MediaQuery.of(context).size.height * 0.4;
    return Scaffold(
      backgroundColor: themeController.onTertiary,
      // AppBar
      appBar: AppBar(
        backgroundColor: themeController.onTertiary,
        elevation: 0, // remove a sombra
        automaticallyImplyLeading: true, // remove botão de voltar, se necessário
        // Text de conferir o pedido
        title: Text(
          'Confira seu pedido',
          style: TextStyle(
            color: themeController.onSurface,
            fontSize: 22,
            fontWeight: FontWeight.w400,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // GestureDetector envolve toda a coluna de conteúdo principal para capturar toques fora dos TextFields e do teclado.
          GestureDetector(
            onTapDown: (details) {
              final keyboardNomeBox = _keyboardNomeKey.currentContext ?.findRenderObject() as RenderBox?;
              final keyboardCupomBox = _keyboardCupomKey.currentContext ?.findRenderObject() as RenderBox?;

              final Offset tapPosition = details.globalPosition;

              bool tappedKeyboard = false;

              if (keyboardNomeBox != null) {
                final nomeRect = keyboardNomeBox.localToGlobal(Offset.zero) &
                    keyboardNomeBox.size;
                if (nomeRect.contains(tapPosition)) tappedKeyboard = true;
              }

              if (keyboardCupomBox != null) {
                final cupomRect = keyboardCupomBox.localToGlobal(Offset.zero) &
                    keyboardCupomBox.size;
                if (cupomRect.contains(tapPosition)) tappedKeyboard = true;
              }

              if (!tappedKeyboard) {
                _nomeFocusNode.unfocus();
                _cupomFocusNode.unfocus();
                setState(() {
                  _showKeyboardNome = false;
                  _showKeyboardCupom = false;
                });
              }
            },
            behavior: HitTestBehavior.translucent,
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: (_showKeyboardNome || _showKeyboardCupom)
                        ? EdgeInsets.fromLTRB( 16, 16, 16, keyboardHeight + 20) // +20 para um espaçamento extra
                        : EdgeInsets.symmetric (vertical: 16, horizontal: 16),
                    child: Column(
                      children: [
                        // Gera os widgets para cada item do pedido
                        ...List.generate(
                          pedidoController.pedidoAtual!.itens.length, // pega os itens e coloca dentro de uma lista
                          (index) {
                            return Container(
                              // Estilização dos itens da lista
                              margin: EdgeInsets.symmetric(vertical: 2),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              padding: EdgeInsets.all(8),
                              child: Row(
                                children: [
                                 SizedBox(width: 16),
                                  // Este Expanded é dentro dos itens da lista
                                  Expanded(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // ENVOLVE ESTE COM FLEXIBLE
                                        Flexible(
                                          child: Text(
                                            '${pedidoController.pedidoAtual!.itens[index].quantidade} x ${pedidoController.pedidoAtual!.itens[index].product.nome}',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500,
                                              color: themeController.onSurface,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1, // também necessário
                                          ),
                                        ),
                                        SizedBox(width: 4),
                                        // Este texto normalmente não precisa de elipse, mas pode manter
                                        Text(
                                          'R\$ ${pedidoController.pedidoAtual!.itens[index].totalPrice.toStringAsFixed(2)}',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            color: themeController.onSurface,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Expanded(
                                  //   child: Row(
                                  //     mainAxisAlignment: MainAxisAlignment.spaceBetween, // separa os lados
                                  //     crossAxisAlignment:
                                  //         CrossAxisAlignment.start,
                                  //     children: [
                                  //       // Apresenta a quantidade de itens selecionados do produto x o nome do produto
                                  //       Text(
                                  //         '${pedidoController.pedidoAtual!.itens[index].quantidade} x ${pedidoController.pedidoAtual!.itens[index].product.nome}',
                                  //         style: TextStyle(
                                  //           fontSize: 18,
                                  //           fontWeight: FontWeight.w500,
                                  //           color: themeController.onSurface,
                                  //         ),
                                  //         overflow: TextOverflow.ellipsis,
                                  //       ),
                                  //      SizedBox(width: 4),
                                  //       // Subtotal deste item
                                  //       Text(
                                  //         'R\$ ${pedidoController.pedidoAtual!.itens[index].totalPrice.toStringAsFixed(2)}',
                                  //         style: TextStyle(
                                  //           fontSize: 16,
                                  //           fontWeight: FontWeight.w500,
                                  //           color: themeController.onSurface,
                                  //         ),
                                  //          overflow: TextOverflow.ellipsis,
                                  //       ),
                                  //     ],
                                  //   ),
                                  // ),
                                ],
                              ),
                            );
                          },
                        ),

                       SizedBox(height: 20),

                        // Textos de Subtotal, Desconto e Total
                        // TEXTO SUBTOTAL
                        if (pedidoController.pedidoAtual != null)
                          Center(
                            child: Text(
                              'Subtotal: R\$ ${pedidoController.pedidoAtual!.subtotal.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: themeController.onSurface,
                              ),
                            ),
                          ),
                       SizedBox(height: 5),

                        // TEXTO DESCONTO
                        if (pedidoController.pedidoAtual != null &&
                            pedidoController.pedidoAtual!.discount > 0)
                          Column(
                            children: [
                              Center(
                                child: Text(
                                  'Desconto: - R\$ ${pedidoController.pedidoAtual!.discount.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w400,
                                    color: themeController.primary,
                                  ),
                                ),
                              ),
                             SizedBox(height: 10),
                            ],
                          ),
                        // TEXTO TOTAL
                        if (pedidoController.pedidoAtual != null)
                          Center(
                            child: Text(
                              'Total: R\$ ${pedidoController.pedidoAtual!.totalPrice.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: themeController.onSurface,
                              ),
                            ),
                          ),
                       SizedBox(height: 5),
                        //Campo para digitar Nome
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                           Center(
                              child:
                               Text('Digite seu nome para retirar produto'),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: TextField(
                                showCursor: true,
                                controller: nomeController,
                                focusNode: _nomeFocusNode,
                                textAlign: TextAlign.center, // ← isso centraliza o cursor e o texto
                                onTap: () {
                                  FocusScope.of(context).requestFocus(_nomeFocusNode);
                                  setState(() {
                                    _nomeInvalido = false;
                                  });
                                },
                                inputFormatters: [UpperCaseTextFormatter()],
                                keyboardType: TextInputType.none, // impede teclado físico
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: _nomeInvalido ? themeController.errorContainer : themeController.surface,
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: _nomeInvalido ? themeController.error : themeController.tertiary,
                                      width: 2,
                                    ),
                                  ),
                                  prefixIcon: Icon(Icons.person),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: _nomeInvalido ? themeController.error : themeController.primary,
                                      width: 2,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10), // Espaçamento entre os campos

                        Text('Digite seu cupom (opcional)'),
                        // Campo para digitar cupom e botão 'Validar cupom'
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: TextField(
                                readOnly: true,
                                enabled: !_cupomAplicado,
                                showCursor: true,
                                controller: cupomController,
                                focusNode: _cupomFocusNode,
                                textAlign: TextAlign.center, // ← isso centraliza o cursor e o texto
                                onTap: () {
                                  if (!_cupomAplicado) {
                                    FocusScope.of(context).requestFocus(_cupomFocusNode);
                                  }
                                    // Resetar o erro ao clicar novamente
                                    if (_cupomInvalido) {
                                      setState(() {
                                        _cupomInvalido = false;
                                      });
                                    }
                                },
                                inputFormatters: [
                                  UpperCaseTextFormatter(),
                                ],
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: (!_cupomAplicado && !_cupomInvalido)
                                  ? themeController.surface
                                  : (_cupomInvalido
                                      ? themeController.errorContainer
                                      : themeController.tertiary),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: _cupomInvalido ?themeController.error : themeController.tertiary,
                                      width: 2,
                                    ),
                                  ),
                                  prefixIcon: Icon(Icons.confirmation_number),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: _cupomInvalido
                                          ? themeController.error
                                          : themeController.primary,
                                      width: 2,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10), // Espaçamento entre o campo e o botão

                            // Botão de remover
                            if (_cupomAplicado && controller.cupomValidado)
                            AbsorbPointer(
                            absorbing: isProcessing,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                  height: 60, // Altura semelhante à do TextField
                                  child: ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        _cupomAplicado = false;
                                        controller.cupomValidado = false;
                                        _cupomInvalido = false;
                                        cupomController.clear();
                                        pedidoController.removeCoupon();
                                      });
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: themeController.error,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                    ),
                                    child: Text(
                                      'Remover cupom',
                                      style: TextStyle(
                                        color: themeController.onError,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        // Botão Confirmar Pedido
                        AbsorbPointer(
                        absorbing: isProcessing,
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: ElevatedButton(
                              onPressed: () {
                                if (nomeController.text.trim().isEmpty) {
                                  setState(() {
                                    _nomeInvalido = true;
                                    FocusScope.of(context).requestFocus(_nomeFocusNode);
                                    _showKeyboardNome = true;
                                    _showKeyboardCupom = false;
                                  });
                                  pedidoController.showCustomDialog(
                                    context: context,
                                    icon: Icons.person, 
                                    message: 'Por favor, preencha o seu nome para continuar.',
                                    confirmText: 'OK',
                                    onConfirm: () {}, 
                                    onCancel: () { Navigator.pop(context); }, 
                                    themeController: themeController,
                                  );
                                } else {
                                  setState(() {
                                    _nomeInvalido = false;
                                  });
                          
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => ConfirmarPedido(),
                                    ),
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: themeController.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 30),
                              ),
                              child: Text(
                                'Confirmar pedido',
                                style: TextStyle(fontSize: 25, color: themeController.onPrimary,),
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
          // TECLADO VIRTUAL - Posicionado na parte inferior
          if (_showKeyboardNome)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                key: _keyboardNomeKey,
                color: themeController.shadow,
                height: MediaQuery.of(context).size.height * 0.4,
                child: VirtualKeyboard(
                  textColor: themeController.scrim,
                  type: VirtualKeyboardType.Alphanumeric,
                  textController: nomeController,
                ),
              ),
            ),

          if (_showKeyboardCupom)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                key: _keyboardCupomKey,
                color: themeController.shadow,
                height: MediaQuery.of(context).size.height * 0.4,
                child: VirtualKeyboard(
                  textColor: themeController.scrim,
                  type: VirtualKeyboardType.Alphanumeric,
                  textController: cupomController,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

  // Classe para letras maiúsculas do campo de CUPOM
  class UpperCaseTextFormatter extends TextInputFormatter {
    @override // esta função substitui a função do TextInputFormatter
    TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue, // pega o que foi digitado no imput
    ) {
    return newValue.copyWith(
      text: newValue.text.toUpperCase(), // transforma tudo em letra maiúscula
      selection: newValue.selection, // mantém posição do cursor
    );
  }
}
