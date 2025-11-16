import 'package:http/http.dart' as client;

Future<client.Response> fetchCityByName(String cityName, String? apiKey) async {
  final uri = Uri.https(
    'api.openweathermap.org',
    '/data/2.5/weather',
    {
      'q': cityName,
      'appid': apiKey,
      'units': 'metric',
    },
  );

  final res = await client.get(uri);

  return res;
}
