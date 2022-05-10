import 'dart:async';

import 'package:flutter/material.dart';

StreamController<bool> isLightTheme = StreamController();

class ThemeTeste {
  final Color primary;
  final Color secondary;
  final String font;

  const ThemeTeste(this.primary, this.secondary, this.font);
}

main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  MainApp({Key? key}) : super(key: key);

  var completeTeste = FutureBuilder(
    future: Future.delayed(
      const Duration(seconds: 3),
      () => const ThemeTeste(Colors.green, Colors.deepPurpleAccent, 'Anton'),
    ),
    builder: (BuildContext context, AsyncSnapshot<ThemeTeste> snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Container(
          color: Colors.white,
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        );
      }
      return StreamBuilder<bool>(
        initialData: true,
        stream: isLightTheme.stream,
        builder: (context, streamSnapshot) {
          final isLight = streamSnapshot.data != null && streamSnapshot.data!;
          return MaterialApp(
            themeMode: isLight ? ThemeMode.light : ThemeMode.dark,
            theme: isLight
                ? ThemeData.light().copyWith(
                    colorScheme: ColorScheme.fromSwatch().copyWith(
                      primary: snapshot.data?.primary,
                      secondary: snapshot.data?.secondary,
                    ),
                    textTheme: ThemeData.light().textTheme.apply(
                          fontFamily: snapshot.data?.font,
                        ),
                    primaryTextTheme: ThemeData.light().textTheme.apply(
                          fontFamily: snapshot.data?.font,
                        ),
                  )
                : ThemeData.dark().copyWith(
                    colorScheme: ColorScheme.fromSwatch().copyWith(
                      primary: snapshot.data?.secondary,
                      secondary: snapshot.data?.primary,
                    ),
                    textTheme: ThemeData.dark().textTheme.apply(
                          fontFamily: snapshot.data?.font,
                        ),
                    primaryTextTheme: ThemeData.dark().textTheme.apply(
                          fontFamily: snapshot.data?.font,
                        ),
                  ),
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              appBar: AppBar(title: const Text("Dynamic Theme")),
              body: const SettingPage(),
            ),
          );
        },
      );
    },
  );
  @override
  Widget build(BuildContext context) {
    return completeTeste;
  }
}

class SettingPage extends StatelessWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            ElevatedButton(
              child: const Text(
                "Light Theme",
                style: TextStyle(color: Colors.white),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                  Theme.of(context).colorScheme.secondary,
                ),
              ),
              onPressed: () {
                isLightTheme.add(true);
              },
            ),
            ElevatedButton(
              child: const Text(
                "Dark Theme",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                isLightTheme.add(false);
              },
            ),
          ],
        ),
      ),
    );
  }
}
