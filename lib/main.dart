import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'state/app_state.dart';
import 'screens/auth_screen.dart';
import 'screens/main_screen.dart';
import 'theme/app_theme.dart';

void main() {

  runApp(

    ChangeNotifierProvider(
      create: (context) => AppState()..initAuth(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return Consumer<AppState>(
      builder: (context, appState, child) {
        return MaterialApp(
          title: 'Controle de Abastecimento',

          theme: appTheme, 
          debugShowCheckedModeBanner: false,
          

          home: appState.isAuthenticated
              ? const MainScreen() 
              : const AuthScreen(), 
        );
      },
    );
  }
}