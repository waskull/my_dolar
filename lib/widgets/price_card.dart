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
  final bool compraUSDT;
  final VoidCallback onToggleType;
  final bool isBolivares;

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
    this.isCompra = false,
    required this.compraUSDT,
    required this.onToggleType,
    required this.isBolivares,
  });

  @override
  Widget build(BuildContext context) {
    final double currentPrice = isCompra ? (compraUSDT ? priceCompra : priceVenta) : priceCompra;

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
              Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
              isCompra
                  ? TextButton(
                      onPressed: onToggleType,
                      child: Text(
                        compraUSDT ? "Compra" : "Venta",
                        style: TextStyle(
                          color: compraUSDT ? Colors.greenAccent : Colors.orangeAccent,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  : Text(
                      DateFormat('hh:mm a').format(date.toLocal()),
                      style: const TextStyle(color: Color(0xFFa1a1aa), fontSize: 12),
                    ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("${currentPrice.toStringAsFixed(2)} Bs",
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 24)),
              Text(
                "${(isBolivares ? (inDolar / currentPrice) : (controller.text.isEmpty ? 0.0 : double.parse(controller.text))).toStringAsFixed(2)}${isEuro ? "€" : "\$"}",
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18, color: Color(0xFFa1a1aa)),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ShadcnInput(
            controller: controller,
            suffixText: isEuro ? "€" : (isBolivares ? "Bs." : "\$"),
            label: "Convertir a $title",
            onChanged: onChanged,
            small: true,
          ),
        ],
      ),
    );
  }
}