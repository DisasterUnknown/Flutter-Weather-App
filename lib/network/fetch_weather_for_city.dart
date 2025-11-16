import 'package:http/http.dart' as client;

Future<client.Response> fetchWeatherCity(Map<String, dynamic> city, String? apiKey) async {
  final uri = Uri.https(
    'api.openweathermap.org',
    '/data/2.5/weather',
    {
      'id': city['CityCode'].toString(),
      'appid': apiKey,
      'units': 'metric',
    },
  );

  final res = await client.get(uri);

  return res;
}
