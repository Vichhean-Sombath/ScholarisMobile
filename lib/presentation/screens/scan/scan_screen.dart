import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../providers/scan_provider.dart';

class ScanScreen extends ConsumerStatefulWidget {
  const ScanScreen({super.key});

  @override
  ConsumerState<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends ConsumerState<ScanScreen> {
  bool _hasPermission = false;
  bool _isCheckingPermission = true;

  @override
  void initState() {
    super.initState();
    _checkPermission();
  }

  Future<void> _checkPermission() async {
    final status = await Permission.camera.status;
    setState(() {
      _hasPermission = status.isGranted;
      _isCheckingPermission = false;
    });
  }

  Future<void> _requestPermission() async {
    final status = await Permission.camera.request();
    setState(() => _hasPermission = status.isGranted);
  }

  @override
  Widget build(BuildContext context) {
    final scanState = ref.watch(scanProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Scan QR')),
      body: scanState.when(
        scanning: () => _ScanningContent(
          hasPermission: _hasPermission,
          isCheckingPermission: _isCheckingPermission,
          onRequestPermission: _requestPermission,
          onDetect: (barcode) {
            final raw = barcode.barcodes.firstOrNull?.rawValue;
            if (raw != null) {
              ref.read(scanProvider.notifier).onQrDetected(raw);
            }
          },
        ),
        submitting: () => _ScanningContent(
          hasPermission: _hasPermission,
          isCheckingPermission: _isCheckingPermission,
          onRequestPermission: _requestPermission,
          onDetect: null,
          overlay: const _SubmittingOverlay(),
        ),
        success: (result) => _ResultDialog(
          title: 'Checked in!',
          message: 'Your attendance has been recorded as ${result.status}.',
          onDismiss: () => ref.read(scanProvider.notifier).resumeScanning(),
        ),
        error: (message) => _ResultDialog(
          title: 'Check-in failed',
          message: message,
          onDismiss: () => ref.read(scanProvider.notifier).resumeScanning(),
        ),
      ),
    );
  }
}

class _ScanningContent extends StatelessWidget {
  const _ScanningContent({
    required this.hasPermission,
    required this.isCheckingPermission,
    required this.onRequestPermission,
    this.onDetect,
    this.overlay,
  });

  final bool hasPermission;
  final bool isCheckingPermission;
  final VoidCallback onRequestPermission;
  final void Function(BarcodeCapture)? onDetect;
  final Widget? overlay;

  @override
  Widget build(BuildContext context) {
    if (isCheckingPermission) {
      return const Center(child: CircularProgressIndicator());
    }

    if (!hasPermission) {
      return _PermissionRequest(onRequestPermission: onRequestPermission);
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        MobileScanner(onDetect: onDetect),
        const _QrOverlay(),
        if (overlay != null) overlay!,
      ],
    );
  }
}

class _PermissionRequest extends StatelessWidget {
  const _PermissionRequest({required this.onRequestPermission});

  final VoidCallback onRequestPermission;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Camera permission is required to scan QR codes.',
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: onRequestPermission,
              child: const Text('Grant Permission'),
            ),
          ],
        ),
      ),
    );
  }
}

class _QrOverlay extends StatelessWidget {
  const _QrOverlay();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ShapeDecoration(
        shape: _ScannerOverlayShape(),
        color: Colors.black.withValues(alpha: 0.5),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 260,
              height: 260,
              child: CustomPaint(painter: _CornerBracketPainter()),
            ),
            const SizedBox(height: 24),
            Text(
              'Align the QR code inside the frame',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _ScannerOverlayShape extends ShapeBorder {
  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.zero;

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    final scanArea = Rect.fromCenter(
      center: rect.center,
      width: 260,
      height: 260,
    );
    return Path()
      ..addRect(rect)
      ..addRRect(
        RRect.fromRectAndRadius(scanArea, const Radius.circular(16)),
      )
      ..fillType = PathFillType.evenOdd;
  }

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) => Path();

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {}

  @override
  ShapeBorder scale(double t) => this;
}

class _CornerBracketPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    const length = 40.0;
    const radius = 12.0;

    final topLeft = Path()
      ..moveTo(0, radius)
      ..lineTo(0, 0)
      ..lineTo(length, 0);
    canvas.drawPath(topLeft, paint);

    final topRight = Path()
      ..moveTo(size.width - length, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, radius);
    canvas.drawPath(topRight, paint);

    final bottomLeft = Path()
      ..moveTo(0, size.height - radius)
      ..lineTo(0, size.height)
      ..lineTo(length, size.height);
    canvas.drawPath(bottomLeft, paint);

    final bottomRight = Path()
      ..moveTo(size.width - length, size.height)
      ..lineTo(size.width, size.height)
      ..lineTo(size.width, size.height - radius);
    canvas.drawPath(bottomRight, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _SubmittingOverlay extends StatelessWidget {
  const _SubmittingOverlay();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withValues(alpha: 0.7),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Colors.white),
            SizedBox(height: 12),
            Text('Checking you in…', style: TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }
}

class _ResultDialog extends StatelessWidget {
  const _ResultDialog({
    required this.title,
    required this.message,
    required this.onDismiss,
  });

  final String title;
  final String message;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          FilledButton(
            onPressed: onDismiss,
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
