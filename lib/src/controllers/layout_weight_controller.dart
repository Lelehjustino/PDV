import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:nubi_pdv/src/controllers/pedido.controller.dart';
import 'package:nubi_pdv/src/models/products_model.dart';
//import 'package:serial_port_win32/serial_port_win32.dart';

class LayoutWeightController {
  // final SerialPort serialPort = SerialPort('COM3', ByteSize: 8, BaudRate: 9600);
  //late final SerialPort serialPort; 
  PedidoController pedidoController = PedidoController();
  Product productSelected = Product( numero: 0, nome: '', valor: 0, unidade: 0, grupo: 0, type: '', diversidadesabores: 0, numeroTamanhoPizza_FK: 0);
  bool polling = true;
  bool err = false;
  int step = 1;
  double pesoFinal = 0;
  int layout = 2;

  //Inicializa os Notifiers
  late VoidCallback pedidoFinalizadoListener;
  final ValueNotifier<int> stepNotifier = ValueNotifier<int>(1);
  final ValueNotifier<bool> errorNotifier = ValueNotifier<bool>(false);
  final ValueNotifier<int> layoutNotifier = ValueNotifier<int>(1);

  //Controller
  LayoutWeightController() {
    try {
      //serialPort = SerialPort('COM3', ByteSize: 8, BaudRate: 9600);
      print('Porta serial COM3 inicializada com sucesso.');
    } catch (e) {
      print('Erro ao inicializar a porta serial COM3: $e');
      // Você pode definir um estado de erro aqui, por exemplo:
      err = true;
      errorNotifier.value = true;
      // Ou lançar uma exceção novamente se for um erro crítico.
      // throw Exception('Falha ao conectar na porta serial: $e');
    }
  }

  //Resgata os Produtos
  // Future<List<Product>> getProducts() async {
  //   try {
  //     //ApiService apiService = ApiService();
  //     List<Product> response = await ApiService.getProducts();

  //     productSelected = response.firstWhere((product) => product.numero == 17);
      
  //     return response;
  //   } catch (e) {
  //     print('Erro ao carregar produtos: $e');
  //     return [];
  //   }
  // }
  

  //Valida a comanda e Inicializa a leitura da balança
  void cardSelected(){
    pedidoController.criarNovoPedido('Cliente novo');
    step = 2;
    stepNotifier.value = step;
    listenToPort();
  }

  //Remove o produto por KG e inicializa a leitura da balança novamente 
  void weightAgain(){
    // pedidoController.removeItem(pedidoController.pedidoAtual!.itens.firstWhere((product) => product.id == 17));
    polling = true;
    listenToPort();
    step = 2;
    layout = 1;
    layoutNotifier.value = layout;  
  }

  //Inicializa a leitura da porta serial
  //Inicializa a leitura da porta serial
  void listenToPort() async {
    // É importante verificar se a porta foi inicializada com sucesso antes de tentar abri-la
    // if (!serialPort.isOpened) {
    //   try {
    //     serialPort.open();
    //   } catch (e) {
    //     print('Erro ao abrir a porta serial: $e');
    //     step = 2;
    //     err = true;
    //     stepNotifier.value = step;
    //     errorNotifier.value = err;
    //     return; // Sai da função se não conseguir abrir a porta
    //   }
    // }

    // while (polling) {
    //   //await serialPort.writeBytesFromString('\x05', includeZeroTerminator: false);

    //   try {
    //     //Recebe os dados de leitura da balança
    //     Uint8List receivedData = await serialPort.readBytes(64, timeout: Duration(milliseconds: 300));

    //     //Verifica se os dados são vazios
    //     if (!receivedData.isNotEmpty) {
    //       step = 2;
    //       err = true;
    //       stepNotifier.value = step;
    //       errorNotifier.value = err;

    //       print('Nenhuma resposta da balança...');
    //       continue;
    //     }

    //     //Verifica se os dados estão dentro do Protocolo da balnaça
    //     if (receivedData[0] != 0x02 && receivedData.last == 0x03) {
    //       step = 2;
    //       err = true;
    //       stepNotifier.value = step;
    //       errorNotifier.value = err;
    //       print('Resposta fora do protocolo esperado');
    //       continue;
    //     }

    //     //Remove a mensagem de erro caso esteja visivel
    //     if (err == true) {
    //       err = false;
    //       errorNotifier.value = err;
    //     }

    //     //Converte o dado para string
    //     String receivedString = String.fromCharCodes(receivedData);
    //     String peso = receivedString.substring(1, receivedString.length - 1);

    //     //Verifica se o peso não Instavel, Negativo ou Acima do limite
    //     if (peso.startsWith('I')) { //Peso instável
    //       step = 3;
    //       stepNotifier.value = step;
    //     } 
    //     else if (peso.startsWith('N')) {} //Peso negativo
    //     else if (peso.startsWith('S')) {} //Peso acima do limite
    //     else {//Peso estavel   
    //       pesoFinal = (double.parse(peso) / 1000);
    //       stabilizedWeight();
    //     }

    //   } catch (e) {
    //     step = 2;
    //     err = true;
    //     stepNotifier.value = step;
    //   }

    //   //Faz a leitura da balança em milisegundos.
    //   await Future.delayed(Duration(milliseconds: 300));
    // }
  }

  //Executa quando o peso da balança é estabilizado
  void stabilizedWeight(){

    if (pesoFinal != 0.00) {
      if(step == 3){
        if(pedidoController.pedidoAtual != null){
          if(productSelected.numero != 0){
            pedidoController.addItemKG(productSelected, pesoFinal);
            polling = false;
          }
        }

        step = 4;
        stepNotifier.value = step;

        Timer(Duration(seconds: 1), () {
          layout = 2;
          layoutNotifier.value = layout;
        });
      }
    } 
    else {
      step = 2;
      stepNotifier.value = step;
    }
    
  }

  //Restaura para um novo pedido.
  void orderFinished(){
    if(pedidoController.orderFinished.value){
      step = 1;
      layout = 1;
      stepNotifier.value = step;
      layoutNotifier.value = layout;
      polling = true;
    }
  }

  //Seta o pedido Controller com o Provider e inicia um listener
  void setPedidoController(PedidoController pedidoControllerParam){
    pedidoController = pedidoControllerParam;

    pedidoFinalizadoListener = orderFinished;

    pedidoController.orderFinished.addListener(pedidoFinalizadoListener);
  }

  //Remove o ouvinte de Pedido finalizado
  void removeListener() {
    print("Listener removido.");
    pedidoController.orderFinished.removeListener(pedidoFinalizadoListener);
  }

  //Finaliza a leitura da porta serial
  void dispose() {
    polling = false;
    //serialPort.close();
    removeListener();
  }
}
