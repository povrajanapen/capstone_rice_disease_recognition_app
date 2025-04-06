# Rice Disease Recognition System 🌾📱

A mobile application designed to assist farmers in identifying rice diseases using AI and computer vision.

---

## Introduction

The Rice Disease Recognition System leverages deep learning techniques to analyze images of rice leaves and provide instant feedback on potential diseases, aiming to bridge the technological gap in the agricultural sector.

---

## Problem Statement

Traditional methods of identifying rice diseases are often time-consuming and require expert knowledge, which may not be readily accessible to all farmers, especially those in remote areas. This limitation can lead to delayed diagnoses and increased crop damage, ultimately affecting yield and income.

---

## Objectives

- Develop a user-friendly mobile application for rice disease detection.
- Implement an AI-based model to accurately identify various rice diseases from leaf images.
- Provide real-time feedback to farmers, enabling prompt action.
- Maintain a history of scans for user reference.
- Allow users to report unidentified diseases for expert analysis.

---

## Features

- Image Capture & Upload  
- AI-Based Disease Detection  
- Scan History  
- Unidentified Disease Reporting  
- Multi-language Support (English & Khmer)  
- Direct Call to Agricultural Experts  

---

## Technologies Used

- **Frontend**: Flutter  
- **Backend**: Firebase (Authentication)  
- **AI/Model Training**: TensorFlow, Keras  
- **Model Architectures**: EfficientNet-B0, DenseNet-121, MobileNetV2  

---

## System Architecture

The system comprises the following components:

1. **Mobile Application:** Built using Flutter, this app serves as the user interface, allowing farmers to capture or upload images of rice leaves, view diagnosis results, and access scan history.

2. **Backend Services:**
- **Firebase**: Manages user authentication and stores user data using Firebase Realtime Database.
- **Python**: Used for developing the machine learning inference pipeline and handling image preprocessing.
- **Flask**: Serves as the web framework to create an API endpoint for model inference, enabling communication between the mobile app and the AI model.

3. **AI Model:** A deep learning model trained using TensorFlow and Keras, capable of analyzing rice leaf images to detect diseases. The model employs ensemble learning, combining EfficientNet-B0, DenseNet-121, and MobileNetV2 architectures to improve accuracy.

---

## Future Enhancements

- Offline detection using on-device models (e.g., TensorFlow Lite)  
- Dashboard for tracking disease trends over time  
- Integration with agricultural support services  
- In-app tips and prevention guides for common rice diseases

---

## Installation and Usage

To run locally:

1. **Clone the repo**
   ```
   git clone https://github.com/povrajanapen/capstone_rice_disease_recognition_app.git
   cd capstone_rice_disease_recognition_app
   ```
2. **Install Dependencies**
   ```
   flutter pub get
   ```
4. **Run the app**
   ```
   flutter run
   ```
5. **Configure Firebase**
   - Set up your Firebase project
   - Add google-services.json (Android) or GoogleService-Info.plist (iOS) to the appropriate folder
   - Enable Firestore, Authentication, and Storage

---

## License

This project is developed for educational purposes and is not currently licensed for commercial use.
