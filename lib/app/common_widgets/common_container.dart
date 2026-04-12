import 'package:flutter/material.dart';

class CommonContainer extends StatelessWidget{

  const CommonContainer(
      {
        super.key,
        this.height,
        this.width,
        this.child,
        this.padding,
        this.margin,
        this.alignment,
      });

  final double? height;
  final double? width;
  final Widget ? child;
  final EdgeInsetsGeometry ? padding;
  final EdgeInsetsGeometry ? margin;
  final AlignmentGeometry ? alignment;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: height,
        padding: padding,
        margin: margin,
        alignment: alignment,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color(0xffebffff),
              Colors.white,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.blueGrey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 1,
              offset: const Offset(.2, .2),
            ),
          ],
        ),
        child: child,
    );
  }



}