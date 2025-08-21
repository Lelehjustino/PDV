/* 

ValueListenableBuilder = ValueListenableBuilder é um widget reativo leve que 
reconstrói parte da UI sempre que o valor de um ValueListenable muda — como um ValueNotifier

 Um ValueListenable<T> é qualquer objeto que: Possui um value e motifica ouvintes quando esse value muda

   Use ValueListenableBuilder quando:
    -Você quer reatividade leve e simples
    -Só uma parte da UI precisa mudar
    -Quer evitar sobrecarga de gerenciadores de estado mais complexos

ChangeNotifierProvider = Cria e fornece uma instância de um ChangeNotifier (ou uma classe que o estende) para a árvore de widgets.
                         Permite que outros widgets ouçam e reajam a mudanças no estado.
    
 Como usar:    
    1- Forneça o controlador no topo da árvore: 
    void main() {
      runApp(
        ChangeNotifierProvider(
          create: (_) => ContadorController(),
          child: const MyApp(),
        ),
      );
    }
    2- Consuma o estado: 
    final controller = Provider.of<ContadorController>(context, listen: false);
    controller.incrementar();

*/