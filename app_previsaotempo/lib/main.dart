import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MaterialApp(
    home: HomePage(),
  ));
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _cityController = TextEditingController();

  void _verificarPrevisaoTempo() {
    final String cityName = _cityController.text;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => WeatherScreen(city: cityName)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Previsão do tempo hoje!',
          style: GoogleFonts.aboreto(),
        ),
        backgroundColor: Colors.blueGrey.shade800,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              style: GoogleFonts.aboreto(),
              controller: _cityController,
              decoration: InputDecoration(
                labelText: 'Digite o nome da cidade',
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                        color: Color.fromARGB(255, 18, 113, 160), width: 2.0)),
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: _verificarPrevisaoTempo,
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                textStyle: TextStyle(fontSize: 16),
              ),
              child: Text('Verificar Previsão do Tempo'),
            ),
          ],
        ),
      ),
    );
  }
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
        city: data['name'],
        temperature: data['main']['temp'],
        minTemperature: data['main']['temp_min'],
        maxTemperature: data['main']['temp_max'],
        description: data['weather'][0]['description'],
      );
    } else {
      throw Exception('Failed to fetch weather data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Previsão do tempo hoje!',
          style: GoogleFonts.aboreto(),
        ),
        backgroundColor: Colors.blueGrey.shade800,
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
                    '${snapshot.data!.city}',
                    style: TextStyle(
                        fontSize: 60,
                        fontFamily: GoogleFonts.aboreto().fontFamily,
                        color: Colors.grey[850],
                        fontWeight: FontWeight.w900),
                  ),
                  SizedBox(height: 10),
                  Text(
                    '${snapshot.data!.temperature}°C',
                    style: TextStyle(
                        fontSize: 80,
                        fontFamily: GoogleFonts.aboreto().fontFamily,
                        color: Colors.grey[850],
                        fontWeight: FontWeight.w900),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Mínima: ${snapshot.data!.minTemperature}°C',
                    style: TextStyle(
                        fontSize: 20,
                        fontFamily: GoogleFonts.aboreto().fontFamily,
                        color: Colors.grey[850],
                        fontWeight: FontWeight.w900),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Máxima: ${snapshot.data!.maxTemperature}°C',
                    style: TextStyle(
                        fontSize: 20,
                        fontFamily: GoogleFonts.aboreto().fontFamily,
                        color: Colors.grey[850],
                        fontWeight: FontWeight.w900),
                  ),
                  SizedBox(height: 10),
                  Text(
                    '${snapshot.data!.description}',
                    style: TextStyle(
                        fontSize: 20,
                        fontFamily: GoogleFonts.aboreto().fontFamily,
                        color: Colors.grey[850],
                        fontWeight: FontWeight.w900),
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

class WeatherData {
  final String city;
  final double temperature;
  final double minTemperature;
  final double maxTemperature;
  final String description;

  WeatherData({
    required this.city,
    required this.temperature,
    required this.minTemperature,
    required this.maxTemperature,
    required this.description,
  });
}
