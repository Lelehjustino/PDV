import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:nubi_pdv/core/database/datasources/produtos_sqlite_datasource.dart';
import 'package:nubi_pdv/core/database/data_produtos_contains.dart';
import 'package:nubi_pdv/core/database/domain/entities/produto_entity.dart';
import 'package:nubi_pdv/core/database/mobx_store/produto_store.dart';
import 'package:nubi_pdv/core/database/models/produto_3_model.dart';
import 'package:nubi_pdv/src/controllers/pedido.controller.dart';
import 'package:nubi_pdv/src/controllers/theme_controller.dart';
import 'package:nubi_pdv/src/views/produtos_registrados_layout.dart';
import 'package:provider/provider.dart';

class InserirProdutos extends StatefulWidget {
  const InserirProdutos({super.key});

  @override
  State<InserirProdutos> createState() => InserirProdutosState();
}

class InserirProdutosState extends State<InserirProdutos> {

  final produtoStore = GetIt.I.get<ProdutoStore>();

  @override
  Widget build(BuildContext context) {
    
   // final pedidoController = Provider.of<PedidoController>(context, listen: true); 
   final themeController = context.read<ThemeController>();
   bool isProcessing = false;

      return Scaffold(
      backgroundColor: themeController.onTertiary,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false, // botão de voltar

        // Botão manual de voltar + título
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: themeController.onSecondary,
          onPressed: () {
            Navigator.push(
              context, 
              MaterialPageRoute(
                builder: (context) => ProdutosRegistradosLayout(),
              ),
            );
          },
        ),

        // Text de conferir o pedido
        title: Text(
          'Inserir produtos',
          style: TextStyle(
            color: themeController.onSecondary,
            fontSize: 22,
            fontWeight: FontWeight.w400,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Text nome
              TextFormField(
                controller: produtoStore.nomeController,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  labelText: 'Nome'
                ),
                onChanged: (value) => produtoStore.atualizarNome(nome: value),
              ),

              SizedBox(height: 30,),

              // Text Descrição
              TextFormField(
                controller: produtoStore.descricaoController,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  labelText: 'Descrição'
                ),
                onChanged: (value) => produtoStore.atualizarDescricao(descricao: value),
              ),

              SizedBox(height: 30,),

              // Text Valor
              TextFormField(
                controller: produtoStore.valorController,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  labelText: 'Valor'
                ),
                onChanged: (value) => produtoStore.atualizarValor(valor: value),
              ),

              SizedBox(height: 30,),
            
              // Botão Salvar produto
              AbsorbPointer(
                absorbing: isProcessing,
                child: Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Observer(builder: (_){
                    return ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: themeController.primary,
                      foregroundColor: themeController.onPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  
                    onPressed: produtoStore.dadosPreenchidos ? botaoGravar : null,
                  
                    icon: Icon(Icons.save),
                    label: Text(
                      "Salvar produto",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  );
                })
                            ),
              ),
            SizedBox(height: 15,),
            ],
          ),
        ),
      ),
    );
  }
  botaoGravar() async {
    final produtoStore = GetIt.I.get<ProdutoStore>();
    await ProdutosSqliteDatasource().save(
      Produto3Model(
        produtoId: produtoStore.produtoId,
        nome: produtoStore.nome, 
        descricao: produtoStore.descricao, 
        valor: produtoStore.valor,
    ));

    

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text( _mensagemDeGravacao()),
    ));
    Navigator.push(
      context, 
      MaterialPageRoute(
        builder: (context) => ProdutosRegistradosLayout(),
      ),
    );
    
  }

  _mensagemDeGravacao() {
    final produtoStore = GetIt.I.get<ProdutoStore>();
    if(produtoStore.produtoId == null || produtoStore.produtoId == 0){
      return 'Produto registrado';
    }
    return 'Produto atualizado';
  }
}
