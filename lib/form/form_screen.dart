import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../app/theme.dart';
import 'date_of_birth_field.dart';
import 'form_label.dart';
import 'phone_number_field.dart';

class FormScreen extends StatefulWidget {
  const FormScreen({super.key});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final _form = GlobalKey<FormState>();

  final _name = TextEditingController();
  final _email = TextEditingController();
  final _phoneNumber = TextEditingController();
  final _dateOfBirth = TextEditingController();
  final _address = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final color = AppColor.of(context);
    const spacing = SizedBox(height: 16);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _form,
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
                controller: _name,
                decoration: const InputDecoration(
                  hintText: 'Enter your full name',
                ),
                validator: _nameValidator,
              ),
              spacing,
              const FormLabel('E-mail'),
              TextFormField(
                controller: _email,
                decoration: const InputDecoration(
                  hintText: 'Enter your e-mail address',
                ),
                validator: _emailValidator,
              ),
              spacing,
              const FormLabel('Phone Number'),
              PhoneNumberField(
                controller: _phoneNumber,
              ),
              spacing,
              const FormLabel('Date of Birth'),
              DateOfBirthField(
                controller: _dateOfBirth,
              ),
              spacing,
              const FormLabel('Address'),
              TextFormField(
                controller: _address,
                decoration: const InputDecoration(
                  hintText: 'Enter your address',
                ),
                validator: _addressValidator,
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  child: const Text('Submit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String? _nameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your name';
    }

    return null;
  }

  String? _emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your e-mail address';
    }

    if (!(value.contains('@') && value.contains('.'))) {
      return 'Please enter a valid e-mail address';
    }

    return null;
  }

  String? _addressValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your address';
    }

    return null;
  }

  void _submitForm() {
    if (!_form.currentState!.validate()) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Form submitted'),
      ),
    );
    Navigator.pop(context);
  }
}
