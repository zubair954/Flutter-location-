import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  static const platform = MethodChannel('com.example.native_bridge');

  @override
  initState() {
    super.initState();
    requestPermissions();
  }

  Future<void> requestPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
      Permission.notification,
    ].request();

    if (statuses[Permission.location]!.isGranted) {
      print('Location permission granted');
    } else {
      print('Location permission denied');
    }

    if (statuses[Permission.notification]!.isGranted) {
      print('Notification permission granted');
    } else {
      print('Notification permission denied');
    }
  }

  // Method to call native code
  Future play() async {
    try {
      await platform.invokeMethod('startPlayer');
      // print(result);
      // return result;
    } on PlatformException catch (e) {
      return "Failed to get message: '${e.message}'.";
    }
  }

  Future stop() async {
    try {
      await platform.invokeMethod('stopPlayer');
      // print(result);
      // return result;
    } on PlatformException catch (e) {
      return "Failed to get message: '${e.message}'.";
    }
  }

  void _incrementCounter() async {
    List<Permission> statuses = [
      Permission.location,
      Permission.notification,
    ];
    setState(() {
      _counter++;
    });
    if (await statuses[0].isGranted == false ||
        await statuses[1].isGranted == false) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please grant all permissions'),
          ),
        );
        await Future.delayed(const Duration(seconds: 2), () {
          openAppSettings();
        });
      }

      return;
    }

    await play();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              onTap: () async {
                await stop();
              },
              child: const Text(
                'You have pushed the button this many times:',
              ),
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
