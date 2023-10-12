import 'package:http/http.dart' as http;

class HttpHelper {
  final String _apiKey = "e41a80bff2b8b61d6a5c48d3df361809";
  final String _baseUrl = "https://api.themoviedb.org/3/movie";

  Future<String> getMoviesByCategory(String category) async {
    final String url = '$_baseUrl/$category?api_key=$_apiKey';
    final http.Response response = await http.get(Uri.parse(url));

    // print(response.body);

    if (response.statusCode == 200) {
      return response.body;
    } else {
      return 'Failed to fetch data';
    }
  }
}
