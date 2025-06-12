// Main entry point of the app
void main() => runApp(MyApp());
import 'package:your_app/screens/prayer_times_screen.dart';

// ثم استدعاء الصفحة عند التنقل إليها
Navigator.push(context,
    MaterialPageRoute(builder: (context) => PrayerTimesScreen()));
