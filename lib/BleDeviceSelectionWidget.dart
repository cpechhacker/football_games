import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_blue/flutter_blue.dart';

const BT_NUS_SERVICE_UUID = '6E400001-B5A3-F393-E0A9-E50E24DCCA9E';
const BT_RX_CHARACTERISTIC_UUID = '6E400002-B5A3-F393-E0A9-E50E24DCCA9E';
const BT_TX_CHARACTERISTIC_UUID = '6E400003-B5A3-F393-E0A9-E50E24DCCA9E';


class BleDevice {
  BluetoothCharacteristic rx;  // receiver on bluetooth device
  BluetoothCharacteristic tx;

  BleDevice(this.rx, this.tx); // transmitter on bluetooth device
}

// This list will contain all selected and connected bluetooth devices.
var bleDevices = <BleDevice>[];

class BleDeviceSelectionWidget extends StatefulWidget {
  BleDeviceSelectionWidget({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _BleDeviceSelectionState createState() => _BleDeviceSelectionState();
}

class _BleDeviceSelectionState extends State<BleDeviceSelectionWidget> {
  bool _scanning = false;
  Stream<List<BluetoothDevice>> connectedDevicesStream = Stream.empty();
  Stream<List<BluetoothDevice>> scannedDevicesStream = Stream.empty();
  String? deviceIdConnecting;
  final keyState = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    connectedDevicesStream =
        Stream.periodic(Duration(seconds: 2)).asyncMap((_) => FlutterBlue.instance.connectedDevices);

    scannedDevicesStream = FlutterBlue.instance.scanResults
        .asyncMap((scanResultList) => scanResultList.map((scanResult) => scanResult.device).toList());

    startScan();
  }

  startScan() {
    if (_scanning) {
      stopScan();
    }

    setState(() {
      _scanning = true;
      deviceIdConnecting = null;
    });

    FlutterBlue.instance.startScan(timeout: Duration(seconds: 5));
  }

  stopScan() {
    FlutterBlue.instance.stopScan();
  }

  /*
   * Super ugly workaround because we can't try/catch the connect method
   */
  Future<bool> connect(BluetoothDevice device) async {
    Future<bool> success = Future.value(false);
    await device.connect().timeout(Duration(seconds: 5), onTimeout: () {
      success = Future.value(false);
      device.disconnect();
    }).then((data) {
      if (success == null) {
        success = Future.value(true);
      }
    });
    return success;
  }

  void _storeRxTx(BluetoothDevice device) async {
    print('fetch services');
    var services = await device.discoverServices();

    var uartService = services.firstWhere((service) => service.uuid.toString().toUpperCase() == BT_NUS_SERVICE_UUID,
        orElse: () => null);

    if (uartService == null) {
      print("UART Service not found");
      return;
    }

    var rxChar = uartService.characteristics
        .firstWhere((char) => char.uuid.toString().toUpperCase() == BT_RX_CHARACTERISTIC_UUID, orElse: () => null);

    var txChar = uartService.characteristics
        .firstWhere((char) => char.uuid.toString().toUpperCase() == BT_TX_CHARACTERISTIC_UUID, orElse: () => null);

    var bleDevice = BleDevice(rxChar, txChar);

    device.state.listen((state) {
      if (state == BluetoothDeviceState.disconnected) {
        // Todo do something if device disconnects
        print("Device has disconnected.  Don't know what to do.");
        // ?? bleDevices.remove(bleDevice);
      }
    });

    try {
      await txChar.setNotifyValue(true);
    } catch (err) {}

    bleDevices.add(bleDevice);
  }


  Future<void> onDeviceSelected(BuildContext context, BluetoothDevice device) async {
    setState(() {
      deviceIdConnecting = device.id.toString();
    });

    try {
      print('checking state');
      var state = await device.state.first;
      print(state);
      if (state != BluetoothDeviceState.connected) {
        print('not connected');
        var success = await connect(device);
        if (!success) {
          keyState.currentState.showSnackBar(SnackBar(
            content: Text("Failed to Connect"),
          ));
          setState(() {
            deviceIdConnecting = null;
          });
          return;
        }
      }

      // TODO inform user that connection to bluetooth device was successful.
      // SnackBar?
      print('Connected to bluetooth device: $deviceIdConnecting');
      _storeRxTx(device);

    } finally {
      setState(() {
        deviceIdConnecting = null;
      });
    }

    setState(() {
      deviceIdConnecting = null;
    });
  }

  Widget buildDeviceListFromStream(BuildContext context, Stream<List<BluetoothDevice>> stream) {
    return StreamBuilder<List<BluetoothDevice>>(
      stream: stream,
      initialData: [],
      builder: (c, snapshot) => Column(
        children: snapshot.data.map((device) {
          var isConnecting = deviceIdConnecting == device.id.toString();
          return ListTile(
            title: Text(device.name.isEmpty ? "No name" : device.name),
            subtitle: Text(device.id.toString()),
            dense: false,
            trailing: StreamBuilder<BluetoothDeviceState>(
              stream: device.state,
              initialData: BluetoothDeviceState.disconnected,
              builder: (c, snapshot) {
                if (isConnecting) {
                  return CircularProgressIndicator(
                    strokeWidth: 1,
                  );
                }
                if (snapshot.data == BluetoothDeviceState.connected) {
                  return Text('Connected');
                }
                return Text('Not Connected');
              },
            ),
            leading: Icon(Icons.bluetooth),
            onTap: () {
              if (deviceIdConnecting == null) {
                onDeviceSelected(context, device);
              }
            },
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: keyState,
      appBar: AppBar(
        title: Text("BLE Device Selection"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            buildDeviceListFromStream(context, connectedDevicesStream),
            buildDeviceListFromStream(context, scannedDevicesStream),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: startScan,
        tooltip: 'Refresh',
        child: Icon(Icons.refresh),
      ),
    );
  }
}