import 'dart:convert';

import 'package:flutter/services.dart';

import '../../asset.dart';
import '../../data/model/country.dart';

class PhoneService {
  static Future<List<Country>> getCountries() async {
    final json = await rootBundle.loadString(AppAsset.countries);
    final countries = jsonDecode(json) as List<dynamic>;
    return countries.map((e) => Country.fromJson(e)).toList();
  }

  static Future<Country?> getCountryByDialCode(String dialCode) {
    return getCountries().then((countries) {
      final index = countries.indexWhere(
        (country) => country.dialCode == dialCode,
      );
      if (index == -1) {
        return null;
      }

      return countries[index];
    });
  }
}
