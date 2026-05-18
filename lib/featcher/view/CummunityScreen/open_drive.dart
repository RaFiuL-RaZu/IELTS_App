import 'package:url_launcher/url_launcher.dart';

class Drive{

 static Future<void> openGoogleDrive() async {
    final Uri url = Uri.parse("https://drive.google.com/drive/my-drive");

    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }
}