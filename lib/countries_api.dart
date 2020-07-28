import 'package:http/http.dart' as http;

Future fetchCountryList() async {
  final response = await http.get(
    'http://portal.cyberliver.com/user/countriesList',
    headers: {"Accept": "application/json"},
  );

  if (response.statusCode == 200) {
    return response;
  } else {
    throw Exception('Get request failed');
  }
}
