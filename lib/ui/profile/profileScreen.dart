import 'dart:io';
import 'package:fasalguru/l10n/app_localizations.dart';
import 'package:fasalguru/ui/Widgets/customBackButton.dart';
import 'package:fasalguru/ui/bottomNavigation/bottomNavigation.dart';
import 'package:fasalguru/ui/home/widgets/homeheader/fasalGuruAppbar.dart';
import 'package:fasalguru/viewModel/profile/ProfileViewModel.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class SaveProfileScreen extends StatefulWidget {
  const SaveProfileScreen({super.key});

  @override
  State<SaveProfileScreen> createState() => _SaveProfileScreenState();
}

class _SaveProfileScreenState extends State<SaveProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _villageController = TextEditingController();
  final _stateController = TextEditingController();

  bool _prefilled = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final vm = context.read<ProfileViewmodel>();

      // Agar profile abhi tak load nahi hua, to fetch karo
      if (vm.profile == null) {
        await vm.loadProfile();
      }

      _fillFieldsFromProfile(vm);

      vm.addListener(_onProfileChanged);
    });
  }

  void _onProfileChanged() {
    final vm = context.read<ProfileViewmodel>();
    _fillFieldsFromProfile(vm);
  }

  void _fillFieldsFromProfile(ProfileViewmodel vm) {
    final p = vm.profile;
    if (p == null) return;

    _nameController.text = p.username;
    _phoneController.text = p.phoneNumber;
    _villageController.text = p.village;
    _stateController.text = p.state;

    if (!_prefilled) {
      _prefilled = true;
      if (mounted) setState(() {});
    }
  }

  @override
  void dispose() {
    context.read<ProfileViewmodel>().removeListener(_onProfileChanged);
    _nameController.dispose();
    _phoneController.dispose();
    _villageController.dispose();
    _stateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        // 👇 leading icon ka size ab yahin se control hoga (chhota kar diya)
        //  leadingWidth: 48,
        leading: CustomBackbutton(
          pressed: () => context.pop(),
        ),
        title: Text(l10n.myProfile),
      ),
      body: SafeArea(
        child: Consumer<ProfileViewmodel>(
          builder: (context, vm, _) {
            if (vm.isLoading && vm.profile == null) {
              return const Center(child: CircularProgressIndicator());
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 10),
                    Center(
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Theme.of(context).colorScheme.primary,
                            width: 3,
                          ),
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            "assets/images/AppLogo.png",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    // 👆 "Fill in your photo and details here" wali line hata di
                    const SizedBox(height: 32),

                    _FieldLabel(l10n.fullName),
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(hintText: l10n.enterYourName),
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? l10n.nameRequired
                          : null,
                    ),
                    const SizedBox(height: 18),

                    _FieldLabel(l10n.mobileNumber),
                    TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      maxLength: 10,
                      decoration: InputDecoration(
                        hintText: l10n.tenDigitMobileNumber,
                        counterText: "",
                      ),
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return l10n.numberRequired;
                        }
                        if (v.trim().length != 10) {
                          return l10n.enterValidTenDigitNumber;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 18),

                    _FieldLabel(l10n.villageDistrict),
                    TextFormField(
                      controller: _villageController,
                      decoration:
                          InputDecoration(hintText: l10n.enterVillageOrDistrict),
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? l10n.fieldRequired
                          : null,
                    ),
                    const SizedBox(height: 18),

                    _FieldLabel(l10n.state),
                    TextFormField(
                      controller: _stateController,
                      decoration: InputDecoration(hintText: l10n.enterYourState),
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? l10n.fieldRequired
                          : null,
                    ),
                    const SizedBox(height: 36),

                    SizedBox(
                      height: 52,
                      child: ElevatedButton(
                        onPressed: vm.isSaving ? null : _onSave,
                        child: vm.isSaving
                            ? const SizedBox(
                                height: 22,
                                width: 22,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2.4,
                                ),
                              )
                            : Text(
                                l10n.saveProfile,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),

                    if (vm.errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: Text(
                          vm.errorMessage!,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: scheme.error),
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: AppBottomNavBar(
        currentRoute: AppBottomNavBar.profileRoute,
      ),
    );
  }

  Future<void> _onSave() async {
    if (!_formKey.currentState!.validate()) return;

    final vm = context.read<ProfileViewmodel>();
    final l10n = AppLocalizations.of(context)!;

    final success = await vm.saveProfile(
      username: _nameController.text,
      phoneNumber: _phoneController.text,
      village: _villageController.text,
      state: _stateController.text,
    );

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.profileSavedSuccess)),
      );
      Navigator.pop(context);
    }
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 2),
      child: Text(
        text,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
      ),
    );
  }
}