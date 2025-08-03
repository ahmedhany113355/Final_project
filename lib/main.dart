import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart'; 
import 'firebase_options.dart'; 
import 'providers/product_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/watchlist_provider.dart';
import 'providers/auth_provider.dart';
import 'screens/auth/login_screen.dart';
import 'screens/home/products_home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => WatchlistProvider()),
      ],
      child: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          return MaterialApp(
            title: 'My E-commerce App',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primarySwatch: Colors.blue,
              colorScheme: ColorScheme.fromSwatch(
                primarySwatch: Colors.blue,
              ).copyWith(
                onPrimary: Colors.white,
              ),
              appBarTheme: const AppBarTheme(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                elevation: 4,
                centerTitle: true,
              ),
              fontFamily: 'Roboto', 
              textTheme: const TextTheme(
                headlineLarge:
                    TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold),
                headlineMedium:
                    TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold),
                headlineSmall:
                    TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                titleLarge:
                    TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
                bodyLarge: TextStyle(fontSize: 16.0),
                bodyMedium: TextStyle(fontSize: 14.0),
                labelLarge:
                    TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              buttonTheme: ButtonThemeData(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0)),
                buttonColor: Colors.blueAccent,
                textTheme: ButtonTextTheme.primary,
              ),
              inputDecorationTheme: InputDecorationTheme(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(color: Colors.blue, width: 2.0),
                ),
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 15.0, horizontal: 10.0),
              ),
              cardTheme: CardTheme(
                elevation: 5,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                margin: const EdgeInsets.all(8),
              ),
              snackBarTheme: SnackBarThemeData(
                backgroundColor: Colors.blueAccent,
                contentTextStyle: const TextStyle(color: Colors.white),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
            ),
            home: FutureBuilder(
              future: authProvider.checkLoginStatus(),
              builder: (ctx, authSnapshot) {
                if (authSnapshot.connectionState == ConnectionState.waiting) {
                  return const Scaffold(
                    body: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                } else {
                  if (authSnapshot.hasError) {
                    return Scaffold(
                      body: Center(
                        child: Text('An error occurred: ${authSnapshot.error}'),
                      ),
                    );
                  } else {
                    return authProvider.isLoggedIn
                        ? const ProductsHomeScreen()
                        : const LoginScreen();
                  }
                }
              },
            ),
            routes: {
              '/products-home': (context) => const ProductsHomeScreen(),
              '/login': (context) => const LoginScreen(),
              // Add other routes here if you have them
            },
          );
        },
      ),
    );
  }
}
