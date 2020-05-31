import 'package:covid19tracker/screens/country_detail.dart';
import 'package:covid19tracker/widgets/figure_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:covid19tracker/helper/extension_methods.dart';
import 'package:covid19tracker/model/country_data.dart';
import 'package:intl/intl.dart';

class CountryDataView extends StatelessWidget {
  final CountryData data;

  CountryDataView({this.data});

  @override
  Widget build(BuildContext context) {
    Locale myLocale = Localizations.localeOf(context);
    NumberFormat formatter = NumberFormat("#,###", myLocale.languageCode);
    TextTheme textTheme = Theme.of(context).textTheme;
    final labelTextStyle = textTheme.bodyText2;
    final valueTextStyle = textTheme.subtitle1;

    var confirmedStyle = valueTextStyle.copyWith(color: Theme.of(context).colorScheme.confirmed);
    var recoveredStyle = valueTextStyle.copyWith(color: Theme.of(context).colorScheme.recovered);
    var diedStyle = valueTextStyle.copyWith(color: Theme.of(context).colorScheme.died);

    return FigureContainer(
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CountryDetail(country: this.data),
            ),
          );
        },
        child: Row(
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget>[
                  Icon(Icons.location_on),
                  Text("${this.data.countryIso2.toCountryEmoji()} ${this.data.country}", style: labelTextStyle),
                ],
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Text(formatter.format(this.data.confirmed), style: confirmedStyle),
                  Text(formatter.format(this.data.recovered), style: recoveredStyle),
                  Text(formatter.format(this.data.deaths), style: diedStyle),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
