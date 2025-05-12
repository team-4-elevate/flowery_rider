// features/auth/data/models/apply/country_data.dart
import 'package:flowery_rider/features/auth/data/models/apply/country_model.dart';

class CountryData {
  static List<Country> getDefaultCountries() {
    return [
      Country(
        isoCode: 'EG',
        name: 'Egypt',
        phoneCode: '20',
        flag: '🇪🇬',
        currency: 'EGP',
      ),
      Country(
        isoCode: 'SA',
        name: 'Saudi Arabia',
        phoneCode: '966',
        flag: '🇸🇦',
        currency: 'SAR',
      ),
      Country(
        isoCode: 'AE',
        name: 'United Arab Emirates',
        phoneCode: '971',
        flag: '🇦🇪',
        currency: 'AED',
      ),
      Country(
        isoCode: 'KW',
        name: 'Kuwait',
        phoneCode: '965',
        flag: '🇰🇼',
        currency: 'KWD',
      ),
    ];
  }

  static Country getDefaultCountry() {
    return Country(
      isoCode: 'EG',
      name: 'Egypt',
      phoneCode: '20',
      flag: '🇪🇬',
      currency: 'EGP',
    );
  }
}
