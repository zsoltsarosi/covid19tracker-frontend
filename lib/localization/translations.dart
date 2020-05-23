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
    },
    'de': {
      'title': 'COVID-19 Tracker',
    },
    'en': {
      'title': 'COVID-19 Tracker',
    },
  };

  String get title {
    return _localizedValues[locale.languageCode]['title'];
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