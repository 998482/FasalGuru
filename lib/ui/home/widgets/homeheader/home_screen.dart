import 'package:fasalguru/model/cropSelection/crop_model.dart';
import 'package:fasalguru/navigation/routes.dart';
import 'package:fasalguru/ui/home/widgets/RecommdationButton/Button.dart';
import 'package:fasalguru/ui/home/widgets/cropsSelection/crop_dropdown_widget.dart';
import 'package:fasalguru/ui/home/widgets/datePicker/SowingDateWidget.dart';
import 'package:fasalguru/ui/home/widgets/homeheader/home_header_widget.dart';
import 'package:fasalguru/ui/home/widgets/soilCard/soil_selection_widget.dart';
import 'package:fasalguru/ui/home/widgets/weatherwidget/weather_forecast_widget.dart';
import 'package:fasalguru/viewModel/weather/weather_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';


class HomeScreen extends StatefulWidget {

  const HomeScreen({super.key});


  @override
  State<HomeScreen> createState() => _HomeScreenState();

}



class _HomeScreenState extends State<HomeScreen> {


  CropModel? selectedCrop;

  SoilType? selectedSoil;

  DateTime? selectedDate;



  @override
  void initState() {

    super.initState();

    Future.microtask(() {

      context.read<WeatherViewModel>().loadWeather(

        latitude: 26.8393,

        longitude: 80.9231,

      );

    });

  }



  @override
  Widget build(BuildContext context) {


    return Scaffold(

      body: SafeArea(

        child: SingleChildScrollView(

          padding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 20,
          ),


          child: Column(

            crossAxisAlignment: CrossAxisAlignment.start,


            children: [


              const HomeHeaderWidget(),


              const SizedBox(height: 28),



              const WeatherForecastWidget(),



              const SizedBox(height: 28),



              CropDropdownWidget(

                onCropSelected: (crop){

                  selectedCrop = crop;

                },

              ),



              const SizedBox(height: 28),



              SoilSelectionWidget(

                onSoilSelected: (soil){

                  selectedSoil = soil;

                },

              ),



              const SizedBox(height: 28),



              SowingDateWidget(

                onDateSelected: (date){

                  selectedDate = date;

                },

              ),



              const SizedBox(height: 40),




             RecommendationButton(
  onPressed: () {
    print("Crop: ${selectedCrop?.name}");
print("Soil: ${selectedSoil?.name}");
print("Date: $selectedDate");
    if (selectedCrop == null ||
        selectedSoil == null ||
        selectedDate == null) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Please select crop, soil and sowing date",
          ),
        ),
      );

      return;
    }

    print(selectedCrop!.name);
    print(selectedSoil!.name);
    print(selectedDate);

    context.push(
      Approutes.recommendation,
      extra: {
        "crop": selectedCrop!.name,
        "soil": selectedSoil!.name,
        "date": selectedDate!,
      },
    );
  },
),


              const SizedBox(height: 20),


            ],

          ),

        ),

      ),

    );

  }

}