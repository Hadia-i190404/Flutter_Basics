import 'package:flutter/material.dart';
import 'package:interviewtask/weatherapi.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(ChangeNotifierProvider<CounterProvider>(
    create: (_) => CounterProvider(),
    child: MyApp(),));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Task Interview',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final counterProvider = Provider.of<CounterProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Task Interview'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FlutterLogo(
              size: 150,
            ),
            SizedBox(height: 30),
            Text(
              'Counter Value: ${counterProvider.counter}',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                counterProvider.incrementCounter();
              },
              child: Text('Increment Counter'),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                _navigateToAPI(context);
              },
              child: Text('Weather API'),
            ),
          ],
        ),
      ),
    );
  }
}

class CounterProvider with ChangeNotifier {
  int _counter = 0;

  int get counter => _counter;

  void incrementCounter() {
    _counter++;
    notifyListeners();
  }
}
void _navigateToAPI(BuildContext context) {
  Navigator.of(context)
      .push(MaterialPageRoute(builder: (context) => WeatherScreen()));
}