import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import '../../../core/utils/app_colors.dart';

class PrivacyScreen extends GetView {
  const PrivacyScreen({super.key});

  static const String privacyHtml = '''
<h1>Privacy Policy</h1>

<p>
Last updated: August 2026
</p>

<p>
Welcome to IELTS Vault. We are committed to protecting your personal information and your right to privacy. This Privacy Policy outlines our practices regarding information collection, usage, and data security when you use our mobile application.
</p>

<h2>1. Information We Collect</h2>

<p>We may collect information you provide directly to us when registering an account, practicing tests, or communicating with us:</p>
<ul>
<li><b>Account Credentials:</b> Full name, email address, and profile settings.</li>
<li><b>Practice Data:</b> Speaking test recordings, written essay drafts, mock exam responses, and target band scores.</li>
<li><b>Device Information:</b> Device model, operating system version, and unique device identifiers for app performance analytics.</li>
</ul>

<h2>2. How We Use Your Information</h2>

<ul>
<li>To evaluate test responses and generate predictive IELTS band scores.</li>
<li>To track and display your preparation progress and skill-by-skill analytics.</li>
<li>To provide secure account access, cloud backup, and password synchronization.</li>
<li>To improve AI scoring algorithms and speech recognition accuracy.</li>
</ul>

<h2>3. Data Security & Storage</h2>

<p>
We implement strict industry-standard encryption protocols (SSL/TLS) to safeguard your personal data, audio recordings, and test analytics against unauthorized access, disclosure, or alteration.
</p>

<h2>4. Audio & Voice Data</h2>

<p>
Your microphone access is strictly used during active IELTS speaking practice and mock test sessions. Audio recordings are processed solely for the purpose of speech analysis and pronunciation feedback.
</p>

<h2>5. Third-Party Services</h2>

<p>
We do not sell, rent, or trade your personal data to third parties. We may utilize reputable cloud infrastructure and analytics partners solely to maintain app reliability.
</p>

<h2>6. Contact Us</h2>

<p>
If you have any questions or concerns about this Privacy Policy, please contact our support team via the in-app support channel or email.
</p>
''';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        backgroundColor: AppColor.background,
        elevation: 0,
        title: const Text(
          "Privacy Policy",
          style: TextStyle(
            color: Color(0xFF0F172A),
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Html(
          data: privacyHtml,
        ),
      ),
    );
  }
}
