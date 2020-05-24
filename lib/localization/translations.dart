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
      'search': 'Keresés',
      'version': 'Verzió v1.0',
      'created_text1': 'Készült Budapesten \u2665',
      'created_text2': 'A kijárási korlátozás alatt, 2020',
      'created_text3': '',
    },
    'de': {
      'title': 'COVID-19 Tracker',
      'page_world': 'Welt',
      'page_countries': 'Länder',
      'page_news': 'News',
      'page_information': 'Information',
      'confirmed': 'Infizierte',
      'recovered': 'Genesene',
      'died': 'Verstorbene',
      'change': 'Veränderung',
      'date': 'Datum',
      'country': 'Land',
      'search': 'Suche',
      'version': 'Version v1.0',
      'created_text1': 'Entwickelt wurde mit \u2665',
      'created_text2': 'In Budapest während Lockdown, 2020',
      'created_text3': '\u2726 Erstellt von: Zsolt Sarosi, Xuezhou Fan. Budapest, 2020 \u2726',
    },
    'en': {
      'title': 'COVID-19 Tracker',
      'page_world': 'World',
      'page_countries': 'Countries',
      'page_news': 'News',
      'page_information': 'Information',
      'confirmed': 'Confirmed',
      'recovered': 'Recovered',
      'died': 'Deaths',
      'change': 'Change',
      'date': 'Date',
      'country': 'Country',
      'search': 'Search',
      'version': 'Version v1.0',
      'created_text1': 'Created with \u2665',
      'created_text2': 'In Budapest during lockdown, 2020',
      'created_text3': '\u2726 Created by: Zsolt Sarosi, Xuezhou Fan. Budapest, 2020 \u2726',
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
  String get search {
    return _localizedValues[locale.languageCode]['search'];
  }
  String get version {
    return _localizedValues[locale.languageCode]['version'];
  }
  String get created_text1 {
    return _localizedValues[locale.languageCode]['created_text1'];
  }
  String get created_text2 {
    return _localizedValues[locale.languageCode]['created_text2'];
  }
  String get created_text3 {
    return _localizedValues[locale.languageCode]['created_text3'];
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