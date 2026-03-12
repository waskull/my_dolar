import 'package:flutter/material.dart';

class ShadcnInput extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final Function(String) onChanged;
  final IconData? icon;
  final bool small;
  final String? suffixText;

  const ShadcnInput({
    super.key,
    required this.controller,
    required this.label,
    required this.onChanged,
    this.icon,
    this.small = false,
    this.suffixText,
  });

  @override
  Widget build(BuildContext context) {
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
                padding: const EdgeInsets.only(right: 8, top: 15),
                child: Text(
                  suffixText!,
                  style: const TextStyle(
                    color: Color(0xFF71717a),
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                  ),
                ),
              )
            : null,
        filled: true,
        fillColor: const Color(0xFF09090b),
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
