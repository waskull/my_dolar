class DolarEuro {
  final String fuente;
  final String nombre;
  final String moneda;
  final dynamic compra;
  final dynamic venta;
  final double promedio;
  final DateTime fechaActualizacion;

  DolarEuro({
    required this.fuente,
    required this.nombre,
    required this.moneda,
    this.compra,
    this.venta,
    required this.promedio,
    required this.fechaActualizacion,
  });

  DolarEuro.fromJson(Map<String, dynamic> json)
    : fuente = json['fuente']?.toString() ?? 'desconocida',
      nombre = json['nombre']?.toString() ?? 'Sin nombre',
      moneda = json['moneda']?.toString() ?? 'VES',
      compra = json['compra'],
      venta = json['venta'],
      promedio = (json['promedio'] ?? 0.0).toDouble(),
      fechaActualizacion = json['fechaActualizacion'] != null
          ? DateTime.parse(json['fechaActualizacion'])
          : DateTime.now();
}

class BinanceP2PResponse {
  String? code;
  String? message;
  String? messageDetail;
  List<P2PAdData>? data;
  int? total;
  bool? success;

  BinanceP2PResponse({
    this.code,
    this.message,
    this.messageDetail,
    this.data,
    this.total,
    this.success,
  });

  factory BinanceP2PResponse.fromJson(Map<String, dynamic> json) {
    return BinanceP2PResponse(
      code: json['code'],
      message: json['message'],
      messageDetail: json['messageDetail'],
      data: json['data'] != null
          ? List<P2PAdData>.from(json['data'].map((x) => P2PAdData.fromJson(x)))
          : null,
      total: json['total'],
      success: json['success'],
    );
  }
}

class P2PAdData {
  Adv? adv;
  Advertiser? advertiser;

  P2PAdData({this.adv, this.advertiser});

  factory P2PAdData.fromJson(Map<String, dynamic> json) {
    return P2PAdData(
      adv: json['adv'] != null ? Adv.fromJson(json['adv']) : null,
      advertiser: json['advertiser'] != null 
          ? Advertiser.fromJson(json['advertiser']) 
          : null,
    );
  }
}

class Adv {
  String? advNo;
  String? tradeType;
  String? asset;
  String? fiatUnit;
  String? price;
  String? surplusAmount;
  String? tradableQuantity;
  String? maxSingleTransAmount;
  String? minSingleTransAmount;
  String? fiatSymbol;
  List<TradeMethod>? tradeMethods;
  int? payTimeLimit;

  Adv({
    this.advNo,
    this.tradeType,
    this.asset,
    this.fiatUnit,
    this.price,
    this.surplusAmount,
    this.tradableQuantity,
    this.maxSingleTransAmount,
    this.minSingleTransAmount,
    this.fiatSymbol,
    this.tradeMethods,
    this.payTimeLimit,
  });

  factory Adv.fromJson(Map<String, dynamic> json) {
    return Adv(
      advNo: json['advNo'],
      tradeType: json['tradeType'],
      asset: json['asset'],
      fiatUnit: json['fiatUnit'],
      price: json['price'],
      surplusAmount: json['surplusAmount'],
      tradableQuantity: json['tradableQuantity'],
      maxSingleTransAmount: json['maxSingleTransAmount'],
      minSingleTransAmount: json['minSingleTransAmount'],
      fiatSymbol: json['fiatSymbol'],
      payTimeLimit: json['payTimeLimit'],
      tradeMethods: json['tradeMethods'] != null
          ? List<TradeMethod>.from(
              json['tradeMethods'].map((x) => TradeMethod.fromJson(x)))
          : null,
    );
  }
}

class TradeMethod {
  String? payType;
  String? tradeMethodName;
  String? tradeMethodShortName;
  String? tradeMethodBgColor;

  TradeMethod({
    this.payType,
    this.tradeMethodName,
    this.tradeMethodShortName,
    this.tradeMethodBgColor,
  });

  factory TradeMethod.fromJson(Map<String, dynamic> json) {
    return TradeMethod(
      payType: json['payType'],
      tradeMethodName: json['tradeMethodName'],
      tradeMethodShortName: json['tradeMethodShortName'],
      tradeMethodBgColor: json['tradeMethodBgColor'],
    );
  }
}

class Advertiser {
  String? userNo;
  String? nickName;
  int? monthOrderCount;
  double? monthFinishRate;
  double? positiveRate;
  String? userType;
  int? userGrade;

  Advertiser({
    this.userNo,
    this.nickName,
    this.monthOrderCount,
    this.monthFinishRate,
    this.positiveRate,
    this.userType,
    this.userGrade,
  });

  factory Advertiser.fromJson(Map<String, dynamic> json) {
    return Advertiser(
      userNo: json['userNo'],
      nickName: json['nickName'],
      monthOrderCount: json['monthOrderCount'],
      monthFinishRate: json['monthFinishRate']?.toDouble(),
      positiveRate: json['positiveRate']?.toDouble(),
      userType: json['userType'],
      userGrade: json['userGrade'],
    );
  }
}