import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:xml/xml.dart';

class GoldPriceWidget extends StatefulWidget {
  const GoldPriceWidget({super.key});

  @override
  _GoldPriceWidgetState createState() => _GoldPriceWidgetState();
}

class _GoldPriceWidgetState extends State<GoldPriceWidget> {
  late List<City> cities = new List.empty();

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final response = await Dio()
          .get('https://sjc.com.vn/xml/tygiavang.xml?t=1706337173481');
      final XmlDocument document = XmlDocument.parse(response.data);
      final List<City> parsedCities =
          document.findAllElements('city').map((cityElement) {
        final cityName = cityElement.getAttribute('name') ?? '';
        final List<GoldItem> goldItems =
            cityElement.findElements('item').map((itemElement) {
          final buy = itemElement.getAttribute('buy') ?? '';
          final sell = itemElement.getAttribute('sell') ?? '';
          final type = itemElement.getAttribute('type') ?? '';
          return GoldItem(buy, sell, type);
        }).toList();
        return City(cityName, goldItems);
      }).toList();

      setState(() {
        cities = parsedCities;
      });
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        body: cities.isEmpty
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Center(
                heightFactor: 1,
                child: Scrollbar(
                    child: ListView.builder(
                  itemCount: cities.length,
                  itemBuilder: (context, index) {
                    final city = cities[index];
                    // return ListTile(
                    //   title: Text(city.name),
                    //   subtitle: Row(
                    //     children: city.goldItems.map((item) {
                    //       return Text(
                    //           '${item.type}: Buy - ${item.buy}, Sell - ${item.sell}');
                    //     }).toList(),
                    //   ),
                    // );
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                          child: Title(
                              color: Colors.black, child: Text(city.name)),
                        ),
                        Container(
                          height: city.goldItems.length * 40,
                          child: ListView.builder(
                              itemCount: city.goldItems.length,
                              itemBuilder: (context, goldIndex) {
                                final goldItem = city.goldItems[goldIndex];
                                return Container(
                                  decoration: BoxDecoration(
                                      border: Border.symmetric(
                                          horizontal: BorderSide(
                                              width: 1,
                                              color: Color.fromARGB(
                                                  255, 50, 206, 19)))),
                                  padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                                  height: 40,
                                  child: Text(goldItem.type +
                                      " - Buy: " +
                                      goldItem.buy +
                                      " - Sell: " +
                                      goldItem.sell),
                                );
                              }),
                        ),
                      ],
                    );
                  },
                )),
              ),
      ),
    );
  }
}

class City {
  final String name;
  final List<GoldItem> goldItems;

  City(this.name, this.goldItems);
}

class GoldItem {
  final String buy;
  final String sell;
  final String type;

  GoldItem(this.buy, this.sell, this.type);
}
