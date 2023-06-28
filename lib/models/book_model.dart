/// status : "ok"
/// id : "1503212300"
/// title : "Invent Your Own Computer Games with Python"
/// subtitle : "A beginner's guide to computer programming in Python"
/// description : "Invent Your Own Computer Games with Python teaches you how to program in the Python language..."
/// authors : "Al Sweigart"
/// publisher : "CreateSpace"
/// pages : "367"
/// year : "2015"
/// image : "https://www.dbooks.org/img/books/1503212300s.jpg"
/// url : "https://www.dbooks.org/invent-your-own-computer-games-with-python-1503212300/"
/// download : "https://www.dbooks.org/d/1503212300-1635507922-39943ccf97e71c6e/"

class BookModel {
  BookModel({
    String? status,
    String? id,
    String? title,
    String? subtitle,
    String? description,
    String? authors,
    String? publisher,
    String? pages,
    String? year,
    String? image,
    String? url,
    String? download,
  }) {
    _status = status;
    _id = extractNumericPart(id!);
    _title = title;
    _subtitle = subtitle;
    _description = description;
    _authors = authors;
    _publisher = publisher;
    _pages = pages;
    _year = year;
    _image = image;
    _url = url;
    _download = download;
  }

  BookModel.fromJson(dynamic json) {
    _status = json['status'];
    _id = extractNumericPart(json['id']);
    _title = json['title'];
    _subtitle = json['subtitle'];
    _description = json['description'];
    _authors = json['authors'];
    _publisher = json['publisher'];
    _pages = json['pages'];
    _year = json['year'];
    _image = json['image'];
    _url = json['url'];
    _download = json['download'];
  }

  String? _status;
  String? _id;
  String? _title;
  String? _subtitle;
  String? _description;
  String? _authors;
  String? _publisher;
  String? _pages;
  String? _year;
  String? _image;
  String? _url;
  String? _download;

  BookModel copyWith({
    String? status,
    String? id,
    String? title,
    String? subtitle,
    String? description,
    String? authors,
    String? publisher,
    String? pages,
    String? year,
    String? image,
    String? url,
    String? download,
  }) =>
      BookModel(
        status: status ?? _status,
        id: id ?? _id,
        title: title ?? _title,
        subtitle: subtitle ?? _subtitle,
        description: description ?? _description,
        authors: authors ?? _authors,
        publisher: publisher ?? _publisher,
        pages: pages ?? _pages,
        year: year ?? _year,
        image: image ?? _image,
        url: url ?? _url,
        download: download ?? _download,
      );

  String? get status => _status;

  String? get id => _id;

  String? get title => _title;

  String? get subtitle => _subtitle;

  String? get description => _description;

  String? get authors => _authors;

  String? get publisher => _publisher;

  String? get pages => _pages;

  String? get year => _year;

  String? get image => _image;

  String? get url => _url;

  String? get download => _download;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['id'] = _id;
    map['title'] = _title;
    map['subtitle'] = _subtitle;
    map['description'] = _description;
    map['authors'] = _authors;
    map['publisher'] = _publisher;
    map['pages'] = _pages;
    map['year'] = _year;
    map['image'] = _image;
    map['url'] = _url;
    map['download'] = _download;
    return map;
  }

  String extractNumericPart(String bookId) {
    RegExp regex = RegExp(r'\d+');
    RegExpMatch? match = regex.firstMatch(bookId);
    if (match != null) {
      return match.group(0) ?? bookId;
    } else {
      return bookId;
    }
  }
}
