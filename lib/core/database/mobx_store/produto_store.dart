import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:nubi_pdv/core/database/models/produto_3_model.dart';

// flutter packages pub run build_runner watch

part 'produto_store.g.dart';

class ProdutoStore = _ProdutoStore with _$ProdutoStore;

abstract class _ProdutoStore with Store {

  // #region CONTROLLERS
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController descricaoController = TextEditingController();
  final TextEditingController valorController = TextEditingController();

  reinicializarFormulario() {
    nomeController.clear();
    valorController.clear();
    descricaoController.clear();
    _nome = '';
    _descricao = '';
    _valor = 0;
    _produtoId = null;

    print('Limpou tudo agora');
  }

  inicializarFormulario({required Produto3Model produto}) {
    nomeController.text = produto.nome;
    descricaoController.text = produto.descricao;
    valorController.text = produto.valor.toString();

    atualizarNome(nome: produto.nome);
    atualizarDescricao(descricao: produto.descricao);
    atualizarValor(valor: produto.valor.toString());
    atualizarProdutoId(produtoId: produto.produtoId!);
  }
  // #endregion

  // #region região _produtoId
    @observable
    int? _produtoId;

    @computed
    int get produtoId => _produtoId ?? 0;

    @action
    atualizarProdutoId({required int produtoId}) {
      _produtoId = produtoId;
    }
  // #endregion

  // #region região nome
    @observable
    String? _nome;

    @computed
    String get nome => _nome ?? '';

    @action
    atualizarNome({required String nome}) {
      _nome = nome;
    }
  // #endregion

  // #region região descrição
    @observable
    String? _descricao;

    @computed
    String get descricao => _descricao ?? '';

    @action
    atualizarDescricao({required String descricao}) {
      _descricao = descricao;
    }
  // #endregion

  // #region região valor
    @observable
    double? _valor;

    @computed
    double get valor => _valor ?? 0;

    @action
    atualizarValor({required String valor}) {
      _valor = double.tryParse(valor);
    }
  // #endregion

  // #region bool para dadosPreenchidos
    @computed
    bool get dadosPreenchidos =>
      nome.isNotEmpty && descricao.isNotEmpty && valor > 0;
  // #endregion
}
