import 'package:chat_app/screens/Home_screen.dart';
import 'package:chat_app/screens/auth_screen.dart';
import 'package:chat_app/screens/splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

//add color scheme
var kColorScheme =
    ColorScheme.fromSeed(seedColor: const Color.fromARGB(121, 5, 163, 220));

//add Dark color scheme
var kDarkColorTheme = ColorScheme.fromSeed(
  brightness: Brightness.dark,
  seedColor: const Color.fromARGB(255, 5, 90, 125),
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FlutterChat',
      theme: ThemeData().copyWith(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 143, 155, 167),
        ),
      ),
      //StrimBuilder - возвращает данные как слушатель ожидя по мере их поступления
      // Future - возвращает только один раз кода данные придут (единажды)
      home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (ctx, snapshot) {
            //запускаем splash screen во врямя загрузки данных
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SplashScreen();
            }

            //если в Firebase есть данные то они вернуться мы их отслеживаем с помощью StreamBuilder
            if (snapshot.hasData) {
              return const HomeScreen();
            } else {
              return const AuthScreen();
            }
          }),
    );
  }
}
