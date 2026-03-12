import 'package:flutter/material.dart';
import 'package:my_dolar/widgets/input.dart';
import '../api/dolar_api.dart';
import '../models/response_dolar.dart';
import '../widgets/price_card.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<DolarEuro> _euros = [];
  DolarEuro _dolar = DolarEuro(
    promedio: 0,
    moneda: 'USD',
    fuente: 'oficial',
    nombre: "dolar",
    fechaActualizacion: DateTime.now(),
  );
  
  DolarEuro _dolarUSDT = DolarEuro(promedio: 0, moneda: 'USDT', fuente: 'binance', nombre: "USDT Compra", fechaActualizacion: DateTime.now());
  DolarEuro _dolarUSDTVenta = DolarEuro(promedio: 0, moneda: 'USDT', fuente: 'binance', nombre: "USDT Venta", fechaActualizacion: DateTime.now());

  bool _isBolivares = true;
  bool _compraUSDT = true;
  bool cargando = false;
  double _monto = 0.0;

  final TextEditingController bolivarcontroller = TextEditingController();
  final TextEditingController bcvcontroller = TextEditingController();
  final TextEditingController usdtcontroller = TextEditingController();
  final TextEditingController eurocontroller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getData();
  }

  void _getData() async {
    setState(() => cargando = true);
    try {
      _dolar = await getDolares();
      _euros = await getEuros();
      
      final usdt = await getPrecioP2PUSDT(tradeType: 'compra');
      final usdtVenta = await getPrecioP2PUSDT(tradeType: 'venta');

      setState(() {
        final usdtPrecio = double.tryParse(usdt?.adv?.price ?? "0") ?? 0.0;
        final usdtVentaPrecio = double.tryParse(usdtVenta?.adv?.price ?? "0") ?? 0.0;

        _dolarUSDT = DolarEuro(fuente: "Binance", nombre: "USDT Compra", moneda: "USDT", promedio: usdtPrecio, fechaActualizacion: DateTime.now());
        _dolarUSDTVenta = DolarEuro(fuente: "Binance", nombre: "USDT Venta", moneda: "USDT", promedio: usdtVentaPrecio, fechaActualizacion: DateTime.now());

        bcvcontroller.text = _dolar.promedio.toStringAsFixed(2);
        if (_euros.isNotEmpty) eurocontroller.text = _euros[0].promedio.toStringAsFixed(2);
        usdtcontroller.text = (_compraUSDT ? usdtPrecio : usdtVentaPrecio).toStringAsFixed(2);
        
        cargando = false;
      });
    } catch (e) {
      setState(() => cargando = false);
    }
  }

  void _recalcular(String value, String tipo) {
    if (value.isEmpty) return;
    double val = double.tryParse(value) ?? 0.0;

    setState(() {
      if (tipo == 'BOLIVAR') {
        _isBolivares = true;
        _monto = val;
        bcvcontroller.text = (val / _dolar.promedio).toStringAsFixed(2);
        eurocontroller.text = _euros.isNotEmpty ? (val / _euros[0].promedio).toStringAsFixed(2) : "0.00";
        usdtcontroller.text = (val / (_compraUSDT ? _dolarUSDT.promedio : _dolarUSDTVenta.promedio)).toStringAsFixed(2);
      } else {
        _isBolivares = false;
        double tasa = (tipo == 'BCV') ? _dolar.promedio : (tipo == 'EURO' ? _euros[0].promedio : (_compraUSDT ? _dolarUSDT.promedio : _dolarUSDTVenta.promedio));
        _monto = val * tasa;
        bolivarcontroller.text = _monto.toStringAsFixed(2);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [IconButton(icon: const Icon(Icons.refresh), onPressed: _getData)],
      ),
      body: cargando 
        ? const Center(child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
        : SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Conversor Principal", style: TextStyle(color: Color(0xFFa1a1aa), fontSize: 14)),
                const SizedBox(height: 12),
                ShadcnInput(
                  controller: bolivarcontroller,
                  label: "Monto",
                  suffixText: "Bs.",
                  icon: Icons.account_balance_wallet_outlined,
                  onChanged: (v) => _recalcular(v, 'BOLIVAR'),
                ),
                const SizedBox(height: 32),
                const Text("Tasas de Cambio", style: TextStyle(color: Color(0xFFa1a1aa), fontSize: 14)),
                const SizedBox(height: 12),
                PriceCard(
                  title: "Dólar BCV",
                  priceCompra: _dolar.promedio,
                  priceVenta: 0,
                  date: _dolar.fechaActualizacion,
                  controller: bcvcontroller,
                  onChanged: (v) => _recalcular(v, 'BCV'),
                  inDolar: _monto,
                  isEuro: false,
                  isBolivares: _isBolivares,
                  compraUSDT: _compraUSDT,
                  onToggleType: () {},
                ),
                const SizedBox(height: 16),
                PriceCard(
                  title: "Dólar USDT",
                  priceCompra: _dolarUSDT.promedio,
                  priceVenta: _dolarUSDTVenta.promedio,
                  date: _dolarUSDT.fechaActualizacion,
                  controller: usdtcontroller,
                  onChanged: (v) => _recalcular(v, 'USDT'),
                  inDolar: _monto,
                  isEuro: false,
                  isCompra: true,
                  isBolivares: _isBolivares,
                  compraUSDT: _compraUSDT,
                  onToggleType: () {
                    setState(() {
                      _compraUSDT = !_compraUSDT;
                      _recalcular(bolivarcontroller.text, 'BOLIVAR');
                    });
                  },
                ),
                const SizedBox(height: 16),
                if (_euros.isNotEmpty)
                  PriceCard(
                    title: "Euro BCV",
                    priceCompra: _euros[0].promedio,
                    priceVenta: 0,
                    date: _euros[0].fechaActualizacion,
                    controller: eurocontroller,
                    onChanged: (v) => _recalcular(v, 'EURO'),
                    inDolar: _monto,
                    isEuro: true,
                    isBolivares: _isBolivares,
                    compraUSDT: false,
                    onToggleType: () {},
                  ),
              ],
            ),
          ),
    );
  }
}