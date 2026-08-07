import 'package:fasalguru/model/cropSelection/crop_model.dart';
import 'package:fasalguru/viewModel/cropSelection/CropSelectionViewModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import 'crop_tile_widget.dart';

class CropBottomSheet extends StatefulWidget {
  const CropBottomSheet({super.key});

  @override
  State<CropBottomSheet> createState() => _CropBottomSheetState();
}

class _CropBottomSheetState extends State<CropBottomSheet> {
  final TextEditingController _searchController = TextEditingController();

  List<CropModel> filteredCrops = [];

  @override
  void initState() {
    super.initState();

    final vm = context.read<CropSelectionViewModel>();

    filteredCrops = List.from(vm.crops);

    _searchController.addListener(_searchCrop);
  }

  void _searchCrop() {
    final vm = context.read<CropSelectionViewModel>();

    final query = _searchController.text.toLowerCase();

    setState(() {
      if (query.isEmpty) {
        filteredCrops = List.from(vm.crops);
      } else {
        filteredCrops = vm.crops.where((crop) {
          return crop.name.toLowerCase().contains(query);
        }).toList();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Consumer<CropSelectionViewModel>(
      builder: (context, vm, child) {
        return Container(
          height: MediaQuery.of(context).size.height * .72,
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(28),
            ),
          ),
          child: Column(
            children: [
              Container(
                width: 55,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),

              const SizedBox(height: 20),

              Text(
                "Select Crop",
                style: theme.textTheme.titleLarge,
              ),

              const SizedBox(height: 20),

              TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: "Search Crop",
                  prefixIcon: Icon(Icons.search),
                ),
              ),

              const SizedBox(height: 20),

              Expanded(
                child: ListView.separated(
                  itemCount: filteredCrops.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final crop = filteredCrops[index];

                    return CropTileWidget(
                      crop: crop,
                      selected: vm.selectedCrop?.id == crop.id,
                      onTap: () {
                        vm.selectCrop(crop);
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),

              const SizedBox(height: 10),

              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}