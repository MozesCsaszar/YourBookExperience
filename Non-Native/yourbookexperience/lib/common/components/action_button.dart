import 'package:flutter/material.dart';
import 'package:yourbookexperience/common/theme/colors.dart';

class ActionButton extends StatefulWidget {
  final Function() onTap;
  final String text;

  const ActionButton({super.key, required this.onTap, required this.text});

  @override
  State<StatefulWidget> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<ActionButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Container(
          decoration: BoxDecoration(
            border: Border.all(width: 2, color: AppColors.foreground1),
            borderRadius: BorderRadius.circular(12),
            color: AppColors.foreground2,
          ),
          child: SizedBox(
              width: double.infinity,
              child: GestureDetector(
                onTap: () {
                  widget.onTap();
                },
                child: Text(
                  widget.text,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ))),
    );
  }
}
