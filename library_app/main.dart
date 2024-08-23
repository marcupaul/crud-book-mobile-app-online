import 'dart:convert';

import 'package:library_app_flutter/services/api_service.dart';
import 'package:library_app_flutter/utils/constants.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../model/book.dart';
import '../screens/edit_book.dart';
import '../screens/add_book.dart';
import '../screens/view_book.dart';
import '../services/book_service.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Library App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.lightGreen,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late List<Book> _bookList = <Book>[];
  final _bookService = BookService();
  final _apiService = ApiService();
  bool _startup = true;
  final _broadcasts = WebSocketChannel.connect(Uri.parse("ws://10.0.2.2:3000"));

  getAllBookDetails() async {
    if (_startup) {
      var serverBooks = await _apiService.getAllBooks();
      _bookService.wipeAllBooks();
      for (Book book in serverBooks) {
        _bookService.insertBook(book);
      }
      await _broadcasts.ready;

      _broadcasts.stream.listen((data) {
        String operation = json.decode(data)['operation'];
        if (operation == "post") {
          _bookService.insertBook(Book.fromJson(json.decode(data)['payload']));
        } 
        else if (operation == "put") {
          _bookService.updateBook(Book.fromJson(json.decode(data)['payload']));
        }
        else if (operation == "delete") {
          _bookService.deleteBook(json.decode(data)['payload']);
        }
      });
      _startup = false;
    }

    var books = await _bookService.readAllBooks();
    _bookList = <Book>[];
    books.forEach((book) {
      setState(() {
        var bookModel = Book();
        bookModel.id = book['id'];
        bookModel.title = book['title'];
        bookModel.author = book['author'];
        bookModel.publishingDate = book['publishingDate'];
        bookModel.isbn = book['isbn'];
        bookModel.description = book['description'];
        bookModel.path = book['path'];
        _bookList.add(bookModel);
      });
    });
  }

  @override
  void initState() {
    getAllBookDetails();
    super.initState();
  }

  _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  _deleteFormDialog(BuildContext context, bookId) {
    return showDialog(
        context: context,
        builder: (param) {
          return AlertDialog(
            title: const Text(
              'Are you certain you want to delete this item?',
              style: TextStyle(color: Colors.lightGreen, fontSize: 20),
            ),
            actions: [
              TextButton(
                  style: TextButton.styleFrom(
                      foregroundColor: Colors.white, // foreground
                      backgroundColor: Colors.red),
                  onPressed: ()  async{
                    var result=await _apiService.deleteBook(bookId);
                    if (result != null) {
                      Navigator.pop(context);
                      getAllBookDetails();
                      _showSuccessSnackBar(
                          'Book successfully deleted from list.');
                    }
                  },
                  child: const Text('Delete')),
              TextButton(
                  style: TextButton.styleFrom(
                      foregroundColor: Colors.white, // foreground
                      backgroundColor: Colors.lightGreen),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Close'))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Library App"),
      ),
      body: ListView.builder(
          itemCount: _bookList.length,
          itemBuilder: (context, index) {
            return Card(
              child: ListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ViewBook(
                            book: _bookList[index],
                          )));
                },
                leading: const Icon(Icons.book),
                title: Text(_bookList[index].title ?? ''),
                subtitle: Text(_bookList[index].author ?? ''),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EditBook(
                                    book: _bookList[index],
                                  ))).then((data) {
                            if (data != null) {
                              getAllBookDetails();
                              _showSuccessSnackBar(
                                  'The book\'s information has been successfully updated');
                            }
                          });
                        },
                        icon: const Icon(
                          Icons.edit,
                          color: Colors.lightGreen,
                        )),
                    IconButton(
                        onPressed: () {
                          _deleteFormDialog(context, _bookList[index].id);
                        },
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ))
                  ],
                ),
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AddBook()))
              .then((data) {
            if (data != null) {
              getAllBookDetails();
              _showSuccessSnackBar('The book was successfully added.');
            }
          });
        },
          backgroundColor: Colors.lightGreen,
        child: const Icon(Icons.add),
      ),
    );
  }
}