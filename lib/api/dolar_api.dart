import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_dolar/models/response_dolar.dart';

Future<DolarEuro> getDolares() async {
  final response = await http.get(
    Uri.parse('https://ve.dolarapi.com/v1/dolares/oficial'),
  );
  if (response.statusCode == 200) {
    final Map<String, dynamic> jsonData = jsonDecode(response.body);
    final data = DolarEuro.fromJson(jsonData);
    return data;
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

Future<P2PAdData?> getPrecioP2PUSDT({String tradeType = 'venta'}) async {
  final url = Uri.parse(
    'https://p2p.binance.com/bapi/c2c/v2/friendly/c2c/adv/search',
  );

  final headers = <String, String>{
    'Content-Type': 'application/json',
    'User-Agent': 'Mozilla/5.0',
  };

  final body = jsonEncode({
    'page': 1,
    'rows': 4,
    'asset': 'USDT',
    'fiat': 'VES',
    'tradeType': tradeType == 'venta' ? 'SELL' : 'BUY',
    'payTypes': [],
    'publisherType': null,
    "merchantCheck": false,
    "transAmount": "2000",
  });

  try {
    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode != 200) {
      debugPrint('Error HTTP: ${response.statusCode}');
      return null;
    }

    final Map<String, dynamic> jsonMap = jsonDecode(response.body);
    final binanceResponse = BinanceP2PResponse.fromJson(jsonMap);

    final ads = binanceResponse.data;
    debugPrint(ads?[2].adv?.price.toString());
    if (ads != null && ads.length >= 2) {
      return ads[1];
    }

    return null;
  } catch (e) {
    debugPrint('Error en la petición: $e');
    return null;
  }
}
