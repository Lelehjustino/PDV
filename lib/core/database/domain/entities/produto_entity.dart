import 'package:equatable/equatable.dart';

// Classe feita a partir das variáveis de db.dart 
// ignore: must_be_immutable
class ProdutoEntity extends Equatable {
  late int? produtoId;
  final String nome;
  final String descricao;
  final double valor;

  ProdutoEntity({
    this.produtoId,
    required this.nome, 
    required this.descricao, 
    required this.valor
  });
  
  @override
  List<Object?> get props => [produtoId]; 
}