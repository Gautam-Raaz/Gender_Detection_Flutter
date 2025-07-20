// // import 'dart:io';
// // import 'dart:typed_data';
// // import 'package:flutter/material.dart';
// // import 'package:image_picker/image_picker.dart';
// // import 'package:tensorflow_lite_flutter/tensorflow_lite_flutter.dart';
// // import 'package:flutter/services.dart' show rootBundle;
// // import 'dart:ui' as ui;
// // import 'package:image/image.dart' as img;

// // void main() {
// //   runApp(const MyApp());
// // }

// // class MyApp extends StatelessWidget {
// //   const MyApp({super.key});

// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       title: 'TFLite Demo',
// //       theme: ThemeData(
// //         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
// //         useMaterial3: true,
// //       ),
// //       home: const TFLiteHomePage(title: 'Image Classifier'),
// //     );
// //   }
// // }

// // class TFLiteHomePage extends StatefulWidget {
// //   const TFLiteHomePage({super.key, required this.title});
// //   final String title;

// //   @override
// //   State<TFLiteHomePage> createState() => _TFLiteHomePageState();
// // }

// // class _TFLiteHomePageState extends State<TFLiteHomePage> {
// //   String result = "Select an image";
// //   File? _image;
// //   final picker = ImagePicker();

// //   Future<void> loadModel() async {
// //     try {
// //       String? res = await Tflite.loadModel(
// //         model: "assets/model.tflite",
// //         labels: "assets/label.txt",
// //         numThreads: 2,
// //         isAsset: true,
// //         useGpuDelegate: false,
// //       );
// //       print("Model loaded: $res");
// //     } catch (e) {
// //       print("Failed to load model: $e");
// //     }
// //   }

// //   @override
// //   void initState() {
// //     super.initState();
// //     loadModel();
// //   }

// //   Future<void> pickImage() async {
// //     final pickedFile = await picker.pickImage(source: ImageSource.gallery);
// //     if (pickedFile == null) return;

// //     setState(() {
// //       _image = File(pickedFile.path);
// //     });

// //     classifyImage(_image!);
// //   }

// //   Future<void> classifyImage(File image) async {
// //     var imageBytes = await image.readAsBytes();

// //     // Decode and resize
// //     img.Image? oriImage = img.decodeImage(imageBytes);
// //     img.Image resizedImage = img.copyResize(oriImage!, width: 224, height: 224);

// //     // Normalize to [0, 1] and convert to Float32
// //     List input = List.generate(224, (y) {
// //       return List.generate(224, (x) {
// //         final pixel = resizedImage.getPixel(x, y);
// //         return [
// //           (img.getRed(pixel) / 255.0),
// //           (img.getGreen(pixel) / 255.0),
// //           (img.getBlue(pixel) / 255.0),
// //         ];
// //       });
// //     });

// //     var recognitions = await Tflite.runModelOnBinary(
// //       binary: _convertToByteList(input),
// //       numResults: 1,
// //       threshold: 0.5,
// //     );

// //     print("Result: $recognitions");
// //     setState(() {
// //       result = recognitions?.first['label'] ?? "No result";
// //     });
// //   }

// //  Uint8List _convertToByteList(List input) {
// //   // expand and flatten, then cast to List<double>
// //   final List<double> flattened = input
// //       .expand((row) => row)
// //       .expand((pixel) => pixel)
// //       .map((e) => e as double)        // ensure each is a double
// //       .toList();

// //   final buffer = Float32List.fromList(flattened).buffer;
// //   return buffer.asUint8List();
// // }


// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(title: Text(widget.title)),
// //       body: Column(
// //         mainAxisAlignment: MainAxisAlignment.center,
// //         children: [
// //           if (_image != null)
// //             Image.file(_image!, height: 200),
// //           const SizedBox(height: 20),
// //           Text(result, style: const TextStyle(fontSize: 18)),
// //           const SizedBox(height: 20),
// //           ElevatedButton(
// //             onPressed: pickImage,
// //             child: const Text("Pick Image"),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }


// // ignore_for_file: use_build_context_synchronously

// import 'dart:io';
// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:image/image.dart' as img;
// import 'package:flutter/services.dart';
// import 'package:tflite_flutter/tflite_flutter.dart';


// void main() => runApp(const MyApp());

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       home: TFLiteHomePage(),
//     );
//   }
// }

// class TFLiteHomePage extends StatefulWidget {
//   const TFLiteHomePage({super.key});

//   @override
//   State<TFLiteHomePage> createState() => _TFLiteHomePageState();
// }

// class _TFLiteHomePageState extends State<TFLiteHomePage> {
//   File? _image;
//   Interpreter? _interpreter;
//   List<String> _labels = [];
//   String _result = "";

//   @override
//   void initState() {
//     super.initState();
//     loadModel();
//   }

//   Future<void> loadModel() async {
//     try {
//       final modelData = await rootBundle.load('assets/model.tflite');
//       final interpreter = Interpreter.fromBuffer(
//         modelData.buffer,
//         options: InterpreterOptions()..threads = 2,
//       );

//       final labelsData = await rootBundle.loadString('assets/labels.txt');
//       _labels = labelsData.split('\n');

//       setState(() {
//         _interpreter = interpreter;
//       });

//       print('Model and labels loaded');
//     } catch (e) {
//       print('Error loading model: $e');
//     }
//   }

//   Future<void> pickImage() async {
//     final picker = ImagePicker();
//     final picked = await picker.pickImage(source: ImageSource.gallery);
//     if (picked == null) return;
//     final image = File(picked.path);
//     setState(() {
//       _image = image;
//     });
//     classifyImage(image);
//   }

//   Future<void> classifyImage(File imageFile) async {
//     if (_interpreter == null) return;

//     final imageBytes = await imageFile.readAsBytes();
//     final oriImage = img.decodeImage(imageBytes);
//     if (oriImage == null) return;

//     final resized = img.copyResize(oriImage, width: 224, height: 224);

//     final input = List.generate(224, (y) => List.generate(224, (x) {
//           final pixel = resized.getPixel(x, y);
//           return [
//             img.getRed(pixel) / 255.0,
//             img.getGreen(pixel) / 255.0,
//             img.getBlue(pixel) / 255.0,
//           ];
//         }));

//     final inputTensor = [input]; // shape: [1, 224, 224, 3]

//     final outputSize = _labels.length;
//     final output = List.filled(outputSize, 0.0).reshape([1, outputSize]);

//     _interpreter!.run(inputTensor, output);

//     final predictions = output[0] as List<double>;
//     final maxIndex = predictions.indexWhere((score) => score == predictions.reduce((a, b) => a > b ? a : b));
//     final label = _labels[maxIndex];
//     final confidence = predictions[maxIndex];

//     setState(() {
//       _result = "Prediction: $label\nConfidence: ${(confidence * 100).toStringAsFixed(2)}%";
//     });
//   }

//   @override
//   void dispose() {
//     _interpreter?.close();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("TFLite Gender Detection")),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             _image != null
//                 ? Image.file(_image!, height: 200)
//                 : const Placeholder(fallbackHeight: 200),
//             const SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: pickImage,
//               child: const Text("Pick Image"),
//             ),
//             const SizedBox(height: 16),
//             Text(
//               _result,
//               style: const TextStyle(fontSize: 18),
//               textAlign: TextAlign.center,
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }


// import 'dart:io';
// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:tflite_flutter/tflite_flutter.dart';
// import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';
// import 'package:image/image.dart' as img;

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Gender Classifier',
//       theme: ThemeData(
//         useMaterial3: true,
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//       ),
//       home: const ClassifierHomePage(),
//     );
//   }
// }

// class ClassifierHomePage extends StatefulWidget {
//   const ClassifierHomePage({super.key});

//   @override
//   State<ClassifierHomePage> createState() => _ClassifierHomePageState();
// }

// class _ClassifierHomePageState extends State<ClassifierHomePage> {
//   late Interpreter interpreter;
//   late List<String> labels;
//   final picker = ImagePicker();
//   File? _image;
//   String _result = 'Select an image';

//   @override
//   void initState() {
//     super.initState();
//     loadModel();
//   }

//   Future<void> loadModel() async {
//     interpreter = await Interpreter.fromAsset('model.tflite');
//     final labelsData = await File('assets/labels.txt').readAsLines();
//     labels = labelsData.map((e) => e.trim()).toList();
//     print('Model loaded.');
//   }

//   Future<void> pickImage() async {
//     final picked = await picker.pickImage(source: ImageSource.gallery);
//     if (picked == null) return;

//     setState(() {
//       _image = File(picked.path);
//       _result = 'Processing...';
//     });

//     classifyImage(_image!);
//   }

//   Future<void> classifyImage(File imageFile) async {
//     // Load and resize image
//     final rawBytes = await imageFile.readAsBytes();
//     img.Image? oriImage = img.decodeImage(rawBytes);
//     img.Image resizedImage = img.copyResize(oriImage!, width: 224, height: 224);

//     // Convert to TensorImage
//     final inputImage = TensorImage.fromImage(resizedImage);
//     final normalized = ImageProcessorBuilder()
//         .add(ResizeOp(224, 224, ResizeMethod.NEAREST_NEIGHBOUR))
//         .add(NormalizeOp(0, 255)) // scale [0,255] → [0,1]
//         .build()
//         .process(inputImage);

//     // Create input and output tensor buffers
//     final inputBuffer = normalized.buffer;

//     TensorBuffer outputBuffer = TensorBuffer.createFixedSize([1, labels.length], TfLiteType.float32);

//     interpreter.run(
//        tensorImage.buffer.asFloat32List(),  // ✅ Convert to Float32List
//        outputBuffer.buffer.asFloat32List(), // ✅ Same here
//      );
 
//     // Get result
//     TensorLabel labelProb = TensorLabel.fromList(labels, outputBuffer);
//     final prediction = labelProb.getMapWithFloatValue();
//     final sorted = prediction.entries.toList()
//       ..sort((a, b) => b.value.compareTo(a.value));
//     final topResult = sorted.first;

//     setState(() {
//       _result = "${topResult.key} : ${(topResult.value * 100).toStringAsFixed(2)}%";
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Gender Classifier")),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             _image != null
//                 ? Image.file(_image!, height: 200)
//                 : const Icon(Icons.image, size: 100),
//             const SizedBox(height: 20),
//             Text(_result, style: const TextStyle(fontSize: 18)),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: pickImage,
//               child: const Text("Pick Image"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

void main() => runApp(const MaterialApp(home: GenderClassifier()));

class GenderClassifier extends StatefulWidget {
  const GenderClassifier({super.key});

  @override
  State<GenderClassifier> createState() => _GenderClassifierState();
}

class _GenderClassifierState extends State<GenderClassifier> {
  late Interpreter interpreter;
  final picker = ImagePicker();
  File? _image;
  String _result = "Pick an image to predict";

  @override
  void initState() {
    super.initState();
    loadModel();
  }

  Future<void> loadModel() async {
    interpreter = await Interpreter.fromAsset("assets/gender.tflite");
    print("✅ Model loaded");
  }

  Future<void> pickImage() async {
    final picked = await picker.pickImage(source: ImageSource.camera);
    if (picked == null) return;

    setState(() => _image = File(picked.path));
    predictGender(_image!);
  }

  Future<void> predictGender(File imageFile) async {
    // 1. Decode image
    final imageBytes = await imageFile.readAsBytes();
    img.Image? image = img.decodeImage(imageBytes);
    if (image == null) return;

    // 2. Resize to 64x64
    img.Image resized = img.copyResize(image, width: 64, height: 64);

    // 3. Normalize pixels to float32 [0, 1]
    var input = List.generate(1, (_) => List.generate(64, (y) =>
        List.generate(64, (x) {
          final pixel = resized.getPixel(x, y);
          return [
            img.getRed(pixel) / 255.0,
            img.getGreen(pixel) / 255.0,
            img.getBlue(pixel) / 255.0
          ];
        })
    ));

    // 4. Create output buffer
    var output = List.filled(1 * 1, 0.0).reshape([1, 1]);

    // 5. Run model
    interpreter.run(input, output);

    // 6. Get prediction
    double confidence = output[0][0];
    String gender = confidence < 0.5 ? "Male" : "Female";

    setState(() {
      _result = "Prediction: $gender\nConfidence: ${(confidence * 100).toStringAsFixed(2)}%";
    });
  }

  @override
  void dispose() {
    interpreter.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Gender Classifier")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _image != null
                ? Image.file(_image!, height: 200)
                : const Placeholder(fallbackHeight: 200),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: pickImage, child: const Text("Pick Image")),
            const SizedBox(height: 20),
            Text(_result, textAlign: TextAlign.center, style: const TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
