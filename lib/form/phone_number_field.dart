import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../app/data/model/country.dart';
import '../app/domain/service/phone_service.dart';

class PhoneNumberField extends StatefulWidget {
  const PhoneNumberField({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final TextEditingController controller;

  @override
  State<PhoneNumberField> createState() => _PhoneNumberFieldState();
}

class _PhoneNumberFieldState extends State<PhoneNumberField> {
  Country? _country;

  final _controller = TextEditingController();

  @override
  void initState() {
    widget.controller.addListener(_loadPhoneNumber);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.next,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        _PhoneNumberSpacingFormatter(),
      ],
      // requires a max length of 12 because of the spacing formatter
      maxLength: 12,
      validator: (value) {
        final number = value ?? '';
        if (_country == null) {
          return 'Please select a dialing code from the modal';
        } else if (number.isEmpty) {
          return 'A phone number is required';
        } else {
          widget.controller.text = '${_country?.dialCode ?? ''} $number';
          return null;
        }
      },
      decoration: InputDecoration(
        prefixIcon: _dialCodeSelector(),
        counter: const SizedBox.shrink(),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _dialCodeSelector() {
    final textTheme = Theme.of(context).textTheme;
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(width: 8),
        InkWell(
          onTap: () => showModalBottomSheet(
            context: context,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            builder: (ctx) => _CountryDialCodeSelector(
              onCountryClicked: (value) {
                setState(() => _country = value);
                Navigator.pop(ctx);
              },
            ),
          ),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              border: Border.all(),
            ),
            child: Row(
              children: [
                if (_country != null) ...{
                  _Emoji(_country!.emoji),
                  const SizedBox(width: 8),
                },
                Icon(
                  Icons.keyboard_arrow_down_outlined,
                  color: textTheme.bodyMedium?.color ?? Colors.black,
                ),
              ],
            ),
          ),
        ),
        if (_country?.dialCode != null) ...{
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              _country!.dialCode,
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        },
      ],
    );
  }

  /// Loads the initial non-empty phone number from the controller
  void _loadPhoneNumber() {
    final number = widget.controller.text;
    if (number.isEmpty) {
      return;
    }

    final spaceIndex = number.indexOf(' ');
    final dialCode = number.substring(0, spaceIndex);
    final phoneNumber = number.substring(spaceIndex + 1);

    _controller.text = phoneNumber;
    PhoneService.getCountryByDialCode(dialCode).then((value) {
      setState(() => _country = value);
    });
  }
}

class _CountryDialCodeSelector extends StatefulWidget {
  const _CountryDialCodeSelector({
    Key? key,
    required this.onCountryClicked,
  }) : super(key: key);

  final Function(Country) onCountryClicked;

  @override
  State createState() => _CountryDialCodeSelectorState();
}

class _CountryDialCodeSelectorState extends State<_CountryDialCodeSelector> {
  final _queryController = StreamController<String>();
  late final _query = _queryController.stream;

  final _countriesController = StreamController<List<Country>>();
  late final _countries = _countriesController.stream;

  @override
  void initState() {
    Future.delayed(Duration.zero, _watchQueryStream);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 16,
        horizontal: 24,
      ),
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: SizedBox(
              width: double.infinity,
              child: Text(
                'Select your country',
                textAlign: TextAlign.center,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: TextField(
                onChanged: (value) {
                  _queryController.add(value);
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: theme.colorScheme.onPrimary,
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: const Icon(Icons.search),
                  hintText: 'Search country',
                ),
              ),
            ),
          ),
          StreamBuilder(
            stream: _countries,
            builder: (_, snapshot) {
              if (snapshot.hasError) {
                return SliverToBoxAdapter(
                  child: Text(
                    snapshot.error.toString(),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.error,
                    ),
                  ),
                );
              } else if (!snapshot.hasData) {
                return const SliverToBoxAdapter(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              final countries = snapshot.data ?? const [];
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (_, index) {
                    final country = countries[index];

                    return InkWell(
                      onTap: () => widget.onCountryClicked(country),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                        ),
                        child: Row(
                          children: [
                            _Emoji(country.emoji),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                country.name,
                                maxLines: 1,
                                style: theme.textTheme.bodyLarge,
                              ),
                            ),
                            Text(
                              country.dialCode,
                              style: theme.textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  childCount: countries.length,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _queryController.close();
    _countriesController.close();

    super.dispose();
  }

  Future<void> _watchQueryStream() async {
    final countries = await PhoneService.getCountries();
    // initialize the stream with the total list of countries
    _countriesController.add(countries);

    await for (final query in _query) {
      final searchQuery = query.toLowerCase().trim();
      _countriesController.add(
        query.isEmpty
            ? countries
            : countries
                .where(
                  (country) => country.name.toLowerCase().contains(searchQuery),
                )
                .toList(),
      );
    }
  }
}

class _Emoji extends StatelessWidget {
  const _Emoji(this.emoji);

  final String emoji;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Text(
        emoji,
        style: const TextStyle(
          fontSize: 20,
        ),
      ),
    );
  }
}

class _PhoneNumberSpacingFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;
    final newText = StringBuffer();

    for (var i = 0; i < text.length; ++i) {
      if (i == 3 || i == 6) {
        newText.write(' ');
      }
      newText.write(text[i]);
    }

    return newValue.copyWith(
      text: newText.toString(),
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}
