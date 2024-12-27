import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gunsayaci/services/providers/settings_provider.dart';
import 'package:gunsayaci/utils/color_palette.dart';
import 'package:gunsayaci/utils/strings.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  // Kopyalama işlemini gerçekleştiren fonksiyon
  void _copyToClipboard(BuildContext context) {
    const String email = KStrings.gmailLink;
    Clipboard.setData(const ClipboardData(text: email)); // Gmail adresini kopyala

    // Kullanıcıya bildirim göstermek için Snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Gmail adresi kopyalandı: $email"),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Widget _settingsItem({
    Function()? onTap,
    required String title,
    required Widget widget,
    required bool isDarkMode,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isDarkMode ? Colors.white10 : Colors.black12,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
            ),
            widget,
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final SettingsProvider settingsProvider =
    Provider.of<SettingsProvider>(context);
    final bool isDarkMode = settingsProvider.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: kWhiteColor,
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 30),
          _settingsItem(
            title: "GitHub Hesabım".tr(),
            onTap: () => launchUrl(
              Uri.parse(KStrings.githubLink),
              mode: LaunchMode.externalApplication,
            ),
            isDarkMode: isDarkMode,
            widget: Image.asset(
              'assets/images/github.png',
              width: 24.0,
              height: 24.0,
            ),
          ),
          _settingsItem(
            title: "Linkedin Hesabım".tr(),
            onTap: () => launchUrl(
              Uri.parse(KStrings.linkedinLink),
              mode: LaunchMode.externalApplication,
            ),
            isDarkMode: isDarkMode,
            widget: Image.asset(
              'assets/images/linkedin.png',
              width: 24.0,
              height: 24.0,
            ),
          ),
          _settingsItem(
            title: "Gmail Hesabım".tr(),
            onTap: () => _copyToClipboard(context),
            isDarkMode: isDarkMode,
            widget: const Icon(Icons.mail_outline),
          ),
        ],
      ),
    );
  }
}
