import 'dart:async';
import 'package:flutter/material.dart';
import 'package:nubi_pdv/src/controllers/theme_controller.dart';
import 'package:nubi_pdv/src/views/layout_totem.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';

class PedidoConfirmadoPage extends StatefulWidget {
  const PedidoConfirmadoPage({super.key});

  @override
  State<PedidoConfirmadoPage> createState() => _PedidoConfirmadoPageState();
}

// como esta tela muda, as aminações tem que ser criadas aqui dentro
class _PedidoConfirmadoPageState extends State<PedidoConfirmadoPage> 
  with SingleTickerProviderStateMixin {

  // Contraladores da animação    
  late AnimationController animationController;
  late Animation<double> scaleAnimation;

  @override
  void initState() {
    super.initState();

    // WidgetsBinding.instance.addPostFrameCallback((_) async {
    //  await windowManager.setFullScreen(true);
    // });
    
    // Roda assim que a tela é iniciada 
    // Animação ícone de confirmação
    animationController = AnimationController(
      duration: const Duration(milliseconds: 1000), // dura 1 segundo
      vsync: this,
    );
    // Diz que a animação é elástica
    scaleAnimation = CurvedAnimation( 
      parent: animationController,
      curve: Curves.elasticOut,
    );
    
    // Começa a animação 
    animationController.forward();

    // Timer de redirecionamento após 5 segundos
    Timer(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => LayoutTotem(), // após 5 segundos vai para o LayouTotem()
        ),
      );
    });
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeController = context.watch<ThemeController>(); // Escuta mudanças nas cores
    return Scaffold(
      backgroundColor: themeController.onTertiary,
      body: SafeArea(
        // coloca no centro da tela, em coluna 
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // aplica a animação de "crescimento" mo ícone
              ScaleTransition(
                scale: scaleAnimation, // aqui está a animação 
                // estilização da animação 
                child: Container(
                  padding:  EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    color: themeController.tertiary,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check_circle_outline,
                    size: 100,
                    color: themeController.primary,
                  ),
                ),
              ),
              SizedBox(height: 30),

              // Texto de 'Pedido confirmado!'
              Text(
                'Pedido confirmado!',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: themeController.onSurface,
                ),
              ),
              SizedBox(height: 20),

              // Texto de 'Seu pedido já está em preparo :)'
              Text(
                'Seu pedido já está em preparo :)',
                style: TextStyle(
                  fontSize: 22,
                  color: themeController.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40),

               // Texto de  'Muito obrigado pelo seu pedido'
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(themeController.primary),
                strokeWidth: 4,
              ),
              SizedBox(height: 20),
              Text(
                'Muito obrigado pelo seu pedido',
                style: TextStyle(fontSize: 16, color: themeController.onSurface,),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

