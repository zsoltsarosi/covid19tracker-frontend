import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter/foundation.dart' show SynchronousFuture;

class Translations {
  Translations(this.locale);

  final Locale locale;

  static Translations of(BuildContext context) {
    return Localizations.of<Translations>(context, Translations);
  }

  static Map<String, Map<String, String>> _localizedValues = {
    'hu': {
      'title': 'COVID-19 Információ',
      'page_world': 'Világ',
      'page_countries': 'Országok',
      'page_news': 'Hírek',
      'page_information': 'Információ',
      'confirmed': 'Fertőzött',
      'recovered': 'Gyógyult',
      'died': 'Elhunyt',
      'change': 'Változás',
      'date': 'Dátum',
      'country': 'Ország',
    },
    'de': {
      'title': 'COVID-19 Tracker',
      'page_world': 'Welt',
      'page_countries': 'Länder',
      'page_news': 'Nachrichten',
      'page_information': 'Information',
      'confirmed': 'Infizierte',
      'recovered': 'Genesene',
      'died': 'Verstorbene',
      'change': 'Dif­fe­renz',
      'date': 'Datum',
      'country': 'Land',
    },
    'en': {
      'title': 'COVID-19 Tracker',
      'page_world': 'World',
      'page_countries': 'Countries',
      'page_news': 'News',
      'page_information': 'Information',
      'confirmed': 'Confirmed',
      'recovered': 'Recovered',
      'died': 'Died',
      'change': 'Change',
      'date': 'Date',
      'country': 'Country',
    },
  };

  String get title {
    return _localizedValues[locale.languageCode]['title'];
  }

  String get page_world {
    return _localizedValues[locale.languageCode]['page_world'];
  }

  String get page_countries {
    return _localizedValues[locale.languageCode]['page_countries'];
  }

  String get page_news {
    return _localizedValues[locale.languageCode]['page_news'];
  }

  String get page_information {
    return _localizedValues[locale.languageCode]['page_information'];
  }

  String get confirmed {
    return _localizedValues[locale.languageCode]['confirmed'];
  }
  String get recovered {
    return _localizedValues[locale.languageCode]['recovered'];
  }
  String get died {
    return _localizedValues[locale.languageCode]['died'];
  }
  String get change {
    return _localizedValues[locale.languageCode]['change'];
  }
  String get date {
    return _localizedValues[locale.languageCode]['date'];
  }
  String get country {
    return _localizedValues[locale.languageCode]['country'];
  }

}

class TranslationsDelegate extends LocalizationsDelegate<Translations> {
  const TranslationsDelegate();

  @override
  bool isSupported(Locale locale) => ['hu', 'de', 'en'].contains(locale.languageCode);

  @override
  Future<Translations> load(Locale locale) {
    // Returning a SynchronousFuture here because an async "load" operation
    // isn't needed to produce an instance of DemoLocalizations.
    return SynchronousFuture<Translations>(Translations(locale));
  }

  @override
  bool shouldReload(TranslationsDelegate old) => false;
}