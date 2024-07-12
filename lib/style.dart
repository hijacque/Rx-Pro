import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const LIGHT_PURPLE = Color(0xFFDABFFF);
const PURPLE = Color(0xFF907AD6);
const BLUE = Color(0xFF4F518C);
const INDIGO = Color(0xFF2C2A4A);
const LIGHT = Color(0xFFF4F4F5);
const DARK = Color(0xFF161616);
const LIGHT_GREY = Color(0xFFBDBDBD);
const DANGER = Color(0xFFFC515D);
const WARNING = Color(0xFFFFCA2A);
const SUCCESS = Color(0xFF00D06B);

OutlineInputBorder roundedBorder(Color? color) => OutlineInputBorder(
      borderSide: BorderSide(color: color ?? LIGHT, width: 1.5),
      borderRadius: BorderRadius.circular(8.0),
    );

final InputDecoration lightTextFieldStyle = InputDecoration(
  isDense: true,
  counterText: "",
  filled: true,
  fillColor: Colors.white,
  border: roundedBorder(LIGHT),
  enabledBorder: roundedBorder(LIGHT),
  focusedBorder: roundedBorder(PURPLE),
  contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
  isCollapsed: true,
);

ButtonStyle lightButtonStyle = TextButton.styleFrom(
  backgroundColor: Colors.white,
  shadowColor: Colors.grey,
  elevation: 3,
  side: const BorderSide(color: LIGHT, width: 1.5),
  padding: const EdgeInsets.symmetric(horizontal: 8),
);

const Decoration lightContainerDecoration = BoxDecoration(
  boxShadow: [
    BoxShadow(
      color: Colors.black26,
      spreadRadius: 0.5,
      blurRadius: 4,
    ),
  ],
  color: Colors.white,
  borderRadius: BorderRadius.all(Radius.circular(8)),
);

ButtonStyle primaryButtonStyle = TextButton.styleFrom(
  backgroundColor: INDIGO,
  shadowColor: Colors.grey,
  elevation: 3,
  side: const BorderSide(color: DARK, width: 1.5),
  padding: const EdgeInsets.symmetric(horizontal: 8),
);

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}

