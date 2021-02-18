import 'dart:convert';

import 'package:aes_crypt/aes_crypt.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:random_string/random_string.dart';
import 'package:safe/models/PasswordModel.dart';
import 'package:safe/models/SortingOptions.dart';
import 'package:local_auth/local_auth.dart';
import 'package:storage_path/storage_path.dart';
import 'package:ext_storage/ext_storage.dart';

class CredentialsProvider with ChangeNotifier, DiagnosticableTreeMixin {
  bool _isLoading = false;
  bool _canCheckBiometrics = false;
  FlutterSecureStorage ss;
  LocalAuthentication auth;
  Map<String, PasswordModel> _passwords = {};
  String search = '';
  SortingOptions sorting = SortingOptions.DATE_DSC;

  bool get canCheckBiometrics => _canCheckBiometrics;
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
    auth = LocalAuthentication();
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
    try {
      _canCheckBiometrics = await auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      print(e);
      _canCheckBiometrics = false;
    }
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

  Future<bool> verifyUser(String reason) async {
    try {
      return await auth.authenticateWithBiometrics(
          localizedReason: reason, useErrorDialogs: true, stickyAuth: true);
    } catch (exception) {
      print(exception);
      return true; // If authentification fails then it isn't available
    }
  }

  Future<String> exportToFile() async {
    var map = passwords.map((e) => e.toMap()).toList();
    print(map);
    String toEncrypt = json.encode(map);
    var encryptionKey = randomString(10);
    var crypt = AesCrypt(encryptionKey);
    var externalDirectoryPath = await ExtStorage.getExternalStoragePublicDirectory(
        ExtStorage.DIRECTORY_DOWNLOADS);
    print(externalDirectoryPath + '/my_passwords_${DateTime.now().millisecondsSinceEpoch}.json.aes');
    // Encrypts the text as UTF8 string and saves it into 'mytext.txt.aes' file.
    crypt.encryptTextToFileSync(toEncrypt, externalDirectoryPath + '/my_passwords${DateTime.now().millisecondsSinceEpoch}.json.aes');;
    return encryptionKey;
  }

  /// Makes var readable inside the devtools by listing all of its properties
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ObjectFlagProperty('_passwords', _passwords));
  }
}
