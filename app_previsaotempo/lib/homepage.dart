import 'package:app_previsaotempo/previsaotempo.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

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
