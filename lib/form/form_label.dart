import 'package:flutter/material.dart';
import 'package:simple_flutter_form/app/theme.dart';

class FormLabel extends StatelessWidget {
  const FormLabel(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColor.of(context).title,
          ),
    );
  }
}
