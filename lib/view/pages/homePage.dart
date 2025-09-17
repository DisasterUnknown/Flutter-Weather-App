import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart' show rootBundle;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final String apiKey = '925f40fbea1185ddc93487e65456b11d';
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
          'units': 'metric', // returns Celsius
        },
      );

      try {
        final res = await client.get(uri);
        if (res.statusCode == 200) {
          final data = jsonDecode(res.body);
          cityWeatherList.add(data);
        }
      } catch (e) {
        print("Error fetching ${city['CityName']}: $e");
      }
    }
    setState(() {});
  }

  // Gradient colors per card
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
    final isLarge = screenWidth > 600;
    final cardWidth = isLarge
        ? (screenWidth - 36) / 2 // 2 cards per row with spacing
        : screenWidth - 24; // 1 card full width with padding

    return Scaffold(
      body: cityWeatherList.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(12),
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                children: List.generate(cityWeatherList.length, (index) {
                  final city = cities[index];
                  final weather = cityWeatherList[index];
                  final gradient = gradients[index % gradients.length];

                  final sunrise = DateTime.fromMillisecondsSinceEpoch(
                          weather['sys']['sunrise'] * 1000,
                          isUtc: true)
                      .add(Duration(seconds: weather['timezone']));
                  final sunset = DateTime.fromMillisecondsSinceEpoch(
                          weather['sys']['sunset'] * 1000,
                          isUtc: true)
                      .add(Duration(seconds: weather['timezone']));

                  return SizedBox(
                    width: cardWidth,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 6,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Top colored part
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: gradient,
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(16),
                                  topRight: Radius.circular(16)),
                            ),
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Left: City + Weather
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      city['CityName'],
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      weather['weather'][0]['description']
                                          .toUpperCase(),
                                      style: const TextStyle(
                                          color: Colors.white70, fontSize: 12),
                                    ),
                                  ],
                                ),
                                // Right: Temperature
                                Text(
                                  "${weather['main']['temp'].toStringAsFixed(1)}°C",
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          // Bottom gray part
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[800],
                              borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(16),
                                  bottomRight: Radius.circular(16)),
                            ),
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Column 1
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        "Pressure: ${weather['main']['pressure']} hPa",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: fontSize)),
                                    Text(
                                        "Humidity: ${weather['main']['humidity']}%",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: fontSize)),
                                    Text(
                                        "Visibility: ${(weather['visibility'] / 1000).toStringAsFixed(1)} km",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: fontSize)),
                                  ],
                                ),
                                // Column 2
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        "${weather['wind']['speed']}m/s, ${weather['wind']['deg']}°",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: fontSize)),
                                  ],
                                ),
                                // Column 3
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        "Sunrise: ${sunrise.hour.toString().padLeft(2, '0')}:${sunrise.minute.toString().padLeft(2, '0')}",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: fontSize)),
                                    Text(
                                        "Sunset: ${sunset.hour.toString().padLeft(2, '0')}:${sunset.minute.toString().padLeft(2, '0')}",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: fontSize)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
    );
  }
}
