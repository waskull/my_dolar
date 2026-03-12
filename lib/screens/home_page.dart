import 'package:flutter/material.dart';
import 'package:my_dolar/api/dolar_api.dart';
import 'package:my_dolar/models/response_dolar.dart';
import 'package:my_dolar/widgets/input.dart';
import 'package:my_dolar/widgets/price_card.dart';
import 'package:my_dolar/widgets/section_title.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;
  final bool isDarkMode = false;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DolarEuro _euros = DolarEuro(
    promedio: 0,
    moneda: 'EUR',
    fuente: 'oficial',
    nombre: "euro",
    fechaActualizacion: DateTime.now(),
  );
  double _monto = 0.0;
  bool _isBolivares = true;

  DolarEuro _dolar = DolarEuro(
    promedio: 0,
    moneda: 'USD',
    fuente: 'oficial',
    nombre: "dolar",
    fechaActualizacion: DateTime.now(),
  );

  DolarEuro _dolarUSDT = DolarEuro(
    promedio: 0,
    moneda: 'USDT',
    fuente: 'binance',
    nombre: "USDT Compra",
    fechaActualizacion: DateTime.now(),
  );

  DolarEuro _dolarUSDTVenta = DolarEuro(
    promedio: 0,
    moneda: 'USDT',
    fuente: 'binance',
    nombre: "USDT Venta",
    fechaActualizacion: DateTime.now(),
  );

  bool _compraUSDT = true;
  bool cargando = false;

  double bolivares = 0.0;

  final TextEditingController bolivarcontroller = TextEditingController(
    text: "",
  );
  final TextEditingController bcvcontroller = TextEditingController(text: "");
  final TextEditingController usdtcontroller = TextEditingController(text: "");
  final TextEditingController eurocontroller = TextEditingController(text: "");

  @override
  void initState() {
    super.initState();
    _dolar = DolarEuro(
      promedio: 0,
      moneda: 'USD',
      fuente: 'oficial',
      nombre: "dolar",
      fechaActualizacion: DateTime.now(),
    );
    _dolarUSDT = _dolar;
    _monto = 0.0;
    _isBolivares = true;
    _getData();
  }

  void _limpiarCampos() {
    setState(() {
      bolivarcontroller.clear();
      bcvcontroller.clear();
      usdtcontroller.clear();
      eurocontroller.clear();
      _monto = 0.0;
    });
  }

  void onChangeBolivar(String value) {
    if (value.isEmpty) return;

    setState(() {
      _isBolivares = true;
      final monto = double.parse(value);
      bcvcontroller.text = (monto * _dolar.promedio).toStringAsFixed(2);
      usdtcontroller.text =
          (_compraUSDT
                  ? monto * _dolarUSDT.promedio
                  : monto * _dolarUSDTVenta.promedio)
              .toStringAsFixed(2);
      eurocontroller.text = (monto * _euros.promedio).toStringAsFixed(2);
      _monto = monto;
    });
  }

  void onChangeUSDT(String value) {
    if (value.isEmpty) {
      _limpiarCampos();
      return;
    }
    setState(() {
      _isBolivares = false;
      double usdtIngresado = double.tryParse(value) ?? 0.0;
      double tasaUSDT = _compraUSDT
          ? _dolarUSDT.promedio
          : _dolarUSDTVenta.promedio;

      double equivalenteBolivares = usdtIngresado * tasaUSDT;
      _monto = equivalenteBolivares;
      bolivarcontroller.text = equivalenteBolivares.toStringAsFixed(2);
      bcvcontroller.text = (equivalenteBolivares / _dolar.promedio)
          .toStringAsFixed(2);

      eurocontroller.text = (equivalenteBolivares / _euros.promedio)
          .toStringAsFixed(2);
    });
  }

  void onChangeEuro(String value) {
    if (value.isEmpty) {
      _limpiarCampos();
      return;
    }
    setState(() {
      _isBolivares = false;
      double euroIngresado = double.tryParse(value) ?? 0.0;

      double equivalenteBolivares = euroIngresado * _euros.promedio;
      _monto = equivalenteBolivares;
      bolivarcontroller.text = equivalenteBolivares.toStringAsFixed(2);
      bcvcontroller.text = (equivalenteBolivares / _dolar.promedio)
          .toStringAsFixed(2);
      double tasaUSDT = _compraUSDT
          ? _dolarUSDT.promedio
          : _dolarUSDTVenta.promedio;
      usdtcontroller.text = (equivalenteBolivares / tasaUSDT).toStringAsFixed(
        2,
      );
    });
  }

  void onChangeBCV(String value) {
    if (value.isEmpty) {
      _limpiarCampos();
      return;
    }
    setState(() {
      _isBolivares = false;
      double bcvIngresado = double.tryParse(value) ?? 0.0;
      double equivalenteBolivares = bcvIngresado * _dolar.promedio;
      _monto = equivalenteBolivares;
      bolivarcontroller.text = equivalenteBolivares.toStringAsFixed(2);

      double tasaUSDT = _compraUSDT
          ? _dolarUSDT.promedio
          : _dolarUSDTVenta.promedio;
      usdtcontroller.text = (equivalenteBolivares / tasaUSDT).toStringAsFixed(
        2,
      );

      eurocontroller.text = (equivalenteBolivares / _euros.promedio)
          .toStringAsFixed(2);
    });
  }

  Future<void> _getData() async {
    setState(() {
      cargando = true;
    });

    _dolar = await getDolares();
    final listaEuros = await getEuros();
    final usdt = await getPrecioP2PUSDT(tradeType: 'compra');
    final usdtVenta = await getPrecioP2PUSDT(tradeType: 'venta');

    setState(() {
      bolivarcontroller.text = "";
      _euros = listaEuros;

      final usdtPrecio = double.parse(usdt?.adv?.price ?? "0");
      final usdtVentaPrecio = double.parse(usdtVenta?.adv?.price ?? "0");

      eurocontroller.text = _euros.promedio.toStringAsFixed(2);

      bcvcontroller.text = _dolar.promedio.toStringAsFixed(2);
      usdtcontroller.text = _compraUSDT
          ? usdtPrecio.toStringAsFixed(2)
          : usdtVentaPrecio.toStringAsFixed(2);

      _dolarUSDT = DolarEuro(
        fuente: "Binance",
        nombre: "USDT Compra",
        moneda: "USDT",
        promedio: usdtPrecio,
        fechaActualizacion: DateTime.now(),
      );
      _dolarUSDTVenta = DolarEuro(
        fuente: "Binance",
        nombre: "USDT Venta",
        moneda: "USDT",
        promedio: usdtVentaPrecio,
        fechaActualizacion: DateTime.now(),
      );

      cargando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF09090b),
      appBar: AppBar(
        title: Text(
          widget.title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF09090b),
        elevation: 0,
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, size: 20),
            onPressed: _getData,
          ),
        ],
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(color: Color(0xFF27272a), height: 1),
        ),
      ),
      body: cargando
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            )
          : SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SectionTitle("Conversor Principal"),
                    const SizedBox(height: 12),
                    ShadcnInput(
                      controller: bolivarcontroller,
                      label: "Monto",
                      suffixText: "Bs.",
                      icon: Icons.account_balance_wallet_outlined,
                      onChanged: onChangeBolivar,
                    ),
                    const SizedBox(height: 32),
                    const SectionTitle("Tasas de Cambio"),
                    const SizedBox(height: 12),
                    PriceCard(
                      title: "Dólar BCV",
                      priceCompra: _dolar.promedio,
                      priceVenta: _dolarUSDTVenta.promedio,
                      date: _dolar.fechaActualizacion,
                      controller: bcvcontroller,
                      onChanged: onChangeBCV,
                      inDolar: _monto,
                      isEuro: false,
                      isCompra: false,
                      isBolivares: _isBolivares,
                      monto: _monto,
                      compraUSDT: _compraUSDT,
                      bolivarController: bolivarcontroller,
                      onChangeBolivar: onChangeBolivar,
                    ),
                    const SizedBox(height: 16),
                    PriceCard(
                      title: "Dólar USDT",
                      priceCompra: _dolarUSDT.promedio,
                      priceVenta: _dolarUSDTVenta.promedio,
                      date: _dolarUSDT.fechaActualizacion,
                      controller: usdtcontroller,
                      onChanged: onChangeUSDT,
                      inDolar: _monto,
                      isEuro: false,
                      isCompra: true,
                      isBolivares: _isBolivares,
                      monto: _monto,
                      compraUSDT: _compraUSDT,
                      bolivarController: bolivarcontroller,
                      onChangeBolivar: onChangeBolivar,
                      onToggleCompraVenta: () {
                        setState(() {
                          _compraUSDT = !_compraUSDT;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    PriceCard(
                      title: "Euro BCV",
                      priceCompra: _euros.promedio,
                      priceVenta: _dolarUSDTVenta.promedio,
                      date: _euros.fechaActualizacion,
                      controller: eurocontroller,
                      onChanged: onChangeEuro,
                      inDolar: _monto,
                      isEuro: true,
                      isCompra: false,
                      isBolivares: _isBolivares,
                      monto: _monto,
                      compraUSDT: _compraUSDT,
                      bolivarController: bolivarcontroller,
                      onChangeBolivar: onChangeBolivar,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
