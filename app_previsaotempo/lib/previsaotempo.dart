import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WeatherData {
  final String city;
  final double temperature;
  final double minTemperature;
  final double maxTemperature;

  WeatherData({
    required this.city,
    required this.temperature,
    required this.minTemperature,
    required this.maxTemperature,
  });
}

class WeatherScreen extends StatefulWidget {
  final String city;

  WeatherScreen({required this.city});

  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  late Future<WeatherData> weatherData;

  @override
  void initState() {
    super.initState();
    weatherData = fetchWeatherData(widget.city);
  }

  Future<WeatherData> fetchWeatherData(String city) async {
    final response = await http.get(
      Uri.parse(
          'https://weather.contrateumdev.com.br/api/weather/city/?city=$city'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return WeatherData(
        city: data['city'],
        temperature: data['temperature'],
        minTemperature: data['min_temperature'],
        maxTemperature: data['max_temperature'],
      );
    } else {
      throw Exception('Failed to fetch weather data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Previsão do Tempo'),
      ),
      body: Center(
        child: FutureBuilder<WeatherData>(
          future: weatherData,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Cidade: ${snapshot.data!.city}',
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Temperatura: ${snapshot.data!.temperature}°C',
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Mínima: ${snapshot.data!.minTemperature}°C',
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Máxima: ${snapshot.data!.maxTemperature}°C',
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              return Text('Erro ao carregar os dados do clima');
            }

            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
