import 'package:flutter/material.dart';

class FormButton extends StatelessWidget {
  final Color backgroundColor;
  final Color textColor;
  final String text;
  final double borderRadius;
  final bool disabled;
  final bool isSmall;
  final Widget? content;
  final void Function()? onTap;

  const FormButton(
      {this.backgroundColor = const Color(0xff0F9A47),
      this.text = 'texto',
      this.disabled = false,
      this.isSmall = false,
      this.textColor = const Color(0xffFFFFFF),
      this.onTap,
      this.content,
      this.borderRadius = 10,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          if (disabled || onTap == null) {
            return;
          }
          onTap!();
        },
        child: Container(
          width: double.infinity,
          height: isSmall ? 40 : 55,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: disabled ? Colors.grey.shade200 : backgroundColor,
            borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
          ),
          child:  content ?? Text(
            text,
            style: TextStyle(
                color: disabled ? Colors.grey.shade700 : textColor,
                fontWeight: FontWeight.bold),
          ),
        ));
  }
}
