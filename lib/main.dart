import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

void main() => runApp(
  DevicePreview(
    enabled: !kReleaseMode,
    builder: (context) => MaterialApp(
      title: "Manager",
      builder: DevicePreview.appBuilder,
      locale: DevicePreview.locale(context),
      useInheritedMediaQuery: true,
      debugShowCheckedModeBanner: false,
      home: FavCity(),
    ),
  ),
);

class FavCity extends StatefulWidget {
  @override
  State<FavCity> createState() => _FavCityState();
}

class _FavCityState extends State<FavCity> {
  var name = "";
  final _city = ["London", "Kampala", "Others"];
  var currentCity = "Others";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Manager")),
      body: Column(
        children: [
          TextField(
            onSubmitted: (String userInput) {
              setState(() {
                name = userInput;
              });
            },
          ),

          DropdownButton<String>(
            items: _city.map((String selectedCity) {
              return DropdownMenuItem<String>(
                value: selectedCity,
                child: Text(selectedCity),
              );
            }).toList(),
            onChanged: (String? newCity) {
              setState(() {
                currentCity = newCity ?? "Others";
              });
            },
            value: currentCity,
          ),

          Padding(
            padding: EdgeInsets.all(20.0),
            child: Text('Your Favourite City is $name'),
          ),
        ],
      ),
    );
  }
}
