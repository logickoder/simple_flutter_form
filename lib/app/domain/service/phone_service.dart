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
}
