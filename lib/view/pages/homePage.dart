import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart' show rootBundle;
import 'package:sample/view/widgets/city_weather_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final String? apiKey = dotenv.env['API_KEY'];
  List<Map<String, dynamic>> cityWeatherList = [];
  List<dynamic> cities = [];
  final http.Client client = http.Client();

  @override
  void initState() {
    super.initState();
    loadCities();
  }

  Future<void> loadCities() async {
    final String data = await rootBundle.loadString('lib/core/cities.json');
    final Map<String, dynamic> jsonData = jsonDecode(data);
    setState(() {
      cities = jsonData['List'];
    });

    await fetchWeatherForCities();
  }

  Future<void> fetchWeatherForCities() async {
    for (var city in cities) {
      final uri = Uri.https(
        'api.openweathermap.org',
        '/data/2.5/weather',
        {
          'id': city['CityCode'],
          'appid': apiKey,
          'units': 'metric',
        },
      );

      try {
        final res = await client.get(uri);
        if (res.statusCode == 200) {
          final data = jsonDecode(res.body);
          cityWeatherList.add(data);
        }
      } catch (e) {
        debugPrint("Error fetching ${city['CityName']}: $e");
      }
    }
    setState(() {});
  }

  // Card colors
  final List<List<Color>> gradients = [
    [Colors.blue.shade400, Colors.blue.shade200],
    [Colors.purple.shade400, Colors.purple.shade200],
    [Colors.green.shade400, Colors.green.shade200],
    [Colors.orange.shade400, Colors.orange.shade200],
    [Colors.red.shade400, Colors.red.shade200],
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final double fontSize = screenWidth < 600 ? 9 : 12;

    return Scaffold(
      body: cityWeatherList.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : LayoutBuilder(
              builder: (context, constraints) {
                final bool isLarge = constraints.maxWidth >= 600;

                return Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: (isLarge ? 100 : 8), vertical: 16),
                  child: Center(
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: isLarge ? 600 : 500,
                        crossAxisSpacing: 24,
                        mainAxisSpacing: 24,
                        childAspectRatio: isLarge ? 2.0 : 1.6,
                      ),
                      physics: const BouncingScrollPhysics(),
                      itemCount: cityWeatherList.length,
                      itemBuilder: (context, index) {
                        final city = cities[index];
                        final weather = cityWeatherList[index];
                        final gradient = gradients[index % gradients.length];

                        return CityWeatherCard(
                          city: city,
                          weather: weather,
                          gradient: gradient,
                          fontSize: fontSize,
                        );
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}
