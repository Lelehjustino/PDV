import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nubi_pdv/src/controllers/global_controller.dart';
import 'package:nubi_pdv/src/controllers/layout_totem_controller.dart';
import 'package:nubi_pdv/src/controllers/pedido.controller.dart';
import 'package:nubi_pdv/src/controllers/theme_controller.dart';
import 'package:nubi_pdv/src/views/layout_pizza.dart';
import 'package:nubi_pdv/src/views/pedido_page.dart';
import 'package:nubi_pdv/src/views/senha_correta_layout.dart';
import 'package:provider/provider.dart';
import 'package:virtual_keyboard_2/virtual_keyboard_2.dart';
import 'package:window_manager/window_manager.dart';

class LayoutTotem extends StatefulWidget {
  const LayoutTotem({super.key});

  @override
  State<LayoutTotem> createState() {
    return LayoutTotemState();
  }
}

class LayoutTotemState extends State<LayoutTotem> {
  int _tapCount = 0;
  DateTime? _firstTapTime;

  final FocusNode _passwordFocusNode = FocusNode();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey _keyboardKey = GlobalKey();
  final FocusNode _keyboardFocusNode = FocusNode();

  bool _isKeyboardVisible = false;
  bool _showPasswordDialog = false;

  bool senhaIncorreta = false;
  bool isProcessing = false;

  @override
  void initState() {
    super.initState();
    GlobalController.instance.inicializaLayoutTotem();
    // final globalController = GlobalController.instance;
    // globalController.inicializaLayoutTotem();
    

    _passwordFocusNode.addListener(() {
      if (_passwordFocusNode.hasFocus) {
        setState(() {
          _isKeyboardVisible = true;
        });
      }
    });
  }

  void handleTap() {
    final now = DateTime.now();

    if (_firstTapTime == null || now.difference(_firstTapTime!) > Duration(seconds: 2)) {
      _tapCount = 1;
      _firstTapTime = now;
    } else {
      _tapCount += 1;
    }

    if (_tapCount == 3) {
      _tapCount = 0;
      _firstTapTime = null;
      setState(() {
        _showPasswordDialog = true;
        _isKeyboardVisible = true;
        _passwordController.clear();
        // FocusScope.of(context).requestFocus(_passwordFocusNode);
      });
      /// Garante que o TextField receba foco após renderização
      WidgetsBinding.instance.addPostFrameCallback((_) {
        FocusScope.of(context).requestFocus(_passwordFocusNode);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeController = context.watch<ThemeController>(); // Escuta mudanças nas cores
    final controller = GlobalController.instance.LayoutTotemcontroller;

    return RawKeyboardListener(
      focusNode: _keyboardFocusNode,
      autofocus: true,
      onKey: (RawKeyEvent event) {
        if (event.runtimeType == RawKeyDownEvent) {
          if (event.logicalKey == LogicalKeyboardKey.escape) {
            setState(() {
              _showPasswordDialog = true;
              _isKeyboardVisible = true;
              _passwordController.clear();
              FocusScope.of(context).requestFocus(_passwordFocusNode);
            });
          }
        }
      },
      child: Scaffold(
        backgroundColor:themeController.onTertiary,
        body: Stack(
          children: [
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                if (_isKeyboardVisible) {
                  _passwordFocusNode.unfocus();
                  setState(() {
                    _isKeyboardVisible = false;
                  });
                }
                handleTap();
              },
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/color.png'),
                      repeat: ImageRepeat.repeat,
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: 40.0),
                        child: Image.asset(
                          'assets/images/logo.png',
                          height: 40,
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Image.asset(
                          'assets/images/image-coffee.png',
                          height: 400,
                        ),
                      ),
                      SizedBox(height: 20),
                      AbsorbPointer(
                      absorbing: isProcessing,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => PedidoPage()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: themeController.primary,
                            padding: EdgeInsets.symmetric(horizontal: 60, vertical: 30),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 5,
                          ),
                          child: Text(
                            'Faça seu pedido',
                            style: TextStyle(
                              fontSize: 36,
                              color: themeController.onPrimary,
                              fontWeight: FontWeight.w200,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Botão invisível para ativar senha com 3 toques
            Positioned(
              top: 0,
              left: 0,
              child: GestureDetector(
                onTap: handleTap,
                child: Container(
                  width: 200,
                  height: 200,
                  color: Colors.transparent,
                ),
              ),
            ),

            // DIÁLOGO PERSONALIZADO 
            if (_showPasswordDialog)
            Positioned.fill(
              child: Container(
                color: Colors.black54,
                alignment: Alignment.center,
                child: Container(
                  width: 350,
                  // height: 400,
                  padding: EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: themeController.onTertiary,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.lock,
                        size: 48,
                        color: themeController.error,
                      ),
                      SizedBox(height: 16),
                      Text(
                        "Digite a senha:",
                        style: TextStyle(
                          fontSize: 18,
                          color: themeController.error,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 16),
                      Focus(
                        child: TextField(
                          controller: _passwordController,
                          focusNode: _passwordFocusNode,
                          readOnly: false,     
                          obscureText: true,
                          maxLength: 4,
                          textAlign: TextAlign.center,  // centraliza o texto e o cursor
                          decoration: InputDecoration(
                            hintText: senhaIncorreta ? 'SENHA INCORRETA' : 'Senha',
                            counterText: '', // Esconde o contador de caracteres
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Colors.grey.shade400),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: themeController.error,
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                        onFocusChange: (hasFocus) {
                          setState(() {}); // Atualiza para aplicar estilos se quiser dinâmico
                        },
                      ),
                      SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AbsorbPointer(
                          absorbing: isProcessing,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                setState(() {
                                  _showPasswordDialog = false;
                                  _isKeyboardVisible = false;
                                });
                              },
                              icon: Icon(Icons.close, color: themeController.error),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                foregroundColor: themeController.error,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  side: BorderSide(color: themeController.error, width: 2),
                                ),
                                elevation: 0,
                              ),
                              label: Text( 
                                'CANCELAR',
                                style: TextStyle(color: themeController.error),
                              ),
                            ),
                          ),
                          SizedBox(width: 12),
                          ElevatedButton.icon(
                            onPressed: () {
                              final todayPassword =
                                  '${DateTime.now().day.toString().padLeft(2, '0')}${DateTime.now().month.toString().padLeft(2, '0')}';
                              if (_passwordController.text == todayPassword) {
                                Navigator.of(context).push(
                                  MaterialPageRoute(builder: (_) => SenhaCorretaLayout()),
                                );
                                setState(() {
                                  _showPasswordDialog = false;
                                  _isKeyboardVisible = false;
                                  senhaIncorreta = false;
                                });
                              } else {
                                 setState(() {
                                  _passwordController.clear();
                                  senhaIncorreta = true;
                                });
                              }
                            },
                            icon: Icon(Icons.check, color: themeController.onPrimary),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: themeController.error,
                              // padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 5,
                            ),
                            label: Text(
                              'Confirmar'.toUpperCase(),
                              style: TextStyle(color: themeController.onPrimary),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // TECLADO VIRTUAL NO MESMO PLANO
            if (_isKeyboardVisible)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  key: _keyboardKey,
                  color: themeController.shadow,
                  height: MediaQuery.of(context).size.height * 0.3,
                  child: VirtualKeyboard(
                    textColor: themeController.scrim,
                    type: VirtualKeyboardType.Numeric,
                    textController: _passwordController,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

 


