import 'dart:convert';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/home_controller.dart';
import '../../../../data/models/city_model.dart';


class Kota extends GetView<HomeController> {
  const Kota({
    super.key,
    required this.provId,
    required this.tipe,
  });

  final int provId;
  final String tipe;
 
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: DropdownSearch<City>(
        label: tipe == "asal" ? "Kota / kabupaten asal" : "Kota / kabupaten tujuan",
        showClearButton: true,
        onFind: (String filter) async {
          Uri url = Uri.parse("https://api.rajaongkir.com/starter/city?province=$provId");
          try {
            final response = await http.get(
              url,
              headers:  {
                "key": "7293135be7ce3e30f9e5bfe6667ad703",
              },
            );
            var data = json.decode(response.body) as Map<String, dynamic>;
            var statusCode = data["rajaongkir"]["status"]["code"];
            print("status code: $statusCode");
            
            if (statusCode != 200) {
              throw data["rajaongkir"]["status"]["description"];
            }

            var listAllCity = 
              data["rajaongkir"]["results"] as List<dynamic>;
            
            var models = City.fromJsonList(listAllCity);
            return models;
          } catch (err) {
            print(err);
            return List<City>.empty();
          }
        },
        onChanged: (cityValue){
          if (cityValue != null) {
            if (tipe == "asal") {
              controller.kotaAsalId.value = int.parse(cityValue.cityId!);
            }else{
             controller.kotaTujuanId.value = int.parse(cityValue.cityId!);
            }
          }else{
            if (tipe == "asal") {
              print("tidak memilih kota/kabupaten asal apapun");
              controller.kotaAsalId.value = 0;
              
            }else{
              print("tidak memilih kota/kabupaten tujuan apapun");
              controller.kotaTujuanId.value = 0;  
            }
          }
          controller.showButton();
        },
        
        showSearchBox: true,
        searchBoxDecoration: InputDecoration(
          contentPadding: 
            EdgeInsets.symmetric(vertical: 10, horizontal: 25),
          hintText: "Cari Kota/kabupaten",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50)
          )
        ),
        popupItemBuilder: (context, item, isSelected){
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text(
              "${item.type} ${item.cityName}",
              style: TextStyle(fontSize: 18),
            ),
          );
        },
        itemAsString: (item) => "${item.type} ${item.cityName}",
      ),
    );
  }
}