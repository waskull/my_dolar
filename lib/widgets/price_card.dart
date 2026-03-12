import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_dolar/widgets/input.dart';

class PriceCard extends StatelessWidget {
  final String title;
  final double priceCompra;
  final double priceVenta;
  final DateTime date;
  final TextEditingController controller;
  final Function(String) onChanged;
  final double inDolar;
  final bool isEuro;
  final bool isCompra;

  final bool isBolivares;
  final double monto;
  final bool compraUSDT;
  final TextEditingController bolivarController;
  final void Function(String) onChangeBolivar;
  final VoidCallback? onToggleCompraVenta;

  const PriceCard({
    super.key,
    required this.title,
    required this.priceCompra,
    required this.priceVenta,
    required this.date,
    required this.controller,
    required this.onChanged,
    required this.inDolar,
    required this.isEuro,
    required this.isCompra,
    required this.isBolivares,
    required this.monto,
    required this.compraUSDT,
    required this.bolivarController,
    required this.onChangeBolivar,
    this.onToggleCompraVenta,
  });

  @override
  Widget build(BuildContext context) {
    final double currentPrice =
        isCompra ? (compraUSDT ? priceCompra : priceVenta) : priceCompra;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF09090b),
        borderRadius: BorderRadius.circular(8),
        border: const Border.fromBorderSide(
          BorderSide(color: Color(0xFF27272a)),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(currentPrice),
          const SizedBox(height: 8),
          _buildMainValues(currentPrice),
          const SizedBox(height: 14),
          ShadcnInput(
            controller: controller,
            suffixText:
                isEuro ? "€" : (isBolivares ? "Bs." : "\$"),
            label: "Convertir a $title",
            onChanged: onChanged,
            small: true,
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(double currentPrice) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        isCompra
            ? TextButton(
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize:
                      MaterialTapTargetSize.shrinkWrap,
                ),
                onPressed: () {
                  onToggleCompraVenta?.call();
                  double nuevoPrecio = compraUSDT
                      ? priceCompra
                      : priceVenta;
                  controller.text =
                      nuevoPrecio.toStringAsFixed(2);
                  if (bolivarController.text.isNotEmpty) {
                    onChangeBolivar(bolivarController.text);
                  } else if (controller.text.isNotEmpty &&
                      !isBolivares) {
                    // solo actualiza el monto si es necesario
                  }
                },
                child: Text(
                  compraUSDT ? "Compra" : "Venta",
                  style: TextStyle(
                    color: compraUSDT
                        ? Colors.greenAccent
                        : Colors.orangeAccent,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            : Text(
                DateFormat('hh:mm a').format(
                  date.toUtc().subtract(
                        const Duration(hours: 4),
                      ),
                ),
                style: const TextStyle(
                  color: Color(0xFFa1a1aa),
                  fontSize: 12,
                ),
              ),
      ],
    );
  }

  Widget _buildMainValues(double currentPrice) {
    final double secondValue = isBolivares
        ? (monto == 0 || currentPrice == 0
            ? 0
            : monto / currentPrice)
        : (controller.text.isEmpty
            ? 0.0
            : double.tryParse(controller.text) ?? 0.0);

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: Row(
        key: ValueKey("${isCompra}_${compraUSDT ? 'compra' : 'venta'}"),
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "${currentPrice.toStringAsFixed(2)} Bs",
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 24,
            ),
          ),
          Text(
            "${secondValue.toStringAsFixed(2)}${isEuro ? "€" : "\$"}",
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 18,
              color: Color(0xFFa1a1aa),
            ),
          ),
        ],
      ),
    );
  }
}
