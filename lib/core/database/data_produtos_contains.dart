import 'dart:ffi';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

// Constante nome das tabelas 
const String KDATABASE_NAME = 'teste.db';

const String KPRODUTOS_TABLE_NAME = 'produtos'; 

// Constantes para o produto 
const String KPRODUTOS_COLUMN_PRODUTOID = 'produtoId';
const String KPRODUTOS_COLUMN_NOME = 'nome';
const String KPRODUTOS_COLUMN_DESCRICAO = 'descricao';
const String KPRODUTOS_COLUMN_VALOR = 'valor';

const String KCREATE_PRODUTOS_TABLE_SCRIPT = '''
  CREATE TABLE $KPRODUTOS_TABLE_NAME (
    $KPRODUTOS_COLUMN_PRODUTOID INTEGER PRIMARY KEY,
    $KPRODUTOS_COLUMN_NOME TEXT,
    $KPRODUTOS_COLUMN_DESCRICAO TEXT,
    $KPRODUTOS_COLUMN_VALOR REAL
  )
''';

// const String KCREATE_PRODUTOS_TABLE_SCRIPT = '''
//   CREATE TABLE $KPRODUTOS_TABLE_NAME 
//   (
//     $KPRODUTOS_COLUMN_PRODUTOID INTEGER PRIMARY KEY,
//     $KPRODUTOS_COLUMN_NOME TEXT,
//     $KPRODUTOS_COLUMN_DESCRICAO TEXT,
//     $KPRODUTOS_COLUMN_VALOR REAL, 
//   )
// ''';
