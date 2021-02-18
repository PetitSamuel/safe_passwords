import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:safe/models/PasswordModel.dart';

class CredentialsProvider with ChangeNotifier, DiagnosticableTreeMixin {
  bool _isLoading = false;
  FlutterSecureStorage ss;
  Map<String, PasswordModel> _passwords = {};
  String search = '';

  List<PasswordModel> get passwords => _passwords?.values?.toList() ?? [];
  List<PasswordModel> get filteredPassword => this
      .passwords
      .where((element) =>
          element.website.toLowerCase().contains(search.toLowerCase()))
      .toList();
  bool get isLoading => _isLoading;

  CredentialsProvider() {
    ss = new FlutterSecureStorage();
    this.init();
  }

  Future init() async {
    _isLoading = true;
    var credentialsMap = await ss.readAll();
    credentialsMap.forEach((key, value) {
      try {
        var dynamicPw = json.decode(value);
        if (dynamicPw["website"] != null &&
            dynamicPw["username"] != null &&
            dynamicPw["password"] != null &&
            dynamicPw["created"] != null) {
          _passwords[key] = PasswordModel.withLastModified(
              website: dynamicPw["website"],
              username: dynamicPw["username"],
              password: dynamicPw["password"],
              created: DateTime.tryParse(dynamicPw["created"]));
          //lastModified: DateTime.tryParse(dynamicPw["lastModified"]));
          print("added password for website " + dynamicPw["website"]);
        }
      } catch (exception) {
        // TODO: log somewhere?
        print(exception);
      }
    });
    _isLoading = false;
    print("loaded up");
  }

  Future<void> addPassword(PasswordModel pw) async {
    _isLoading = true;
    _passwords[pw.website] = pw;
    await ss.write(key: pw.website, value: json.encode(pw.toMap()));
    notifyListeners();
    _isLoading = false;
  }

  Future<void> removePassword(String website) async {
    _isLoading = true;
    _passwords.remove(website);
    await ss.delete(key: website);
    notifyListeners();
    _isLoading = false;
  }

  updateSearch(String search) {
    this.search = search;
    notifyListeners();
  }

  /// Makes var readable inside the devtools by listing all of its properties
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ObjectFlagProperty('_passwords', _passwords));
  }
}
