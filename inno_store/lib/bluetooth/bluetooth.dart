import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Bluetooth App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class BluetoothConnect extends GetxController {
  var connectedDevice = Rx<BluetoothDevice?>(null);
  var receivedData = Rx<String>('');
  Timer? dataTimer;
  StreamSubscription? scanSubscription;

  // MARK: Scan
  Future scanDevices() async {
    if (await Permission.bluetoothScan.request().isGranted) {
      if (await Permission.bluetoothConnect.request().isGranted) {
        // Listen to scan results
        scanSubscription = FlutterBluePlus.onScanResults.listen((results) {
          if (results.isNotEmpty) {
            ScanResult r = results.last; // the most recently found device
            print('${r.device.remoteId}: "${r.advertisementData.advName}" found!');

            // Try to connect to the device
            connectDevice(r.device);
            print('device connected');
          }
        },
        onError: (e) => print(e),
        );

        // Wait for Bluetooth enabled & permission granted
        await FlutterBluePlus.adapterState.where((val) => val == BluetoothAdapterState.on).first;

        // Start scanning w/ timeout
        await FlutterBluePlus.startScan(
          withKeywords: ["INNO Store"],
          timeout: Duration(seconds: 5),
        );

        // Wait for scanning to stop
        await FlutterBluePlus.isScanning.where((val) => val == false).first;

        // Cleanup: cancel subscription when scanning stops
        if (scanSubscription != null) {
          FlutterBluePlus.cancelWhenScanComplete(scanSubscription!);
        }
      }
    } 
  }

  Future stopScanning() async {
    await FlutterBluePlus.stopScan();
    scanSubscription?.cancel();
    print('Stopped scanning');
  }

  Stream<List<ScanResult>> scanResults = FlutterBluePlus.scanResults;

  // MARK: Connect
  Future connectDevice(BluetoothDevice device) async {
    if (await Permission.bluetoothScan.request().isGranted &&
        await Permission.bluetoothConnect.request().isGranted) {

      if (!await Geolocator.isLocationServiceEnabled()) {
        print('Location services are disabled.');
        return;
      }

      // Listen for disconnection
      var subscription = device.connectionState.listen((BluetoothConnectionState state) async {
        if (state == BluetoothConnectionState.disconnected) {
          print('Device disconnected');
          connectedDevice.value = null; // Clear the connected device
          dataTimer?.cancel(); // Cancel the timer
        }
      });

      // Cleanup subscription on disconnection
      device.cancelWhenDisconnected(subscription, delayed: true, next: true);

      // Retry connection with a delay
      int retries = 0;
      const maxRetries = 3;
      while (retries < maxRetries) {
        try {
          await device.connect(timeout: Duration(seconds: 10));
          print('Connected to ${device.remoteId}');
          connectedDevice.value = device;

          // Discover services and read characteristics
          await discoverServices(device);

          // Start the timer to read data every 2 seconds
          dataTimer = Timer.periodic(Duration(seconds: 1), (timer) {
            readData(device);
          });

          break;
        } catch (e) {
          print('Connection attempt ${retries + 1} failed: $e');
          retries++;
          if (retries >= maxRetries) {
            print('Failed to connect after $maxRetries attempts');
            return;
          }
          await Future.delayed(Duration(seconds: 1));
        }
      }
    }
  }

  Future disconnectDevice(BluetoothDevice device) async {
    await device.disconnect();
    print('Disconnected from ${device.remoteId}');
    connectedDevice.value = null; // Clear the connected device
    dataTimer?.cancel(); // Cancel the timer
  }

  bool checkConnection(BluetoothDevice device) {
    bool isConnected = device.isConnected;
    print('Device ${device.remoteId} is connected: $isConnected');
    return isConnected;
  }

  Future discoverServices(BluetoothDevice device) async {
    List<BluetoothService> services = await device.discoverServices();
    for (BluetoothService service in services) {
      for (BluetoothCharacteristic characteristic in service.characteristics) {
        // For demonstration, we are only reading the characteristic with UUID `9d4f98c6-5459-420b-812f-dd255e636228`.
        if (characteristic.uuid.toString() == '9d4f98c6-5459-420b-812f-dd255e636228') {
          // Store the characteristic for continuous reading
          readData(device, characteristic);
        }
      }
    }
  }

  Future readData(BluetoothDevice device, [BluetoothCharacteristic? characteristic]) async {
    if (characteristic != null) {
      var data = await characteristic.read();
      receivedData.value = String.fromCharCodes(data);
    } else {
      // If characteristic is not passed, re-discover services and read data
      await discoverServices(device);
    }
  }

  Offset getRedDotCoordinates() {
    // Assume the received data contains the coordinates in the format "x,y"
    var coordinates = receivedData.value.split(',');
    if (coordinates.length == 2) {
      double x = double.tryParse(coordinates[0]) ?? 0.0;
      double y = double.tryParse(coordinates[1]) ?? 0.0;
      return Offset(x, y);
    }
    return Offset(0.0, 0.0); // Default coordinates if parsing fails
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final BluetoothConnect bluetoothConnect = Get.put(BluetoothConnect());
  bool isScanning = false;

  void _toggleScanning() async {
    setState(() {
      isScanning = !isScanning;
    });

    if (isScanning) {
      await bluetoothConnect.scanDevices();
    } else {
      await bluetoothConnect.stopScanning();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: Obx(() {
        // Display the received data
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _toggleScanning,
              child: Text(isScanning ? 'Stop Scanning' : 'Start Scanning'),
            ),
            SizedBox(height: 20),
            Text(
              'Received Data: ${bluetoothConnect.receivedData.value}',
              style: TextStyle(fontSize: 18),
            ),
          ],
        );
      }),
    );
  }
}
