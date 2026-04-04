import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'core/widgets/common_text.dart';

class TestScreen extends StatelessWidget {
  const TestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:CommonText(title: "Test Screen", fSize: 20,fWeight: FontWeight.w600,color: Colors.red,),
        centerTitle: true,
      ),
    );
  }
}
