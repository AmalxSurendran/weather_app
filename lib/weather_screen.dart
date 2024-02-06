// ignore_for_file: camel_case_types, non_constant_identifier_names, must_be_immutable, override_on_non_overriding_member

import 'dart:convert';
import 'dart:developer';

import 'dart:ui';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/additional_information.dart';
import 'package:weather_app/forcast_items.dart';
import 'package:weather_app/secreats.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  @override
  late Future<Map<String, dynamic>> weather;

  Future<Map<String, dynamic>> getWeather() async {
    try {
      String CityName = 'London';

      final res = await http.get(
        Uri.parse(
            "http://api.openweathermap.org/data/2.5/forecast?q=$CityName&APPID=$openWeatherApiKey"),
      );
      final data = jsonDecode(res.body);

      if (res.statusCode == 200) {
        return data;
      }
      throw 'unexpected error occured';

      //  data['list'][0]['main']['temp'];
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  void initState() {
    super.initState();
    weather = getWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Weather App",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                weather = getWeather();
              });
            },
            icon: const Icon(Icons.refresh_sharp),
          ),
        ],
      ),
      body: FutureBuilder(
        future: weather,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                snapshot.hasError.toString(),
              ),
            );
          }

          final data = snapshot.data!;
          final currentweather = data['list'][0];
          final currenttemp = currentweather['main']['temp'];
          final currentsky = currentweather['weather'][0]['main'];
          final currentpressure = currentweather['main']['pressure'];
          final currentwindspeed = currentweather['wind']['speed'];
          final currenthumidity = currentweather['main']['humidity'];
          return Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //MainCards
                SizedBox(
                  width: double.infinity,
                  child: Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(
                          sigmaX: 10,
                          sigmaY: 10,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(17.0),
                          child: Column(
                            children: [
                              Text(
                                '$currenttemp k',
                                style: const TextStyle(
                                  fontSize: 35,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Icon(
                                currentsky == 'Clouds' || currentsky == 'rain'
                                    ? Icons.cloud
                                    : Icons.sunny,
                                size: 65,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                currentsky,
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 50),
                const Text(
                  "Weather Forecast",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),

                SizedBox(
                  height: 120,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        final hourlyforecast = data['list'][index + 1];
                        final hourlysky =
                            data['list'][index + 1]['weather'][0]['main'];
                        final hourlytemp =
                            hourlyforecast['main']['temp'].toString();
                        final time = DateTime.parse(hourlyforecast['dt_txt']);
                        return ForcastItems(
                          icons: hourlysky == 'clouds' || hourlysky == 'Rain'
                              ? Icons.cloud
                              : Icons.sunny,
                          time: DateFormat.jm().format(time),
                          temp: hourlytemp,
                        );
                      }),
                ),
                // const SingleChildScrollView(
                //   scrollDirection: Axis.horizontal,
                //   child: Row(
                //     children: [
                //       ForcastItems(
                //         time: "07.30",
                //         icons: Icons.cloudy_snowing,
                //         temp: "71.63",
                //       ),
                //       ForcastItems(
                //         time: "10.30",
                //         icons: Icons.cloud,
                //         temp: "73.92",
                //       ),
                //       ForcastItems(
                //         time: "01.30",
                //         icons: Icons.sunny,
                //         temp: "79.98",
                //       ),
                //       ForcastItems(
                //         time: "04.30",
                //         icons: Icons.cloudy_snowing,
                //         temp: "70.63",
                //       ),
                //       ForcastItems(
                //         time: "07.30",
                //         icons: Icons.cloudy_snowing,
                //         temp: "65.21",
                //       ),
                //     ],
                //   ),
                // ),

                const SizedBox(height: 20),

                // AdditionalInformation
                const Text(
                  "Additional Information",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    additional_information(
                      icon: Icons.water_drop_sharp,
                      label: "Humidity",
                      value: currenthumidity.toString(),
                    ),
                    additional_information(
                      icon: Icons.air_rounded,
                      label: "Wind Speed",
                      value: currentwindspeed.toString(),
                    ),
                    additional_information(
                      icon: Icons.beach_access_rounded,
                      label: "Pressure",
                      value: currentpressure.toString(),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
