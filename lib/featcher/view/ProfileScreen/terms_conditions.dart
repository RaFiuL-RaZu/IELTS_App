import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';

import '../../../core/utils/app_colors.dart';

class TermsOfUseScreen extends GetView {
  const TermsOfUseScreen({super.key});

  static const String termsHtml = '''
<h1>Terms of Use</h1>

<p>
Welcome to our application. These Terms of Use ("Terms") govern your access to and use of our services. By creating an account, signing in, or continuing to use this application, you acknowledge that you have read, understood, and agreed to be bound by these Terms.
</p>

<h2>1. Acceptance of Terms</h2>

<p>
By selecting the <b>"I Agree to the Terms of Use"</b> checkbox during sign-up or login, you confirm that you accept these Terms and our Privacy Policy.
</p>

<h2>2. User Responsibilities</h2>

<ul>
<li>Provide accurate account information.</li>
<li>Respect other users.</li>
<li>Use the application only for lawful purposes.</li>
</ul>

<h2>3. Prohibited Conduct</h2>

<ul>
<li>Do not post illegal content.</li>
<li>Do not upload sexually explicit material.</li>
<li>Do not harass, bully, threaten, or abuse other users.</li>
<li>Do not impersonate another person.</li>
<li>Do not spread spam or malicious software.</li>
</ul>

<h2>4. Zero-Tolerance Policy</h2>

<p>
We maintain a strict zero-tolerance policy for objectionable content and abusive behavior.
</p>

<ul>
<li>Immediate removal of violating content.</li>
<li>Temporary account suspension.</li>
<li>Permanent account termination.</li>
<li>Reporting to law enforcement where required.</li>
</ul>

<h2>5. User Generated Content</h2>

<p>
You are solely responsible for the content you upload or share. We reserve the right to remove any content that violates these Terms.
</p>

<h2>6. Reporting Abuse</h2>

<p>
Users can report objectionable content or abusive behavior using the in-app reporting feature.
</p>

<h2>7. Contact</h2>

<p>
If you have any questions regarding these Terms, please contact our support team.
</p>
''';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        backgroundColor: AppColor.background,
        title: const Text("Terms of Use"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Html(
          data: termsHtml,
        ),
      ),
    );
  }
}