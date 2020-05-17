
abstract class SingleDayData {
  DateTime date;
  int confirmed;
  int recovered;
  int deaths;

  SingleDayData({this.date, this.confirmed, this.recovered, this.deaths});
}