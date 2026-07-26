![Flutter](https://img.shields.io/badge/Flutter-3.0-blue)
![TensorFlow Lite](https://img.shields.io/badge/TensorFlow-Lite-orange)
![License](https://img.shields.io/badge/License-Educational-lightgrey)
![GitHub stars](https://img.shields.io/github/stars/mahamatdev/Smart-Leaf-Doctor?style=social)


# 🌿 Smart Leaf Doctor

An AI-powered mobile application for detecting crop leaf diseases using Machine Learning.

## 📱 Overview

Smart Leaf Doctor is a Flutter-based mobile application that helps farmers detect diseases affecting crop leaves by simply taking or uploading a photo. The application uses a trained Convolutional Neural Network (CNN) model to classify healthy and diseased leaves and provides instant diagnosis, confidence scores, symptoms, treatment recommendations, and voice assistance.

The project aims to improve early disease detection, reduce crop losses, and support precision agriculture through artificial intelligence.

---

## 🎯 Project Objectives

- Detect crop leaf diseases using Machine Learning.
- Support early disease diagnosis.
- Reduce dependence on manual inspection.
- Provide instant disease analysis.
- Improve agricultural productivity.
- Offer an easy-to-use mobile application for farmers.

---

## 🌾 Supported Crops

Currently the application supports:

- 🌽 Maize
- 🌿 Cassava

Additional crops can easily be added in future versions.

---

## 🧠 Artificial Intelligence

The application uses a **Convolutional Neural Network (CNN)** trained on labeled crop leaf images.

The CNN automatically learns important visual features including:

- Leaf color
- Texture
- Disease spots
- Shape abnormalities

The trained model is converted into **TensorFlow Lite (.tflite)** format and integrated into the Flutter application for fast offline prediction.

---

## ✨ Features

- 📷 Capture leaf image
- 🖼 Upload image from gallery
- 🤖 AI-powered disease detection
- 📊 Confidence percentage
- 🌱 Crop identification
- 🦠 Disease diagnosis
- 📋 Symptoms description
- 💊 Treatment recommendations
- 🔊 Voice Assistant (Text-to-Speech)
- 💡 Smart recommendations
- 💾 Save diagnosis
- 📤 Share analysis result
- 🕘 Diagnosis history
- 📱 Modern Material Design interface
- 🌍 Multi-language support
  - English
  - Kinyarwanda
  - French
  - Arabic
- ⚡ Offline AI prediction

---

## 🏗 Technology Stack

### Mobile Development

- Flutter
- Dart

### Machine Learning

- Python
- TensorFlow
- TensorFlow Lite
- CNN (Convolutional Neural Network)

### Development Tools

- Android Studio
- Visual Studio Code
- Git
- GitHub

---

## 📂 Project Structure

```
lib/
│
├── models/
├── screens/
├── services/
├── widgets/
├── utils/
└── assets/
```

---

## 🔄 Application Workflow

1. Open the application.
2. Capture a leaf image or select one from the gallery.
3. The image is preprocessed.
4. The CNN model analyzes the image.
5. The disease is identified.
6. The application displays:
   - Crop type
   - Disease name
   - Confidence score
   - Symptoms
   - Treatment recommendation
7. The user can:
   - Listen to the diagnosis
   - Save the result
   - Share the report
   - View previous diagnoses

---

# 📸 Screenshots

Here are some views of the Smart Leaf Doctor application:

<p align="center">
  <img src="images/1.jpeg" width="200" alt="Home Screen"/>
  <img src="images/2.jpeg" width="200"  alt="Scan or Upload Leaf"/>
  <img src="images/3.jpeg" width="200" alt="Best Practices"/>
  <img src="images/4.jpeg" width="200" alt="Settings"/>
</p>

<p align="center">
  <img src="images/5.jpeg" width="200" alt="Analysis Result (healthy)"/>
  <img src="images/6.jpeg" width="200" alt="Analysis Result (diseased)"/>
  <img src="images/7.jpeg" width="200" alt="History"/>
</p>

---

## 🤝 Contributing
Contributions are welcome!  
- Fork the repository  
- Create a new branch (`git checkout -b feature-branch`)  
- Make your changes  
- Commit (`git commit -m "Add new feature"`)  
- Push (`git push origin feature-branch`)  
- Open a Pull Request

---

## 🚀 Future Improvements

- More crop support
- Cloud synchronization
- Farmer accounts
- GPS farm location
- Offline multilingual voice assistant
- Disease severity estimation
- Automatic pesticide recommendations
- Agricultural expert consultation
- Weather-based disease prediction

---

## 👨‍💻 Developer

**Mahamat Ali Abderaman**

Bachelor of Information Technology

University of Kigali

---

## 📄 License

Creative Commons Attribution-NonCommercial 4.0 International (CC BY-NC 4.0)

This project is licensed under the Creative Commons Attribution-NonCommercial 4.0 International License.

You are free to:
- Share — copy and redistribute the material in any medium or format
- Adapt — remix, transform, and build upon the material

Under the following terms:
- Attribution — You must give appropriate credit, provide a link to the license, and indicate if changes were made.
- NonCommercial — You may not use the material for commercial purposes.

No additional restrictions — You may not apply legal terms or technological measures that legally restrict others from doing anything the license permits.

Full license text: https://creativecommons.org/licenses/by-nc/4.0/

---

## ⭐ Support

If you find this project useful, consider giving it a ⭐ on GitHub.
