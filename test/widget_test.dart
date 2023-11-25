import 'package:http/http.dart' as http;

void main() async {
  Uri url = Uri.parse("https://api.rajaongkir.com/starter/cost");
  final response = await http.post(
    url,
    body: {
      "origin" : "501",
      "destination" : "114",
      "weight": "1700",
      "courier": "jne"
    },
    headers: {
      "key": "7293135be7ce3e30f9e5bfe6667ad703",
      // "content-type": "application/x-www-form-urlencode"
    },
  );

  print(response.body);
  print(response.statusCode);
}