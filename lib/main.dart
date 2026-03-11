import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_dolar/api/dolar_api.dart';
import 'package:my_dolar/models/response_dolar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  final String text = 'BDV: ';
  final String title = 'Precio BDV/Binance';
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: text,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF09090b), // Zinc 950
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFfafafa), // Zinc 50
          surface: Color(0xFF09090b),
          secondary: Color(0xFF27272a), // Zinc 800
          onSurface: Color(0xFFfafafa),
        ),
        textTheme: const TextTheme(
          headlineMedium: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: -1,
            color: Color(0xFFfafafa),
          ),
        ),
      ),
      themeMode: ThemeMode.dark,
      home: MyHomePage(title: title),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  final bool isDarkMode = false;

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
    moneda: 'USD',
    fuente: 'binance',
    nombre: "dolar",
    fechaActualizacion: DateTime.now(),
  );
  bool cargando = false;
  double bolivares = 0.0;
  TextEditingController bolivarcontroller = TextEditingController(text: "");
  TextEditingController bcvcontroller = TextEditingController(text: "");
  TextEditingController usdtcontroller = TextEditingController(text: "");
  TextEditingController eurocontroller = TextEditingController(text: "");
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
    _euros = [
      DolarEuro(
        promedio: 0,
        moneda: 'EUR',
        fuente: 'oficial',
        nombre: "euro",
        fechaActualizacion: DateTime.now(),
      ),
    ];
    _dolares = [_dolar];
    _monto = 0.0;
    _isBolivares = true;
    _getData();
  }

  void onChangeBolivar(String value) {
    if (value.isEmpty) {
      return;
    }

    setState(() {
      _isBolivares = true;
      bcvcontroller.text = (double.parse(value) * _dolar.promedio)
          .toStringAsFixed(2);
      usdtcontroller.text = (double.parse(value) * _dolarUSDT.promedio)
          .toStringAsFixed(2);
      eurocontroller.text = (double.parse(value) * _euros[0].promedio)
          .toStringAsFixed(2);
      _monto = double.parse(value);
    });
  }

  void onChangeUSDT(String value) {
    if (value.isEmpty) {
      return;
    }
    setState(() {
      _isBolivares = false;
      bolivarcontroller.text = (double.parse(value) * _dolarUSDT.promedio)
          .toStringAsFixed(2);
      bcvcontroller.text = "";
      eurocontroller.text = "";
      _monto = double.parse(value) * _dolarUSDT.promedio;
    });
  }

  void onChangeEuro(String value) {
    if (value.isEmpty) {
      return;
    }
    setState(() {
      _isBolivares = false;
      bolivarcontroller.text = (double.parse(value) * _euros[0].promedio)
          .toStringAsFixed(2);
      bcvcontroller.text = "";
      _monto = double.parse(value) * _euros[0].promedio;
      usdtcontroller.text = "";
    });
  }

  void onChangeBCV(String value) {
    if (value.isEmpty) {
      return;
    }
    setState(() {
      _isBolivares = false;
      bolivarcontroller.text = (double.parse(value) * _dolar.promedio)
          .toStringAsFixed(2);
      usdtcontroller.text = "";
      _monto = double.parse(value) * _dolar.promedio;
      eurocontroller.text = "";
    });
  }

  void _getData() async {
    setState(() {
      cargando = true;
    });
    final listaDolares = await getDolares();
    final listaEuros = await getEuros();
    //final usdt = await getVesPrice();
    //debugPrint("usdt: $usdt");
    setState(() {
      bolivarcontroller.text = "";
      _euros = listaEuros;
      if (_euros.isNotEmpty) {
        eurocontroller.text = _euros[0].promedio.toStringAsFixed(2);
      }
      _dolares = listaDolares;
      if (_dolares.isNotEmpty) {
        bcvcontroller.text = _dolares[0].promedio.toStringAsFixed(2);
        _dolar = _dolares[0];
        usdtcontroller.text = _dolares[1].promedio.toStringAsFixed(2);
        _dolarUSDT = _dolares[1];
      }

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
                    _buildSectionTitle("Conversor Principal"),
                    const SizedBox(height: 12),
                    _buildShadcnInput(
                      controller: bolivarcontroller,
                      label: "Monto",
                      suffixText: "Bs.",
                      icon: Icons.account_balance_wallet_outlined,
                      onChanged: onChangeBolivar,
                    ),
                    const SizedBox(height: 32),
                    _buildSectionTitle("Tasas de Cambio"),
                    const SizedBox(height: 12),

                    // Grid de tarjetas tipo Shadcn
                    _buildPriceCard(
                      "Dólar BCV",
                      _dolar.promedio,
                      _dolar.fechaActualizacion,
                      bcvcontroller,
                      onChangeBCV,
                      _monto,
                      false,
                    ),
                    const SizedBox(height: 16),
                    _buildPriceCard(
                      "Dólar USDT",
                      _dolarUSDT.promedio,
                      _dolarUSDT.fechaActualizacion,
                      usdtcontroller,
                      onChangeUSDT,
                      _monto,
                      false,
                    ),
                    const SizedBox(height: 16),
                    if (_euros.isNotEmpty)
                      _buildPriceCard(
                        "Euro BCV",
                        _euros[0].promedio,
                        _euros[0].fechaActualizacion,
                        eurocontroller,
                        onChangeEuro,
                        _monto,
                        true,
                      ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: Color(0xFFa1a1aa),
      ),
    );
  }

  Widget _buildPriceCard(
    String title,
    double price,
    DateTime date,
    TextEditingController controller,
    Function(String) onChanged,
    double inDolar,
    bool isEuro,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF09090b),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF27272a)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              Text(
                DateFormat('HH:mm a').format(date),
                style: const TextStyle(color: Color(0xFFa1a1aa), fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${price.toStringAsFixed(2)} Bs",
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 24,
                ),
              ),
              Text(
                "${(inDolar / price).toStringAsFixed(2)}${isEuro ? "€" : "\$"}",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  color: Color(0xFFa1a1aa),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _buildShadcnInput(
            controller: controller,
            suffixText: isEuro
                ? "€"
                : _isBolivares
                ? "Bs."
                : "\$",
            label: "Convertir a $title",
            onChanged: onChanged,
            small: true,
          ),
        ],
      ),
    );
  }

  Widget _buildShadcnInput({
    required TextEditingController controller,
    required String label,
    required Function(String) onChanged,
    IconData? icon,
    bool small = false,
    String? suffixText,
  }) {
    return TextFormField(
      controller: controller,
      onChanged: onChanged,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      style: TextStyle(fontSize: small ? 14 : 14, color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Color(0xFFa1a1aa), fontSize: 14),
        floatingLabelBehavior: FloatingLabelBehavior.never,
        hintText: label,
        hintStyle: const TextStyle(color: Color(0xFF3f3f46), fontSize: 14),
        prefixIcon: icon != null
            ? Icon(icon, size: 20, color: const Color(0xFFa1a1aa))
            : null,
        suffixIcon: suffixText != null
            ? Padding(
                padding: const EdgeInsets.only(
                  right: 8,
                  top: 15,
                ), // Ajuste estético
                child: Text(
                  suffixText,
                  style: const TextStyle(
                    color: Color(0xFF71717a), // Zinc 400
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                  ),
                ),
              )
            : null,
        filled: true,
        fillColor: const Color(0xFF09090b),
        contentPadding: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: small ? 12 : 12,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF27272a)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.white, width: 1),
        ),
      ),
    );
  }
}
