import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import 'package:sleekit/utils/app_router.dart';
import 'package:sleekit/utils/common/app_loading_widget.dart';

import 'auth/viewmodel/auth_view_model.dart';

void main() async {
  runApp(MyApp(),);
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
              create: (BuildContext context) => AuthViewModel()),
        ],
        child: GlobalLoaderOverlay(

            overlayWidgetBuilder: (_) {
              //ignored progress for the moment
              return const AppLoadingWidget();
            },
            child: MaterialApp.router(
              color: Colors.white,
              title: 'Sleek IT',
              themeMode: ThemeMode.system,
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                fontFamily: 'SF Pro', // Set default font for the entire app
              ),
              // Using the updated currentTheme getter
              routeInformationProvider:
                  AppRouter.router.routeInformationProvider,
              routeInformationParser: AppRouter.router.routeInformationParser,
              routerDelegate: AppRouter.router.routerDelegate,
            )));
  }
}
