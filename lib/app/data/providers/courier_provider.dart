import 'package:get/get.dart';

import '../models/courier_model.dart';

class CourierProvider extends GetConnect {
  @override
  void onInit() {
    httpClient.defaultDecoder = (map) {
      if (map is Map<String, dynamic>) return Courier.fromJson(map);
      if (map is List)
        return map.map((item) => Courier.fromJson(item)).toList();
    };
    httpClient.baseUrl = 'YOUR-API-URL';
  }

  Future<Courier?> getCourier(int id) async {
    final response = await get('courier/$id');
    return response.body;
  }

  Future<Response<Courier>> postCourier(Courier courier) async =>
      await post('courier', courier);
  Future<Response> deleteCourier(int id) async => await delete('courier/$id');
}
