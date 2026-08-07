import 'package:fasalguru/model/cropSelection/crop_model.dart';
import 'package:fasalguru/viewModel/cropSelection/CropSelectionViewModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CropDropdownWidget extends StatelessWidget {

  final Function(CropModel) onCropSelected;

  const CropDropdownWidget({
    super.key,
    required this.onCropSelected,
  });


  @override
  Widget build(BuildContext context) {
    return Consumer<CropSelectionViewModel>(
      builder: (context, vm, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Select Crop",
              style: Theme.of(context).textTheme.titleMedium,
            ),

            const SizedBox(height: 10),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: Theme.of(context)
                      .colorScheme
                      .primary
                      .withOpacity(.2),
                ),
              ),

              child: DropdownButtonHideUnderline(
                child: DropdownButton<CropModel>(

                  isExpanded: true,
                  menuMaxHeight: 350,

                  value: vm.selectedCrop,

                  icon: Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: Theme.of(context).colorScheme.primary,
                  ),


                  selectedItemBuilder: (context) {
                    return vm.crops.map((crop) {

                      return Row(
                        children: [

                          Image.asset(
                            crop.image,
                            width: 32,
                            height: 32,
                          ),

                          const SizedBox(width: 12),

                          Expanded(
                            child: Text(
                              crop.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),

                        ],
                      );

                    }).toList();
                  },


                  items: vm.crops.map((crop) {

                    return DropdownMenuItem<CropModel>(
                      value: crop,

                      child: Row(
                        children: [

                          Image.asset(
                            crop.image,
                            width: 32,
                            height: 32,
                          ),

                          const SizedBox(width: 12),

                          Expanded(
                            child: Text(
                              crop.name,
                            ),
                          ),

                        ],
                      ),
                    );

                  }).toList(),


                  onChanged: (CropModel? crop) {

                    if(crop != null){

                      // ViewModel me save
                      vm.selectCrop(crop);


                      // HomeScreen ko bhej do
                      onCropSelected(crop);

                    }

                  },

                ),
              ),
            ),
          ],
        );
      },
    );
  }
}