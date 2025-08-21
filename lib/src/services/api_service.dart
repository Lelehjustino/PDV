import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:nubi_pdv/src/models/flavors_model.dart';
import 'package:nubi_pdv/src/models/products_model.dart';

class ApiService {
  final String url = 'http://192.168.1.200:4205/product/all';

  // Requisição para produtos
  static getProducts() async {
    final url = Uri.parse('http://192.168.1.200:4205/product/all');

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6ImxlaGp1c3Rpbm93ZWhiZUBnbWFpbC5jb20iLCJwYXNzd29yZCI6IjEyMzQiLCJkYXRhQmFzZSI6InVuMDAwMiIsImlhdCI6MTc1MjYwMTE4N30.p4XhtwnBkCKRifRxSeNCRvRrjEDgXms9m4r57O5w2Dk',
        },
      ).timeout(
        const Duration(seconds: 10), // segundos 
        onTimeout: () {
          throw TimeoutException('A requisição demorou muito para responder.');
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> decoded = jsonDecode(response.body);
        final List<dynamic> jsonList = decoded['products'];
        // print('produtos: ${jsonList}');

        return jsonList.map((json) => Product.fromJson(json)).toList();
      } else {
        throw Exception('Erro ao buscar produtos: ${response.statusCode}');
      }
    } on TimeoutException catch (e) {
      // print('Erro de Timeout: ${e.message}');
      rethrow;
    } catch (e) {
      // print('Ocorreu um erro: $e');
      rethrow;
    }
  }

  // Requisição para grupos dos produtos
  static Future<List<Grupo>> getGrupo() async {
    final url = Uri.parse('http://192.168.1.200:4205/product/groups'); 

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6ImxlaGp1c3Rpbm93ZWhiZUBnbWFpbC5jb20iLCJwYXNzd29yZCI6IjEyMzQiLCJkYXRhQmFzZSI6InVuMDAwMiIsImlhdCI6MTc1MjYwMTE4N30.p4XhtwnBkCKRifRxSeNCRvRrjEDgXms9m4r57O5w2Dk',
        },
      ).timeout(
        const Duration(seconds: 10), // segundos 
        onTimeout: () {
          throw TimeoutException('A requisição demorou muito para responder.');
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> decoded = jsonDecode(response.body);
        final List<dynamic> jsonList = decoded['groups'];
        return jsonList.map((json) => Grupo.fromJson(json)).toList();
      } else {
        throw Exception('Erro ao selecionar grupo: ${response.statusCode}');
      }
    } on TimeoutException catch (e) {
      // print('Erro de Timeout: ${e.message}');
      rethrow;
    } catch (e) {
      // print('Ocorreu um erro: $e');
      rethrow;
    }
  }

  //Requisição para Sabores
   static getFlavors() async {
    final url = Uri.parse('http://192.168.1.200:4205/product/flavors'); 

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6ImxlaGp1c3Rpbm93ZWhiZUBnbWFpbC5jb20iLCJwYXNzd29yZCI6IjEyMzQiLCJkYXRhQmFzZSI6InVuMDAwMiIsImlhdCI6MTc1MjYwMTE4N30.p4XhtwnBkCKRifRxSeNCRvRrjEDgXms9m4r57O5w2Dk',
        },
      ).timeout(
        const Duration(seconds: 10), // Define um timeout de 10 segundos
        onTimeout: () {
          // Esta função é chamada se o timeout ocorrer
          throw TimeoutException('A requisição demorou muito para responder.');
        },
      );

    if (response.statusCode == 200) {
      
      final Map<String, dynamic> decoded = jsonDecode(response.body);
      final List<dynamic> jsonList = decoded['products'];
      // print('SABORES: ${jsonList}');

      final list = jsonList.map((json) => Flavors.fromJson(json)).toList();
      return list;
    } else {
      throw Exception('Erro ao buscar os sabores: ${response.statusCode}');
    }
        } on TimeoutException catch (e) {
      // Captura a exceção de timeout
      // print('Erro de Timeout: ${e.message}');
      rethrow; // Relança a exceção para que o chamador possa lidar com ela
    } catch (e) {
      // Captura outras exceções de rede ou parsing
      // print('Ocorreu um erro: $e');
      rethrow; // Relança a exceção
    }
  }
}

  
