import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../views/widgets/province.dart';
import '../views/widgets/city.dart';
import './widgets/berat.dart';
import '../controllers/home_controller.dart';


class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);
  @override

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ongkos Kirim'),
        centerTitle: true,
        backgroundColor: Colors.grey,
      ),

      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(20),
          children: [
            Provinsi(tipe: "asal",),
            Obx(
              () => controller.hiddenKotaAsal.isTrue 
                ? SizedBox() 
                : Kota(
                  provId: controller.provAsalId.value,
                  tipe: "asal",
                  )
            ),
            Provinsi(tipe: "tujuan"),
            Obx(
              () => controller.hiddenKotaTujuan.isTrue 
                ? SizedBox() 
                : Kota(
                  provId: controller.provTujuanId.value,
                  tipe: "tujuan",
                  )
            ),
            BeratBarang(),
            Padding(
              padding: const EdgeInsets.only(bottom: 50 ),
              child: DropdownSearch<Map<String, dynamic>>(
                mode: Mode.MENU,
                showClearButton: true,
                items: [
                  {
                    "code" : "jne",
                    "name" : "Jalur Nugraha Ekakurir (JNE)", 
                  },
                  {
                    "code" : "tiki",
                    "name" : "Titipan Kilat (TIKI)", 
                  },
                  {
                    "code" : "POS",
                    "name" : "Perusahaan Opsional Surat (POS INdonesia)", 
                  },
                ],
                label: "Tipe kurir   ",
                hint: 'Pilih kurir',
                onChanged: (value){
                  if (value != null) {
                    controller.kurir.value = value['code'];
                    controller.showButton();
                  }else{
                    controller.hiddenButton.value = true;
                    controller.kurir.value = "";
                  }
                },
                itemAsString: (item) => "${item['name']}" ,
                popupItemBuilder: (context, item, isSelected) => Container(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    "${item['name']}",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                    ),
                    ),
                ),
              ),
            ),
            Obx(
              () => controller.hiddenButton.isTrue ? SizedBox() : ElevatedButton(
              onPressed: () =>controller.ongkosKirim(), 
              child: Text("cek ongkos kirim"),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 20),
                backgroundColor: Colors.grey ,
              ),
              ),
            )
          ],
        ),
      ),
    );
  }
}




