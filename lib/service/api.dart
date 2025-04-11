import 'dart:convert';
import 'package:http/http.dart' as http;

class University {
  final String name;
  final String country;
  final String webPage;

  University({required this.name, required this.country, required this.webPage});

  factory University.fromJson(Map<String, dynamic> json) {
    return University(
      name: json['name'],
      country: json['country'],
      webPage: json['web_page'],
    );
  }
}

class UniversityApiService {
  static Future<List<University>> fetchUniversities(String query) async {
    final url = Uri.parse('http://universities.hipolabs.com/search?name=$query');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        return data.map((json) => University.fromJson(json)).toList();
      } else {
        return _mockData(query);
      }
    } catch (e) {
      return _mockData(query);
    }
  }

  // Fallback mock data
  static List<University> _mockData(String query) {
    return [
      University(name: "Middle Earth University", country: "Fantasyland", webPage: "http://meu.fantasy"),
      University(name: "Mock State College", country: "Nowhere", webPage: "http://mock.nowhere"),
    ].where((u) => u.name.toLowerCase().contains(query.toLowerCase())).toList();
  }
}
