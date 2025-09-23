import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BaseText extends StatelessWidget {
  final String text;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final TextDecoration? decoration;
  final double? letterSpacing;
  final double? lineHeight;

  const BaseText(
      this.text, {
        super.key,
        this.fontSize,
        this.fontWeight,
        this.color,
        this.textAlign,
        this.maxLines,
        this.overflow,
        this.decoration,
        this.letterSpacing,
        this.lineHeight,
      });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign ?? TextAlign.start,
      maxLines: maxLines,
      overflow: overflow,
      style: GoogleFonts.roboto(
        fontSize: fontSize ?? 16,
        fontWeight: fontWeight ?? FontWeight.normal,
        color: color ?? Colors.black,
        decoration: decoration ?? TextDecoration.none,
        letterSpacing: letterSpacing,
        height: lineHeight,
      ),
    );
  }
}
