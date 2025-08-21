import 'package:flutter/material.dart';
import 'package:nubi_pdv/src/controllers/pedido.controller.dart';
import 'package:nubi_pdv/src/controllers/theme_controller.dart';
import 'package:nubi_pdv/src/views/pedido_confirmado.dart';
import 'package:provider/provider.dart';

class ConfirmarPedido extends StatefulWidget {
  const ConfirmarPedido({super.key});

  @override
  State<ConfirmarPedido> createState() => ConfirmarPedidoState();
}

class ConfirmarPedidoState extends State<ConfirmarPedido> {
    String? metodoSelecionado;
    bool mostrarImagem = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final pedidoController = Provider.of<PedidoController>(context, listen: true);
    final themeController = context.watch<ThemeController>(); // Escuta mudanças nas cores
    bool isProcessing = false;

    return Scaffold(
      backgroundColor: themeController.onTertiary,
      // AppBar
      appBar: AppBar(
        backgroundColor: themeController.onTertiary,
        elevation: 0, // remove a sombra
        automaticallyImplyLeading: true, // botão de voltar 
        // Text de conferir o pedido
        title: Text(
          'Escolha um método de pagamento',
          style: TextStyle(
            color: themeController.onSurface,
            fontSize: 22,
            fontWeight: FontWeight.w400,
          ),
        ),
        centerTitle: true,
      ),
      // Texto 'Escolha um método de pagamento'
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            // child: Text(
            //   'Escolha um método de pagamento',
            //   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            // ),
          ),

          // Caixa cinza com padding interno para centralizar os métodos
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.2,
            color: themeController.tertiary,
            padding: EdgeInsets.all(16), // margem igual em todos os lados
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              // Cada botão muda o método selecionado e esconde imagem
              children: [
                buildMetodoPagamentoBoxCredito('Crédito', () {
                  setState(() {
                    metodoSelecionado = 'credito';
                    mostrarImagem = false;
                  });
                }, metodoSelecionado,  context),
                buildMetodoPagamentoBoxDebito('Débito',  () {
                  setState(() {
                    metodoSelecionado = 'debito';
                    mostrarImagem = false;
                  });
                 }, metodoSelecionado,  context),
                buildMetodoPagamentoBoxDinheiro('Dinheiro', () {
                  setState(() {
                    metodoSelecionado = 'dinheiro';
                    mostrarImagem = false;
                  });
                 }, metodoSelecionado,  context),
                buildMetodoPagamentoBoxPix('Pix', () {
                  setState(() {
                    metodoSelecionado = 'pix';
                    mostrarImagem = false;
                  });
                 }, metodoSelecionado,  context),
              ],
            ),
          ),

          SizedBox(height: 10),
          AbsorbPointer(
          absorbing: isProcessing,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: themeController.primary,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 30),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed: () {
                if (metodoSelecionado != null) {
                  setState(() {
                    mostrarImagem = true;
                  });
                }
                //pedidoController.limparCarrinho();
              },
              child: Text(
                'Confirmar método de pagamento',
                style: TextStyle(
                  color: themeController.onPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          // Container 'vazio'
          Container(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.5,
            color: themeController.tertiary,
            // Mostra uma imagem baseada no método
            child: Center(
              child: mostrarImagem && metodoSelecionado != null 
                  ? Image.asset(
                      'assets/images/$metodoSelecionado.png',
                      fit: BoxFit.contain,
                      width: 500,
                      height: 500,
                    )
                  : Text(
                      'Selecione e confirme um método de pagamento',
                      style: TextStyle(fontSize: 16),
              ),
            ),
          ),
          SizedBox(height: 5,),
          
          // Botão falso, para ir para a próxima view e limpar o carrinho 
          AbsorbPointer(
          absorbing: isProcessing,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: themeController.primary,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 30),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed: () {
                // Limpa o carrinho
                pedidoController.limparCarrinho();
            
                // Navega para a tela PedidoConfirmadoState() 
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => PedidoConfirmadoPage()),
                );
              },
              child: Text(
                'BOTÃO FALSO',
                style: TextStyle(
                  color: themeController.onPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}

// Caixa crédito
Widget buildMetodoPagamentoBoxCredito(String metodo, VoidCallback onTap, String? metodoSelecionado,  BuildContext context,) {
  final bool isSelecionado = metodoSelecionado == 'credito';
  final themeController = context.watch<ThemeController>(); // Escuta mudanças nas cores
  return Expanded(
    child: GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4),
        height: 100,
        decoration: BoxDecoration(
          color: themeController.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color:Theme.of(context).colorScheme.onSurface,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
          // Borda especial se estiver selecionado
          border: Border.all(
            color: isSelecionado ? themeController.primary : themeController.tertiary,
            width: isSelecionado ? 3 : 1,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          metodo,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: themeController.onSurface,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    ),
  );
}

// Caixa débito
Widget buildMetodoPagamentoBoxDebito(String metodo, VoidCallback onTap, String? metodoSelecionado,  BuildContext context) {
  final bool isSelecionado = metodoSelecionado == 'debito';
  final themeController = context.watch<ThemeController>(); // Escuta mudanças nas cores
  return Expanded(
    child: GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4),
        height: 100,
        decoration: BoxDecoration(
          color: themeController.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: themeController.onSurface,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
          border: Border.all(
            color: isSelecionado ? themeController.primary : themeController.tertiary,
            width: isSelecionado ? 3 : 1,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          metodo,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: themeController.onSurface
          ),
          textAlign: TextAlign.center,
        ),
      ),
    ),
  );
}

// Caixa dinheiro
Widget buildMetodoPagamentoBoxDinheiro(String metodo, VoidCallback onTap, String? metodoSelecionado, BuildContext context,) {
  final bool isSelecionado = metodoSelecionado == 'dinheiro';
  final themeController = context.watch<ThemeController>(); // Escuta mudanças nas cores
  return Expanded(
    child: GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4),
        height: 100,
        decoration: BoxDecoration(
          color: themeController.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: themeController.onSurface,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
          border: Border.all(
            color: isSelecionado ? themeController.primary: themeController.tertiary,
            width: isSelecionado ? 3 : 1,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          metodo,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: themeController.onSurface,
          ),
        ),
      ),
    ),
  );
}

// Caixa pix
Widget buildMetodoPagamentoBoxPix(String metodo, VoidCallback onTap, String? metodoSelecionado, BuildContext context,) {
  final bool isSelecionado = metodoSelecionado == 'pix';
  final themeController = context.watch<ThemeController>(); // Escuta mudanças nas cores
  return Expanded(
    child: GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4),
        height: 100,
        decoration: BoxDecoration(
          color: themeController.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: themeController.onSurface,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
          border: Border.all(
            color: isSelecionado ? themeController.primary : themeController.tertiary,
            width: isSelecionado ? 3 : 1,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          metodo,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: themeController.onSecondary,
          ),
        ),
      ),
    ),
  );
}
