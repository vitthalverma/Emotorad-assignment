import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class ScratchCardWidget extends StatefulWidget {
  final VoidCallback onScratchComplete;

  const ScratchCardWidget({super.key, required this.onScratchComplete});

  @override
  _ScratchCardWidgetState createState() => _ScratchCardWidgetState();
}

class _ScratchCardWidgetState extends State<ScratchCardWidget> {
  // List of points that the user has “scratched” (touched).
  final List<Offset> _points = [];
  // Whether the reward has been revealed.
  bool _revealed = false;

  static const int scratchThreshold = 50;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        // Add the local position (relative to the widget) to the list.
        RenderBox box = context.findRenderObject() as RenderBox;
        setState(() {
          _points.add(box.globalToLocal(details.globalPosition));
          if (_points.length > scratchThreshold && !_revealed) {
            _revealed = true;
            // Notify parent that scratch is complete.
            widget.onScratchComplete();
          }
        });
      },
      onPanEnd: (details) {
        _points.add(Offset.infinite); // Indicates the end of a stroke.
      },
      child: CustomPaint(
        size: const Size(300, 200),
        painter: ScratchCardPainter(points: _points),
        child: Container(
          width: 300,
          height: 200,
          alignment: Alignment.center,
          // The “reward” text shown underneath the scratch layer.
          child: const Text(
            'Scratch to Earn Coins!',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

/// The custom painter that draws an opaque overlay and “erases” parts based on user touches.
class ScratchCardPainter extends CustomPainter {
  final List<Offset> points;
  final Paint _paint = Paint()
    ..color = Colors.grey
    ..style = PaintingStyle.fill;

  ScratchCardPainter({required this.points});

  @override
  void paint(Canvas canvas, Size size) {
    // First, draw the opaque overlay.
    canvas.drawRect(Offset.zero & size, _paint);

    // Then “erase” parts of the overlay by drawing clear circles.
    final erasePaint = Paint()
      ..blendMode = ui.BlendMode.clear
      ..style = PaintingStyle.fill;

    for (final point in points) {
      // Skip markers (e.g., Offset.infinite).
      if (point == Offset.infinite) continue;
      canvas.drawCircle(point, 20, erasePaint);
    }
  }

  @override
  bool shouldRepaint(covariant ScratchCardPainter oldDelegate) => true;
}
