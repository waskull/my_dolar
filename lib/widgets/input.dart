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
    this.small = true,
    this.suffixText,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: TextFormField(
        controller: controller,
        onChanged: onChanged,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        style: const TextStyle(fontSize: 13, color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Color(0xFFa1a1aa), fontSize: 13),
          floatingLabelBehavior: FloatingLabelBehavior.never,
          hintText: label,
          hintStyle: const TextStyle(color: Color.fromARGB(255, 125, 125, 125), fontSize: 13),
          prefixIcon: icon != null
              ? Icon(icon, size: 16, color: const Color(0xFFa1a1aa))
              : null,
          suffixIcon: suffixText != null
              ? Container(
                  padding: const EdgeInsets.only(right: 12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        suffixText!,
                        style: const TextStyle(
                          color: Color(0xFF71717a),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                )
              : null,
          filled: true,
          fillColor: const Color(0xFF09090b),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 8,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: const BorderSide(color: Color(0xFF27272a)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: const BorderSide(color: Colors.white, width: 0.8),
          ),
        ),
      ),
    );
  }
}
