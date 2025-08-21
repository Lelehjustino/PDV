import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:nubi_pdv/src/controllers/pedido.controller.dart';
import 'package:nubi_pdv/src/models/products_model.dart';
import 'package:nubi_pdv/src/services/api_service.dart';
import 'package:provider/provider.dart';

class ProductsPage extends StatefulWidget{
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState(){
    return ProductsPageState();
  }

}

class ProductsPageState extends State<ProductsPage>{
  Map<int, Color> itemColors = {};
  String inputValue = '';
  
  List<Product> listProducts = [
    Product(nome: "Produto 1", numero: 1, valor: 5.00, unidade: 1, grupo: 0, type: '', diversidadesabores: 0, numeroTamanhoPizza_FK: 0),
    Product(nome: "Produto 2", numero: 2, valor: 10.00, unidade: 1, grupo: 0, type: '', diversidadesabores: 0, numeroTamanhoPizza_FK: 0),
    Product(nome: "Produto 3", numero: 3, valor: 15.00, unidade: 1, grupo: 0, type: '', diversidadesabores: 0, numeroTamanhoPizza_FK: 0),
    Product(nome: "Produto 4", numero: 4, valor: 20.00, unidade: 1, grupo: 0, type: '', diversidadesabores: 0, numeroTamanhoPizza_FK: 0)
  ];

  @override
  void initState() {
    getProducts();
    super.initState();
  }

  Future<void> getProducts() async {
    try {
      //ApiService apiService = ApiService();
      List<Product> response = await ApiService.getProducts();
      setState(() {
        listProducts = response;
      });
    } catch (e) {
      print('Erro ao carregar produtos: $e');
    }
  }

  @override
  Widget build(BuildContext context){
    var pedidoController = Provider.of<PedidoController>(context, listen: false);

    double screenWidth = MediaQuery.of(context).size.width;
    bool isMobile = screenWidth < 800;
    
    return Container(
      padding: EdgeInsets.all(10),
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Color(0xFFf8f9fe)
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Pesquise o produto',
                border: OutlineInputBorder(),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: const Color.fromARGB(255, 206, 206, 206)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).primaryColor),
                )
              ),
              onChanged: (value) {
                setState(() {
                  inputValue = value;
                });
              },
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Wrap(
                alignment: isMobile ? WrapAlignment.center : WrapAlignment.start,
                spacing: 10,
                runSpacing: 10,
                children:List.generate(listProducts.length, (index) {

                  if(listProducts[index].unidade == 2){
                    return SizedBox();
                  }

                  if(!listProducts[index].nome.toLowerCase().contains(inputValue.toLowerCase())){
                    return SizedBox();
                  }
            
                  String formattedPrice = NumberFormat.currency(
                    locale: 'pt_BR', 
                    symbol: 'R\$',
                    decimalDigits: 2,
                  ).format(listProducts[index].valor);
            
                  Color containerColor = itemColors[index] ?? Color(0xFFf8f9fe);
                    
                  return SizedBox(
                    width: 180,
                    height: 190,
                      child: InkWell(
                        onTap: (){
                          if(pedidoController.pedidoAtual == null){
                            pedidoController.criarNovoPedido('Cliente');
                          }
                          pedidoController.addItem(listProducts[index]);
                        },
            
                        onHover: (isHovering) {
                          setState(() {
                            itemColors[index] = isHovering ? const Color.fromARGB(255, 228, 239, 248) : Color(0xFFf8f9fe);
                          });
                        },
            
                        child:Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: containerColor,
                            border: Border.all(color: const Color.fromARGB(255, 219, 219, 219)),
                            borderRadius: BorderRadius.circular(10)
                          ),
                          //Content Product
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              //Image Product
                              Expanded(
                                child: Image.asset(
                                  'assets/CocaCola.png',
                                  width: double.infinity,
                                  fit: BoxFit.contain,
                                ),
                              ),
            
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
            
                                  //Text Product
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: 130,
                                        child: Text(
                                          listProducts[index].nome,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600
                                          ),
                                        ),
                                      ),
                                      Text(
                                        formattedPrice,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      ),
                                    ],
                                  ),
            
                                  //Button Add
                                  InkWell(
                                    onTap: (){
                                      if(pedidoController.pedidoAtual == null){
                                        pedidoController.criarNovoPedido('Cliente');
                                      }
                                      pedidoController.addItem(listProducts[index]);
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).primaryColor,
                                        borderRadius: BorderRadius.circular(5)
                                      ),
                                      child: Icon(Icons.add, color: Colors.white, size: 25),
                                    ),
                                  ) 
                                ],
                              ),
                            ],
                          ),
                        ),
                      ), 
                  );
                }),
              ),
            ),
          ),
        ],
      ) 
    );
  }
}