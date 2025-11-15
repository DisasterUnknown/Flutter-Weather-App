import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CityWeatherCard extends StatelessWidget {
  final Map<String, dynamic> city;
  final Map<String, dynamic> weather;
  final List<Color> gradient;
  final double fontSize;
  final VoidCallback? onRemove; // new

  const CityWeatherCard({
    super.key,
    required this.city,
    required this.weather,
    required this.gradient,
    required this.fontSize,
    this.onRemove,
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

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        boxShadow: const [
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
          // Header
          Container(
            height: 120,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: gradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(4),
                topRight: Radius.circular(4),
              ),
            ),
            padding: const EdgeInsets.all(12),
            child: Stack(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // left: City, Time, Clouds
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${city['CityName']}, ${weather['sys']['country']}",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              DateFormat('h.mma, MMM d')
                                  .format(DateTime.now())
                                  .toLowerCase(),
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.8),
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.cloud_queue,
                              color: Colors.white,
                              size: 24,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              weather['weather'][0]['description']
                                  .toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    // right: Temp
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${weather['main']['temp'].toStringAsFixed(0)}°C",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 40,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "Temp Min: ${weather['main']['temp_min'].toStringAsFixed(0)}°C",
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.9),
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              "Temp Max: ${weather['main']['temp_max'].toStringAsFixed(0)}°C",
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.9),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),

                Positioned(
                  top: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: onRemove,
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Body (unchanged)
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[800],
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(4),
                bottomRight: Radius.circular(4),
              ),
            ),
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Pressure: ${weather['main']['pressure']} hPa",
                        style: TextStyle(color: Colors.white, fontSize: fontSize),
                      ),
                      Text(
                        "Humidity: ${weather['main']['humidity']}%",
                        style: TextStyle(color: Colors.white, fontSize: fontSize),
                      ),
                      Text(
                        "Visibility: ${(weather['visibility'] / 1000).toStringAsFixed(1)} km",
                        style: TextStyle(color: Colors.white, fontSize: fontSize),
                      ),
                    ],
                  ),
                ),
                Container(width: 1, height: 50, color: Colors.grey),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Transform.rotate(
                        angle: 20,
                        child: const Icon(
                          Icons.navigation_outlined,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      Text(
                        "${weather['wind']['speed']}m/s, ${weather['wind']['deg']}°",
                        style: TextStyle(color: Colors.white, fontSize: fontSize),
                      ),
                    ],
                  ),
                ),
                Container(width: 1, height: 50, color: Colors.grey),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "Sunrise: ${sunrise.hour.toString().padLeft(2, '0')}:${sunrise.minute.toString().padLeft(2, '0')}",
                        style: TextStyle(color: Colors.white, fontSize: fontSize),
                      ),
                      Text(
                        "Sunset: ${sunset.hour.toString().padLeft(2, '0')}:${sunset.minute.toString().padLeft(2, '0')}",
                        style: TextStyle(color: Colors.white, fontSize: fontSize),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
