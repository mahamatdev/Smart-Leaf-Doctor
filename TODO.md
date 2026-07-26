# TODO: Integrate New AI Model for Crop Analysis

## Tasks
- [x] Add `status` field to DiseaseResult model
- [x] Modify AIService to use new model (best_float32.tflite and labels.txt)
- [x] Update parsing logic in AIService to extract crop_type, status, diagnosis, confidence
- [x] Update AnalysisResultScreen to display status and confidence in main card
- [x] Adjust border colors: green for healthy, red for diseased, yellow for unknown
- [x] Keep crop type and diagnosis in their respective cards
