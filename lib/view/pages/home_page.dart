import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart' show rootBundle;
import 'package:intl/intl.dart';
import 'package:sample/network/fetch_weather_for_city.dart';
import 'package:sample/network/get_weather_by_city_name.dart';
import 'package:sample/view/pages/city_weather_page.dart';
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
  final TextEditingController _cityController = TextEditingController();

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
    cityWeatherList.clear();
    for (var city in cities) {
      await fetchWeatherForCity(city);
    }
    setState(() {});
  }

  Future<void> fetchWeatherForCity(Map<String, dynamic> city) async {
    try {
      final res = await fetchWeatherCity(city, apiKey);
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        setState(() {
          cityWeatherList.add(data);
        });
      }
    } catch (e) {
      debugPrint("Error fetching ${city['CityName']}: $e");
    }
  }

  Future<void> addCityByName(String cityName) async {
    try {
      final res = await fetchCityByName(cityName, apiKey);
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        setState(() {
          cityWeatherList.add(data);
          cities.add({'CityName': cityName, 'CityCode': data['id']});
          _cityController.clear();
        });
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('City not found')));
      }
    } catch (e) {
      debugPrint('Error adding city $cityName: $e');
    }
  }

  void removeCity(int index) {
    setState(() {
      cityWeatherList.removeAt(index);
      cities.removeAt(index);
    });
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
    final screenHeight = MediaQuery.of(context).size.height;
    final double fontSize = screenWidth < 600 ? 9 : 12;
    final bool isLarge = screenWidth >= 600;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                  horizontal: (isLarge ? 100 : 8), vertical: 16),
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: screenHeight - 115,
                  ),
                  child: Column(
                    children: [
                      // Header
                      Container(
                        margin: const EdgeInsets.only(bottom: 24, top: 68),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.cloud,
                              size: isLarge ? 48 : 32,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Weather App',
                              style: TextStyle(
                                fontSize: isLarge ? 32 : 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Search & Add City
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: isLarge ? 300 : 200,
                            height: 40,
                            child: TextField(
                              controller: _cityController,
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                hintText: 'Enter city name',
                                hintStyle: TextStyle(color: Colors.grey[400]),
                                filled: true,
                                fillColor: Colors.grey[900],
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(6),
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: () {
                              if (_cityController.text.isNotEmpty) {
                                addCityByName(_cityController.text);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueGrey[800],
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                            ),
                            child: const Text('Add City'),
                          ),
                        ],
                      ),

                      const SizedBox(height: 68),

                      // City Cards
                      Wrap(
                        spacing: 24,
                        runSpacing: 24,
                        alignment: WrapAlignment.center,
                        children:
                            List.generate(cityWeatherList.length, (index) {
                          final city = cities[index];
                          final weather = cityWeatherList[index];
                          final gradient = gradients[index % gradients.length];

                          return SizedBox(
                              width: isLarge ? 500 : 350,
                              child: CityWeatherCard(
                                city: city,
                                weather: weather,
                                gradient: gradient,
                                fontSize: fontSize,
                                onRemove: () => removeCity(index),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => CityWeatherPage(
                                        cityName: city['CityName'],
                                        date: DateFormat('h.mma, MMM d')
                                            .format(DateTime.now())
                                            .toLowerCase(),
                                        weather: weather,
                                        bgColor: gradient,
                                        onBack: () => Navigator.pop(context),
                                      ),
                                    ),
                                  );
                                },
                              ));
                        }),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              color: Colors.grey[900],
              alignment: Alignment.center,
              child: const Text(
                '2025 Fidenz Technologies',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
