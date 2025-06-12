// Prayer times UI
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:adhan_dart/adhan_dart.dart';
import 'package:intl/intl.dart';

class PrayerTimesScreen extends StatefulWidget {
  @override
  _PrayerTimesScreenState createState() => _PrayerTimesScreenState();
}

class _PrayerTimesScreenState extends State<PrayerTimesScreen> {
  Map<String, String> prayerTimes = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPrayerTimes();
  }

  Future<void> fetchPrayerTimes() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          isLoading = false;
        });
        return;
      }

      LocationPermission permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        setState(() {
          isLoading = false;
        });
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      final Coordinates coordinates =
          Coordinates(position.latitude, position.longitude);
      final params = CalculationMethod.MuslimWorldLeague.getParameters();
      final prayerTimes = PrayerTimes.today(coordinates, params);

      setState(() {
        this.prayerTimes = {
          'الفجر': DateFormat.jm().format(prayerTimes.fajr),
          'الشروق': DateFormat.jm().format(prayerTimes.sunrise),
          'الظهر': DateFormat.jm().format(prayerTimes.dhuhr),
          'العصر': DateFormat.jm().format(prayerTimes.asr),
          'المغرب': DateFormat.jm().format(prayerTimes.maghrib),
          'العشاء': DateFormat.jm().format(prayerTimes.isha),
        };
        isLoading = false;
      });
    } catch (e) {
      print("خطأ في تحديد الموقع أو الحساب: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('مواقيت الصلاة')),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : prayerTimes.isEmpty
              ? Center(child: Text('تعذر تحديد الموقع'))
              : ListView(
                  children: prayerTimes.entries.map((entry) {
                    return ListTile(
                      title: Text(entry.key,
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      trailing: Text(entry.value),
                    );
                  }).toList(),
                ),
    );
  }
}
