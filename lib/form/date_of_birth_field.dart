import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DateOfBirthField extends StatelessWidget {
  const DateOfBirthField({
    super.key,
    required this.controller,
    this.decoration = const InputDecoration(
      hintText: 'DD/MM/YYYY',
    ),
  });

  final TextEditingController controller;
  final InputDecoration decoration;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        _DateOfBirthFormatter(),
      ],
      keyboardType: TextInputType.datetime,
      // requires a max length of 10 because of the spacing formatter
      maxLength: 10,
      decoration: decoration.copyWith(
        counter: const SizedBox.shrink(),
      ),
      validator: _validator,
      textInputAction: TextInputAction.next,
    );
  }

  String? _validator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your date of birth';
    }

    final splits = value.split('/');
    if (splits.length != 3) {
      return 'Please enter a valid date of birth';
    }

    final day = int.tryParse(splits[0]);
    final month = int.tryParse(splits[1]);
    final year = int.tryParse(splits[2]);

    if (day == null || month == null || year == null) {
      return 'Please enter a valid date of birth';
    }

    if (year < 1900 || year > DateTime.now().year) {
      return 'Please enter a valid year';
    }

    if (month < 1 || month > 12) {
      return 'Please enter a valid month';
    }

    switch (month) {
      case 1:
      case 3:
      case 5:
      case 7:
      case 8:
      case 12:
        if (day < 1 || day > 31) {
          return 'Please enter a valid day';
        }
        break;
      case 4:
      case 6:
      case 9:
      case 11:
        if (day < 1 || day > 30) {
          return 'Please enter a valid day';
        }
        break;
      case 2:
        if (year % 4 == 0) {
          if (day < 1 || day > 29) {
            return 'Please enter a valid day';
          }
        } else {
          if (day < 1 || day > 28) {
            return 'Please enter a valid day';
          }
        }
        break;
    }

    return null;
  }
}

class _DateOfBirthFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final oldText = oldValue.text;
    final newText = newValue.text;

    if (oldText.length == newText.length) {
      return newValue;
    }

    final buffer = StringBuffer();

    for (var index = 0; index < newText.length; ++index) {
      if (index == 2 || index == 4) {
        buffer.write('/');
      }

      buffer.write(newText.characters.elementAt(index));
    }

    return newValue.copyWith(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }
}
