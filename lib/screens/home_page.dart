import 'package:flutter/material.dart';
import 'package:my_dolar/api/dolar_api.dart';
import 'package:my_dolar/models/response_dolar.dart';
import '../widgets/price_card.dart';
import '../widgets/input.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<DolarEuro> _euros = [];
  List<DolarEuro> _dolares = [];
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
  
  TextEditingController bolivarcontroller = TextEditingController(text: "");
  TextEditingController bcvcontroller = TextEditingController(text: "");
  TextEditingController usdtcontroller = TextEditingController(text: "");
  TextEditingController eurocontroller = TextEditingController(text: "");

  @override
  void initState() {
    super.initState();
    _getData();
  }

  void _toggleCompraUSDT() {
    setState(() {
      _compraUSDT = !_compraUSDT;
      
      // Actualizar controlador USDT con el nuevo precio
      final nuevoPrecio = _compraUSDT ? _dolarUSDT.promedio : _dolarUSDTVenta.promedio;
      usdtcontroller.text = nuevoPrecio.toStringAsFixed(2);
      
      // Si hay monto en bolívares, recalcular
      if (bolivarcontroller.text.isNotEmpty) {
        onChangeBolivar(bolivarcontroller.text);
      }
    });
  }

  void onChangeBolivar(String value) {
    if (value.isEmpty) return;

    setState(() {
      _isBolivares = true;
      _monto = double.parse(value);
      
      bcvcontroller.text = (_monto * _dolar.promedio).toStringAsFixed(2);
      usdtcontroller.text = (_monto * (_compraUSDT ? _dolarUSDT.promedio : _dolarUSDTVenta.promedio)).toStringAsFixed(2);
      eurocontroller.text = (_monto * _euros[0].promedio).toStringAsFixed(2);
    });
  }

  void onChangeUSDT(String value) {
    if (value.isEmpty) return;
    
    setState(() {
      _isBolivares = false;
      _monto = double.parse(value) * (_compraUSDT ? _dolarUSDT.promedio : _dolarUSDTVenta.promedio);
      
      bolivarcontroller.text = _monto.toStringAsFixed(2);
      bcvcontroller.text = "";
      eurocontroller.text = "";
    });
  }

  void onChangeEuro(String value) {
    if (value.isEmpty) return;
    
    setState(() {
      _isBolivares = false;
      _monto = double.parse(value) * _euros[0].promedio;
      
      bolivarcontroller.text = _monto.toStringAsFixed(2);
      bcvcontroller.text = "";
      usdtcontroller.text = "";
    });
  }

  void onChangeBCV(String value) {
    if (value.isEmpty) return;
    
    setState(() {
      _isBolivares = false;
      _monto = double.parse(value) * _dolar.promedio;
      
      bolivarcontroller.text = _monto.toStringAsFixed(2);
      usdtcontroller.text = "";
      eurocontroller.text = "";
    });
  }

  Future<void> _getData() async {
    setState(() => cargando = true);
    
    try {
      final listaDolares = await getDolares();
      final listaEuros = await getEuros();
      final usdt = await getPrecioP2PUSDT(tradeType: 'compra');
      final usdtVenta = await getPrecioP2PUSDT(tradeType: 'venta');
      
      setState(() {
        bolivarcontroller.clear();
        _euros = listaEuros;
        _dolares = listaDolares;
        
        if (_dolares.isNotEmpty) {
          _dolar = _dolares[0];
          bcvcontroller.text = _dolar.promedio.toStringAsFixed(2);
        }
        
        if (_euros.isNotEmpty) {
          eurocontroller.text = _euros[0].promedio.toStringAsFixed(2);
        }
        
        final usdtPrecio = double.tryParse(usdt?.adv?.price ?? "0") ?? 0.0;
        final usdtVentaPrecio = double.tryParse(usdtVenta?.adv?.price ?? "0") ?? 0.0;
        
        usdtcontroller.text = _compraUSDT ? usdtPrecio.toStringAsFixed(2) : usdtVentaPrecio.toStringAsFixed(2);
        
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
      });
    } catch (e) {
      debugPrint('Error cargando datos: $e');
    } finally {
      setState(() => cargando = false);
    }
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
                    const SectionTitle(title: "Conversor Principal"),
                    const SizedBox(height: 12),
                    ShadcnInput(
                      controller: bolivarcontroller,
                      label: "Monto",
                      suffixText: "Bs.",
                      icon: Icons.account_balance_wallet_outlined,
                      onChanged: onChangeBolivar,
                    ),
                    const SizedBox(height: 32),
                    const SectionTitle(title: "Tasas de Cambio"),
                    const SizedBox(height: 12),
                    
                    PriceCard(
                      title: "Dólar BCV",
                      priceCompra: _dolar.promedio,
                      priceVenta: _dolarUSDTVenta.promedio,
                      date: _dolar.fechaActualizacion,
                      controller: bcvcontroller,
                      onChanged: onChangeBCV,
                      monto: _monto,
                      isEuro: false,
                      isCompra: false,
                      isBolivares: _isBolivares,
                      compraUSDT: _compraUSDT,
                      onToggleCompraUSDT: () {}, // No usado para BCV
                    ),
                    const SizedBox(height: 16),
                    
                    PriceCard(
                      title: "Dólar USDT",
                      priceCompra: _dolarUSDT.promedio,
                      priceVenta: _dolarUSDTVenta.promedio,
                      date: _dolarUSDT.fechaActualizacion,
                      controller: usdtcontroller,
                      onChanged: onChangeUSDT,
                      monto: _monto,
                      isEuro: false,
                      isCompra: true,
                      isBolivares: _isBolivares,
                      compraUSDT: _compraUSDT,
                      onToggleCompraUSDT: _toggleCompraUSDT,
                    ),
                    const SizedBox(height: 16),
                    
                    if (_euros.isNotEmpty)
                      PriceCard(
                        title: "Euro BCV",
                        priceCompra: _euros[0].promedio,
                        priceVenta: _dolarUSDTVenta.promedio,
                        date: _euros[0].fechaActualizacion,
                        controller: eurocontroller,
                        onChanged: onChangeEuro,
                        monto: _monto,
                        isEuro: true,
                        isCompra: false,
                        isBolivares: _isBolivares,
                        compraUSDT: _compraUSDT,
                        onToggleCompraUSDT: () {}, // No usado para Euro
                      ),
                  ],
                ),
              ),
            ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;
  
  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: Color(0xFFa1a1aa),
      ),
    );
  }
}
