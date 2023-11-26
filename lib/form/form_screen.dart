import 'package:flutter/material.dart';

import '../app/theme.dart';
import 'form_label.dart';

class FormScreen extends StatelessWidget {
  const FormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final color = AppColor.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Form'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Enter your details',
              style: textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: color.title,
              ),
            ),
            const SizedBox(height: 32),
            const FormLabel('Name'),
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'Enter your full name',
              ),
            ),
            const FormLabel('E-mail'),
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'Enter your e-mail address',
              ),
            ),
            const FormLabel('Password'),
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'Password',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
