import 'package:fasalguru/navigation/routes.dart';
import 'package:fasalguru/ui/Widgets/Custom_Button.dart';
import 'package:fasalguru/viewModel/LocationViewModel/LocationViewModel.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class locationScreen extends StatefulWidget {
  const locationScreen({super.key});

  @override
  State<locationScreen> createState() => _locationScreenState();
}

class _locationScreenState extends State<locationScreen> {
  TextEditingController locationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Padding(padding: EdgeInsets.all(40),child:
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: Image.asset(
              "assets/images/LocationBackground.png",
              width: 400,
              height: 300,
            ),
          ),
          
          Text(
            "Allow Location Access",
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              fontSize: 30,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          Text(
            "We need your location for accurate ",
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontSize: 18,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          Text(
            "weather & irrigation advice",
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontSize: 18,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
         Consumer<LocationViewModel>(
  builder: (context, vm, child) {

    // Loading State
    if (vm.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    // Error State
    if (vm.errorMessage != null) {
      return Text(
        vm.errorMessage!,
        style: const TextStyle(color: Colors.red),
      );
    }

    // Success State
    if (vm.location != null) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Latitude : ${vm.location!.latitude}",
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 10),
          Text(
            "Longitude : ${vm.location!.longitude}",
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      );
    }

    // Initial State
    return const Text("Location not fetched");
  },
)
        ],
      ),
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(left: 30, right: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () {
                context.push(Approutes.login);
              },
              child: Text(
                "Skip",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Custom_Button(
              height: 60,
              width: 120,
              text: "Next",
              color: Theme.of(context).colorScheme.primary,
              onPressed: () {
                context.read<LocationViewModel>().fetchLocation();
              },
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
