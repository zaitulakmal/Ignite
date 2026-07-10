import 'package:flutter/foundation.dart';

/// Mock BLE device state shared across screens (dashboard + device tab).
class DeviceState {
  DeviceState._();

  static final connected = ValueNotifier<bool>(false);
  static const deviceName = 'IGNITE-CU-0042';
  static const firmware = 'v1.4.2';
  static int batteryPct = 82;

  /// Wrap ports on the main control unit: name + battery, null = empty slot.
  static final wrapPorts = <({String area, int battery})?>[
    (area: 'Shoulder', battery: 76),
    (area: 'Lower Back', battery: 64),
    null,
    null,
  ];
}
