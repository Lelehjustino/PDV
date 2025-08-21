import 'package:flutter/material.dart';

class Product {
  final int numero;
  final String nome;
  final double valor;
  final int unidade;
  final int grupo;
  final String type;
  final int diversidadesabores;
  final int numeroTamanhoPizza_FK;
  IconData? icone;
  
  Product({
    required this.numero,
    required this.nome,
    required this.valor,
    required this.unidade,
    required this.grupo,
    required this.type,
    required this.diversidadesabores,
    required this.numeroTamanhoPizza_FK,
    this.icone,
  });
  

  factory Product.fromJson(Map<String, dynamic> json) {
    // print(json);
    return Product(
      nome: json['nome'] ?? 'Nome não disponível',
      numero: json['numero'] ?? 0,
      valor: json['valor']?.toDouble() ?? 0.0,
      unidade: json['unidade'] ?? 1,
      type: json['id'] ?? '', 
      grupo: json['grupo'] ?? '',
      diversidadesabores: json['diversidadesabores']?.toInt() ?? 0,
      numeroTamanhoPizza_FK: json['diversidadesabores'] ?? 0,
    );
  }

  @override
  String toString() {
    return 'Product{nome: $nome, valor: $valor, unidade: $unidade, type: $type,  grupo: $grupo, diversidadesabores: $diversidadesabores}';
  }

  static where(Function(dynamic p) param0) {}

  toLowerCase() {}
}

class Grupo{
  final int id;
  final String name;
  final String type;
  IconData? icone;

  Grupo({
    required this.id,
    required this.name,
    required this.type,
    this.icone,
  });
  
  factory Grupo.fromJson(Map<String, dynamic> json) {
    return Grupo(
      id: json['numero'] ?? 0,
      name: json['nome'] ?? '',
      type: json['id'] ?? '', // quanto este id for PZ (ele é grupo de pizza), quando for 'P' (produto)
      icone: null, //VEM NULL POIS SERA ATRIBUIDO DEPOIS
    );
  }

   @override
  String toString() {
    return '{id: $id, nome: $name, type: $type,  icone: $icone}';
  }

  static where(Function(dynamic p) param0) {}

  toLowerCase() {}

  void clear() {}
}