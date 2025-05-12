import 'package:app/view/root/home/info/camera/camera.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class InfoScreen extends StatefulWidget {
  const InfoScreen({super.key});

  @override
  State<InfoScreen> createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  List<CameraDescription> cameras = [];
  CameraController? _cameraController;

  _cameraUI(BuildContext context) async {
    await _setupCameraController();

    Widget _buildUI() {
      if (_cameraController == null ||
          _cameraController?.value.isInitialized == false) {
        return const Center(child: CircularProgressIndicator());
      }

      return SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            CameraPreview(
              child: Container(
                margin: EdgeInsets.only(top: 50, left: 24),
                alignment: Alignment.topLeft,
                child: IconButton(
                  onPressed: () => context.pop(),
                  icon: Icon(Icons.close, size: 36, color: Colors.black),
                ),
              ),
              _cameraController!,
            ),
            Container(
              decoration: BoxDecoration(),
              child: IconButton(onPressed: () {}, icon: Icon(Icons.camera)),
            ),
          ],
        ),
      );
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => _buildUI(),
    );
  }

  _settingUI(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder:
          (context) => Padding(
            padding: EdgeInsets.only(top: 30, left: 24, right: 24, bottom: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  onPressed: () {
                    context.go('/login');
                  },
                  child: Text('Logout'),
                ),
              ],
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              _settingUI(context);
            },
            icon: Icon(Icons.settings_outlined),
          ),
        ],
      ),
      body: Column(
        children: [
          Center(
            child: GestureDetector(
              onTap: () {
                _cameraUI(context);
                // context.go('/root/info/camera');
              },
              child: Container(
                clipBehavior: Clip.hardEdge,
                margin: EdgeInsets.only(bottom: 20),
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 10,
                      offset: Offset(0, 4),
                      color: Colors.black12,
                    ),
                  ],
                  color: Colors.white,
                ),
                child: Image.network(
                  fit: BoxFit.cover,
                  'https://easydrawingart.com/wp-content/uploads/2019/08/How-to-draw-an-anime-face.jpg',
                ),
              ),
            ),
          ),

          Text(
            'Auos Thanawat',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          Text('thanawatauos@gmail.com'),
        ],
      ),
    );
  }

  Future<void> _setupCameraController() async {
    try {
      final _cameras = await availableCameras();

      if (_cameras.isNotEmpty) {
        _cameraController = CameraController(
          _cameras.first,
          ResolutionPreset.high,
        );

        await _cameraController!.initialize();
        if (mounted) {
          setState(() {});
        }
      }
    } catch (e) {
      debugPrint('Error initializing camera: $e');
    }
  }
}
