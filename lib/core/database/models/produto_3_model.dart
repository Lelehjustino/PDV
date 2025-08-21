import 'package:nubi_pdv/core/database/data_produtos_contains.dart';
import 'package:nubi_pdv/core/database/domain/entities/produto_entity.dart';

class Produto3Model extends ProdutoEntity{
  Produto3Model({
    produtoId, 
    required nome, 
    required descricao, 
    required valor
  }) :super(
      produtoId: produtoId,
      nome: nome,
      descricao: descricao,
      valor: valor,
    );

    Map<String, dynamic> toMap(){
      return {
        KPRODUTOS_COLUMN_PRODUTOID: produtoId,
        KPRODUTOS_COLUMN_NOME: nome,
        KPRODUTOS_COLUMN_DESCRICAO: descricao,
        KPRODUTOS_COLUMN_VALOR: valor, 
      };
    }
    
    factory Produto3Model.fromMap(Map <String, Object?> map ){
      return Produto3Model(
        produtoId: (map[KPRODUTOS_COLUMN_PRODUTOID] as num ).toInt(),
        nome: map[KPRODUTOS_COLUMN_NOME], 
        descricao: map[KPRODUTOS_COLUMN_DESCRICAO], 
        valor: (map[KPRODUTOS_COLUMN_VALOR] as num ).toDouble(),
      );
    }
}