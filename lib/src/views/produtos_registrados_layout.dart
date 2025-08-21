import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:nubi_pdv/core/database/constants/urls_contants.dart';
import 'package:nubi_pdv/core/database/datasources/produtos_sqlite_datasource.dart';
import 'package:nubi_pdv/core/database/mobx_store/produto_store.dart';
import 'package:nubi_pdv/core/database/models/produto_3_model.dart';
import 'package:nubi_pdv/src/controllers/pedido.controller.dart';
import 'package:nubi_pdv/src/controllers/theme_controller.dart';
import 'package:nubi_pdv/src/views/inserir_produtos.dart';
// import 'package:nubi_pdv/src/views/layout_totem.dart';
import 'package:nubi_pdv/src/views/senha_correta_layout.dart';
import 'package:provider/provider.dart';

class ProdutosRegistradosLayout extends   StatelessWidget {
  const ProdutosRegistradosLayout({super.key});

  @override

  Widget build(BuildContext context) {
      final pedidoController = Provider.of<PedidoController>(context, listen: true); 
      final themeController = context.read<ThemeController>();
      final ScrollController scrollController = ScrollController();
      // final produtoStore = GetIt.I.get<ProdutoStore>();
      
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
                builder: (context) => SenhaCorretaLayout(),
              ),
            );
          },
        ),

        // Text de conferir o pedido
        title: Text(
          'Produtos registrados',
          style: TextStyle(
            color: themeController.onSecondary,
            fontSize: 22,
            fontWeight: FontWeight.w400,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(padding: EdgeInsets.only(top: 30),
        child: FutureBuilder(
          future: ProdutosSqliteDatasource().getAll(),
          builder: 
            (BuildContext context, AsyncSnapshot<List<Produto3Model>> snapshot){
              // Verifica se o app ainda está esperando o resultado do Future
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(color: themeController.primary),
                );
              }
              // Verifica se deu erro ao carregar os dados.
              if (snapshot.hasError) {
                return Center(child: Text('Erro ao carregar os produtos.'));
              }
              // Verifica se não tem nenhum dado ainda
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('Nenhum produto registrado.'));
              }
              return ScrollbarTheme(
              data: ScrollbarThemeData(
                thumbColor: WidgetStateProperty.all(themeController.tertiary),
                trackColor: WidgetStateProperty.all(themeController.surface),
                radius: const Radius.circular(16),
                thickness: WidgetStateProperty.all(20), // espessura do scroll
              ),
              child: Scrollbar(
                controller: scrollController,
                thumbVisibility: true,
                trackVisibility: true,
                interactive: true,
                scrollbarOrientation: ScrollbarOrientation.right,
                child: ListView.builder(
                  controller: scrollController,
                  padding: const EdgeInsets.only(right: 16, top: 8, bottom: 80), 
                  physics: const BouncingScrollPhysics(),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final Produto3Model produto = snapshot.data![index];
                    return InkWell(
                      onTap: () {
                        final _produtoStore = GetIt.I.get<ProdutoStore>();
                        final produtoSelecionado = Produto3Model(
                          produtoId: produto.produtoId,
                          nome: produto.nome,
                          valor: produto.valor,
                          descricao: produto.descricao,
                        );
                        _produtoStore.inicializarFormulario(produto: produtoSelecionado);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => InserirProdutos(),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8, right: 4, bottom: 4),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: themeController.primary,
                                shape: BoxShape.circle,
                              ),
                              child: CircleAvatar(
                                backgroundColor: themeController.surface,
                                radius: 25,
                                backgroundImage: const AssetImage(KSEN_IMAGEM_URL),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    produto.nome,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: themeController.onSurface,
                                    ),
                                  ),
                                  Text(
                                    produto.descricao,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: themeController.onSurface,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(child: Container()),
                            Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Texto do valor
                                Text(
                                  _valorEmMoedaCorrente(
                                    context: context,
                                    valor: produto.valor,
                                  ),
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: themeController.onSurface,
                                  ),
                                ),

                                // Ícone de lixeira
                                IconButton(
                                  icon: Icon(
                                    Icons.delete,
                                    color: themeController.onError, 
                                  ),
                                  onPressed: () {
                                      pedidoController.showCustomDialog(
                                      context: context,
                                      icon: Icons.delete_outline, // Icone
                                      message: 'Deseja remover este produto?\n${produto.nome}',
                                      cancelText: 'Cancelar', // texto de cancelar ação 
                                      confirmText: 'Remover', // texto de prosseguir ação 
                                      onConfirm: () { // quando clicar em 'Remover' 
                                        ProdutosSqliteDatasource().deleteProduto( // deleta produto da BASE 
                                          Produto3Model(
                                            nome: produto.nome, 
                                            descricao: produto.descricao, 
                                            valor: produto.valor,
                                            produtoId: produto.produtoId,
                                          ),
                                        );
                                        Navigator.push(
                                          context,
                                          PageRouteBuilder(
                                            transitionDuration: Duration.zero, // sem duração
                                            reverseTransitionDuration: Duration.zero, // sem duração ao voltar
                                            pageBuilder: (context, animation, secondaryAnimation) => ProdutosRegistradosLayout(),
                                            transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                              return child; // retorna direto, sem animação
                                            },
                                          ),
                                        );
                                        // Navigator.push(
                                        //   context, 
                                        //   MaterialPageRoute(
                                        //     builder: (context) => ProdutosRegistradosLayout(),
                                        //   ),
                                        // );
                                      },    
                                      onCancel: () { 
                                        Navigator.push(
                                            context, 
                                            MaterialPageRoute(
                                              builder: (context) => ProdutosRegistradosLayout(),
                                            ),
                                          );
                                        }, 
                                        themeController: themeController,
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                            // Padding(
                            //   padding: const EdgeInsets.all(12.0),
                            //   child: Text(
                            //     _valorEmMoedaCorrente(
                            //       context: context,
                            //       valor: produto.valor,
                            //     ),
                            //     style: TextStyle(
                            //       fontSize: 16,
                            //       color: themeController.onSurface,
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          }, 
        ),
      ),
      floatingActionButton: 
      // FloatingActionButton.large(
      FloatingActionButton(
        backgroundColor: themeController.secondary,
        onPressed: (){
          final _produtoStore = GetIt.I.get<ProdutoStore>();
          _produtoStore.reinicializarFormulario();
          Navigator.push(
            context, 
            MaterialPageRoute(
              builder: (context) => InserirProdutos(),
            ),
          );
        },
        child: Icon(
          Icons.add,
          color: themeController.onSecondary,
          size: 30,
        ),
      ),
    );
  }
  _valorEmMoedaCorrente({required BuildContext context, required double valor}){
    final formatadorDeValor = NumberFormat.simpleCurrency(locale: Intl.defaultLocale);

    return formatadorDeValor.format(valor);
  }
}