import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:safe/models/PasswordModel.dart';
import 'package:safe/models/SortingOptions.dart';

class CredentialsProvider with ChangeNotifier, DiagnosticableTreeMixin {
  bool _isLoading = false;
  FlutterSecureStorage ss;
  Map<String, PasswordModel> _passwords = {};
  String search = '';
  SortingOptions sorting = SortingOptions.DATE_DSC;

  List<PasswordModel> get passwords => _passwords?.values?.toList() ?? List();
  List<PasswordModel> get filteredSortedCredentials {
    var filtered = this
        .passwords
        .where((element) =>
            element.website.toLowerCase().contains(search.toLowerCase()))
        .toList();
    filtered.sort((a, b) {
      switch (sorting) {
        case SortingOptions.NAME_ASC:
          return a.website.toLowerCase().compareTo(b.website.toLowerCase());
        case SortingOptions.NAME_DESC:
          return b.website.toLowerCase().compareTo(a.website.toLowerCase());
        case SortingOptions.DATE_ASC:
          return a
              .getLastModifiedOrCreated()
              .compareTo(b.getLastModifiedOrCreated());
        case SortingOptions.DATE_DSC:
        default:
          return b
              .getLastModifiedOrCreated()
              .compareTo(a.getLastModifiedOrCreated());
      }
    });
    return filtered;
  }

  bool get isLoading => _isLoading;

  CredentialsProvider() {
    ss = new FlutterSecureStorage();
  }

  Future init() async {
    print("init started");
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

  updateSorting(SortingOptions sorting) {
    this.sorting = sorting;
    notifyListeners();
  }

  /// Makes var readable inside the devtools by listing all of its properties
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ObjectFlagProperty('_passwords', _passwords));
  }
}
