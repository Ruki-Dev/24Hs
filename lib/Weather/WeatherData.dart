class WeatherData {
  final DateTime date;
  final String name;
  final double temp;
  final String main;
  final String icon;
  final String desc;

  WeatherData(
      {this.desc, this.date, this.name, this.temp, this.main, this.icon});

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      date: new DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000,
          isUtc: false),
      name: json['name'],
      temp: (json['main']['temp'].toDouble() - 273.15),
      //-32)*(0.556),
      main: json['weather'][0]['main'],
      icon: json['weather'][0]['icon'],
      desc: json['weather'][0]['description'],
    );
  }
}
