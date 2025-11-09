import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';

/// Виджет для рендеринга математических формул в LaTeX формате
class MathFormulaWidget extends StatelessWidget {
  final String latex;
  final double fontSize;
  final Color? textColor;
  final TextAlign textAlign;

  const MathFormulaWidget({
    super.key,
    required this.latex,
    this.fontSize = 18.0,
    this.textColor,
    this.textAlign = TextAlign.center,
  });

  @override
  Widget build(BuildContext context) {
    final color = textColor ?? Theme.of(context).textTheme.bodyLarge?.color;

    // Handle empty or invalid LaTeX
    if (latex.trim().isEmpty) {
      return const SizedBox.shrink();
    }

    try {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Math.tex(
          latex,
          textStyle: TextStyle(
            fontSize: fontSize,
            color: color,
          ),
          mathStyle: MathStyle.display,
          textScaleFactor: 1.0,
        ),
      );
    } catch (e) {
      debugPrint('❌ Error rendering LaTeX: $latex - Error: $e');
      // Fallback to plain text if LaTeX is invalid
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Text(
          latex,
          style: TextStyle(
            fontSize: fontSize,
            color: color,
            fontFamily: 'monospace',
          ),
          textAlign: textAlign,
        ),
      );
    }
  }
}

/// Инлайн математическая формула (для встраивания в текст)
class InlineMathWidget extends StatelessWidget {
  final String latex;
  final double fontSize;
  final Color? textColor;

  const InlineMathWidget({
    super.key,
    required this.latex,
    this.fontSize = 16.0,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final color = textColor ?? Theme.of(context).textTheme.bodyMedium?.color;

    if (latex.trim().isEmpty) {
      return const SizedBox.shrink();
    }

    try {
      return Math.tex(
        latex,
        textStyle: TextStyle(
          fontSize: fontSize,
          color: color,
        ),
        mathStyle: MathStyle.text,
      );
    } catch (e) {
      debugPrint('❌ Error rendering inline LaTeX: $latex');
      return Text(
        latex,
        style: TextStyle(
          fontSize: fontSize,
          color: color,
          fontFamily: 'monospace',
        ),
      );
    }
  }
}
