import 'package:fasalguru/l10n/app_localizations.dart';
import 'package:fasalguru/model/cropSelection/crop_model.dart';

class CropRepository {
  List<CropModel> getCrops(AppLocalizations l10n) {
    return [
      CropModel(
        id: "wheat",
        name: l10n.cropWheat,
        image: "assets/images/grain.png",
      ),
      CropModel(
        id: "maize",
        name: l10n.cropMaize,
        image: "assets/images/maize corn.png",
      ),
      CropModel(
        id: "chickpea",
        name: l10n.cropChickpea,
        image: "assets/images/chickpea.png",
      ),
      CropModel(
        id: "potato",
        name: l10n.cropPotato,
        image: "assets/images/potato.png",
      ),
      CropModel(
        id: "tomato",
        name: l10n.cropTomato,
        image: "assets/images/tomato.png",
      ),
      CropModel(
        id: "sugarcane",
        name: l10n.cropSugarcane,
        image: "assets/images/sugarcane.png",
      ),
    ];
  }
}