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
    return TextFormField(
      controller: controller,
      onChanged: onChanged,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      style: TextStyle(fontSize: small ? 13 : 14, color: Colors.white),
      decoration: InputDecoration(
        isDense: true,
        labelText: label,
        labelStyle: TextStyle(
          color: const Color(0xFFa1a1aa),
          fontSize: small ? 12 : 14,
        ),
        floatingLabelBehavior: FloatingLabelBehavior.never,
        hintText: label,
        hintStyle: TextStyle(
          color: const Color(0xFF3f3f46),
          fontSize: small ? 13 : 14,
        ),

        prefixIcon: icon != null
            ? Icon(icon, size: small ? 16 : 20, color: const Color(0xFFa1a1aa))
            : null,

        suffixIcon: suffixText != null
            ? Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      suffixText!,
                      style: TextStyle(
                        color: const Color(0xFF71717a),
                        fontWeight: FontWeight.w500,
                        fontSize: small ? 11 : 13,
                      ),
                    ),
                  ],
                ),
              )
            : null,
        suffixIconConstraints: const BoxConstraints(minHeight: 0, minWidth: 0),

        filled: true,
        fillColor: const Color(0xFF09090b),

        contentPadding: EdgeInsets.symmetric(
          horizontal: 12,
          vertical: small ? 10 : 14,
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(small ? 6 : 8),
          borderSide: const BorderSide(color: Color(0xFF27272a)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(small ? 6 : 8),
          borderSide: const BorderSide(color: Colors.white, width: 0.8),
        ),
      ),
    );
  }
}
