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
      'version': 'Verzió v##',
      'created_text1': 'Készült Budapesten \u2665',
      'created_text2': 'A kijárási korlátozás alatt, 2020',
      'created_text3': '',
      'news_minute_ago': '## perce',
      'news_minutes_ago': '## perce',
      'news_hour_ago': '## órája',
      'news_hours_ago': '## órája',
      'news_day_ago': '## napja',
      'news_days_ago': '## napja',
      'information': 'Információk és tippek',
      'update_title': 'Új verzió',
      'update_available': 'Új verzió érhető el. Kérjük frissítse az alkalmazást.',
      'modal_ok': 'Frissítés',
      'modal_cancel': 'Mégse'
    },
    'de': {
      'title': 'COVID-19 Information',
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
      'version': 'Version v##',
      'created_text1': 'Entwickelt wurde mit \u2665',
      'created_text2': 'In Budapest während Lockdown, 2020',
      'created_text3': '\u2726 Erstellt von: Zsolt Sarosi and Xuezhou Fan. Budapest, 2020 \u2726',
      'news_minute_ago': 'vor ## Minute',
      'news_minutes_ago': 'vor ## Minuten',
      'news_hour_ago': 'vor ## Stunde',
      'news_hours_ago': 'vor ## Stunden',
      'news_day_ago': 'vor ## Tag',
      'news_days_ago': 'vor ## Tagen',
      'information': 'Informationen und Tipps',
      'update_title': 'Neue Version',
      'update_available': 'Neue Version verfügbar. Bitte aktualisieren Sie die App.',
      'modal_ok': 'Aktualisieren',
      'modal_cancel': 'Abbrechen'
    },
    'en': {
      'title': 'COVID-19 Information',
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
      'version': 'Version v##',
      'created_text1': 'Made with \u2665',
      'created_text2': 'In Budapest during lockdown, 2020',
      'created_text3': '\u2726 Created by: Zsolt Sarosi and Xuezhou Fan. Budapest, 2020 \u2726',
      'news_minute_ago': '## minute ago',
      'news_minutes_ago': '## minutes ago',
      'news_hour_ago': '## hour ago',
      'news_hours_ago': '## hours ago',
      'news_day_ago': '## day ago',
      'news_days_ago': '## days ago',
      'information': 'Information and Tips',
      'update_title': 'New Version',
      'update_available': 'New version available. Please update the app.',
      'modal_ok': 'Update',
      'modal_cancel': 'Cancel'
    },
  };

  String get title {
    return _localizedValues[locale.languageCode]['title'];
  }

  String get pageWorld {
    return _localizedValues[locale.languageCode]['page_world'];
  }

  String get pageCountries {
    return _localizedValues[locale.languageCode]['page_countries'];
  }

  String get pageNews {
    return _localizedValues[locale.languageCode]['page_news'];
  }

  String get pageInformation {
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

  String get createdText1 {
    return _localizedValues[locale.languageCode]['created_text1'];
  }

  String get createdText2 {
    return _localizedValues[locale.languageCode]['created_text2'];
  }

  String get createdText3 {
    return _localizedValues[locale.languageCode]['created_text3'];
  }

  String get newsMinuteAgo {
    return _localizedValues[locale.languageCode]['news_minute_ago'];
  }

  String get newsMinutesAgo {
    return _localizedValues[locale.languageCode]['news_minutes_ago'];
  }

  String get newsHourAgo {
    return _localizedValues[locale.languageCode]['news_hour_ago'];
  }

  String get newsHoursAgo {
    return _localizedValues[locale.languageCode]['news_hours_ago'];
  }

  String get newsDayAgo {
    return _localizedValues[locale.languageCode]['news_day_ago'];
  }

  String get newsDaysAgo {
    return _localizedValues[locale.languageCode]['news_days_ago'];
  }

  String get information {
    return _localizedValues[locale.languageCode]['information'];
  }

  String get update_title {
    return _localizedValues[locale.languageCode]['update_title'];
  }

  String get update_available {
    return _localizedValues[locale.languageCode]['update_available'];
  }

  String get modal_ok {
    return _localizedValues[locale.languageCode]['modal_ok'];
  }

  String get modal_cancel {
    return _localizedValues[locale.languageCode]['modal_cancel'];
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
