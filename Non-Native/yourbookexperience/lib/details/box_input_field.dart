import 'package:flutter/material.dart';
import 'package:yourbookexperience/common/theme/colors.dart';

class BoxInputField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  const BoxInputField({
    super.key,
    required this.controller,
    required this.label,
  });
  @override
  State<BoxInputField> createState() => _BoxInputFieldState();
}

class _BoxInputFieldState extends State<BoxInputField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.foreground1, width: 2),
          ),
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              SizedBox(
                  width: double.infinity,
                  child: Container(
                      decoration: const BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  color: AppColors.foreground1, width: 2))),
                      child: Text(
                        widget.label,
                        style: Theme.of(context).textTheme.titleMedium,
                        textAlign: TextAlign.center,
                      ))),
              TextField(
                controller: widget.controller,
                maxLines: null,
                style: Theme.of(context).textTheme.bodyMedium,
              )
            ],
          )),
    );
  }
}
