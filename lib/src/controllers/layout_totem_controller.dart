import 'package:flutter/material.dart';
import 'package:nubi_pdv/src/models/flavors_model.dart';
import 'package:nubi_pdv/src/models/products_model.dart';
import 'package:nubi_pdv/src/services/api_service.dart';
import 'package:nubi_pdv/src/views/pedido_page.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

void navegarParaPedido(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => PedidoPage()),
  );
}

class LayoutTotemController {

    final ValueNotifier<bool> notifier = ValueNotifier<bool>(false);

    List<IconData> grupoIcones = []; //Esse Map liga cada grupo ao seu respectivo ícone.
    List<Grupo> grupos = []; //Essa lista guarda os dados que vêm da API.
    List<Grupo> gruposProdutos = []; // Essa lista guarda os dados que vêm da API (somente os grupos de produtos)
    List<Product> produtos = [];
    List<Product> produtosFiltrado = [];
    List<Flavors> flavors = [];
    int indexSelected = 0;
    int idGroupSelected = 0;
    String filter = '';
    bool cupomValidado = false;

    final TextEditingController nomeController = TextEditingController();
    final TextEditingController cupomController = TextEditingController();

    LayoutTotemController(){
      carregarProdutos();
      carregarGrupos();
      carregarSabores();
      selectedItem(0);
      TextEditingController();
      cupomValidado;
    }

  // Função para carregar dados dos produtos 
  carregarProdutos() async {
    produtos = await ApiService.getProducts();
    produtosFiltrado = produtos; 
  }

  // Função para carregar grupos dos produtos
  carregarGrupos() async {
    grupos.add( Grupo( id: 0, name: 'Todos', icone: mapearIconeGrupo(0), type: '',), );
    var count = await ApiService.getGrupo();

    for (var grupo in count) {
      if (grupo.type == 'P') { // só adiciona se o tipo for 'P'
        grupos.add( Grupo( id: grupo.id, name: grupo.name, icone: mapearIconeGrupo(grupo.id), type: grupo.type, ),
        );
      }
    }

    notifier.value = !notifier.value;
  }

  // Função para carregar dados de sabores de pizza 
  carregarSabores() async {
    flavors = await ApiService.getFlavors();    
  }

  // Função que ao clicar em um icone de grupo, os filtra 
  selectedGroup(int idGroup, int index){
    indexSelected = index;
    idGroupSelected = idGroup;

    if(idGroup != 0){
      produtosFiltrado = produtos.where((product) => product.grupo == idGroup).toList();
    }
    else{
      produtosFiltrado = produtos;
    }    
    
    filtrarProdutos(filter);

    notifier.value = !notifier.value;
  }

  // Função que ao clicar em um produto, chama os dados do mesmo  
    selectedItem(int idItem){
    //groupSelected = index;

    if(idItem != 0){
      produtosFiltrado = produtos.where((product) => product.numero == idItem).toList();
    }
    else{
      produtosFiltrado = produtos;
    }
    filtrarProdutos(filter);

    notifier.value = !notifier.value;
  }

  // Função para colocar icone estático ao grupo 
  IconData mapearIconeGrupo(int id) {
    switch (id) {
    case 0:
      return LucideIcons.handPlatter;
    case 1:
      return LucideIcons.torus;
    case 2:
      return LucideIcons.coffee;
    case 3:
      return LucideIcons.glassWater;
    case 4:
      return LucideIcons.croissant;
    case 5:
      return LucideIcons.hamburger;
    case 6:
      return LucideIcons.cupSoda;
    case 7:
      return LucideIcons.dessert;
    case 8:
      return LucideIcons.dessert;
    case 9:
      return LucideIcons.sandwich;
    case 10:
      return LucideIcons.beef;

    default:
      return LucideIcons.coffee;
    }
  }
  
  // Função que filtra produtos na barra de busca 
  filtrarProdutos(String? query){
    final textoBusca = (query ?? '').toLowerCase();
    filter = textoBusca;
    List<Product> filtrado;
    

    if(idGroupSelected == 0){
      filtrado = produtos;
    }
    else{
      filtrado = produtos.where((product) => product.grupo == idGroupSelected).toList();
    }
    
    produtosFiltrado = filtrado.where((produto) => (produto.nome ?? '').toLowerCase().contains(textoBusca)).toList();

    notifier.value = !notifier.value;
  }

  // Função para validar cupom
  bool valededCunpom(String cupom){
    if(cupom == 'DESC50'){
      return true;

    } if(cupom == 'DESCO10'){
      return true;

    } if(cupom == 'DESC15'){
      return true;
    }
    else{
      return false; 
    }
  }

  void dispose() {}
}


