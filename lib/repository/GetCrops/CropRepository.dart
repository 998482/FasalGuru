import 'package:fasalguru/model/cropSelection/crop_model.dart';

class CropRepository {

  List<CropModel> getCrops(){

      return const [

        CropModel(
            id: "wheat",
            name: "Wheat",
            image: "assets/images/grain.png"
        ),

        CropModel(
            id: "maize",
            name: "Maize",
            image: "assets/images/maize corn.png"
        ),

        CropModel(
            id: "chickpea",
            name: "Chickpea",
            image: "assets/images/chickpea.png"
        ),

        CropModel(
            id: "potato",
            name: "Potato",
            image: "assets/images/potato.png"
        ),

        CropModel(
            id: "tomato",
            name: "Tomato",
            image: "assets/images/tomato.png"
        ),

        CropModel(
            id: "sugarcane",
            name: "Sugarcane",
            image: "assets/images/sugarcane.png"
        ),

      ];

  }

}