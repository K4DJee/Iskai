import 'package:flutter/material.dart';
import 'package:iskai/l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> fetchUrl(String link, BuildContext context) async {
  final url = Uri.parse(
    link,
  );

  try {
    await launchUrl(url);
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context)!.errorFetchUrl)),
    );
  }
}
