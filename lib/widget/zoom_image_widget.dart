import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';

class ZoomableImageWidget extends StatefulWidget {
  final String? image;

  const ZoomableImageWidget({Key? key, required this.image}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ZoomableImageWidgetState createState() => _ZoomableImageWidgetState();
}

class _ZoomableImageWidgetState extends State<ZoomableImageWidget> {
  double _scale = 1.0;
  double _previousScale = 1.0;

  Future<void> _downloadImage() async {
    try {
      // Check storage permission
      if (await Permission.storage.request().isDenied) {
        Dio dio = Dio();
        var response = await dio.get(widget.image!,
            options: Options(responseType: ResponseType.bytes));

        final result = await ImageGallerySaver.saveImage(
          Uint8List.fromList(response.data),
          quality: 100,
          name: "downloaded_image",
        );

        if (result["isSuccess"]) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Image saved to gallery!')),
          );
        } else {
          throw Exception('Error saving image to gallery');
        }
      } else {
        throw Exception('Storage permission not granted');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.download,
              color: Colors.white,
            ),
            onPressed: _downloadImage,
          )
        ],
      ),
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
            maxScale: 3.0,
            child: Image.network(
              widget.image!,
              fit: BoxFit.contain,
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
