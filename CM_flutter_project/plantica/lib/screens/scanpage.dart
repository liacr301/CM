import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'plantinfopage.dart';
import 'package:plantica/bloc/scan/scan_bloc.dart';
import 'package:plantica/bloc/scan/scan_state.dart';
import 'package:plantica/bloc/scan/scan_event.dart'; 
import 'package:plantica/database.dart';
import 'package:image_picker/image_picker.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:io';

class ScanPage extends StatelessWidget {
  const ScanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ScanBloc(
        database: context.read<AppDatabase>(),
      )..add(InitializeScan()),
      child: const ScanView(),
    );
  }
}

class ScanView extends StatelessWidget {
  const ScanView({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: const Color(0xFFF3F4F6),
        body: Center(
          child: SingleChildScrollView(
            child: BlocConsumer<ScanBloc, ScanState>(
              listener: (context, state) {
                if (state is ScanError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.message)),
                  );
                }
              },
              builder: (context, state) {
                return _buildContent(context, state);
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, ScanState state) {
    if (state is ScanOffline) {
      return _buildOfflineContent(context);
    } else if (state is Loading) {
      return const CircularProgressIndicator();
    } else if (state is ImagePickerDisplayed) {
      return _buildImagePickerDialog(context);
    } else if (state is PlantIdentified) {
      return ScanResultView(
        image: state.image,
        plantName: state.plantName,
        plantId: state.plantId,
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildOfflineContent(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.wifi_off, size: 100, color: Colors.red),
        const SizedBox(height: 20),
        const Text(
          'No internet connection',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        const Text(
          'Please check your connection and try again.',
          style: TextStyle(fontSize: 16),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            context.read<ScanBloc>().add(CheckConnectivity());
          },
          child: const Text('Try Again'),
        ),
      ],
    );
  }

  Widget _buildImagePickerDialog(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Choose image source'),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.camera_alt),
              label: const Text('Camera'),
              onPressed: () {
                context.read<ScanBloc>().add(PickImage(ImageSource.camera));
              },
            ),
            const SizedBox(width: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.photo_library),
              label: const Text('Gallery'),
              onPressed: () {
                context.read<ScanBloc>().add(PickImage(ImageSource.gallery));
              },
            ),
          ],
        ),
      ],
    );
  }
}

class ScanResultView extends StatelessWidget {
  final File image;
  final String plantName;
  final int plantId;

  const ScanResultView({
    required this.image,
    required this.plantName,
    required this.plantId,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(100)),
            image: DecorationImage(
              image: FileImage(image),
              fit: BoxFit.cover,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'Your plant is a',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Text(
          plantName,
          style: const TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 139, 96, 133),
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[300],
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onPressed: () {
                context.read<ScanBloc>().add(ResetScan());
              },
              child: const Text('Try Again'),
            ),
            const SizedBox(width: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[100],
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Plantinfopage(plantId: plantId),
                  ),
                );
              },
              child: const Text('Add Plant'),
            ),
          ],
        ),
      ],
    );
  }
}