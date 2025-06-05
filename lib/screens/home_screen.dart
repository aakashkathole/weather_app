import 'package:flutter/material.dart';
import 'package:weather_icons/weather_icons.dart';
import 'package:geolocator/geolocator.dart';
import 'package:dio/dio.dart';  // Dio
import '../services/weather_service.dart';
import '../models/weather_model.dart';
import 'new_page.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String cityName = '';
  String location = 'Loading...';
  String temperature = '';
  String weatherCondition = '';
  String humidity = '';
  String windSpeed = '';

  final Dio dio = Dio();  // Create Dio instance
  final WeatherService _weatherService = WeatherService(Dio()); // Pass Dio instance to WeatherService

  bool isLoading = false; // loader for loading

  @override
  void initState() {
    super.initState();
    _fetchWeatherData();
  }

  Future<void> _fetchWeatherData() async {
    setState(() => isLoading = true);

    try {
      WeatherResponse? weather;

      if (cityName.isNotEmpty) {
        weather = await _weatherService.fetchWeatherByCity(
          cityName,
          'c6b77af094b929d835b85b9802046fcb', // API key
          'metric',
        );
      } else {
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );

        weather = await _weatherService.fetchWeather(
          position.latitude,
          position.longitude,
          'c6b77af094b929d835b85b9802046fcb', // API key
          'metric',
        );
      }

      setState(() {
        location = weather?.name ?? 'Unknown location';
        temperature = '${weather?.main?.temp?.toString() ?? 'N/A'} °C';
        weatherCondition = (weather?.weather != null && weather!.weather.isNotEmpty)
            ? weather.weather[0].description
            : 'N/A';
        humidity = '${weather?.main?.humidity?.toString() ?? 'N/A'}%';
        windSpeed = '${weather?.wind?.speed?.toString() ?? 'N/A'} m/s';
      });
    } catch (e) {
      setState(() {
        location = 'Unable to fetch weather';
        temperature = 'N/A';
        weatherCondition = 'N/A';
        humidity = 'N/A';
        windSpeed = 'N/A';
      });
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryBg = Color(0xFF87CEEB);
    return Scaffold(
      backgroundColor: primaryBg,
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  onSubmitted: (value) {
                    setState(() {
                      cityName = value;
                      location = cityName;
                    });
                    _fetchWeatherData();
                  },
                  decoration: InputDecoration(
                    labelText: 'Search for location',
                    prefixIcon: const Icon(Icons.search_outlined),
                    contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(80),
                      borderSide: const BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(80),
                      borderSide: const BorderSide(color: Colors.blue),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: _fetchWeatherData,
            icon: Icon(
              Icons.refresh_outlined,
              color: Colors.blue,
              size: 30,
            ),
          ),
        ],
        backgroundColor: primaryBg,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: isLoading
              ? SizedBox(
            width: 100,
            height: 100,
            child: RefreshProgressIndicator(
              color: Colors.blue,
              backgroundColor: Colors.white,
            ),
          )
              : Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              Row(
                children: [
                  Text(
                    location,
                    style: TextStyle(fontSize: 20,
                    color: Colors.white
                    ),
                  ),
                  SizedBox(width: 5,),
                  Icon(
                    Icons.location_on_outlined,
                    size: 20,
                    color: Colors.white,
                  )
                ],
              ),
              Row(
                children: [
                  Text(
                    temperature,
                    style: TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.w300,
                      color: Colors.white,
                    ),
                  ),
                  Spacer(),
                  Icon(
                    Icons.cloud,
                    color: Colors.white,
                    size: 75,
                  )
                ],
              ),
              const SizedBox(height: 20),

              Container(
                width: 100,          // Width of the container
                height: 125,         // Height of the container
                alignment: Alignment.topLeft,  // Alignment of child within the container
                padding: EdgeInsets.all(8),   // Inner padding
                margin: EdgeInsets.all(0),    // Outer margin
                decoration: BoxDecoration(
                  color: Color(0xFFB0E0E),         // Background color
                  borderRadius: BorderRadius.circular(12),  // Rounded corners
                  border: Border.all(color: Color(0xFF4682B), width: 1),  // Border style
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text(
                  'Weather is $weatherCondition at $location',
                  style: TextStyle(color: Colors.white),
                ),
                    Divider(color: Colors.white, thickness: 0.2,),
                ]
                ),
              ),

              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center, // align containers to the start
                children: [
                  // First Container
                  Expanded(child:
                  Container(
                    height: 100,
                    alignment: Alignment.topLeft,
                    padding: EdgeInsets.all(8),
                    margin: EdgeInsets.all(0),
                    decoration: BoxDecoration(
                      color: Color(0xFFB0E0E), // faint sky blue background
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Color(0xFFB0E0E), width: 1),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Today\'s Temperature',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  ),

                  // Spacing between containers
                  SizedBox(width: 10),
                  // Second Container (Same as the first one)
                  Expanded(child:
                  Container(
                    height: 100,
                    alignment: Alignment.topLeft,
                    padding: EdgeInsets.all(8),
                    margin: EdgeInsets.all(0),
                    decoration: BoxDecoration(
                      color: Color(0xFFB0E0E),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Color(0xFFB0E0E), width: 1),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'AQI',
                          style: TextStyle(color: Colors.white,),
                        ),
                      ],
                    ),
                  ),
                  ),
                ],
              ),

              const SizedBox(height: 10),
              Row(
                children: [
                  // left container (50% width, ... height)
                  Expanded(
                    flex: 2, // 50% width
                    child: Container(
                      height: 320,
                      padding: EdgeInsets.all(8),
                      margin: EdgeInsets.all(0),
                      decoration: BoxDecoration(
                        color: Color(0xFFB0E0E),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 5,),
                          Text('Today', style: TextStyle(color: Colors.white, fontSize: 16),),
                          SizedBox(height: 10,),
                          Text('Yesterday', style: TextStyle(color: Colors.white, fontSize: 16),),
                          SizedBox(height: 10,),
                          Text('Tomorrow', style: TextStyle(color: Colors.white, fontSize: 16),),
                          Divider(color: Colors.white, thickness: 0.2,),
                          Text('Monday', style: TextStyle(color: Colors.white, fontSize: 16),),
                          SizedBox(height: 10,),
                          Text('Tuesday', style: TextStyle(color: Colors.white, fontSize: 16),),
                          SizedBox(height: 10,),
                          Text('Wednesday', style: TextStyle(color: Colors.white, fontSize: 16),),
                          SizedBox(height: 10,),
                          Text('Thursday', style: TextStyle(color: Colors.white, fontSize: 16),),
                          SizedBox(height: 10,),
                          Text('Friday', style: TextStyle(color: Colors.white, fontSize: 16),),
                          SizedBox(height: 10,),
                          Text('Saturday', style: TextStyle(color: Colors.white, fontSize: 16),),

                        ],
                      )
                    ),
                  ),
                  const SizedBox(width: 10),

                  // right 6 containers (each 25% width, ... height)
                  Expanded(
                    flex: 2, // 50% width
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 100,
                                padding: EdgeInsets.all(8),
                                margin: EdgeInsets.all(0),
                                decoration: BoxDecoration(
                                  color: Color(0xFFB0E0E),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                alignment: Alignment.topLeft,
                                child: Text(
                                  'UV Index',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Container(
                                height: 100,
                                padding: EdgeInsets.all(8),
                                margin: EdgeInsets.all(0),
                                decoration: BoxDecoration(
                                  color: Color(0xFFB0E0E),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                alignment: Alignment.topLeft,
                                child: Text(
                                  'Humidity',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),

                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 100,
                                padding: EdgeInsets.all(8),
                                margin: EdgeInsets.all(0),
                                decoration: BoxDecoration(
                                  color: Color(0xFFB0E0E),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                alignment: Alignment.topLeft,
                                child: Text(
                                  'Wind',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Container(
                                height: 100,
                                padding: EdgeInsets.all(8),
                                margin: EdgeInsets.all(0),
                                decoration: BoxDecoration(
                                  color: Color(0xFFB0E0E),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                alignment: Alignment.topLeft,
                                child: Text(
                                  'Dew point',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),

                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 100,
                                padding: EdgeInsets.all(8),
                                margin: EdgeInsets.all(0),
                                decoration: BoxDecoration(
                                  color: Color(0xFFB0E0E),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                alignment: Alignment.topLeft,
                                child: Text(
                                  'Pressure',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Container(
                                height: 100,
                                padding: EdgeInsets.all(8),
                                margin: EdgeInsets.all(0),
                                decoration: BoxDecoration(
                                  color: Color(0xFFB0E0E),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                alignment: Alignment.topLeft,
                                child: Text(
                                  'Visibility',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5,),
              Divider(color: Colors.white,),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OverviewCardlocation(
                    title: "Current Location",
                    value: location,
                    icon: Icons.location_on_outlined,
                  ),
                ],
              ),

              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OverviewCard(
                    title: "Weather",
                    value: weatherCondition,
                    icon: Icons.cloud_outlined,
                  ),
                  OverviewCard(
                    title: "Temperature",
                    value: temperature,
                    icon: WeatherIcons.thermometer,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OverviewCard(
                    title: "Total Humidity %",
                    value: humidity,
                    icon: WeatherIcons.humidity,
                  ),
                  OverviewCard(
                    title: "Wind Speed m/s",
                    value: windSpeed,
                    icon: WeatherIcons.windy,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  ElevatedButton(
              child: Text("Go to New Page"),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return NewPage();
                          },
                        ),
                      );

                    },
        ),
                ],
              ),
              const SizedBox(height: 80,),
              Row(
                children: [
                  Text(
                    '@ aakash kathole',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// OverviewCard Widget (for weather, temperature, humidity, wind speed)
class OverviewCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const OverviewCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        color: Colors.white,
        shadowColor: Colors.blue,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Icon(icon, size: 40, color: Colors.lightBlue.shade700),
              const SizedBox(height: 8),
              Text(
                value,
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(title, style: const TextStyle(fontSize: 14, color: Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }
}

// OverviewCard Widget (for current location card)
class OverviewCardlocation extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const OverviewCardlocation({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        color: Colors.white,
        shadowColor: Colors.blue,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(icon, size: 50, color: Colors.lightBlue.shade700),
              const SizedBox(width: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold,),
                  ),
                  const SizedBox(height: 4),
                  Text(title, style: const TextStyle(fontSize: 14, color: Colors.grey)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
