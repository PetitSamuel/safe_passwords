import 'package:url_launcher/url_launcher.dart';
import 'package:validators/validators.dart';

Future<void> launchInBrowser(String url) async {
  if (!url.startsWith('http')) url = 'http://$url';
  if (await canLaunch(url)) {
    await launch(url, forceSafariVC: false, forceWebView: false);
  } else {
    throw 'Could not launch $url';
  }
}

bool isValidUrl(String url) {
  print("sup");
  return isURL(url);
}
