import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_dolar/models/response_dolar.dart';

Future<List<DolarEuro>> getDolares() async {
  final response = await http.get(
    Uri.parse('https://ve.dolarapi.com/v1/dolares'),
  );
  if (response.statusCode == 200) {
    List<dynamic> data = json.decode(response.body);
    return data.map((item) => DolarEuro.fromJson(item)).toList();
  } else {
    throw Exception('Fallo al traer los dolares');
  }
}

Future<List<DolarEuro>> getEuros() async {
  final response = await http.get(
    Uri.parse('https://ve.dolarapi.com/v1/euros'),
  );
  if (response.statusCode == 200) {
    List<dynamic> data = json.decode(response.body);
    return data.map((item) => DolarEuro.fromJson(item)).toList();
  } else {
    throw Exception('Fallo al traer los euros');
  }
}

Future<double?> getVesPrice() async {
  const url = 'https://api.binance.com/api/v3/ticker/price?symbol=USDTVES';
  try {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      debugPrint("petición: $data");
      return double.parse(data['price']);
    }
  } catch (e) {
    debugPrint("Error en la petición: $e");
  }
  return null;
}
