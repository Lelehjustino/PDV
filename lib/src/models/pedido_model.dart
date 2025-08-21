import 'dart:convert';

import 'package:nubi_pdv/src/models/products_model.dart';

class Pedido {
  final int id;
  final String customerName;
  final List<Item> _itens;
  double subtotal = 0;
  double totalPrice;
  double discount = 0;
  String cumpom = '';
  double cumpomValue = 0;
  int cumpomType = 0; //1 = valor, 2 = porcentagem 

  Pedido({ 
    this.id = 0,
    this.customerName = '',
    this.totalPrice = 0,
    List<Item>? itens
  }) : _itens = itens ?? [];

  List<Item> get itens => _itens;


  //Método para aprensetar o estilo json
  toJson() {
    var teste = {
      'id': id,
      'customerName': customerName,
      'itens': itens.map((item) => item.toJson()).toList(),
      'totalPrice': totalPrice,
    };
    String json = const JsonEncoder.withIndent('  ').convert(teste);
    return json;
  }
  
  @override
  String toString() {
    return 'Pedido{id: $id, customerName: $customerName, itens: $itens, totalPrice: $totalPrice}';
  }
}

class Item {
  final int id;
  final Product product;  
  double unitPrice;
  double totalPrice;
  int quantidade; 
  final List<Adicional> adicionais; 
  final List<Observacao> observacoes; 

  Item({
    required this.id,
    required this.product,
    required this.unitPrice,
    required this.totalPrice,
    required this.quantidade, 
    required this.adicionais, 
    required this.observacoes, 
  });

  //Método para aprensetar o estilo json
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product': product,
      'unitPrice': unitPrice,
      'totalPrice': totalPrice,
      'quantidade': quantidade,
      'adicionais': adicionais,
      'observacoes': observacoes,
    };
  }

    @override
  String toString() {
    return 'Item{id: $id, product: $product, unitPrice: $unitPrice, totalPrice: $totalPrice, quantidade: $quantidade, adicionais: $adicionais, observacoes: $observacoes }';
  }
}

class Adicional {
  String nome;
  double valor; 
  int quantidade;

  Adicional({
    required this.nome,
    required this.valor, 
    required this.quantidade, 
  });

  get id => null;

  //Método para aprensetar o estilo json
  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'valor': valor, 
      'quantidade': quantidade, 
    };
  }
   @override
  String toString() {
    return 'Adicional {nome: $nome, valor: $valor, quantidade: $quantidade}';
  }
}

class Observacao {
  String nome;
  int id; 

  Observacao({
    required this.nome,
    required this.id,
  });

  //Método para aprensetar o estilo json
  Map<String, dynamic> toJson() {
    return {
      'nome': nome, 
      'id': id, 
    };
  }
   @override
  String toString() {
    return 'Observacao {nome: $nome, id: $id}';
  }
}

class Pizza {
  String nome; // aqui é o tamanho 
  double valor;
  int quantidade;
  String grupo;

  Pizza({
    required this.nome, // aqui é o tamanho 
    required this.valor,
    required this.quantidade,
    required this.grupo,
  });

  // Cria uma pizza a partir de um Produto
  factory Pizza.fromProduto(Product produto) {
    return Pizza(
      nome: produto.nome,
      valor: produto.valor,
      quantidade: 1,
      grupo: produto.grupo.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'valor': valor,
      'quantidade': quantidade,
      'grupo': grupo,
    };
  }

  @override
  String toString() {
    return 'Pizza {nome: $nome, valor: $valor, quantidade: $quantidade, grupo: $grupo}';
  }
}


