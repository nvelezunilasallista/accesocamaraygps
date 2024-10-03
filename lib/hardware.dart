import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';

class Hardware extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _Hardware();
  }
}

class _Hardware extends State<Hardware> {
  final ImagePicker _picker = ImagePicker();

  DecorationImage defaultImage = DecorationImage(
      fit: BoxFit.cover,
      image: NetworkImage(
          "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png"));

  TextEditingController latitude = TextEditingController();
  TextEditingController longitude = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Ejemplo Acceso a Cámara y GPS")),
        body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                Row(
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          getImage(ImageSource.camera);
                        },
                        child: Text("Cámara")),
                    VerticalDivider(),
                    ElevatedButton(
                        onPressed: () {
                          getImage(ImageSource.gallery);
                        },
                        child: Text("Galería"))
                  ],
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  height: MediaQuery.of(context).size.height * 0.5,
                  decoration: BoxDecoration(
                      shape: BoxShape.rectangle, image: defaultImage),
                ),
                TextField(
                  readOnly: true,
                  controller: latitude,
                  decoration: InputDecoration(
                      helperText: "Latitud",
                      helperStyle: TextStyle(fontSize: 15)),
                ),
                TextField(
                  readOnly: true,
                  controller: longitude,
                  decoration: InputDecoration(
                      helperText: "Longitud",
                      helperStyle: TextStyle(fontSize: 15)),
                )
              ],
            )));
  }

  void getImage(ImageSource source) async {
    XFile? image = await _picker.pickImage(source: source);
    if (image != null) {
      File localImage = File(image.path);

      bool locationIsActive = await Geolocator.isLocationServiceEnabled();

      if (locationIsActive) {
        LocationPermission permissions = await Geolocator.checkPermission();

        if (permissions == LocationPermission.unableToDetermine ||
            permissions == LocationPermission.denied ||
            permissions == LocationPermission.deniedForever) {
          permissions = await Geolocator.requestPermission();
        }
        if (permissions == LocationPermission.always ||
            permissions == LocationPermission.whileInUse) {
          Position position = await Geolocator.getCurrentPosition();

          latitude.text = position.latitude.toString();
          longitude.text = position.longitude.toString();
        }
      }

      setState(() {
        this.defaultImage = DecorationImage(image: FileImage(localImage));
      });
    }
  }
}
