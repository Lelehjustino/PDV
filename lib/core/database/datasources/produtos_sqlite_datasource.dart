import 'package:nubi_pdv/core/database/datasources/data_general_constants.dart';
import 'package:nubi_pdv/core/database/data_produtos_contains.dart';
import 'package:nubi_pdv/core/database/domain/entities/produto_entity.dart';
import 'package:nubi_pdv/core/database/models/produto_3_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class ProdutosSqliteDatasource {
  // Função para criar base de dados 
  Future<Database> _getDataBase() async {
    return openDatabase(
      join(await getDatabasesPath(), KDATABASE_NAME),
      onCreate: (db, version) async {
        await db.execute(KCREATE_PRODUTOS_TABLE_SCRIPT);

        // Inserindo um exemplo
        await db.rawInsert('''
          INSERT INTO $KPRODUTOS_TABLE_NAME (
            $KPRODUTOS_COLUMN_NOME,
            $KPRODUTOS_COLUMN_DESCRICAO,
            $KPRODUTOS_COLUMN_VALOR
          )
          VALUES (
            'Suco de laranja', '300 ml - Natural', 5
          )
        ''');
      },
      version: KDATABASE_VERSION,
    );
  }

  // Função para criar um produto de maneira privada 
  Future _create(ProdutoEntity produto) async {
  print("Entrou na função _create"); // DEBUG 1

  try {
    final Database db = await _getDataBase();
    print("Banco obtido com sucesso"); // DEBUG 2

    produto.produtoId = await db.rawInsert('''
      INSERT INTO $KPRODUTOS_TABLE_NAME (
        $KPRODUTOS_COLUMN_NOME,
        $KPRODUTOS_COLUMN_DESCRICAO,
        $KPRODUTOS_COLUMN_VALOR
      )
      VALUES (
        '${produto.nome}',  
        '${produto.descricao}',
        ${produto.valor}
      )
    ''');
    
      // print("Produto inserido com sucesso, id: ${produto.produtoId}"); // DEBUG 3
      // print(await getDatabasesPath());

    } catch (ex, stacktrace) {
      // print("Erro ao inserir produto: $ex");
      // print("Stacktrace: $stacktrace"); // DEBUG detalhado
    }
  }

  // Função que retorna a lista de produtos 
  Future<List<Produto3Model>> getAll() async {
     try {
      final Database db = await _getDataBase();
      final List<Map<String, dynamic>> produtosMap = await db.query(
        KPRODUTOS_TABLE_NAME, 
        orderBy: '$KPRODUTOS_COLUMN_PRODUTOID ASC',
        );

      return List.generate(produtosMap.length, (index){
        return Produto3Model.fromMap(produtosMap[index]);
      });
    } catch (ex) {
      return List.empty();
    }
  }

  // Função para atualizar produto de maneira privada
  Future _update(Produto3Model produto) async {
    try{
      final Database db = await _getDataBase();

      await db.update(
        KPRODUTOS_TABLE_NAME, 
        produto.toMap(),
        where: '$KPRODUTOS_COLUMN_PRODUTOID = ?',
        whereArgs: [produto.produtoId]
      );
    }
    catch(ex){
      return;
    }
  }

  // Função save
  Future save (Produto3Model produto) async{
    if(produto.produtoId == 0){
      await _create(produto);
    } else {
      await _update(produto);
    }
  }

  // Função deletar produtos 
  Future <void> deleteProduto (Produto3Model produto) async {
    final db = await _getDataBase();
      await db.delete(
      KPRODUTOS_TABLE_NAME,
      where: '$KPRODUTOS_COLUMN_PRODUTOID = ?',
      whereArgs: [produto.produtoId],
    );
  }

}