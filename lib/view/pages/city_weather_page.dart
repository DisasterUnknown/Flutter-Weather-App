import 'package:flutter/material.dart';

class CityWeatherPage extends StatelessWidget {
  final Map<String, dynamic> weather;
  final String cityName;
  final String date;
  final VoidCallback onBack;
  final List<Color> bgColor;

  const CityWeatherPage({
    super.key,
    required this.weather,
    required this.cityName,
    required this.date,
    required this.onBack,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    final sunrise = DateTime.fromMillisecondsSinceEpoch(
            weather['sys']['sunrise'] * 1000,
            isUtc: true)
        .add(Duration(seconds: weather['timezone']));

    final sunset = DateTime.fromMillisecondsSinceEpoch(
            weather['sys']['sunset'] * 1000,
            isUtc: true)
        .add(Duration(seconds: weather['timezone']));

    final screenWidth = MediaQuery.of(context).size.width;
    final isLarge = screenWidth >= 600;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.cloud, color: Colors.white, size: 32),
                const SizedBox(width: 10),
                Text(
                  'Weather App',
                  style: TextStyle(
                    fontSize: isLarge ? 30 : 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // TOP CARD
                    Container(
                      width: double.infinity,
                      margin:
                          EdgeInsets.symmetric(horizontal: isLarge ? 160 : 40),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: bgColor,
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(4),
                          topRight: Radius.circular(4),
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              IconButton(
                                onPressed: onBack,
                                icon: const Icon(Icons.arrow_back,
                                    color: Colors.white),
                              ),
                            ],
                          ),
                          Text(
                            '$cityName, ${weather['sys']['country']}',
                            style: TextStyle(
                              fontSize: isLarge ? 30 : 26,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            date,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.white70,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                children: [
                                  const Icon(Icons.cloud,
                                      color: Colors.white, size: 40),
                                  const SizedBox(height: 4),
                                  Text(
                                    weather['weather'][0]['description']
                                        .toString()
                                        .toUpperCase(),
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 30),
                              Container(
                                  width: 1, height: 50, color: Colors.white54),
                              const SizedBox(width: 30),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${weather['main']['temp'].toStringAsFixed(0)}°C",
                                    style: TextStyle(
                                      fontSize: isLarge ? 56 : 50,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    "Temp Min: ${weather['main']['temp_min'].toStringAsFixed(0)}°C\n"
                                    "Temp Max: ${weather['main']['temp_max'].toStringAsFixed(0)}°C",
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 25),
                        ],
                      ),
                    ),

                    Container(
                      width: double.infinity,
                      margin:
                          EdgeInsets.symmetric(horizontal: isLarge ? 160 : 40),
                      padding: EdgeInsets.symmetric(
                          horizontal: isLarge ? 50 : 30, vertical: 28),
                      decoration: const BoxDecoration(
                        color: Color(0xFF2B2F3A),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(4),
                          bottomRight: Radius.circular(4),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Pressure: ${weather['main']['pressure']} hPa",
                                  style: const TextStyle(color: Colors.white),
                                ),
                                Text(
                                  "Humidity: ${weather['main']['humidity']}%",
                                  style: const TextStyle(color: Colors.white),
                                ),
                                Text(
                                  "Visibility: ${(weather['visibility'] / 1000).toStringAsFixed(1)} km",
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Transform.rotate(
                                  angle: 20,
                                  child: const Icon(
                                    Icons.navigation_outlined,
                                    color: Colors.white,
                                    size: 22,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  "${weather['wind']['speed']} m/s  ${weather['wind']['deg']}°",
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  "Sunrise: ${sunrise.hour.toString().padLeft(2, '0')}:${sunrise.minute.toString().padLeft(2, '0')}",
                                  style: const TextStyle(color: Colors.white),
                                ),
                                Text(
                                  "Sunset: ${sunset.hour.toString().padLeft(2, '0')}:${sunset.minute.toString().padLeft(2, '0')}",
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(bottom: 1),
              child: Container(
                width: double.infinity, 
                padding: const EdgeInsets.symmetric(vertical: 10),
                color: Colors.grey[900], 
                child: const Center(
                  child: Text(
                    '2025 Fidenz Technologies',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
