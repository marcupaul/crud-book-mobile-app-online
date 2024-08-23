import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:library_app_flutter/model/book.dart';
import 'package:library_app_flutter/utils/constants.dart';

class ApiService {
  var dio = Dio();

  Future<List<Book>> getAllBooks() async {
    String requestUrl = "${Constants.baseUrl}/books";

    final response = await dio.get(requestUrl);

    if (response.statusCode == 200) {
      final result = response.data;
      return (result as Iterable).map((book) => Book.fromJson(book)).toList();
    } else {
      throw Exception("Failed to get all books from server.");
    }
  }

  Future<Book> insertBook(Book newBook) async {
    String requestUrl = "${Constants.baseUrl}/book";

    final response = await dio.post(requestUrl, options: Options(
        headers: {HttpHeaders.contentTypeHeader: "application/json"}),
        data: jsonEncode(newBook));

    if (response.statusCode == 201) {
      final result = response.data;
      return Book.fromJson(result);
    } else {
      throw Exception("Could not add book.");
    }
  }

  Future<Book> updateBook(Book updatedBook) async {
    String requestUrl = "${Constants.baseUrl}/books/${updatedBook.id}";

    final response = await dio.put(requestUrl, options: Options(
        headers: {HttpHeaders.contentTypeHeader: "application/json"}),
        data: jsonEncode(updatedBook));

    if (response.statusCode == 200) {
      final result = response.data;
      return Book.fromJson(result);
    } else {
      throw Exception("Could not update book.");
    }
  }

  Future<Book> deleteBook(int bookId) async {
    String requestUrl = "${Constants.baseUrl}/books/$bookId";

    final response = await dio.delete(requestUrl);

    if (response.statusCode == 202) {
      final result = response.data;
      return Book.fromJson(result);
    } else {
      throw Exception("Could not delete book.");
    }
  }
}