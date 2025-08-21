import 'package:get_it/get_it.dart';
import 'package:nubi_pdv/core/database/data_produtos_contains.dart';
import 'package:nubi_pdv/core/database/domain/entities/produto_entity.dart';
import 'package:nubi_pdv/core/database/mobx_store/produto_store.dart';
import 'package:nubi_pdv/core/database/datasources/produtos_sqlite_datasource.dart';
import 'package:nubi_pdv/src/controllers/layout_totem_controller.dart';
import 'package:nubi_pdv/src/views/layout_totem.dart';

class GlobalController {
  late LayoutTotemController LayoutTotemcontroller;

  // --- 1. Construtor privado ---
  GlobalController._privateConstructor();

  // --- 2. Instância única (singleton) ---
  static final GlobalController _instance = GlobalController._privateConstructor();

  // --- 3. Getter público para acessar a instância ---
  static GlobalController get instance => _instance;
  
  final produtoStore = GetIt.I.get<ProdutoStore>();

  // --- 5. Inicializador ---
  void inicializaLayoutTotem() {
    LayoutTotemcontroller = LayoutTotemController();
    // produtoStore.atualizarNome(nome: nome);
    // produtoStore.atualizarDiversidadesabores(diversidadesabores: diversidadesabores);
    // produtoStore.atualizarGrupo(grupo: grupo);
    // produtoStore.atualizarNumero(numero: numero);
    // produtoStore.atualizarNumeroTamanhoPizzaFK(numeroTamanhoPizza_FK: numeroTamanhoPizza_FK);
    // produtoStore.atualizarType(type: type);
    // produtoStore.atualizarUnidade(unidade: unidade);
    // produtoStore.atualizarValor(valor: valor);
    // ProdutosSqliteDatasource().create(
    //   ProdutoEntity(
    //     nome: produtoStore.nome, 
    //     valor: produtoStore.valor, 
    //     unidade: produtoStore.unidade, 
    //     grupo: produtoStore.grupo, 
    //     type: produtoStore.type, 
    //     diversidadesabores: produtoStore.diversidadesabores, 
    //     numeroTamanhoPizza_FK: produtoStore.numeroTamanhoPizza_FK,
    //   ),
    // );
  }
}


