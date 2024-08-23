import 'dart:async';

import '../db_helper/repository.dart';
import '../model/book.dart';

class BookService
{
  late Repository repository;
  BookService(){
    repository = Repository();
  }
  insertBook(Book book) async{
    return await repository.insertBook('books', book.bookMap());
  }
  readAllBooks() async{
    return await repository.readBooks('books');
  }
  updateBook(Book book) async{
    return await repository.updateBook('books', book.bookMap());
  }
  deleteBook(bookId) async {
    return await repository.deleteBookById('books', bookId);
  }
  wipeAllBooks() async {
    return await repository.wipeAllBooks('books');
  }
}