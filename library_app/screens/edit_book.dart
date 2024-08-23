import 'package:library_app_flutter/services/api_service.dart';

import '../model/book.dart';
import '../services/book_service.dart';
import 'package:flutter/material.dart';
class EditBook extends StatefulWidget {
  final Book book;
  const EditBook({Key? key,required this.book}) : super(key: key);

  @override
  State<EditBook> createState() => _EditBookState();
}

class _EditBookState extends State<EditBook> {
  var _bookTitleController = TextEditingController();
  var _bookAuthorController = TextEditingController();
  var _bookPublishingDateController = TextEditingController();
  var _bookIsbnController = TextEditingController();
  var _bookDescriptionController = TextEditingController();
  var _bookPathController = TextEditingController();
  bool _validateTitle = false;
  bool _validateAuthor = false;
  bool _validatePublishingDate = false;
  bool _validateIsbn = false;
  bool _validateDescription = false;
  bool _validatePath = false;
  var _bookService = BookService();
  var _apiService = ApiService();

  @override
  void initState() {
    setState(() {
      _bookTitleController.text=widget.book.title ?? '';
      _bookAuthorController.text=widget.book.author ?? '';
      _bookPublishingDateController.text=widget.book.publishingDate ?? '';
      _bookIsbnController.text=widget.book.isbn ?? '';
      _bookDescriptionController.text=widget.book.description ?? '';
      _bookPathController.text=widget.book.path ?? '';
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Book"),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Edit Current Book',
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.lightGreen,
                    fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 20.0,
              ),
              TextField(
                  controller: _bookTitleController,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: 'Enter New Title',
                    labelText: 'Title',
                    errorText:
                    _validateTitle ? 'Given value can\'t be empty.' : null,
                  )),
              const SizedBox(
                height: 20.0,
              ),
              TextField(
                  controller: _bookAuthorController,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: 'Enter New Author',
                    labelText: 'Author',
                    errorText:
                    _validateAuthor ? 'Given value can\'t be empty.' : null,
                  )),
              const SizedBox(
                height: 20.0,
              ),
              TextField(
                  controller: _bookPublishingDateController,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: 'Enter New Publishing Date',
                    labelText: 'Publishing Date',
                    errorText:
                    _validatePublishingDate ? 'Given value can\'t be empty.' : null,
                  )),
              const SizedBox(
                height: 20.0,
              ),
              TextField(
                  controller: _bookIsbnController,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: 'Enter New ISBN',
                    labelText: 'ISBN',
                    errorText:
                    _validateIsbn ? 'Given value can\'t be empty.' : null,
                  )),
              const SizedBox(
                height: 20.0,
              ),
              TextField(
                  controller: _bookDescriptionController,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: 'Enter New Description',
                    labelText: 'Description',
                    errorText:
                    _validateDescription ? 'Given value can\'t be empty.' : null,
                  )),
              const SizedBox(
                height: 20.0,
              ),
              TextField(
                  controller: _bookPathController,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: 'Enter New Path',
                    labelText: 'Path',
                    errorText:
                    _validatePath ? 'Given value can\'t be empty.' : null,
                  )),
              const SizedBox(
                height: 20.0,
              ),
              Row(
                children: [
                  TextButton(
                      style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.lightGreen,
                          textStyle: const TextStyle(fontSize: 15)),
                      onPressed: () async {
                        setState(() {
                          _bookTitleController.text.isEmpty
                              ? _validateTitle = true
                              : _validateTitle = false;
                          _bookAuthorController.text.isEmpty
                              ? _validateAuthor = true
                              : _validateAuthor = false;
                          _bookPublishingDateController.text.isEmpty
                              ? _validatePublishingDate = true
                              : _validatePublishingDate = false;
                          _bookIsbnController.text.isEmpty
                              ? _validateIsbn = true
                              : _validateIsbn = false;
                          _bookDescriptionController.text.isEmpty
                              ? _validateDescription = true
                              : _validateDescription = false;
                          _bookPathController.text.isEmpty
                              ? _validatePath = true
                              : _validatePath = false;

                        });
                        if (_validateTitle == false &&
                            _validateAuthor == false &&
                            _validatePublishingDate == false &&
                            _validateIsbn == false &&
                            _validateDescription == false &&
                            _validatePath == false) {
                          var _book = Book();
                          _book.id=widget.book.id;
                          _book.title = _bookTitleController.text;
                          _book.author = _bookAuthorController.text;
                          _book.publishingDate = _bookPublishingDateController.text;
                          _book.isbn = _bookIsbnController.text;
                          _book.description = _bookDescriptionController.text;
                          _book.path = _bookPathController.text;
                          var result = await _apiService.updateBook(_book);
                          Navigator.pop(context,result);
                        }
                      },
                      child: const Text('Update Details')),
                  const SizedBox(
                    width: 10.0,
                  ),
                  TextButton(
                      style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.red,
                          textStyle: const TextStyle(fontSize: 15)),
                      onPressed: () {
                        _bookTitleController.text = '';
                        _bookAuthorController.text = '';
                        _bookPublishingDateController.text = '';
                        _bookIsbnController.text = '';
                        _bookDescriptionController.text = '';
                        _bookPathController.text = '';
                      },
                      child: const Text('Clear Fields'))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}