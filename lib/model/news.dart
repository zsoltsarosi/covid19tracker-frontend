
class News {
  String id;
  DateTime date;
  String title;
  String link;
  String imgBase64;
  String sourceName;
  String sourceUrl;

  News({this.id, this.date, this.title, this.link, this.imgBase64, this.sourceName, this.sourceUrl});

  factory News.fromJson(Map<String, dynamic> json) {
    var date = DateTime.parse(json['date']);
    if (!date.isUtc) {
      date = DateTime.utc(date.year, date.month, date.day, date.hour, date.minute, date.second);
    }
    return News(
      id: json['id'] as String,
      date: date,
      title: json['title'] as String,
      link: json['link'] as String,
      imgBase64: json['imageData'] as String,
      sourceName: json['sourceName'] as String,
      sourceUrl: json['sourceUrl'] as String,
    );
  }
}