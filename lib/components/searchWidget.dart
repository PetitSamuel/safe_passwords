import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safe/providers/CredentialsProvider.dart';

class SearchWidget extends StatefulWidget {
  SearchWidget({Key key}) : super(key: key);

  @override
  _SearchWidgetState createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  final searchController = TextEditingController();

  updateSearch(BuildContext context) {
    context.read<CredentialsProvider>().updateSearch(searchController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(left: 16, right: 16, top: 4, bottom: 8),
        child:  TextField(
          autofocus: false,
          controller: searchController,
          onChanged: (_) {
            updateSearch(context);
          },
          decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey, width: 1.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey, width: 1.0),
              ),
              hintText: "Enter a message",
              suffixIcon: IconButton(
                onPressed: () {
                  searchController.clear();
                  updateSearch(context);
                  FocusScope.of(context).unfocus();
                },
                icon: Icon(Icons.clear),
              ),
              prefixIcon: Icon(Icons.search)),
        ));
  }
}
