import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'input.dart';

class PriceCard extends StatelessWidget {
  final String title;
  final double priceCompra;
  final double priceVenta;
  final DateTime date;
  final TextEditingController controller;
  final Function(String) onChanged;
  final double monto;
  final bool isEuro;
  final bool isCompra;
  final bool isBolivares;
  final bool compraUSDT;
  final VoidCallback onToggleCompraUSDT;

  const PriceCard({
    super.key,
    required this.title,
    required this.priceCompra,
    required this.priceVenta,
    required this.date,
    required this.controller,
    required this.onChanged,
    required this.monto,
    required this.isEuro,
    this.isCompra = false,
    required this.isBolivares,
    required this.compraUSDT,
    required this.onToggleCompraUSDT,
  });

  @override
  Widget build(BuildContext context) {
    final currentPrice =
        isCompra ? (compraUSDT ? priceCompra : priceVenta) : priceCompra;

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
          _buildHeader(),
          const SizedBox(height: 8),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: Row(
              key: ValueKey("$title-${compraUSDT ? 'compra' : 'venta'}"),
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
                  "${(isBolivares ? (monto / currentPrice) : double.tryParse(controller.text) ?? 0.0).toStringAsFixed(2)}${isEuro ? "€" : "\$"}",
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    color: Color(0xFFa1a1aa),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          ShadcnInput(
            controller: controller,
            label: "Convertir a $title",
            suffixText: isEuro ? "€" : (isBolivares ? "Bs." : "\$"),
            onChanged: onChanged,
            small: true,
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
        if (isCompra)
          TextButton(
            onPressed: onToggleCompraUSDT,
            child: Text(
              compraUSDT ? "Compra" : "Venta",
              style: TextStyle(
                color: compraUSDT ? Colors.greenAccent : Colors.orangeAccent,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        else
          Text(
            DateFormat('hh:mm a')
                .format(date.toUtc().subtract(const Duration(hours: 4))),
            style: const TextStyle(
              color: Color(0xFFa1a1aa),
              fontSize: 12,
            ),
          ),
      ],
    );
  }
}
