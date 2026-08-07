# 🌾 FasalGuru

**Offline-First Smart Crop & Irrigation Advisory System**

FasalGuru is a Flutter-based Android application that helps farmers make informed crop and irrigation decisions by combining a trained Machine Learning model with a science-based rule engine — designed to work reliably even in areas with poor internet connectivity.

---

## 📌 Problem Statement

Most farmers can access weather forecasts, but forecasts alone don't answer the questions that matter:
- Which crop should I grow given my soil and climate?
- Should I irrigate today, or will rain make it unnecessary?

FasalGuru bridges this gap by converting raw weather and soil data into direct, actionable recommendations.

---

## ✨ Features

- 🌱 **Crop Recommendation** — ML-powered suggestion from 8 region-relevant crops (Rice, Wheat, Maize, Chickpea, Lentil, Mustard, Mungbean, Sugarcane)
- 💧 **Irrigation Advisory** — Science-based Yes/No irrigation guidance using the FAO-56 crop water balance method
- 📡 **Offline-First** — Weather data cached locally; core recommendations work without an active internet connection
- 📍 **Location-Aware** — Auto-detects farmer's location for accurate, hyperlocal weather data
- 🌐 **Bilingual** — Full Hindi/English localization
- 📊 **History Tracking** — Past recommendations stored locally for reference

---

## 🧠 Machine Learning

| Detail | Value |
|---|---|
| Problem Type | Multi-class Classification (22 crops, filtered to 8 region-relevant) |
| Algorithm | Random Forest Classifier (compared against Logistic Regression & Decision Tree) |
| Dataset | [Crop Recommendation Dataset](https://www.kaggle.com/datasets/atharvaingle/crop-recommendation-dataset) (Kaggle) — 2,200 records |
| Features | Nitrogen, Phosphorus, Potassium, Temperature, Humidity, pH, Rainfall |
| Test Accuracy | 99.55% (5-fold cross-validated, hyperparameter tuned) |
| Mobile Deployment | Converted to TensorFlow Lite via an equivalent Keras Neural Network (99.32% accuracy) for on-device inference |

**Note on accuracy:** This dataset's classes are cleanly separable, which explains the high accuracy — a known, published characteristic of this benchmark dataset, not an artifact of overfitting (confirmed via cross-validation).

---

## 💧 Irrigation Rule Engine (Not ML — By Design)

No public dataset (Kaggle or Government of India) provides real-world irrigation ground-truth labels. Rather than fabricate labels for a supervised classifier, irrigation decisions are computed using the **FAO-56 Crop Water Balance method** — a peer-reviewed agronomic standard (Allen et al., 1998):

```
ET0 (Reference Evapotranspiration) → via Hargreaves equation
ETc (Crop Water Need) = ET0 × Kc (FAO crop coefficient)
Water Balance = Rainfall − ETc
Decision = Irrigate if Water Balance < threshold
```

This is a deliberate, disclosed engineering decision — a defensible alternative to an unsupported ML claim.

---

## 📊 Data Sources

| Source | Used For |
|---|---|
| [NASA POWER API](https://power.larc.nasa.gov/) | Live & historical weather data (temperature, humidity, rainfall) — free, no API key required |
| [Kaggle — Crop Recommendation Dataset](https://www.kaggle.com/datasets/atharvaingle/crop-recommendation-dataset) | ML model training |
| [data.gov.in](https://www.data.gov.in/) — Ministry of Agriculture & Farmers Welfare | Crop production statistics (contextual reference) |
| FAO-56 Published Tables | Crop coefficients (Kc) for irrigation calculation |

---

## 🏗️ Tech Stack

**Frontend:** Flutter (Dart), MVVM Architecture
**Machine Learning:** Python, Scikit-learn, TensorFlow/Keras, TensorFlow Lite
**Local Storage:** Room Database (offline weather & history cache)
**APIs:** NASA POWER (weather), Gemini API (natural-language explanations, online-only)
**State Management:** Provider

---

## 📁 Project Structure

```
FasalGuru/
├── ml_pipeline/
│   ├── data/                          # Datasets
│   ├── notebooks/                     # Training scripts
│   └── models/                        # Trained .pkl / .tflite models
├── rule_engine/
│   ├── et0_calculator.py              # FAO-56 ET0 formula
│   ├── fao_kc_tables.py               # Crop coefficient reference
│   ├── irrigation_logic.py            # Water balance decision engine
│   └── soil_data.py                   # Regional soil defaults
├── lib/                                # Flutter app source
│   ├── models/
│   ├── repository/
│   ├── viewmodel/
│   └── view/
└── README.md
```

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (≥3.0)
- Python 3.10+ (for ML pipeline)

### ML Pipeline
```bash
pip install pandas scikit-learn tensorflow
python ml_pipeline/notebooks/train_crop_model.py
```

### Flutter App
```bash
flutter pub get
flutter run
```

---

## ⚠️ Honest Scope & Limitations

- Currently supports **2 districts** (Lucknow, Sitapur) and **8 crops** — deliberately scoped for accuracy over breadth
- Irrigation advice is formula-derived, not learned from real farmer behavior data (no such public dataset exists)
- Soil nutrient values default to district-level estimates when the farmer doesn't provide a Soil Health Card reading — clearly disclosed in-app as an estimate, not a live reading
- Designed and validated as a technical portfolio project; broader real-world farmer adoption would require on-ground distribution partnerships beyond the scope of this build

---

## 👤 Author

**Vikas Chandra Yadav**
B.Tech CSE (AI & ML), RR Group of Institutions, AKTU University, Lucknow

---

## 📄 License

This project is for academic/portfolio purposes. Datasets used retain their original licenses (see Data Sources above).
