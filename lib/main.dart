import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

void main() => runApp(
  DevicePreview(
    enabled: !kReleaseMode,
    builder: (context) => MaterialApp(
      title: "the two of us",
      builder: DevicePreview.appBuilder,
      locale: DevicePreview.locale(context),
      useInheritedMediaQuery: true,
      debugShowCheckedModeBanner: false,
      home: SIapp(),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
      ),
    ),
  ),
);

class SIapp extends StatefulWidget {
  @override
  State<SIapp> createState() => _SIappState();
}

class _SIappState extends State<SIapp> {
  final _currency = ["USD", "pound", "sterling"];
  String currentSelected = "USD";
  TextEditingController principalController = TextEditingController();
  TextEditingController roiController = TextEditingController();
  TextEditingController termController = TextEditingController();
  String displayResults = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Simple Interest Caliculator"),
        backgroundColor: Colors.deepPurple,
      ),
      body: ListView(
        children: [
          Padding(padding: const EdgeInsets.all(20.0), child: image),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              keyboardType: TextInputType.number,
              controller: principalController,
              decoration: InputDecoration(
                labelText: "Principal Amount",
                hintText: "Enter principal amount e.g. 1000",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: roiController,
              decoration: InputDecoration(
                labelText: "Rate of Interest",
                hintText: "Enter principal amount e.g. 1000",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
            ),
          ),

          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: termController,
                    decoration: InputDecoration(
                      labelText: "Term",
                      hintText: "",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                  ),
                ),
              ),
              Container(width: 10),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DropdownButton(
                    value: currentSelected,
                    items: _currency.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValueSelected) {
                      setState(() {
                        currentSelected = newValueSelected!;
                      });
                    },
                  ),
                ),
              ),
            ],
          ),

          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        displayResults = doMath();
                      });
                    },
                    child: Text("caliculate"),
                  ),
                ),
              ),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      reset();
                    },
                    child: Text("Reset"),
                  ),
                ),
              ),
            ],
          ),

          Padding(padding: EdgeInsets.all(8.0), child: Text(displayResults)),
        ],
      ),
    );
  }

  String doMath() {
    double principle = double.tryParse(principalController.text) ?? 0.0;
    double roi = double.tryParse(roiController.text) ?? 0.0;
    double term = double.tryParse(termController.text) ?? 0.0;

    double total = principle + (principle * roi * term) / 100;

    String results =
        "Afer $term years, your investement will be worth $total $currentSelected";
    return results;
  }

  void reset() {
    setState(() {
      principalController.text = "";
      roiController.text = "";
      termController.text = "";
      currentSelected = _currency[0];
    });
  }
}

Widget image = Image.asset("images/images.jpg", width: 125, height: 125);
