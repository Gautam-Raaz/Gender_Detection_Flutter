# 🧠 Gender Detection Flutter App (Offline)

This Flutter application performs **gender classification** (Male or Female) from images using a **TensorFlow Lite (TFLite)** model — completely offline with **no internet or API** required.

---

## 🚀 Features

- ✅ Gender detection from images
- 📶 Works **offline** — no network needed
- ⚡ Fast on-device inference using TFLite
- 🧠 Custom-trained deep learning model
- 📱 Simple, intuitive Flutter UI
- UTKFace dataset for training the model

---

## 🛠️ Tech Stack

| Component         | Technology           |
|------------------|----------------------|
| Frontend         | Flutter (Dart)       |
| Model Training   | Python + TensorFlow  |
| Model Deployment | TensorFlow Lite (TFLite) |
| Integration      | `tflite_flutter` package |

---

## 🧠 How It Works

1. **Model Training (Python)**  
   - A CNN (Convolutional Neural Network) is trained on a labeled dataset of faces.
   - The trained `.h5` model is then converted to `.tflite`.

2. **Model Integration (Flutter)**  
   - The `.tflite` model is bundled with the Flutter app.
   - Flutter’s `tflite_flutter` package loads and runs inference.
   - Gender prediction is displayed on-screen without internet.

---

## 📂 App Structure

```
assets/
└── model.tflite            # Offline gender detection model
```

---

## 📸 Sample Output

> Input: Image of a person  
> Output: `Predicted Gender: Female (Confidence: 93.1%)`

---

## 🔧 Setup Instructions

### 1. Prerequisites

- Flutter SDK (3.x recommended)
- Android Studio / Xcode
- Python (for training the model — optional)
- Mobile device or emulator

### 2. Clone the Repository

```bash
git clone https://github.com/your-username/gender_detection_flutter.git
cd gender-detection-flutter
```

### 3. Add Your TFLite Model

Place your `model.tflite` file in the `assets/` directory.

Update your `pubspec.yaml`:

```yaml
flutter:
  assets:
    - assets/model.tflite
```

### 4. Install Dependencies

```bash
flutter pub get
```

### 5. Run the App

```bash
flutter run
```

---

## 📦 Flutter Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  tflite_flutter: ^0.10.3
  image_picker: ^1.0.4
  path_provider: ^2.1.1
```

---

## 🧪 Model Training Summary (Python)

```python
# Load dataset and preprocess images
# Build and train a CNN model
# Convert to TFLite
import tensorflow as tf

converter = tf.lite.TFLiteConverter.from_keras_model(model)
tflite_model = converter.convert()
with open("model.tflite", "wb") as f:
    f.write(tflite_model)
```

---

## 📄 License

MIT License © 2025 [Gautam Raj]
