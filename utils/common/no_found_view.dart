
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:sleekit/utils/string_helper.dart';


class NotFoundView extends StatelessWidget {
  const NotFoundView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Lottie.asset("assets/lottie/page_not_found.json"),
            ElevatedButton(
                onPressed: () {
                  context.pop();
                },
                child: Text(StringHelper.GO_BACK))
          ],
        ),
      ),
    );
  }
}
