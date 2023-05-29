import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:interviewtask/AuthService.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:interviewtask/SignUpLoginScreen.dart';


class Weather {
  final String city;
  final double temperature;

  Weather({required this.city, required this.temperature});

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      city: json['name'],
      temperature: json['main']['temp'].toDouble(),
    );
  }
}


class WeatherScreen extends StatefulWidget {

  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {


  String city = 'London'; // Default city
  Weather? weather;
  String error = '';

  final TextEditingController _cityController = TextEditingController();
  final AuthService _authService = AuthService(); // Create an instance of AuthService

  @override
  void initState() {
    super.initState();
    fetchWeatherData();
  }

  Future<void> fetchWeatherData() async {
    // Fetch weather data implementation remains the same
    // ...
  }

  // Function to handle user sign out
  Future<void> _signOut() async {
    try {
      await _authService.signOut();
      setState(() {
        weather = null;
        error = '';
      });
    } catch (e) {
      print('Failed to sign out: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather App'),
        actions: [
          IconButton(
            onPressed: _signOut, // Call the sign-out function
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _cityController,
              decoration: const InputDecoration(labelText: 'City'),
              onSubmitted: (_) => fetchWeatherData(),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: fetchWeatherData,
              child: const Text('Fetch Weather'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed:(){ _navigateToregisteration(context);},
              child: const Text('Register'),
            ),
            const SizedBox(height: 16.0),
            if (weather != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('City: ${weather!.city}'),
                  Text('Temperature: ${weather!.temperature}°C'),
                ],
              ),
            if (error.isNotEmpty) Text('Error: $error'),
          ],
        ),
      ),
    );
  }
}

void _navigateToregisteration(BuildContext context) {
  Navigator.of(context)
      .push(MaterialPageRoute(builder: (context) => SignUpLoginScreen()));
}