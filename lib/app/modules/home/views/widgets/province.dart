import 'dart:convert';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../controllers/home_controller.dart';
import '../../../../data/models/province_model.dart';


class Provinsi extends GetView<HomeController> {
  const Provinsi({
    super.key,
    required this.tipe,
  });

  final String tipe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: DropdownSearch<Province>(
        label: tipe == "asal" ? "Provinsi asal" : "Provinsi tujuan",
        showClearButton: true,
        onFind: (String filter) async {
          Uri url = Uri.parse("https://api.rajaongkir.com/starter/province");
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

            var listAllProvince = 
              data["rajaongkir"]["results"] as List<dynamic>;
            
            var models = Province.fromJsonList(listAllProvince);
            return models;
          } catch (err) {
            print(err);
            return List<Province>.empty();
          }
        },
        onChanged: (prov){
          if (prov != null) {
            if (tipe == "asal") {
              controller.hiddenKotaAsal.value = false;
              controller.provAsalId.value = int.parse(prov.provinceId!);
            }else{
              controller.hiddenKotaTujuan.value = false;
              controller.provTujuanId.value = int.parse(prov.provinceId!);
            }
            controller.showButton();
          }else{ 
            if (tipe == "asal") {
              controller.hiddenKotaAsal.value = true;
              controller.provAsalId.value = 0;
            }else{
              controller.hiddenKotaTujuan.value = true;
              controller.provTujuanId.value = 0;
            }
          }

        },
        showSearchBox: true,
        searchBoxDecoration: InputDecoration(
          contentPadding: 
            EdgeInsets.symmetric(vertical: 10, horizontal: 25),
          hintText: "Cari Provinsi",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50)
          )
        ),
        popupItemBuilder: (context, item, isSelected){
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text(
              "${item.province}",
              style: TextStyle(fontSize: 18),
            ),
          );
        },
        itemAsString: (item) => item.province!,
      ),
    );
  }
}