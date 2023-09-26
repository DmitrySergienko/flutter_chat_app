import 'package:flutter/material.dart';

class ZoomableImageWidget extends StatefulWidget {
  final String? image;

  ZoomableImageWidget({Key? key, required this.image}) : super(key: key);

  @override
  _ZoomableImageWidgetState createState() => _ZoomableImageWidgetState();
}

class _ZoomableImageWidgetState extends State<ZoomableImageWidget> {
  double _scale = 1.0;
  double _previousScale = 1.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: GestureDetector(
        onScaleStart: (details) {
          setState(() {
            _previousScale = _scale;
          });
        },
        onScaleUpdate: (details) {
          setState(() {
            _scale = _previousScale * details.scale;
          });
        },
        onDoubleTap: () {
          setState(() {
            _scale = 1.0;
          });
        },
        child: Center(
          child: InteractiveViewer(
            minScale: 1.0,
            maxScale: 3.0, // You can adjust the max zoom level as needed.
            child: Image.network(
              widget.image!,
              fit: BoxFit.contain, // You can adjust the fit mode as needed.
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.error);
              },
            ),
          ),
        ),
      ),
    );
  }
}
