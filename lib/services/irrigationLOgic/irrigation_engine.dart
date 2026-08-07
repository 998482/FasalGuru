

class CropProfile {
  final String name;
  // Stage lengths in days: [initial, development, mid, late]
  final List<int> stageDays;
  // Kc values: [Kc_ini, Kc_mid, Kc_end]
  final List<double> kc;
  // Max root depth in meters (root grows from 0.2m -> maxRootDepth during dev+mid)
  final double maxRootDepth;
  // Depletion fraction p (FAO-56 Table 22, no-stress threshold)
  final double p;

  const CropProfile({
    required this.name,
    required this.stageDays,
    required this.kc,
    required this.maxRootDepth,
    required this.p,
  });

  int get totalDays => stageDays.reduce((a, b) => a + b);
}

/// FAO-56 standard values (Allen et al. 1998). Local calibration ke hisaab se
/// baad me adjust kar sakte ho — abhi ye safe defaults hain.
final Map<String, CropProfile> cropStages = {
  'wheat': const CropProfile(
    name: 'wheat',
    stageDays: [15, 25, 50, 30],
    kc: [0.4, 1.15, 0.4],
    maxRootDepth: 1.5,
    p: 0.55,
  ),
  'maize': const CropProfile(
    name: 'maize',
    stageDays: [30, 40, 50, 30],
    kc: [0.3, 1.2, 0.35],
    maxRootDepth: 1.5,
    p: 0.55,
  ),
  'chickpea': const CropProfile(
    name: 'chickpea',
    stageDays: [20, 30, 35, 15],
    kc: [0.4, 1.15, 0.35],
    maxRootDepth: 0.8,
    p: 0.50,
  ),
  'lentil': const CropProfile(
    name: 'lentil',
    stageDays: [20, 30, 60, 40],
    kc: [0.4, 1.1, 0.3],
    maxRootDepth: 0.7,
    p: 0.50,
  ),
  'mustard': const CropProfile(
    name: 'mustard',
    stageDays: [25, 35, 45, 25],
    kc: [0.35, 1.15, 0.35],
    maxRootDepth: 1.0,
    p: 0.60,
  ),
  'mungbean': const CropProfile(
    name: 'mungbean',
    stageDays: [20, 30, 30, 10],
    kc: [0.4, 1.05, 0.6],
    maxRootDepth: 0.6,
    p: 0.45,
  ),
  'sugarcane': const CropProfile(
    name: 'sugarcane',
    stageDays: [35, 60, 190, 120],
    kc: [0.4, 1.25, 0.75],
    maxRootDepth: 1.8,
    p: 0.65,
  ),
};

/// Default soil water-holding capacity (FC - WP) by texture, mm water per mm soil depth.
/// Farmer ke Soil Health Card se texture aayega; na mile to loam default use karo.
double soilWaterHoldingCapacity(String soilTexture) {
  switch (soilTexture.toLowerCase()) {
    case 'sandy':
      return 0.09;
    case 'sandy_loam':
      return 0.11;
    case 'loam':
      return 0.14;
    case 'clay_loam':
      return 0.17;
    case 'clay':
      return 0.19;
    default:
      return 0.14; // loam fallback
  }
}

/// 1. Stage lookup — daysSinceSowing se pata karo abhi konsa stage hai
/// Returns stage index: 0=initial, 1=development, 2=mid, 3=late
int getStageIndex(CropProfile crop, int daysSinceSowing) {
  int cumulative = 0;
  for (int i = 0; i < crop.stageDays.length; i++) {
    cumulative += crop.stageDays[i];
    if (daysSinceSowing <= cumulative) return i;
  }
  return crop.stageDays.length - 1; // harvest ke baad bhi late stage treat karo
}

/// 2. Kc lookup with linear interpolation between stages (matches FAO-56 practice)
double getKc(CropProfile crop, int daysSinceSowing) {
  final d = crop.stageDays;
  final k = crop.kc;
  final iniEnd = d[0];
  final devEnd = d[0] + d[1];
  final midEnd = d[0] + d[1] + d[2];
  final lateEnd = crop.totalDays;

  if (daysSinceSowing <= iniEnd) return k[0];
  if (daysSinceSowing <= devEnd) {
    final frac = (daysSinceSowing - iniEnd) / d[1];
    return k[0] + frac * (k[1] - k[0]);
  }
  if (daysSinceSowing <= midEnd) return k[1];
  if (daysSinceSowing <= lateEnd) {
    final frac = (daysSinceSowing - midEnd) / d[3];
    return k[1] + frac * (k[2] - k[1]);
  }
  return k[2]; // harvest ke baad
}

/// 3. Root depth grows from 0.2m -> maxRootDepth during dev+mid, then holds
double getRootDepth(CropProfile crop, int daysSinceSowing) {
  const double startDepth = 0.2;
  final d = crop.stageDays;
  final growthEnd = d[0] + d[1] + d[2]; // root maturity by end of mid stage
  if (daysSinceSowing <= d[0]) return startDepth;
  if (daysSinceSowing >= growthEnd) return crop.maxRootDepth;
  final frac = (daysSinceSowing - d[0]) / (growthEnd - d[0]);
  return startDepth + frac * (crop.maxRootDepth - startDepth);
}

/// 4. ETc = Kc * ET0 (ET0 Open-Meteo se aata hai, daily.et0_fao_evapotranspiration[0])
double calculateETc(double kc, double et0) => kc * et0;

/// 5. TAW aur RAW — root zone soil water bucket size
double calculateTAW(double waterHoldingCapacity, double rootDepthM) {
  return 1000 * waterHoldingCapacity * rootDepthM; // mm
}

double calculateRAW(double taw, double p) => p * taw;

/// 6. Bucket update — Dr = root zone depletion (mm). Har din carry-forward hota hai.
/// Room DB me previousDeficitMm store karna, roz yahi function se update karna.
double updateDepletion({
  required double previousDeficitMm,
  required double rainfallMm,
  required double etcMm,
  required double taw,
}) {
  double newDeficit = previousDeficitMm - rainfallMm + etcMm;
  if (newDeficit < 0) newDeficit = 0; // excess rain runoff/deep percolation, bucket full
  if (newDeficit > taw) newDeficit = taw; // saturation cap
  return newDeficit;
}

/// 7. Decision — irrigate chahiye ya nahi
bool shouldIrrigate(double depletionMm, double rawMm) => depletionMm >= rawMm;

/// Ek single call jo poora din ka result deta hai — UI/output screen isi ko call karega
class IrrigationResult {
  final bool irrigate;
  final double depletionMm;
  final double rawMm;
  final double tawMm;
  final double etcMm;

  IrrigationResult({
    required this.irrigate,
    required this.depletionMm,
    required this.rawMm,
    required this.tawMm,
    required this.etcMm,
  });
}

IrrigationResult runDailyCheck({
  required String cropName,
  required int daysSinceSowing,
  required double et0,
  required double rainfallMm,
  required double previousDeficitMm,
  required String soilTexture,
}) {
  final crop = cropStages[cropName.toLowerCase()];
  if (crop == null) {
    throw ArgumentError('Crop "$cropName" not supported (rice excluded from bucket model)');
  }

  final kc = getKc(crop, daysSinceSowing);
  final rootDepth = getRootDepth(crop, daysSinceSowing);
  final etc = calculateETc(kc, et0);
  final whc = soilWaterHoldingCapacity(soilTexture);
  final taw = calculateTAW(whc, rootDepth);
  final raw = calculateRAW(taw, crop.p);

  final newDeficit = updateDepletion(
    previousDeficitMm: previousDeficitMm,
    rainfallMm: rainfallMm,
    etcMm: etc,
    taw: taw,
  );

  return IrrigationResult(
    irrigate: shouldIrrigate(newDeficit, raw),
    depletionMm: newDeficit,
    rawMm: raw,
    tawMm: taw,
    etcMm: etc,
  );
}