
class Flavors {
  final int id; // número da venda
  final String type; // id
  final String nome; // sabor da pizza 
  final int valor1; 
  final int valor2; 
  final int valor3; 
  final int valor4; 
  final int valor5; 
  final int valor6; 
  final int valor7; 
  final int valor8; 
  final int valor9; 
  final int valor10;
  final int valor11; 
  final int valor12; 
  final int valor13; 
  final int valor14; 
  final int valor15; 
  final int valor16; 
  final int valor17; 
  final int valor18; 
  final int valor19; 
  final int valor20;
  final int valor21; 
  final int valor22; 
  final int valor23; 
  final int valor24; 
  final int valor25; 
  final int valor26; 
  final int valor27; 
  final int valor28; 
  final int valor29; 
  final int valor30;
  final int grupo;
  final int numerogrupo_FK;

  Flavors({
    required this.numerogrupo_FK,
    required this.id,
    required this.type,
    required this.nome,
    required this.valor1,
    required this.valor2,
    required this.valor3,
    required this.valor4,
    required this.valor5,
    required this.valor6,
    required this.valor7,
    required this.valor8,
    required this.valor9,
    required this.valor10,
    required this.valor11,
    required this.valor12,
    required this.valor13,
    required this.valor14,
    required this.valor15,
    required this.valor16,
    required this.valor17,
    required this.valor18,
    required this.valor19,
    required this.valor20,
    required this.valor21,
    required this.valor22,
    required this.valor23,
    required this.valor24,
    required this.valor25,
    required this.valor26,
    required this.valor27,
    required this.valor28,
    required this.valor29,
    required this.valor30,
    required this.grupo, required String tipo,
  });

  factory Flavors.fromJson(Map<String, dynamic> json) {
    return Flavors(
      numerogrupo_FK: json['numerogrupo_FK'] ?? 0,
      id: json['numerovenda'] ?? 0,
      type: json['id']?.toString() ?? '',
      nome: json['nome'] ?? '',
      grupo: json['grupo'] ?? 0,
      valor1: json['valor1'] ?? 0,
      valor2: json['valor2'] ?? 0,
      valor3: json['valor3'] ?? 0,
      valor4: json['valor4'] ?? 0,
      valor5: json['valor5'] ?? 0,
      valor6: json['valor6'] ?? 0,
      valor7: json['valor7'] ?? 0,
      valor8: json['valor8'] ?? 0,
      valor9: json['valor9'] ?? 0,
      valor10: json['valor10'] ?? 0,
      valor11: json['valor11'] ?? 0,
      valor12: json['valor12'] ?? 0,
      valor13: json['valor13'] ?? 0,
      valor14: json['valor14'] ?? 0,
      valor15: json['valor15'] ?? 0,
      valor16: json['valor16'] ?? 0,
      valor17: json['valor17'] ?? 0,
      valor18: json['valor18'] ?? 0,
      valor19: json['valor19'] ?? 0,
      valor20: json['valor20'] ?? 0,
      valor21: json['valor21'] ?? 0,
      valor22: json['valor22'] ?? 0,
      valor23: json['valor23'] ?? 0,
      valor24: json['valor24'] ?? 0,
      valor25: json['valor25'] ?? 0,
      valor26: json['valor26'] ?? 0,
      valor27: json['valor27'] ?? 0,
      valor28: json['valor28'] ?? 0,
      valor29: json['valor29'] ?? 0,
      valor30: json['valor30'] ?? 0, 
      tipo: '',
  );
}

 @override
  String toString() {
    return 
    'Flavors{id: $id, type: $type, nome: $nome, grupo: $grupo, '
    'valor1: $valor1, valor2: $valor2, valor3: $valor3, valor4: $valor4, valor5: $valor5, '
    'valor6: $valor6, valor7: $valor7, valor8: $valor8, valor9: $valor9, valor10: $valor10, '
    'valor11: $valor11, valor12: $valor12, valor13: $valor13, valor14: $valor14, valor15: $valor15, '
    'valor16: $valor16, valor17: $valor17, valor18: $valor18, valor19: $valor19, valor20: $valor20, '
    'valor21: $valor21, valor22: $valor22, valor23: $valor23, valor24: $valor24, valor25: $valor25, '
    'valor26: $valor26, valor27: $valor27, valor28: $valor28, valor29: $valor29, valor30: $valor30}';
  }
  static where(Function(dynamic p) param0) {}

  toLowerCase() {}
}

class SaborSelecionadoComFracao {
  final Flavors sabor;
  double fracao; 

  SaborSelecionadoComFracao({
    required this.sabor, 
    required this.fracao
  });
}

class Fatias {
  String nome;
  int id; 

  Fatias({
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