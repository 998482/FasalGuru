import 'package:fasalguru/l10n/app_localizations.dart';
import 'package:fasalguru/local/location/location_prefs.dart';
import 'package:fasalguru/main.dart'; // <-- added: for global `startupState`
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
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(40),
        child: Column(
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
              l10n.allowLocationAccess,
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                fontSize: 30,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            Text(
              l10n.locationAccuracyReasonLine1,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontSize: 18,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            Text(
              l10n.locationAccuracyReasonLine2,
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
                        l10n.latitudeLabel(vm.location!.latitude.toString()),
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        l10n.longitudeLabel(vm.location!.longitude.toString()),
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  );
                }

                // Initial State
                return Text(l10n.locationNotFetched);
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
                // FIX: location step ko explicitly "done" mark karo
                // (skip case) taaki GoRouter redirect wapas location
                // screen pe na bheje -> "too many redirects" crash fix.
                startupState.setLocationStepDone(true);
                context.go(Approutes.district);
              },
              child: Text(
                l10n.skip,
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
              text: l10n.next,
              color: Theme.of(context).colorScheme.primary,
              onPressed: () async {
                final locationVM = context.read<LocationViewModel>();
                await locationVM.fetchLocation();

                // Agar location mil gayi, coordinates save karo
                if (locationVM.location != null) {
                  await LocationPrefs.saveCoordinates(
                    locationVM.location!.latitude,
                    locationVM.location!.longitude,
                  );
                }

                // FIX: location step done mark karo (allow case) —
                // yahi missing line thi jo redirect loop cause kar rahi thi.
                startupState.setLocationStepDone(true);

                if (!context.mounted) return;
                context.go(Approutes.district);
              },
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}