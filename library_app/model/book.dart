class Book {
  int? id;
  String? title;
  String? author;
  String? publishingDate;
  String? isbn;
  String? description;
  String? path;

  Book(
      {this.id, this.title, this.author, this.publishingDate, this.isbn, this.description, this.path});

  bookMap() {
    var mapping = <String, dynamic>{};
    mapping['id'] = id;
    mapping['title'] = title!;
    mapping['author'] = author!;
    mapping['publishingDate'] = publishingDate!;
    mapping['isbn'] = isbn!;
    mapping['description'] = description!;
    mapping['path'] = path!;
    return mapping;
  }

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
        id: json["id"],
        title: json["title"],
        author: json["author"],
        publishingDate: json["publishingDate"],
        isbn: json["isbn"],
        description: json["description"],
        path: json["path"]
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'publishingDate': publishingDate,
      'isbn': isbn,
      'description': description,
      'path': path
    };
  }
}