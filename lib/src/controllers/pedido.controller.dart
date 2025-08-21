//import 'dart:ffi';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nubi_pdv/src/controllers/theme_controller.dart';
import 'package:nubi_pdv/src/models/pedido_model.dart';
import 'package:nubi_pdv/src/models/products_model.dart';
//import 'package:provider/provider.dart';


class PedidoController with ChangeNotifier{
  ValueNotifier<bool> orderFinished = ValueNotifier<bool>(false);

  Pedido? _pedidoAtual;

  Pedido? get pedidoAtual => _pedidoAtual;
  
  get index => null;

  List<Item> getItensDoCarrinho() {return pedidoAtual?.itens ?? [];
  }

  // Criar um novo pedido
  void criarNovoPedido(String customerName) {
    if(_pedidoAtual == null){
      orderFinished.value = false;
      _pedidoAtual = Pedido(customerName: customerName);
    }
    notifyListeners();
  }

 // Calcula o preço total com desconto
 void selectCoupon(double totalPrice, TextEditingController cupomController) {
  String cupom = cupomController.text.trim().toUpperCase();

  // Verifica cupom por nome (ex: "DESCONTO10")
  if (cupom == "DESC10") { // cupom 10 reais de desconto 
    _pedidoAtual!.cumpom = cupom;
    _pedidoAtual!.cumpomType = 1;
    _pedidoAtual!.cumpomValue = 10; 
    _pedidoAtual!.discount = 10; 
      
    } else if (cupom == "DESC50") { // cupom 10% de desconto 
      _pedidoAtual!.cumpom = cupom;
      _pedidoAtual!.cumpomType = 2;
      _pedidoAtual!.cumpomValue = 0.5; 
    
      _pedidoAtual!.discount = _pedidoAtual!.subtotal * _pedidoAtual!.cumpomValue; 

    } else if (cupom == "DESC15") { // cupom 15% de desconto 
      _pedidoAtual!.cumpom = cupom;
      _pedidoAtual!.cumpomType = 2;
      _pedidoAtual!.cumpomValue = 0.15; 
    
      _pedidoAtual!.discount = _pedidoAtual!.subtotal * _pedidoAtual!.cumpomValue; 
    }

    calcularTotal();
    notifyListeners();
  }

  // Adicionar item ao pedido atual
  void addItemTotem(Item novoItem) { // recebe Item e adiciona ao pedido (_pedidoAtual)
    if (_pedidoAtual == null) { // se não tem _pedidoAtua
      criarNovoPedido('nome'); // cria um novo pedido com o parâmetro 'nome'
    }

    if (_pedidoAtual != null) { // se não tem _pedidoAtua
      final comparacao = 
      _pedidoAtual!.itens // lista de itens já adicionados no pedido atual
      .indexWhere((itemExistente) // verifica se esse itemExistente é igual ao novoItem
      => _itensSaoIguais
      (itemExistente, novoItem)); 

      if (comparacao >= 0) { // significa que já existe um item igual no pedido
        final itemExistente = _pedidoAtual!.itens[comparacao]; // Pega o item já existente.
        itemExistente.quantidade += novoItem.quantidade; // Soma a quantidade do novo item à quantidade do item existente
        itemExistente.totalPrice = itemExistente.unitPrice * itemExistente.quantidade; // Atualiza o preço total com base na nova quantidade multiplicada pelo preço unitário.
      } else { // se não tiver nehum igual, adiciona como um novo item
        _pedidoAtual!.itens.add(novoItem);
      }
    }

    calcularTotal();
    notifyListeners();
  }

  // Booleano auxiliar (addItemTotem) 
  bool _itensSaoIguais(Item a, Item b) { // recebe dois itens e aponta de são iguais ou não 
      if (a.product.numero != b.product.numero) return false;

      if (a.adicionais.length != b.adicionais.length) return false;
      if (a.observacoes.length != b.observacoes.length) return false;

      for (int i = 0; i < a.adicionais.length; i++) {
        final adA = a.adicionais[i];
        final adB = b.adicionais[i];
        if (adA.nome != adB.nome || adA.quantidade != adB.quantidade) return false;
      }

      for (int i = 0; i < a.observacoes.length; i++) {
        final obA = a.observacoes[i];
        final obB = b.observacoes[i];
        if (obA.id != obB.id) return false;
      }
    return true;
  }

  // Adicionar Item Pizza ao pedido atual
  void addItemPizzaTotem(Item novoItem) {
      if (_pedidoAtual == null) { // Verifica se ainda não existe um pedido em andamento
      criarNovoPedido('Pizza');   // Cria um novo pedido com nome genérico 'Pizza'. Isso garante que exista um pedido antes de adicionar itens a ele.
    }
    
    // Verifica novamente se o pedido foi criado 
    if (_pedidoAtual != null) {
      final comparacao = _pedidoAtual!.itens.indexWhere( // Procura dentro da lista de itens do pedido atual se já existe uma pizza igual à nova.
        (itemExistente) => _mesmaPizza(itemExistente, novoItem), // Se encontrar uma pizza igual, comparacao recebe o índice dela.
      );
    
    // Se encontrou uma pizza igual no pedido
      if (comparacao >= 0) {
        final itemExistente = _pedidoAtual!.itens[comparacao]; // Pega a pizza já existente que é igual à nova
        itemExistente.quantidade += novoItem.quantidade; // Soma a quantidade da nova pizza à quantidade da pizza já existente no pedido
        itemExistente.totalPrice = itemExistente.unitPrice * itemExistente.quantidade; // Recalcula o valor total da pizza com base na nova quantidade
      } else { // Se não encontrou uma pizza igual, adiciona a nova pizza como novo item no pedido
        _pedidoAtual!.itens.add(novoItem);
      }
    }

    calcularTotal();
    notifyListeners();
  }
  
  // Booleano auxiliar (addItemTotem) 
  bool _mesmaPizza(Item a, Item b) {
  return 
    a.product.nome == b.product.nome &&
    a.product.grupo == b.product.grupo &&
    a.product.type == b.product.type &&
    a.product.diversidadesabores == b.product.diversidadesabores &&
    listEquals(a.observacoes, b.observacoes) &&
    listEquals(a.adicionais, b.adicionais);
}

  // Adicionar item ao pedido atual
  void addItem(Product item) {
    if (_pedidoAtual != null) {
      Item? findProd;

      // if(_pedidoAtual!.itens.isNotEmpty){
      //   findProd = _pedidoAtual!.itens.firstWhere(
      //   (itemProd) => itemProd.id == item.numero,
      //   orElse: () => Item(
      //     id: -1, 
      //     numero: 0,
      //     nome: '',
      //     valor: 0.0,
      //     unidade: 0,
      //     quantidade: 0,
      //     totalItem: 0
      //   ));
      // }
      
      // if(findProd!.id != -1){
      //   findProd.quantidade++;
      //   findProd.totalItem = findProd.valor * findProd.quantidade;
      // }
      // else{
      //   print('caiu aqui');
      //   Item newItem = Item(
      //     id: item.numero,
      //     numero: item.numero,
      //     nome: item.nome,
      //     valor: item.valor,
      //     unidade: item.unidade,
      //     quantidade: 1,
      //     totalItem: item.valor
      //   );

      //   _pedidoAtual?.itens.add(newItem);
      // }

      calcularTotal();
      notifyListeners();     
    }
  }

  //Adiciona item de kg ao pedido atual
  void addItemKG(Product item, double weight){
    if(_pedidoAtual != null){
      double value = double.parse((weight * item.valor).toStringAsFixed(2));

      // Item newItem = Item(
      //   id: 1,
      //   numero: item.numero,
      //   nome: item.nome,
      //   valor: value,
      //   unidade: item.unidade,
      //   quantidade: weight,
      //   totalItem: value
      // );

      // _pedidoAtual?.itens.add(newItem);

      calcularTotal();
    }
  }

  // Remover item do pedido
  void removeItem(Item item) {
    if (_pedidoAtual != null) {
      _pedidoAtual?.itens.remove(item);
      calcularTotal();
      notifyListeners();
    }
  }

  //Adiciona 1 no item do carrinho
  void addOneCounter(Item item){
    item.quantidade ++;
    item.totalPrice = item.quantidade * item.unitPrice;
    calcularTotal();
    notifyListeners();
  }

  //Remove 1 no item do carrinho
  void removeOneCounter(Item item){
    if(item.quantidade == 1){
      removeItem(item);
    }
    else{
      item.quantidade --;
      item.totalPrice = item.quantidade * item.unitPrice;
      calcularTotal();
    }
    notifyListeners();
  }
 
  // Remove uma Pizza do carrinho 
  void removeItemPizzaTotem(Item itemParaRemover) {
    if (_pedidoAtual == null) return;

    // Encontra o primeiro item que "bate" com o que queremos remover
    final index = _pedidoAtual!.itens.indexWhere(
      (item) => _mesmaPizza(item, itemParaRemover),
    );

    // Se achou o item
    if (index != -1) {
      final item = _pedidoAtual!.itens[index];

      // Se quantidade for 1, remove da lista
      if (item.quantidade == 1) {
        _pedidoAtual!.itens.removeAt(index);
      } else {
        // Se for mais que 1, apenas diminui a quantidade
        item.quantidade -= 1;
        item.totalPrice = item.unitPrice * item.quantidade;
      }

      calcularTotal();
      notifyListeners();
    }
  }

  //Calcula o Total do pedido
  void calcularTotal(){
    if(_pedidoAtual != null){

      _pedidoAtual?.totalPrice = 0;

      _pedidoAtual?.itens.forEach((item){
        var value = 0.0;

        if(item.product.unidade == 1){
          value = item.unitPrice * item.quantidade;
        }
        else{
          value = item.unitPrice;
        }

        _pedidoAtual?.totalPrice += value;
      });

      _pedidoAtual!.subtotal = _pedidoAtual!.totalPrice;

      if(_pedidoAtual!.discount != 0){
        _pedidoAtual!.totalPrice = _pedidoAtual!.totalPrice - _pedidoAtual!.discount;
      }
    }
  }

  // Finalizar pedido
  Future<void> finalizarPedido() async {
    if (_pedidoAtual != null) {
      _pedidoAtual = null;
      print('pedido Finalizado');
      orderFinished.value = true;
      notifyListeners();
    }
  }
  
  // Limpar carrinho 
  void limparCarrinho() {
    if (pedidoAtual != null) {
      pedidoAtual!.itens.clear();
      pedidoAtual!.totalPrice = 0.0;
      pedidoAtual!.subtotal = 0.0;
      pedidoAtual!.discount = 0.0;
    }
    notifyListeners();
  }

  // Função para remover cupom
  void removeCoupon() {
  pedidoAtual!.discount = 0.0;
  pedidoAtual!.totalPrice = pedidoAtual!.subtotal;
  notifyListeners(); // muito importante para atualizar a UI
}

  // Função widget padrão DIÁLOGO (estilizações)
  Future<void> showCustomDialog({
  required BuildContext context,
  required ThemeController themeController, // Agora o ThemeController é passado como parâmetro!
  IconData? icon,
  required String message,
  String? cancelText,
  required String confirmText,
  required VoidCallback onConfirm,
  required VoidCallback onCancel,
  Widget? customContent,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          contentPadding: EdgeInsets.all(24),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null)
                Padding(
                  padding: EdgeInsets.only(bottom: 16),
                  child: Icon(
                    icon,
                    size: 48,
                    color: themeController.error,
                  ),
                ),
              Text(
                message,
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              if (customContent != null) ...[
                SizedBox(height: 16),
                customContent,
              ],
              SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (cancelText != null)
                    TextButton.icon(
                      onPressed: () {
                        Navigator.of(context).pop();
                        onCancel();
                      },
                      icon: Icon(Icons.close, color: themeController.error),
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(
                            color: themeController.error,
                            width: 2,
                          ),
                        ),
                      ),
                      label: Text(
                        cancelText.toUpperCase(),
                        style: TextStyle(color: themeController.error),
                      ),
                    ),
                  SizedBox(width: 12),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(context).pop();
                      onConfirm();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: themeController.error,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    // icon: Icon(Icons.check, color: themeController.onPrimary),
                    icon: Icon(Icons.thumb_up, color: themeController.onPrimary),
                    label: Text(
                      confirmText.toUpperCase(),
                      style: TextStyle(color: themeController.onPrimary),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  } 

}

