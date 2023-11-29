import 'package:flutter/material.dart';

import '../app/data/model/form.dart' as model;

import '../app/domain/service/form_service.dart';
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

  final _title = TextEditingController();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _phoneNumber = TextEditingController();
  final _dateOfBirth = TextEditingController();
  final _address = TextEditingController();

  var _formSaving = false;

  @override
  void initState() {
    Future.delayed(Duration.zero, _loadForm);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const spacing = SizedBox(height: 16);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          form == null ? 'Enter your details' : 'Update your details',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _form,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const FormLabel('Title'),
              TextFormField(
                controller: _title,
                decoration: const InputDecoration(
                  hintText: 'Enter the form title',
                ),
                validator: _titleValidator,
              ),
              spacing,
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
                  onPressed: _formSaving ? null : _submitForm,
                  child: _formSaving
                      ? CircularProgressIndicator(
                          color: AppColor.of(context).background,
                        )
                      : Text(form == null ? 'Save' : 'Update'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  model.Form? get form {
    return ModalRoute.of(context)?.settings.arguments as model.Form?;
  }

  void _loadForm() async {
    final form = this.form;
    if (form == null) {
      return;
    }

    _title.text = form.title;
    _name.text = form.name;
    _email.text = form.email;
    _phoneNumber.text = form.phoneNumber;
    _dateOfBirth.text = () {
      final day = form.dateOfBirth.day.toString().padLeft(2, '0');
      final month = form.dateOfBirth.month.toString().padLeft(2, '0');
      final year = form.dateOfBirth.year;
      return '$day/$month/$year';
    }();
    _address.text = form.address;
  }

  String? _titleValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter the form title';
    }

    return null;
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

    setState(() => _formSaving = true);

    final dateOfBirth = _dateOfBirth.text;
    final dateSplits = dateOfBirth.split('/');

    final form = model.Form(
      id: this.form?.id,
      title: _title.text,
      name: _name.text,
      email: _email.text,
      phoneNumber: _phoneNumber.text,
      dateOfBirth: DateTime(
        int.parse(dateSplits[2]),
        int.parse(dateSplits[1]),
        int.parse(dateSplits[0]),
      ),
      address: _address.text,
    );
    final message = form.id == null
        ? 'Form saved successfully'
        : 'Form updated successfully';

    FormService.save(form).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
      Navigator.pop(context, true);
    }).whenComplete(() {
      setState(() => _formSaving = false);
    });
  }
}
