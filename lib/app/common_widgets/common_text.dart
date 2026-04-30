import 'package:flutter/material.dart';

class CommonText extends StatelessWidget {
  final String text;
  final double? fontSize;
  final Color? color;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final FontStyle? fontStyle;

  const CommonText(
      this.text, {
        super.key,
        this.fontSize,
        this.color,
        this.fontWeight,
        this.textAlign,
        this.maxLines,
        this.overflow,
        this.fontStyle,
      });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign ?? TextAlign.start,
      maxLines: maxLines,
      overflow: overflow ?? TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: fontSize ?? 14,
        color: color ?? Colors.black,
        fontWeight: fontWeight ?? FontWeight.normal,
        fontStyle: fontStyle,
      ),
    );
  }
}

