import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:justtsham/core/utils/app_colors.dart';
import 'package:justtsham/core/widgets/common_text.dart';
import 'package:justtsham/featcher/view/authentication/navber_screen.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentPage extends StatefulWidget {
  final String url;

  const PaymentPage({
    super.key,
    required this.url,
  });

  @override
  State<PaymentPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<PaymentPage> {
  late final WebViewController controller;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
          NavigationDelegate(
            onPageStarted: (_) {
              if (mounted) setState(() => isLoading = true);
            },
            onPageFinished: (_) {
              if (mounted) setState(() => isLoading = false);
            },
            onNavigationRequest: (request) {
              final url = request.url;

              debugPrint("NAVIGATING TO: $url");

              if (url.contains("checkout.stripe.com") &&
                  url.contains("return")) {
                Get.dialog(
                  const Center(child: CircularProgressIndicator(color: AppColor.primary)),
                  barrierDismissible: false,
                );
                Future.delayed(const Duration(seconds: 2), () {
                  Get.offAll(() => NavBarScreen());
                });
                return NavigationDecision.prevent;
              }

              return NavigationDecision.navigate;
            },
          )
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(onPressed: (){
        Get.offAll(() => NavBarScreen());
        }, icon: Icon(Icons.arrow_back,color: Colors.white,)),
        backgroundColor: AppColor.primary,
        title: CommonText(title: "Payment Page",color: Colors.white,fSize: 16,),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: controller),

          if (isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}