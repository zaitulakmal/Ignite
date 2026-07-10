import 'dart:async';

import 'package:flutter/material.dart';

import '../../data/device_state.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common.dart';

class DeviceScreen extends StatefulWidget {
  const DeviceScreen({super.key});

  @override
  State<DeviceScreen> createState() => _DeviceScreenState();
}

enum _ScanPhase { idle, scanning, found, connecting }

class _DeviceScreenState extends State<DeviceScreen>
    with SingleTickerProviderStateMixin {
  _ScanPhase _phase = _ScanPhase.idle;
  late final AnimationController _pulse;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pulse.dispose();
    super.dispose();
  }

  void _startScan() {
    setState(() => _phase = _ScanPhase.scanning);
    _timer = Timer(const Duration(seconds: 2), () {
      if (mounted) setState(() => _phase = _ScanPhase.found);
    });
  }

  void _connect() {
    setState(() => _phase = _ScanPhase.connecting);
    _timer = Timer(const Duration(milliseconds: 1400), () {
      if (!mounted) return;
      DeviceState.connected.value = true;
      setState(() => _phase = _ScanPhase.idle);
    });
  }

  void _disconnect() {
    DeviceState.connected.value = false;
    setState(() => _phase = _ScanPhase.idle);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Device')),
      body: SafeArea(
        child: ValueListenableBuilder<bool>(
          valueListenable: DeviceState.connected,
          builder: (context, connected, _) =>
              connected ? _buildConnected() : _buildPairing(),
        ),
      ),
    );
  }

  // -- Pairing flow ----------------------------------------------------------

  Widget _buildPairing() {
    final text = Theme.of(context).textTheme;
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      children: [
        const SizedBox(height: 24),
        SizedBox(
          height: 220,
          child: Center(
            child: _phase == _ScanPhase.scanning ||
                    _phase == _ScanPhase.connecting
                ? AnimatedBuilder(
                    animation: _pulse,
                    builder: (context, child) => Stack(
                      alignment: Alignment.center,
                      children: [
                        for (final delay in [0.0, 0.4, 0.8])
                          _pulseRing((_pulse.value + delay) % 1.0),
                        child!,
                      ],
                    ),
                    child: const IgniteLogo(size: 84),
                  )
                : const IgniteLogo(size: 84),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          switch (_phase) {
            _ScanPhase.idle => 'Pair your control unit',
            _ScanPhase.scanning => 'Scanning for devices…',
            _ScanPhase.found => 'Device found',
            _ScanPhase.connecting => 'Connecting…',
          },
          textAlign: TextAlign.center,
          style: text.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 8),
        Text(
          _phase == _ScanPhase.idle
              ? 'Turn on your IGNITE control unit and keep it within 1 meter of your phone.'
              : 'Bluetooth Low Energy · secure pairing',
          textAlign: TextAlign.center,
          style: text.bodyMedium?.copyWith(color: AppColors.slate),
        ),
        const SizedBox(height: 28),
        if (_phase == _ScanPhase.idle)
          FilledButton.icon(
            onPressed: _startScan,
            icon: const Icon(Icons.bluetooth_searching_rounded),
            label: const Text('Scan for Devices'),
          ),
        if (_phase == _ScanPhase.found || _phase == _ScanPhase.connecting)
          AppCard(
            child: Row(
              children: [
                const IconBadge(
                  icon: Icons.developer_board_rounded,
                  color: AppColors.teal,
                  background: AppColors.tealSoft,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        DeviceState.deviceName,
                        style: text.titleSmall
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      Text(
                        'Signal strong · -42 dBm',
                        style:
                            text.bodySmall?.copyWith(color: AppColors.slate),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 40,
                  child: FilledButton(
                    onPressed:
                        _phase == _ScanPhase.connecting ? null : _connect,
                    style: FilledButton.styleFrom(
                      minimumSize: const Size(0, 40),
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                    ),
                    child: _phase == _ScanPhase.connecting
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text('Connect'),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _pulseRing(double t) {
    final size = 100 + t * 160;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.ember.withValues(alpha: (1 - t) * 0.35),
          width: 2,
        ),
      ),
    );
  }

  // -- Connected view --------------------------------------------------------

  Widget _buildConnected() {
    final text = Theme.of(context).textTheme;
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      children: [
        // Control unit card
        AppCard(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                children: [
                  const IgniteLogo(size: 52),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          DeviceState.deviceName,
                          style: text.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w800),
                        ),
                        Text(
                          'Main Control Unit · ${DeviceState.firmware}',
                          style: text.bodySmall
                              ?.copyWith(color: AppColors.slate),
                        ),
                      ],
                    ),
                  ),
                  const StatusChip(
                    label: 'CONNECTED',
                    icon: Icons.check_circle_rounded,
                    color: AppColors.success,
                    background: AppColors.successSoft,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  _deviceStat(Icons.battery_5_bar_rounded,
                      '${DeviceState.batteryPct}%', 'Battery'),
                  _verticalDivider(),
                  _deviceStat(
                      Icons.network_check_rounded, '-42 dBm', 'Signal'),
                  _verticalDivider(),
                  _deviceStat(Icons.shield_rounded, 'OK', 'Safety'),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        const SectionHeader(title: 'Wrap ports'),
        const SizedBox(height: 4),
        Text(
          'Attach up to 4 therapy wraps per cycle.',
          style: text.bodySmall?.copyWith(color: AppColors.slate),
        ),
        const SizedBox(height: 12),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.35,
          children: [
            for (var i = 0; i < DeviceState.wrapPorts.length; i++)
              _wrapPortCard(i, DeviceState.wrapPorts[i]),
          ],
        ),
        const SizedBox(height: 24),
        AppCard(
          child: Row(
            children: [
              const IconBadge(
                icon: Icons.system_update_alt_rounded,
                color: AppColors.teal,
                background: AppColors.tealSoft,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Firmware up to date',
                      style: text.titleSmall
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    Text(
                      '${DeviceState.firmware} · OTA updates enabled',
                      style: text.bodySmall?.copyWith(color: AppColors.slate),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded, color: AppColors.muted),
            ],
          ),
        ),
        const SizedBox(height: 16),
        OutlinedButton.icon(
          onPressed: _disconnect,
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.danger,
            side: const BorderSide(color: AppColors.line),
          ),
          icon: const Icon(Icons.bluetooth_disabled_rounded),
          label: const Text('Disconnect Device'),
        ),
      ],
    );
  }

  Widget _deviceStat(IconData icon, String value, String label) {
    final text = Theme.of(context).textTheme;
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: AppColors.slate, size: 20),
          const SizedBox(height: 6),
          Text(
            value,
            style: text.titleSmall?.copyWith(fontWeight: FontWeight.w800),
          ),
          Text(
            label,
            style: text.labelSmall?.copyWith(color: AppColors.muted),
          ),
        ],
      ),
    );
  }

  Widget _verticalDivider() =>
      Container(width: 1, height: 40, color: AppColors.line);

  Widget _wrapPortCard(int index, ({String area, int battery})? port) {
    final text = Theme.of(context).textTheme;
    final letter = String.fromCharCode(65 + index); // A, B, C, D
    if (port == null) {
      return Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.line, width: 1.4),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.add_circle_outline_rounded,
                color: AppColors.muted, size: 28),
            const SizedBox(height: 8),
            Text(
              'Port $letter empty',
              style: text.labelMedium?.copyWith(color: AppColors.muted),
            ),
            Text(
              'Attach a wrap',
              style: text.labelSmall?.copyWith(color: AppColors.muted),
            ),
          ],
        ),
      );
    }
    return AppCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.emberSoft,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'WRAP $letter',
                  style: text.labelSmall?.copyWith(
                    color: AppColors.emberDeep,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              const Spacer(),
              const Icon(Icons.check_circle_rounded,
                  color: AppColors.success, size: 18),
            ],
          ),
          const Spacer(),
          Text(
            port.area,
            style: text.titleSmall?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.battery_5_bar_rounded,
                  size: 14, color: AppColors.slate),
              const SizedBox(width: 4),
              Text(
                '${port.battery}%',
                style: text.labelSmall?.copyWith(color: AppColors.slate),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
