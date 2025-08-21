import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:nubi_pdv/src/controllers/pedido.controller.dart';
import 'package:nubi_pdv/src/controllers/theme_controller.dart';
import 'package:nubi_pdv/src/models/flavors_model.dart';
import 'package:nubi_pdv/src/models/pedido_model.dart';
import 'package:nubi_pdv/src/models/products_model.dart';
import 'package:nubi_pdv/src/services/api_service.dart';
import 'package:nubi_pdv/src/views/carrinho_layout.dart';
import 'package:provider/provider.dart';

class LayoutPizza extends StatefulWidget {
  final Pizza pizza;
  const LayoutPizza({super.key, required this.pizza,});

  @override
  State<LayoutPizza> createState() => _LayoutPizzaState();
}

class _LayoutPizzaState extends State<LayoutPizza> {
  // Declara uma variável pizza que será preenchida depois.
  late Pizza pizza;
  late Product produto;  
  late Flavors sabor;
  late Grupo grupo;
  
  // Para filtrar os sabores confrome o grupo 
  List<Flavors> saboresFiltrados = []; // GUARDA APENAS OS SABORES DO GRUPO SELECIONADO

  // Essas são variáveis pra guardar o que o usuário escolheu: grupo, tamanho e sabor.
  late Grupo grupoSelecionado;
  late String tamanhosSelecionados;
  List<Flavors> saboresSelecionados = [];
  Map<Flavors, int> bordasSelecionadas = {};
  Map<Flavors, int> saboresSelecionados2 = {};

  List fatiasSelecionadas = [];

  // Lista de grupos de pizzas (ex: Tradicional)
  List<Grupo> gruposDisponiveis = [];
  List<Product> tamanhosDisponiveis = [];
  List<Flavors> saboresDisponiveis = [];
  
  // ScrollController
  final ScrollController saboresScrollController = ScrollController();

  // Controlardor de fatias 
  List fatiasDisponiveis = [];
  int totalFatiasPizza = 16;

  @override
  void initState() {
    super.initState();
    pizza = widget.pizza;
    tamanhosSelecionados = pizza.nome; 

    // Carrega os grupos do servidor com carregarGrupos()
    carregarGrupos();
    // Carrega os tamanhos do servidor com carregarTamanhos()
    carregarTamanhos();
    // Carrega os sabores do servidor com carregarSabores()
    carregarSabores();
    // Função que filtra os Sabores por grupo 
    filtrarSaboresPorGrupo();

  }
  
  // Pega os grupos da API 
  Future<void> carregarGrupos() async {
    var resposta = await ApiService.getGrupo(); // Pede os grupos do servidor
    setState(() {
      gruposDisponiveis = resposta.where((grupo) => grupo.type == 'PZ').toList(); // Filtra só os grupos do tipo pizza (type == 'PZ')
      if (gruposDisponiveis.isNotEmpty) {
        grupoSelecionado = gruposDisponiveis.first; // Pega o primeiro grupo da lista como padrão 
        pizza.grupo = grupoSelecionado.name; // Salva isso na pizza
      }
    });
  }
 

 // Pegar tamanhos da API 
  Future<void> carregarTamanhos() async {
    var resposta2 = await ApiService.getProducts(); // Pega os produtos do servidor
    setState(() {
      tamanhosDisponiveis = resposta2.where((produto) => produto.type == 'PZ').toList();
      if (tamanhosDisponiveis.isNotEmpty) {
        pizza.nome = tamanhosSelecionados;
      }
    });
  }
  
  // Função para carregar os sabores 
  Future<void> carregarSabores() async {
    try {
        final resposta = await ApiService.getFlavors();
        setState(() {
          // Aqui você pode filtrar os sabores por grupo, se quiser:
          // saboresDisponiveis = resposta.where((s) => s.grupoId == grupoSelecionado.id).toList();
          saboresDisponiveis = resposta;
          // sabor = saboresDisponiveis[0]; // Define o sabor também
        });
        filtrarSaboresPorGrupo(); // ← já filtra aqui também
    } catch (e) {
      print('Erro ao carregar sabores no layout pizza: $e');
    }
  }

  // Função para criar um produto a partir da Pizza
  Product criarProdutoPizza() {
     final tamanhoSelecionado = tamanhosDisponiveis.firstWhere(
    (t) => t.nome == tamanhosSelecionados,
    orElse: () => tamanhosDisponiveis.first,
  );

  final totalFatias = saboresSelecionados2.values.fold(0, (a, b) => a + b);

  final nomesDosSabores = saboresSelecionados2.entries
    .map((entry) {
      final quantidade = entry.value;
      final fracao = totalFatias == 1
        ? '$quantidade'
        : '$quantidade/$totalFatias';
      return '$fracao ${entry.key.nome}';
    })
    .join('\n');

    return Product(
      numero: 0,
      nome: '${pizza.nome}' + '\n$nomesDosSabores',
      valor: pizza.valor,
      unidade: 1, // ou 1 se for sempre 1 unidade
      grupo: grupoSelecionado.id,
      type: grupoSelecionado.type, 
      diversidadesabores: tamanhoSelecionado.diversidadesabores, 
      numeroTamanhoPizza_FK: 0,
    );
  }

  // Função para criar um Item a partir do ItemPizza
  Item criarItemPizza() {
    final produtoCriado = criarProdutoPizza();

    // Convertendo as bordas selecionadas para a lista de adicionais
     final tamanhoSelecionado = tamanhosDisponiveis.firstWhere(
      (t) => t.nome == tamanhosSelecionados,
      orElse: () => tamanhosDisponiveis.first,
    );
    final numeroTamanho = tamanhoSelecionado.numero;

    final List<Adicional> adicionaisSelecionados = bordasSelecionadas.entries
      .where((entry) => entry.value > 0)
      .map((entry) => Adicional(
        nome: entry.key.nome,
        quantidade: entry.value,
        valor: getValorSaborPorTamanho(entry.key, numeroTamanho), // valor da borda com base no tamanho
      ))
      .toList();
    return Item(
      id: 0,
      product: produtoCriado,
      unitPrice: pizza.valor,
      totalPrice: pizza.valor * pizza.quantidade,
      quantidade: pizza.quantidade,
      adicionais: adicionaisSelecionados, // bordas e / ou outros adicionais 
      observacoes: [], // se não tiver observacoes aqui
    );
  }
  
   void limparPizzaSelecionada() {
    setState(() {
      // Limpa os sabores selecionados
      saboresSelecionados.clear();
      saboresSelecionados2.clear(); // Limpa também o mapa auxiliar

      // Limpa as bordas selecionadas
      bordasSelecionadas.clear();

      // Redefine o grupo selecionado para o primeiro disponível, se houver
      if (gruposDisponiveis.isNotEmpty) {
        grupoSelecionado = gruposDisponiveis.first;
        pizza.grupo = grupoSelecionado.name; // atualiza o grupo
        filtrarSaboresPorGrupo(); // Atualiza a lista de sabores disponíveis com base no novo grupo
      }

      // Redefine o tamanho selecionado para o tamanho inicial da pizza (ou o primeiro disponível)
      if (tamanhosDisponiveis.isNotEmpty) {
        tamanhosSelecionados = widget.pizza.nome; // Volta ao tamanho original da pizza
        pizza.nome = tamanhosSelecionados;
        pizza.valor = 0.0; // Ou o valor inicial da pizza sem sabores/bordas selecionados
      } else {
        pizza.valor = 0.0;
      }

      pizza.quantidade = 1; // Reseta a quantidade da pizza para 1
    });
  }

  // Função para filtrar sabores conforme os grupos 
  void filtrarSaboresPorGrupo() {
    setState(() {
      saboresFiltrados = saboresDisponiveis.where((sabor) => sabor.numerogrupo_FK == grupoSelecionado.id).toList();
    });
  }
  

  // Função atualizarValorPizzaMedia – Calcula a média dos valores dos sabores selecionados - LÓGICA VALOR PIZZA 1
  void atualizarValorPizzaMedia() {
    pizza.valor = 0.0;

    final tamanhoSelecionado = tamanhosDisponiveis.firstWhere(
      (t) => t.nome == tamanhosSelecionados,
      orElse: () => tamanhosDisponiveis.first,
    );

    final numeroTamanho = tamanhoSelecionado.numero;

    double valor = 0.0;
    final totalFatias = saboresSelecionados2.values.fold(0, (a, b) => a + b);
    if (totalFatias > 0) {
      saboresSelecionados2.forEach((sabor, qtd) {
        valor += getValorSaborPorTamanho(sabor, numeroTamanho) * (qtd / totalFatias);
      });
      valor += tamanhoSelecionado.valor;
    }

    // Sempre soma a borda, mesmo que não tenha sabor
    if (bordasSelecionadas.isNotEmpty) {
      bordasSelecionadas.forEach((borda, qtd) {
        valor += getValorSaborPorTamanho(borda, numeroTamanho) * qtd;
      });
    }

    pizza.valor = valor;
  }

  // Função atualizarValorPizzaMaior – Pega sempre o maior valor - LÓGICA VALOR PIZZA 2
  void atualizarValorPizzaMaior() {
    pizza.valor = 0.0;

    final tamanhoSelecionado = tamanhosDisponiveis.firstWhere(
      (t) => t.nome == tamanhosSelecionados,
      orElse: () => tamanhosDisponiveis.first,
    );

    final numeroTamanho = tamanhoSelecionado.numero;

    double valor = 0.0;

    // Se tiver sabores, pega o mais caro
    if (saboresSelecionados.isNotEmpty) {
      final saborMaisCaro = saboresSelecionados.reduce((a, b) =>
        getValorSaborPorTamanho(a, numeroTamanho) > getValorSaborPorTamanho(b, numeroTamanho) ? a : b);

      valor += getValorSaborPorTamanho(saborMaisCaro, numeroTamanho);
    }

    // Sempre soma a borda, independente de ter sabor ou não
    if (bordasSelecionadas.isNotEmpty) {
      bordasSelecionadas.forEach((borda, qtd) {
        valor += getValorSaborPorTamanho(borda, numeroTamanho) * qtd;
      });
    }

    pizza.valor = valor;
  }

  // Função atualizarValorPizzaPonderada – Calcula a média ponderada dos valores dos sabores selecionados - LÓGICA VALOR PIZZA 3
  void atualizarValorPizzaPonderada() {
    pizza.valor = 0.0;

    final tamanhoSelecionado = tamanhosDisponiveis.firstWhere(
      (t) => t.nome == tamanhosSelecionados,
      orElse: () => tamanhosDisponiveis.first,
    );

    final numeroTamanho = tamanhoSelecionado.numero;
    double valor = 0.0;

    // Se houver sabores, calcula a média ponderada (nesse caso, mesma média simples) + valor do tamanho
    if (saboresSelecionados.isNotEmpty) {
      final total = saboresSelecionados.fold<double>(
        0.0,
        (soma, s) => soma + getValorSaborPorTamanho(s, numeroTamanho),
      );

      final mediaSabores = total / saboresSelecionados.length;
      valor += mediaSabores + tamanhoSelecionado.valor;
    }

    // Sempre soma a borda
    if (bordasSelecionadas.isNotEmpty) {
      bordasSelecionadas.forEach((borda, qtd) {
        valor += getValorSaborPorTamanho(borda, numeroTamanho) * qtd;
      });
    }

    pizza.valor = valor.ceilToDouble(); // Arredonda pra cima como antes
  }

  //FUNÇÃO VALOR DE ACORDO COM TAMANHO 
  double getValorSaborPorTamanho(Flavors sabor, int numeroTamanho) {
    switch (numeroTamanho) {
      case 1:
        return sabor.valor1.toDouble();
      case 2:
        return sabor.valor2.toDouble();
      case 3:
        return sabor.valor3.toDouble();
      case 4:
        return sabor.valor4.toDouble();
      default:
        return 0.0;
    }
  }

  // Cores dos sabores 
  Map<Flavors, Color> mapearCoresSabores(Map<Flavors, int> saboresSelecionados2, ThemeController themeController) {
    final List<Color> coresBase = [
      themeController.primaryContainer,
      themeController.secondaryContainer,
      themeController.tertiaryContainer,
      themeController.surfaceDim,
    ];

    final Map<Flavors, Color> mapaCores = {};
    int corIndex = 0;

    for (var sabor in saboresSelecionados2.keys) {
      mapaCores[sabor] = coresBase[corIndex % coresBase.length];
      corIndex++;
    }

    return mapaCores;
  }

  Map<Flavors, Color> mapearCoresBordas(Map<Flavors, int> bordasSelecionadas, ThemeController themeController) {
    final List<Color> coresBorda = [
      themeController.onPrimaryContainer,
      themeController.onSecondaryContainer,
      themeController.onTertiaryContainer,
      themeController.surfaceBright,
    ];

    final Map<Flavors, Color> mapaCores = {};
    int corIndex = 0;

    for (var borda in bordasSelecionadas.keys.where((b) => bordasSelecionadas[b]! > 0)) {
      mapaCores[borda] = coresBorda[corIndex % coresBorda.length];
      corIndex++;
    }

    return mapaCores;
  }

  @override
  Widget build(BuildContext context) {
    final pedidoController = Provider.of<PedidoController>(context, listen: false);
    final themeController = context.read<ThemeController>();

    final mapaCoresSabores = mapearCoresSabores(saboresSelecionados2, themeController);
    final mapaCoresBordas = mapearCoresBordas(bordasSelecionadas, themeController);
    
    // Variáveis carregadas sem dar null ( : 0; / : []; )
    final tamanhoNumero = (tamanhosSelecionados.isNotEmpty && tamanhosDisponiveis.isNotEmpty)
      ? tamanhosDisponiveis.firstWhere(
          (t) => t.nome == tamanhosSelecionados,
          orElse: () => tamanhosDisponiveis.first,
        ).numero ?? 0
      : 0;

    final saboresDisponiveis = (tamanhoNumero > 0 && saboresFiltrados.isNotEmpty)
      ? saboresFiltrados
          .where((sabor) => getValorSaborPorTamanho(sabor, tamanhoNumero) > 0)
          .toList()
      : [];
  
    bool isProcessing = false;

    return Scaffold(
      backgroundColor: themeController.onTertiary,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          // Declara o tamanho da pizza 
          'Pizza ${pizza.nome}',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Center(
              // GRÁFICO + SABORES SELECIONADOS + VALOR TOTAL 
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                 SizedBox(
                  width: 300,
                  height: 300,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // TEXTO E GRÁFICO DA PIZZA 
                      // Texto central quando não há sabores
                      if (saboresSelecionados.isEmpty)
                        Text(
                          'Comece a montar sua pizza',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: themeController.onSurface.withOpacity(0.5),
                          ),
                          textAlign: TextAlign.center,
                        ),

                      // Camada da borda (anel externo)
                      if (bordasSelecionadas.isNotEmpty)
                        PieChart(
                          PieChartData(
                            sections: gerarBordaComoContorno(bordasSelecionadas, themeController, pizza),
                            sectionsSpace: 0,
                            centerSpaceRadius: 125,
                            startDegreeOffset: 0,
                          ),
                        ),

                      // Camada dos sabores (aparece apenas se houver sabores)
                      if (saboresSelecionados.isNotEmpty)
                        PieChart(
                          PieChartData(
                            sections: gerarFatiasPizza(saboresSelecionados2, themeController, pizza),
                            sectionsSpace: 0,
                            centerSpaceRadius: 0,
                            startDegreeOffset: 0,
                          ),
                        ),
                    ],
                  ),
                ),
                  SizedBox(width: 16),
                  if(saboresSelecionados2.isNotEmpty || bordasSelecionadas.isNotEmpty)
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.all(10), // margem externa
                      padding: EdgeInsets.all(12), // padding interno entre a borda e o conteúdo
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: themeController.onSurface.withOpacity(0.5), // cor da borda
                          width: 1, // espessura da borda
                        ),
                        borderRadius: BorderRadius.circular(10), // cantos arredondados (opcional)
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Sabores selecionados 
                          if(saboresSelecionados2.isNotEmpty || bordasSelecionadas.isNotEmpty)
                          Text("Sabores:", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          SizedBox(height: 4),
                          // APRESENTAÇÃO SABORES
                          ...(() { // É uma função anônima que é executada na hora.
                              // Conta quantos sabores foram escolhidos no total, incluindo repetições
                              final totalSabores = saboresSelecionados.length;
                              // final totalFatias = saboresSelecionados2.values.fold(0, (a, b) => a + b);
                              // Cria um novo mapa para agrupar sabores iguais e contar quantas vezes cada um aparece.
                              final Map<Flavors, int> saboresAgrupados = {};

                              // Prepara o índice da cor e a lista de fatias
                              int corIndex = 0;
                              for (var sabor in saboresSelecionados) {
                                saboresAgrupados[sabor] = (saboresAgrupados[sabor] ?? 0) + 1;
                              }
                              // print('SABORES AGRUPADOS: $saboresAgrupados');
                              // Pega cada sabor e a quantidade dele e transforma em um Text para mostrar na tela.
                              return saboresAgrupados.entries.map((entry) {
                                final quantidade = entry.value;
                                final fracao = (totalSabores == 1)
                                ? '$quantidade'
                                : '$quantidade/$totalSabores';
                                return Row(
                                  children: [
                                    Transform.rotate(
                                      angle: 0, // 0 = ponta para cima, pi = para baixo
                                      child: Icon(
                                        Icons.local_pizza,
                                        size: 20,
                                        color: mapaCoresSabores[entry.key],
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      '$fracao - ${entry.key.nome}',
                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                );
                              }).toList();
                            })(),
                            if(bordasSelecionadas.isNotEmpty)
                            Text("Bordas:", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                            // APRESENTAÇÃO BORDAS
                            if (bordasSelecionadas.isNotEmpty) // Só vai mostrar as bordas se alguma tiver sido escolhida
                            ...(() { // Função anônima que será executada na hora
                              // Soma todas as quantidades de bordas escolhidas
                              final totalBordas = bordasSelecionadas.values.fold(0, (a, b) => a + b);
                              // final List<Color> coresBorda = [
                              //     themeController.onPrimaryContainer,
                              //     themeController.onSecondaryContainer,
                              //     themeController.onTertiaryContainer,
                              //     themeController.surfaceBright,
                              //   ];
                                int corIndex = 0;
                             // Pega só as bordas que foram escolhidas  
                             return bordasSelecionadas.entries
                              .where((entry) => entry.value > 0)
                              .map((entry) { // Transforma cada borda num widget de texto
                                final quantidade = entry.value;
                                // final fracao = '$quantidade/$totalBordas';
                                final fracao = (totalBordas == 1)
                                ? '$quantidade'
                                : '$quantidade/$totalBordas';
                                return Row(
                                children: [
                                  Transform.rotate(
                                    angle: 0,
                                    child: Icon(
                                      Icons.circle_outlined,
                                      size: 20,
                                      color: mapaCoresBordas[entry.key],
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    '$fracao - ${entry.key.nome}',
                                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
                                  ),
                                ],
                              );
                                // return 
                                // Column(
                                //   children: [
                                //     Text(
                                //       '$fracao - ${entry.key.nome}',
                                //       style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
                                //     ),
                                //   ],
                                // );
                              }).toList();
                            })(),
                            SizedBox(height: 8),
                            // Valor total da pizza 
                            Center(
                              child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                'R\$ ${pizza.valor.toStringAsFixed(2)}',
                                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: themeController.primary),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 16),
            // Botões com os grupos de pizza ['TRADICIONAIS', 'EXCLUSIVAS', 'SELECOES' e 'BORDAS']
            Row( 
              children: gruposDisponiveis.map((grupoAtual) { // Vai criar um botão para cada grupo de pizza que está na lista
                final bool isSelected = grupoSelecionado == grupoAtual; //  Verifica se o botão é o que está selecionado agora, SE ESTIVER FICA COM COR DIFERENTE 
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    child: SizedBox(
                      height: 50,
                      child: AbsorbPointer(
                      absorbing: isProcessing,
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              grupoSelecionado = grupoAtual; // Atualiza o grupo selecionado
                              pizza.grupo = grupoAtual.name; // Chama filtrarSaboresPorGrupo() para mostrar só os sabores desse grupo // ERRO
                            });
                            filtrarSaboresPorGrupo();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isSelected ? themeController.primary : themeController.secondary,
                            foregroundColor: isSelected ? themeController.onPrimary : themeController.onSecondary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            grupoAtual.name,
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 8),
 
            // Texto 'Sabores disponíveis'
            Text('Sabores disponíveis', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
            SizedBox(height: 8),
            
            // Lista de sabores disponíveis com Scroll visível 
            Expanded(
              child: saboresDisponiveis.isNotEmpty
                ? ScrollbarTheme(
                data: ScrollbarThemeData(
                  thumbColor: WidgetStateProperty.all(themeController.tertiary),
                  trackColor: WidgetStateProperty.all(themeController.surface),
                  radius: Radius.circular(16),
                  thickness: WidgetStateProperty.all(20),
                ),
                child: Scrollbar(
                  controller: saboresScrollController,
                  thumbVisibility: true,
                  trackVisibility: true,
                  interactive: true,
                  scrollbarOrientation: ScrollbarOrientation.right,
                  child: GridView.builder(
                    controller: saboresScrollController,
                    padding: EdgeInsets.only(right: 30),
                    scrollDirection: Axis.vertical,
                    physics: AlwaysScrollableScrollPhysics(),
                    itemCount: saboresFiltrados.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      childAspectRatio: 1,
                    ),
                    itemBuilder: (context, index) {
                      final sabor = saboresFiltrados[index];
                      final bool ehBorda = sabor.type == 'B'; // Identifica quando é borda 
                      //  Atualiza lista linear de sabores selecionados
                      saboresSelecionados = saboresSelecionados2.entries
                        .expand((entry) => List.filled(entry.value, entry.key))
                        .toList();
                      // Calcula a quantidade do sabor
                      final int quantidade = ehBorda
                        ? (bordasSelecionadas[sabor] ?? 0)
                        : (saboresSelecionados2[sabor] ?? 0);
                      // Verifica se está selecionado
                      final bool selecionado = quantidade > 0;
                      return Container(
                        decoration: BoxDecoration(
                          color: selecionado ? themeController.primary.withOpacity(0.7) : themeController.surface,
                          border: Border.all(
                            color: selecionado ? themeController.primary.withOpacity(0.7) : themeController.surface,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                child: Center(
                                  // Sabor da pizza
                                  child: Text(
                                    sabor.nome,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: selecionado ? themeController.onPrimary : themeController.onSurface,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                            Text(
                              // Declara o preço da pizza 
                              'R\$ ${getValorSaborPorTamanho( // Função que recebe dois argumentos
                                sabor, 
                                tamanhosDisponiveis.firstWhere((t) => 
                                t.nome == tamanhosSelecionados, orElse: () => 
                                tamanhosDisponiveis.first).numero).toStringAsFixed(2)}',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: selecionado ? themeController.onPrimary : themeController.onSurface,
                                ),
                            ),
                            // Controlar de quantidade 
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                // Botão para remover
                                IconButton(
                                  icon: Icon(Icons.remove, size: 18),
                                  color: selecionado ? themeController.onPrimary : themeController.onSurface,
                                  onPressed: () {
                                    setState(() {
                                      if (ehBorda) {
                                        if (bordasSelecionadas.containsKey(sabor)) {
                                          bordasSelecionadas[sabor] = bordasSelecionadas[sabor]! - 1;
                                          if (bordasSelecionadas[sabor]! <= 0) {
                                            bordasSelecionadas.remove(sabor);
                                            atualizarValorPizzaMedia();
                                          }
                                        }
                                      } else {
                                        if (saboresSelecionados2.containsKey(sabor)) {
                                          saboresSelecionados2[sabor] = saboresSelecionados2[sabor]! - 1;
                                          if (saboresSelecionados2[sabor]! <= 0) {
                                            saboresSelecionados2.remove(sabor);
                                            atualizarValorPizzaMedia();
                                          }
                                          saboresSelecionados = saboresSelecionados2.entries
                                            .expand((entry) => List.filled(entry.value, entry.key))
                                            .toList();
                                        }
                                      }
                                      atualizarValorPizzaMedia();
                                    });
                                  },
                                ),

                                // Quantidade exibida
                               Text(
                                '${ehBorda ? (bordasSelecionadas[sabor] ?? 0) : (saboresSelecionados2[sabor] ?? 0)}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: selecionado ? themeController.onPrimary : themeController.onSurface,
                                  ),
                                ),

                                // Botão para adicionar
                                IconButton(
                                  icon: Icon(Icons.add, size: 18),
                                  color: selecionado ? themeController.onPrimary : themeController.onSurface,
                                 onPressed: () {
                                  setState(() {
                                    // Procura na lista tamanhosDisponiveis qual o tamanho selecionado 
                                    final tamanhoAtual = tamanhosDisponiveis.firstWhere(
                                      (t) => t.nome == tamanhosSelecionados,
                                      orElse: () => tamanhosDisponiveis.first,
                                    );
                                    // Número de sabores permitidos para esse tamanho de pizza
                                    final int limiteSabores = tamanhoAtual.diversidadesabores;

                                    if (ehBorda) { 
                                      // LÓGICA DAS BORDAS 
                                      final int totalBordasSelecionadas = bordasSelecionadas.values.fold(0, (a, b) => a + b); // Soma quantas bordas já foram escolhidas até agora
                                      final int quantidadeAtual = bordasSelecionadas[sabor] ?? 0; // Verifica quantas vezes essa borda específica já foi escolhida
                                      final bool outrosSaboresDeBorda = bordasSelecionadas.keys.any((k) => k != sabor); // Vê se tem outras bordas diferentes dessa já selecionadas
                                      final bool podeAdicionar = totalBordasSelecionadas < limiteSabores && // Não passou o limite
                                          (quantidadeAtual == 0 || (quantidadeAtual == 1 && outrosSaboresDeBorda)); // quantidadeAtual DESTA BORDA 

                                      if (podeAdicionar) { // Adiciona 1 a quantidade desta borda 
                                        bordasSelecionadas[sabor] = quantidadeAtual + 1;
                                      } else {
                                        pedidoController.showCustomDialog(
                                          context: context,
                                          icon: Icons.warning,
                                          message: 'Você pode escolher até $limiteSabores sabores de bordas para a pizza ${pizza.nome}.',
                                          confirmText: 'OK',
                                          onConfirm: () {},
                                          onCancel: () => Navigator.pop(context),
                                          themeController: themeController,
                                        );
                                      }
                                      // Atualiza o valor da pizza 
                                      atualizarValorPizzaMedia();
                                    } else {
                                      // LÓGICA DOS SABORES 
                                      final int totalFatiasSelecionadas = saboresSelecionados2.values.fold(0, (a, b) => a + b); // Soma quantas fatias já foram escolhidas com sabores
                                      // saboresSelecionados2 é um Map com String e Int, ele pegua os Ints e soma, tendo a quantidade de fatias que já foram escolhidas 

                                      final int saboresDiferentesSelecionados = saboresSelecionados2.length; // Conta quantos sabores diferentes foram escolhidos até agora
                                      // Conta quantos itens existem na lista, que são os sabores, ou seja, a quantidade de sabores selecionados 
                                      final int quantidadeAtual = saboresSelecionados2[sabor] ?? 0; // Ele verifica quantas fatias já foram atribuídas a um sabor específico
                                      // Pega o sabor e verfica quantas fatias estão sendo atribuidas a ele, a quantidade do sabor 

                                      final bool podeAdicionarFatias = totalFatiasSelecionadas < totalFatiasPizza; // Verifica se ainda tem fatias disponíveis pra adicionar mais sabores
                                      
                                      final bool podeAdicionarSabor = saboresSelecionados2.containsKey(sabor) || // Esse sabor já foi escolhido antes
                                          saboresDiferentesSelecionados < limiteSabores; // Se ainda cabe um sabor novo dentro do limite

                                      // Para impedir um único sabor ser selecionado duas vezes (Para isto não acontecer: CAIPIRA 2/2) 
                                      final bool impedidoPorSaborUnico =
                                          saboresDiferentesSelecionados == 1 && // Verifica se só tem um sabor diferente selecionado até agora
                                          saboresSelecionados2.containsKey(sabor) && // Verifica se o sabor que o usuário está tentando adicionar de novo já está presente
                                          quantidadeAtual > 0; // Garante que esse sabor já tem pelo menos 1 fatia atribuída
                                      
                                      // Se pode adicionar, aumenta a contagem desse sabor
                                      if (podeAdicionarFatias && podeAdicionarSabor && !impedidoPorSaborUnico) {
                                        saboresSelecionados2[sabor] = quantidadeAtual + 1;

                                        // Atualiza a lista expandida
                                        saboresSelecionados = saboresSelecionados2.entries.expand((e) => List.filled(e.value, e.key),).toList();
                                      } else {
                                        pedidoController.showCustomDialog(
                                          context: context,
                                          icon: Icons.warning,
                                          message: !podeAdicionarFatias // Se NÃO pode adicionar mais fatias
                                            ? 'Sua pizza já esta completa' // valor_se_verdadeiro
                                            : 'Você pode escolher até $limiteSabores sabores para a pizza ${pizza.nome}.', // valor_se_falso
                                          confirmText: 'OK',
                                          onConfirm: () {},
                                          onCancel: () => Navigator.pop(context),
                                          themeController: themeController,
                                        );
                                      }
                                      // Atualiza o preço da pizza com base nos sabores escolhidos
                                      atualizarValorPizzaMedia();
                                    }
                                  });
                                }
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              )
              :
                // Chama a função apenas uma vez após renderizar o frame
                Builder(
                  builder: (context) {
                    WidgetsBinding.instance.addPostFrameCallback((_) { //Este método registra uma função para ser executada APÓS o próximo frame de renderização
                      limparPizzaSelecionada();
                    });
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Text(
                          "Nenhum sabor disponível para este tamanho.",
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                        ),
                      ),
                    );
                  },
                ),
              ),
            // Lista de botões de TAMANHO  
            Row(
              children: tamanhosDisponiveis.map((tamanhoAtual) {
                final bool isSelected = tamanhosSelecionados == tamanhoAtual.nome;

                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    child: SizedBox(
                      height: 50,
                      child: AbsorbPointer(
                      absorbing: isProcessing,
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              final int novoLimite = tamanhoAtual.diversidadesabores;
                              final saboresDiferentesSelecionados = saboresSelecionados2.length;
                              final totalBordasSelecionadas = bordasSelecionadas.values.fold(0, (a, b) => a + b);
                        
                              // Validação: se passar do limite de sabores OU de bordas, mostra erro e cancela a troca
                              if (saboresDiferentesSelecionados > novoLimite || totalBordasSelecionadas > novoLimite) {
                                pedidoController.showCustomDialog(
                                  context: context,
                                  icon: Icons.warning,
                                  message: 'A Pizza ${tamanhoAtual.nome} permite no máximo $novoLimite sabores e bordas.\n'
                                           'Reduza antes de trocar o tamanho.',
                                  confirmText: 'OK',
                                  onConfirm: () {},
                                  onCancel: () {},
                                  themeController: themeController,
                                );
                                return; // Impede a troca do tamanho
                              }
                        
                              // SE ESTIVER TUDO DENTRO DOS LIMITES
                              // Aplica mudanças no tamanho
                              tamanhosSelecionados = tamanhoAtual.nome;
                              pizza.nome = tamanhosSelecionados;
                              pizza.valor = tamanhoAtual.valor;
                        
                              // Atualiza o valor da pizza após qualquer alteração
                              atualizarValorPizzaMedia();
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isSelected
                                ? themeController.primary
                                : themeController.secondary,
                            foregroundColor: isSelected
                                ? themeController.onPrimary
                                : themeController.onSecondary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            tamanhoAtual.nome,
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          SizedBox(height: 8),
            // Botão para adicionar ao carrinho 
            AbsorbPointer(
            absorbing: isProcessing,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: SizedBox(
                  height: 60,
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: themeController.primary,
                      foregroundColor: themeController.onPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: () {
                      if (saboresSelecionados.isEmpty) { // .isEmpty = está vazia 
                      // if ( saboresSelecionados2.values.fold(0, (a, b) => a + b) != totalFatiasPizza) {
                        pedidoController.showCustomDialog(
                          context: context,
                          icon: Icons.warning,
                          message: 'Selecione pelo menos um sabor para continuar.',
                          confirmText: 'OK',
                          onConfirm: () {},
                          onCancel: () => Navigator.pop(context),
                          themeController: themeController,
                        );
                        return;
                      }
                      final item = criarItemPizza();
                      pedidoController.addItemPizzaTotem(item);
                      limparPizzaSelecionada();
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => CarrinhoLayout()),
                      );
              
                    },
                    label: Text(
                      "Adicionar pizza ao carrinho",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    icon: Icon(Icons.add),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Função que retorna uma lista (gerarFatiasPizza)
List<PieChartSectionData> gerarFatiasPizza(
  Map<Flavors, int> saboresSelecionados2,
  ThemeController themeController,
  Pizza pizza,
){
  final totalFatias = saboresSelecionados2.values.fold(0, (a, b) => a + b);
  if (totalFatias == 0) return [];

  final List<Color> coresBase = [
    themeController.primaryContainer,
    themeController.secondaryContainer,
    themeController.tertiaryContainer,
    themeController.surfaceDim,
  ];
  int corIndex = 0;
  final List<PieChartSectionData> fatias = [];
  saboresSelecionados2.forEach((sabor, qtd) {
    final double porcentagem = qtd / totalFatias;
    fatias.add(PieChartSectionData(
      value: porcentagem,
      color: coresBase[corIndex % coresBase.length],
      title: sabor.nome,
      titleStyle: TextStyle(
        color: themeController.surface,
        fontWeight: FontWeight.w600,
        fontSize: 10,
      ),
      radius: 120,
    ));
    corIndex++;
  });
  return fatias;
}

// Função que retorna uma lista (gerarBordaComoContorno)
List<PieChartSectionData> gerarBordaComoContorno( 
  Map<Flavors, int> bordasSelecionadas, // Essa função recebe um mapa com bordas selecionadas e suas quantidades.
  ThemeController themeController,
  Pizza pizza,
  ) {
    // Aqui somamos todas as quantidades de bordas para saber o total
    final totalBordas = bordasSelecionadas.values.fold(0, (a, b) => a + b);
    // Filtra as bordas para tirar as que têm valor zero
    final Map<Flavors, int> bordasFiltradas = Map.fromEntries(
      bordasSelecionadas.entries.where((e) => e.value > 0),
    );

    // Se não tem borda nenhuma, devolve lista vazia e nem continua
    if (totalBordas == 0) return [];
    
    // Cores para representar as bordas
    final List<Color> coresBorda = [
      themeController.onPrimaryContainer,
      themeController.onSecondaryContainer,
      themeController.onTertiaryContainer,
      themeController.surfaceBright,
    ];

    // Prepara o índice da cor e a lista de fatias
    int corIndex = 0;
    final List<PieChartSectionData> fatias = [];

    // Para cada borda com valor maior que zero
    bordasFiltradas.forEach((borda, quantidade) {
      fatias.add(
        PieChartSectionData(
          value: quantidade.toDouble(),
          color: coresBorda[corIndex % coresBorda.length],
          title: '',
          // title: borda.nome,
          //   titleStyle: TextStyle(
          //     color: themeController.onSurface,
          //     fontWeight: FontWeight.w600,
          //     fontSize: 12,
          //   ),
          radius: 10, // maior que a camada de sabores
          titlePositionPercentageOffset: 0.5, // valor maior que 1 = fora do gráfico
        ),
      );
      corIndex++;
    });

  return fatias;
}
