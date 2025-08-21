import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:nubi_pdv/src/controllers/theme_controller.dart';
import 'package:nubi_pdv/src/views/layout_totem.dart';
import 'package:nubi_pdv/src/views/layout_weight.dart';
import 'package:provider/provider.dart';
import 'package:virtual_keyboard_2/virtual_keyboard_2.dart';

class TemaTotem extends StatefulWidget {
   const TemaTotem({super.key});

  @override
  State<TemaTotem> createState() => _TemaTotemState();
}

class _TemaTotemState extends State<TemaTotem> {
  // Cria um mapa onde cada chave é o nome e o valor é uma lista RGBO
  final Map<String, List<TextEditingController>> listaCores = {};

  // Focus Node declarado fora do TextField 
  Map<String, List<FocusNode>> focusNodesCores = {};

  final FocusNode focusNode = FocusNode();
  bool isKeyboardVisible = false;
  TextEditingController? currentController; // Controlador atualmente em foco
  // Controller para o Scroll da lista de cores 
  final ScrollController scrollController = ScrollController();

  final GlobalKey keyboardKey = GlobalKey();

  // Uma lista com os nomes das cores
  final List<String> nomesCores = [
    'Primária',
    'Contraste com Primária',
    'Secundária',
    'Contraste com Secundária',
    'Cor de Fundo',
    'Cor de Fundo 2',
    'Superfícies Elevadas',
    'Contraste com Superfícies Elevadas',
    'Mensagem',
    'Contraste com Cor Usada para Erros',
    'Erros (mais claro)',
    'Teclado',
    'Letras teclado',
    'Primeiro sabor',
    'Primeira borda',
    'Segundo sabor',
    'Segunda borda',
    'Terceiro sabor',
    'Terceira borda',
    'Quarto sabor',
    'Quarta borda',
  ];

  @override
  void initState() {
    super.initState();
    // Pega o ThemeController atual para acessar as cores já definidas
    final theme = context.read<ThemeController>();

    for (var key in nomesCores){ // Para cada nome de cor da lista
      final color = restagaCor (theme, key); //  Busca a cor atual associada àquela chave.
      
      listaCores[key] = [ // Cria 4 campos de texto, para permitir a edição daquela cor 
        TextEditingController(text: color.red.toString()), 
        TextEditingController(text: color.green.toString()),
        TextEditingController(text: color.blue.toString()),
        TextEditingController(text: color.opacity.toStringAsFixed(1)),
      ];

      focusNodesCores[key] = List.generate(4, (_) => FocusNode());
    }
    
    // detectar qual campo de cor ganhou foco
    for (var entry in focusNodesCores.entries) {
      for (var node in entry.value) {
        node.addListener(() {
          if (node.hasFocus) {
            final index = entry.value.indexOf(node);
            final controller = listaCores[entry.key]![index];
            setState(() {
              isKeyboardVisible = true;
              currentController = controller;
            });
          }
        });
      }
    }
  }
  
  // Função para pegar a cor correta
  Color restagaCor(ThemeController theme, String key) {
    switch (key) {
      case 'Primária':
        return theme.primary;
      case 'Contraste com Primária':
        return theme.onPrimary;
      case 'Secundária':
        return theme.secondary;
      case 'Contraste com Secundária':
        return theme.onSecondary;
      case 'Cor de Fundo 2':
        return theme.tertiary;
      case 'Cor de Fundo':
        return theme.onTertiary;
      case 'Superfícies Elevadas':
        return theme.surface;
      case 'Contraste com Superfícies Elevadas':
        return theme.onSurface;
      case 'Mensagem':
        return theme.error;
      case 'Contraste com Cor Usada para Erros':
        return theme.onError;
      case 'Erros (mais claro)':
        return theme.errorContainer;
      case 'Teclado':
        return theme.shadow;
      case 'Letras teclado':
        return theme.scrim;
      case 'Primeiro sabor':
        return theme.primaryContainer;  
      case 'Primeira borda':
        return theme.onPrimaryContainer;   
      case 'Segundo sabor':
        return theme.secondaryContainer;  
      case 'Segunda borda':
        return theme.onSecondaryContainer;  
      case 'Terceiro sabor':
        return theme.tertiaryContainer; 
      case 'Terceira borda':
        return theme.onTertiaryContainer; 
      case 'Quarto sabor':
        return theme.surfaceDim;
      case 'Quarta borda':
        return theme.surfaceBright; 
      default:
        return Colors.black;
    }
  }
  // Essa função lê os valores digitados nos campos de texto e transforma na cor 
  Color converteCor (List<TextEditingController> ctrls) {
    int r = int.parse(ctrls[0].text);
    int g = int.parse(ctrls[1].text);
    int b = int.parse(ctrls[2].text);
    double o = double.parse(ctrls[3].text);
    return Color.fromRGBO(r, g, b, o); // Cria uma nova cor com esses valores
  }

  @override
  Widget build(BuildContext context) {
    final themeController = context.watch<ThemeController>(); // Escuta mudanças nas cores
    bool isProcessing = false;
    return Scaffold(
      backgroundColor: themeController.onTertiary,
      appBar: AppBar(
        title: Text('Cores do seu totem'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Stack(
      children: [ 
        GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTapDown: (details) {
          final keyboardBox = keyboardKey.currentContext?.findRenderObject() as RenderBox?;
          final tapPosition = details.globalPosition;

          bool tappedKeyboard = false;

         if (keyboardBox != null) {
            final keyboardRect = keyboardBox.localToGlobal(Offset.zero) & keyboardBox.size;
            if (keyboardRect.contains(tapPosition)) {
              tappedKeyboard = true;
            }
          }

          if (!tappedKeyboard) {
            FocusScope.of(context).unfocus(); // ← agora isso funciona
            setState(() {
              isKeyboardVisible = false;
              currentController = null;
            });
          }
        },
        child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
         // Lista de campos de cores
         Expanded(
              child: Row(
              children: [
              // Lista de cores
                Expanded(
                  flex: 4, 
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                         child: ScrollbarTheme(
                          data: ScrollbarThemeData(
                            thumbColor: WidgetStateProperty.all(themeController.tertiary),
                            trackColor: WidgetStateProperty.all(themeController.surface),
                            radius: Radius.circular(16),
                            thickness: WidgetStateProperty.all(30),
                          ),
                            child: Scrollbar(
                              controller: scrollController,
                              thumbVisibility: true,
                              trackVisibility: true,
                              interactive: true,
                              scrollbarOrientation: ScrollbarOrientation.right,
                              child: ListView.builder(
                                padding: EdgeInsets.only(right: 30), // espaço para não ser coberto pela scrollbar
                                controller: scrollController,
                                physics: BouncingScrollPhysics(),
                                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                                itemCount: nomesCores.length,
                                itemBuilder: (context, index) {
                                  final key = nomesCores[index];
                                  final lista = listaCores[key]!;
                                  final focos = focusNodesCores[key]!;
                                // Retorna um Card com o nome da cor
                                // return Card(
                                return Container(
                                      child: Padding(
                                        padding: EdgeInsets.all(10.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(key, style: TextStyle(fontWeight: FontWeight.bold)),
                                            // Linha com os 4 campos (R, G, B, O) 
                                            SizedBox(
                                              width: MediaQuery.of(context).size.width * 0.9,
                                              child: Row(
                                                children: [
                                                  for (int i = 0; i < 4; i++) // monta 4 quadradinhos 
                                                    Expanded(
                                                      child: Padding(
                                                        padding:  EdgeInsets.symmetric(horizontal: 4),
                                                        child: 
                                                        TextField(
                                                          controller: lista[i],
                                                          focusNode: focos[i], 
                                                          readOnly: true, // teclado físico
                                                          onTap: () {
                                                          setState(() { 
                                                              // currentController = lista[i];
                                                              // isKeyboardVisible = true;
                                                              FocusScope.of(context).requestFocus(focos[i]);
                                                            });
                                                          },
                                                          decoration: InputDecoration(
                                                            labelText: ['R', 'G', 'B', 'O'][i],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  // Previa da cor 
                                                  GestureDetector(
                                                    onTap: () async {
                                                      Color corAtual = converteCor(lista); // pega a cor atual daquele conjunto RGBO
                                                                        
                                                      await showDialog(
                                                        context: context,
                                                        builder: (context) {
                                                          Color corTemporaria = corAtual;
                                                                        
                                                          return AlertDialog(
                                                            title: Text('Selecione uma cor'),
                                                            content: SingleChildScrollView(
                                                              child: ColorPicker(
                                                                pickerColor: corAtual,
                                                                onColorChanged: (Color color) {
                                                                  corTemporaria = color;
                                                                },
                                                                enableAlpha: true, // permite editar opacidade
                                                                displayThumbColor: true,
                                                                paletteType: PaletteType.hsvWithHue,
                                                              ),
                                                            ),
                                                            actions: [
                                                              // Botão Cancelar 
                                                              AbsorbPointer(
                                                              absorbing: isProcessing,
                                                                child: ElevatedButton(
                                                                  style: ElevatedButton.styleFrom(
                                                                    backgroundColor: themeController.secondary,
                                                                    foregroundColor: themeController.onSecondary,
                                                                    shape: RoundedRectangleBorder(
                                                                      borderRadius: BorderRadius.circular(10),
                                                                    ),
                                                                  ),
                                                                  onPressed: () {
                                                                    Navigator.of(context).pop();
                                                                  },
                                                                  child: Text('Cancelar')),
                                                              ),
                                                                        
                                                              // Botão Aplicar   
                                                              AbsorbPointer(
                                                              absorbing: isProcessing,
                                                                child: ElevatedButton(
                                                                  style: ElevatedButton.styleFrom(
                                                                    backgroundColor: themeController.primary,
                                                                    foregroundColor: themeController.onPrimary,
                                                                    shape: RoundedRectangleBorder(
                                                                      borderRadius: BorderRadius.circular(10),
                                                                    ),
                                                                  ),
                                                                  child: Text('Aplicar'),
                                                                  onPressed: () {
                                                                    // atualiza os TextFields com os valores escolhidos
                                                                    lista[0].text = corTemporaria.red.toString();
                                                                    lista[1].text = corTemporaria.green.toString();
                                                                    lista[2].text = corTemporaria.blue.toString();
                                                                    lista[3].text = corTemporaria.opacity.toStringAsFixed(1);
                                                                    setState(() {}); // atualiza o preview
                                                                    Navigator.of(context).pop();
                                                                  },
                                                                ),
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                      );
                                                    },
                                                    child: Container(
                                                      width: 40,
                                                      height: 40,
                                                      margin:  EdgeInsets.only(left: 8),
                                                      decoration: BoxDecoration(
                                                        color: converteCor(lista), // a cor dele é a cor convertida 
                                                        border: Border.all(color: Colors.black12),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
            // Botão “Salvar alterações”
            Row(
              children: [
                Expanded(
                  child: AbsorbPointer(
                  absorbing: isProcessing,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // vare a lista entry.key: o nome da cor / entry.value: a lista de RGBO
                        for (var entry in listaCores.entries) {
                          final color = converteCor(entry.value); // chama a função _parseColor que converte os textos digitados em uma cor real
                          themeController.updateColor(type: entry.key, color: color); // ATUALIZA O THEME CONTROLLER
                        }
                         Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => LayoutTotem()),
                            );
                      },
                      icon: Icon(Icons.check, color: themeController.onPrimary),
                      label: Text(
                        'Salvar alterações',
                        style: TextStyle(color: themeController.onPrimary),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: themeController.primary,
                        padding:  EdgeInsets.symmetric(vertical: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16),

                // Botão 'Descartar alterações'
                Expanded(
                  child: AbsorbPointer(
                  absorbing: isProcessing,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.close, color: themeController.onSecondary),
                      label: Text(
                        'Descartar alterações',
                        style: TextStyle(color: themeController.onSecondary),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: themeController.secondary,
                        padding:  EdgeInsets.symmetric(vertical: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        ),
      ),
        if (isKeyboardVisible && currentController != null)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              key: keyboardKey,
              height: MediaQuery.of(context).size.height * 0.4,
              color: themeController.shadow,
              child: VirtualKeyboard(
                textColor: themeController.scrim,
                type: VirtualKeyboardType.Numeric,
                textController: currentController!,
              ),
            ),
          ),
        ],
      ),
    );
  } 
}
