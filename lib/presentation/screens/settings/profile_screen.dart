import 'dart:convert';

import 'package:finniu/constants/colors.dart';
import 'package:finniu/domain/entities/ubigeo.dart';
import 'package:finniu/presentation/providers/settings_provider.dart';
import 'package:finniu/presentation/providers/ubigeo_provider.dart';
import 'package:finniu/presentation/providers/user_provider.dart';
import 'package:finniu/presentation/screens/settings/constants/civil_state.dart';
import 'package:finniu/presentation/screens/settings/widgets.dart';
import 'package:finniu/widgets/custom_select_button.dart';
import 'package:finniu/widgets/scaffold.dart';
import 'package:finniu/widgets/snackbar.dart';
import 'package:finniu/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loader_overlay/loader_overlay.dart';

class ProfileScreen extends StatefulHookConsumerWidget {
  const ProfileScreen({
    Key? key,
  }) : super(key: key);
  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final fieldValues = <String, dynamic>{
    'firstName': null,
    'lastName': null,
    'docNumber': null,
    'province': null,
    'department': null,
    'district': null,
    'civilState': null,
    'address': null,
    'occupation': null,
  };
  final ImagePicker _picker = ImagePicker();
  @override
  Widget build(BuildContext context) {
    // final themeProvider = Provider.of<SettingsProvider>(context, listen: false);
    final themeProvider = ref.watch(settingsNotifierProvider);
    final userProfile = ref.watch(userProfileNotifierProvider);

    // final namesController = useTextEditingController();
    final firstNameController = useTextEditingController(text: userProfile.firstName);
    final lastNameController = useTextEditingController(text: userProfile.lastName);
    final docNumberController =
        useTextEditingController(text: userProfile.documentNumber == null ? '' : userProfile.documentNumber);
    final departmentController = useTextEditingController(text: userProfile.region);
    final provinceController = useTextEditingController(text: userProfile.provincia);
    final districtController = useTextEditingController(text: userProfile.distrito);
    final addressController = useTextEditingController(text: userProfile.address);
    final civilStateController = useTextEditingController(text: userProfile.civilStatus);

    final occupationController = useTextEditingController(text: userProfile.occupation);

    final regionsFuture = ref.watch(regionsFutureProvider.future);
    final allProvincesFuture = ref.read(provincesFutureProvider.future);
    final provinces = ref.watch(provincesStateNotifier);
    final districtsFuture = ref.read(districtsFutureProvider.future);
    final districts = ref.watch(districtsStateNotifier);
    final departmentCodeController = useTextEditingController();
    final provinceCodeController = useTextEditingController();
    final districtCodeController = useTextEditingController();

    final formKey = GlobalKey<FormState>();

    final percentage = useState(0.0);
    final percentageString = useState('0%');

    final imageFile = useState(
      userProfile.imageProfileUrl ??
          "https://e7.pngegg.com/pngimages/84/165/png-clipart-united-states-avatar-organization-information-user-avatar-service-computer-wallpaper-thumbnail.png",
    );

    final editar = useState(userProfile.hasRequiredData() ? false : true);

    Color disabledColor = themeProvider.isDarkMode ? Color(grayText) : const Color(0xffF4F4F4);
    Color enableColor = themeProvider.isDarkMode ? const Color(backgroundColorDark) : const Color(whiteText);

    int mapControllerKey() {
      int count = 0;
      if (firstNameController.text.isNotEmpty) {
        count += 1;
      }
      if (lastNameController.text.isNotEmpty) {
        count++;
      }
      if (docNumberController.text.isNotEmpty) {
        count++;
      }
      if (departmentController.text.isNotEmpty) {
        count++;
      }
      if (provinceController.text.isNotEmpty) {
        count++;
      }
      if (districtController.text.isNotEmpty) {
        count++;
      }
      if (addressController.text.isNotEmpty) {
        count++;
      }
      if (civilStateController.text.isNotEmpty) {
        count++;
      }
      if (addressController.text.isNotEmpty) {
        count++;
      }
      if (occupationController.text.isNotEmpty) {
        count++;
      }
      return count;
    }

    void _calculatePercentage() {
      int count = mapControllerKey();

      if (count == 0) {
        percentage.value = 0.0;
      } else {
        percentage.value = (count / 9.0);
      }
      if (percentage.value >= 1.0) {
        percentage.value = 1.0;
      }
      percentageString.value = '${(percentage.value * 100).round()}%';
    }

    _calculatePercentage();

    Future<void> filterSelects(WidgetRef ref) async {
      final String departmentValue = departmentController.text;
      String departmentName = ''; // this value
      String departmentCode = '';

      final String provinceValue = provinceController.text;
      String provinceName = '';
      String provinceCode = '';

      final String districtValue = districtController.text;
      String districtName = '';
      String districtCode = '';

      if (departmentValue.isNotEmpty) {
        if (int.tryParse(departmentValue) != null) {
          if (departmentValue.length > 2) {
            departmentName = RegionEntity.getNameFromCode(
              departmentValue.substring(departmentValue.length - 2),
              await regionsFuture,
            );
          } else {
            departmentName = RegionEntity.getNameFromCode(
              departmentValue,
              await regionsFuture,
            );
          }
          departmentCode = departmentValue;
        } else {
          departmentName = departmentValue;
          departmentCode = RegionEntity.getCodeFromName(
            departmentName,
            await regionsFuture,
          );
        }
        ref.read(provincesStateNotifier.notifier).filterProvinces(departmentCode);
      }

      if (provinceValue.isNotEmpty) {
        if (int.tryParse(provinceValue) != null) {
          if (provinceValue.length > 2) {
            provinceName = ProvinceEntity.getNameFromCode(
              provinceValue.substring(provinceValue.length - 2),
              departmentCode,
              await allProvincesFuture,
            );
            provinceCode = provinceValue.substring(provinceValue.length - 2);
          } else {
            provinceName = ProvinceEntity.getNameFromCode(
              provinceValue,
              departmentCode,
              await allProvincesFuture,
            );
            provinceCode = provinceValue;
          }
        } else {
          provinceName = provinceValue;
          provinceCode = ProvinceEntity.getCodeFromName(
            provinceName,
            departmentCode,
            await allProvincesFuture,
          );
        }
        final allRegions = await regionsFuture;
        final allProvinces = await allProvincesFuture;
        final codeRegion = RegionEntity.getCodeFromName(
          departmentName,
          allRegions,
        );
        final codeProvince = ProvinceEntity.getCodeFromName(
          provinceName,
          codeRegion,
          allProvinces,
        );
        ref.read(districtsStateNotifier.notifier).filterDistricts(codeProvince, codeRegion);
      }

      if (districtValue.isNotEmpty) {
        if (int.tryParse(districtValue) != null) {
          if (districtValue.length > 2) {
            districtName = DistrictEntity.getNameFromCode(
              districtValue.substring(districtValue.length - 2),
              provinceCode,
              departmentCode,
              await districtsFuture,
            );
            districtCode = districtValue.substring(districtValue.length - 2);
          } else {
            districtName = DistrictEntity.getNameFromCode(
              districtValue,
              provinceCode,
              departmentCode,
              await districtsFuture,
            );
            districtCode = districtValue;
          }
        } else {
          districtName = districtValue;

          districtCode = DistrictEntity.getCodeFromName(
            districtName,
            provinceCode,
            departmentCode,
            await districtsFuture,
          );
        }
      }

      departmentController.text = departmentName;
      provinceController.text = provinceName;
      districtController.text = districtName;
      // to map the correct value to the civil state controller
      civilStateController.text = MaritalStatusMapper().mapStatusToText(civilStateController.text);
    }

    useEffect(
      () {
        //show overlay loader
        context.loaderOverlay.show();
        filterSelects(ref);
        context.loaderOverlay.hide();

        return () {}; // Return an empty dispose callback
      },
      const [],
    );
    return CustomLoaderOverlay(
      child: CustomScaffoldReturn(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(25),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  Container(
                    height: 100,
                    width: double.maxFinite,
                    alignment: Alignment.center,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        InkWell(
                          onTap: () async {
                            //show loader
                            context.loaderOverlay.show();
                            try {
                              Future<XFile?> ximage = _picker.pickImage(source: ImageSource.gallery);

                              final xImage = await ximage;
                              imageFile.value = xImage!.path;

                              final List<int> imageBytes = await xImage.readAsBytes();
                              final base64Image = "data:image/jpeg;base64,${base64Encode(imageBytes)}";
                              final success = await ref.read(
                                updateUserAvatarFutureProvider(
                                  base64Image,
                                ).future,
                              );

                              context.loaderOverlay.hide();
                              if (success) {
                                CustomSnackbar.show(context, 'Su foto de perfil se actualizó correctamente', 'success');
                              } else {
                                CustomSnackbar.show(context, 'Error al actualizar el su foto de perfil', 'error');
                              }
                            } catch (e) {
                              context.loaderOverlay.hide();
                              CustomSnackbar.show(context, 'Error al actualizar el su foto de perfil', 'error');
                            }
                          },
                          child: CircularPercentAvatar(
                            percentage: percentage,
                            imageFile: imageFile,
                          ),
                        ),
                        Positioned(
                          left: -62,
                          top: 10,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              width: 67,
                              height: 35,
                              // padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: const Color(primaryDark),
                                border: Border.all(
                                  width: 4,
                                  color: const Color(0xff295984),
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              // color: Color(primaryDark),
                              child: Center(
                                child: Text(
                                  percentageString.value.toString(),
                                  // textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        // Positioned(
                        //   right: 18,
                        //   bottom: 25,
                        //   child: InkWell(
                        //     onTap: () async {
                        //       Future<XFile?> ximage = _picker.pickImage(source: ImageSource.gallery);
                        //       imageFile.value = await ximage.then((value) => value!.path);
                        //     },
                        //     child: const Icon(
                        //       Icons.add_photo_alternate_outlined,
                        //       size: 13,
                        //     ),
                        //   ),
                        // )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  SizedBox(
                    width: 224,
                    child: Text(
                      'Completa tus datos',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        height: 1.5,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: themeProvider.isDarkMode ? const Color(primaryLight) : const Color(primaryDark),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: 224,
                    child: TextFormField(
                      readOnly: !editar.value,
                      showCursor: editar.value,
                      controller: firstNameController,
                      key: const Key('firstName'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Este dato es requerido';
                        }
                        return null;
                      },
                      onEditingComplete: () {
                        _calculatePercentage();
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: (editar.value ? enableColor : disabledColor),
                        hintText: 'Escriba sus nombres',
                        label: const Text("Nombres"),
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  SizedBox(
                    width: 224,
                    child: TextFormField(
                      readOnly: !editar.value,
                      showCursor: editar.value,
                      controller: lastNameController,
                      key: const Key('lastName'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Este dato es requerido';
                        }
                        return null;
                      },
                      onEditingComplete: () {
                        _calculatePercentage();
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: (editar.value ? enableColor : disabledColor),
                        hintText: 'Escriba sus apellidos',
                        label: const Text("Apellidos"),
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  SizedBox(
                    width: 224,
                    child: TextFormField(
                      readOnly: !editar.value,
                      showCursor: editar.value,
                      key: const Key('docNumber'),
                      controller: docNumberController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Este dato es requerido';
                        }
                        if (value.length != 9) {
                          return 'Tiene que ser de  dígitos';
                        }
                        return null;
                      },
                      onEditingComplete: () {
                        _calculatePercentage();
                      },
                      keyboardType: const TextInputType.numberWithOptions(signed: true, decimal: true),
                      decoration: InputDecoration(
                        hintText: 'Escriba su documento de indentificación',
                        label: const Text("Documento de indentificación"),
                        filled: true,
                        fillColor: (editar.value ? enableColor : disabledColor),
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  SizedBox(
                    width: 224,
                    height: 39,
                    child: CustomSelectButton(
                      enabled: editar.value,
                      textEditingController: departmentController,
                      labelText: 'Departamento',
                      asyncItems: (String filter) async {
                        final response = await regionsFuture;
                        return response.map((e) => e.name).toList();
                      },
                      callbackOnChange: (value) async {
                        departmentController.text = value;
                        provinceController.text = '';
                        districtController.text = '';
                        final regions = await regionsFuture;
                        final codeRegion = RegionEntity.getCodeFromName(value, regions);

                        ref.read(provincesStateNotifier.notifier).filterProvinces(codeRegion);
                        departmentCodeController.text = codeRegion;
                        _calculatePercentage();
                      },
                    ),
                  ),
                  const SizedBox(height: 28),
                  SizedBox(
                    width: 224,
                    height: 38,
                    child: CustomSelectButton(
                      enabled: editar.value,
                      textEditingController: provinceController,
                      labelText: 'Provincia',
                      items: provinces.map((e) => e.name).toList(),
                      callbackOnChange: (value) async {
                        districtController.text = '';
                        final allRegions = await regionsFuture;
                        final allProvinces = await allProvincesFuture;
                        final codeRegion = RegionEntity.getCodeFromName(
                          departmentController.text,
                          allRegions,
                        );
                        final codeProvince = ProvinceEntity.getCodeFromName(
                          value,
                          codeRegion,
                          allProvinces,
                        );
                        ref.read(districtsStateNotifier.notifier).filterDistricts(codeProvince, codeRegion);
                        _calculatePercentage();
                        provinceController.text = value;
                        provinceCodeController.text = codeProvince;
                      },
                    ),
                  ),
                  const SizedBox(height: 28),
                  SizedBox(
                    width: 224,
                    height: 38,
                    child: CustomSelectButton(
                      enabled: editar.value,
                      textEditingController: districtController,
                      labelText: 'Distrito',
                      items: districts.map((e) => e.name).toList(),
                      callbackOnChange: (value) {
                        _calculatePercentage();
                        districtController.text = value;
                        districtCodeController.text = DistrictEntity.getCodeFromName(
                          value,
                          provinceCodeController.text,
                          departmentCodeController.text,
                          districts,
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 28),
                  SizedBox(
                    width: 224,
                    height: 38,
                    child: TextFormField(
                      readOnly: !editar.value,
                      showCursor: editar.value,
                      key: const Key('address'),
                      controller: addressController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Este dato es requerido';
                        }

                        return null;
                      },
                      onEditingComplete: () {
                        _calculatePercentage();
                      },
                      decoration: InputDecoration(
                        hintText: 'Escriba su dirección',
                        label: const Text("Dirección"),
                        filled: true,
                        fillColor: (editar.value ? enableColor : disabledColor),
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  SizedBox(
                    width: 224,
                    height: 38,
                    child: CustomSelectButton(
                      enabled: editar.value,
                      textEditingController: civilStateController,
                      labelText: 'Estado Civil',
                      items: MaritalStatusMapper().values,
                      callbackOnChange: (value) {
                        civilStateController.text = value.toString();
                        _calculatePercentage();
                      },
                    ),
                  ),
                  const SizedBox(height: 15),
                  SizedBox(
                    width: 224,
                    height: 38,
                    child: TextFormField(
                      readOnly: !editar.value,
                      showCursor: editar.value,
                      key: const Key('occupation'),
                      controller: occupationController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Este dato es requerido';
                        }

                        return null;
                      },
                      onEditingComplete: () {
                        _calculatePercentage();
                      },
                      decoration: InputDecoration(
                        hintText: 'Escriba su ocupación',
                        label: const Text("Ocupación"),
                        filled: true,
                        fillColor: (editar.value ? enableColor : disabledColor),
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  Container(
                    width: 224,
                    height: 50,
                    child: TextButton(
                      onPressed: () async {
                        try {
                          if (!editar.value) {
                            editar.value = !editar.value;
                            return;
                          }

                          if (firstNameController.text.isEmpty ||
                              lastNameController.text.isEmpty ||
                              docNumberController.text.isEmpty ||
                              departmentController.text.isEmpty ||
                              provinceController.text.isEmpty ||
                              districtController.text.isEmpty ||
                              addressController.text.isEmpty ||
                              occupationController.text.isEmpty ||
                              civilStateController.text.isEmpty) {
                            CustomSnackbar.show(
                              context,
                              'Por favor, complete todos los campos',
                              'error',
                            );
                            return;
                          }

                          context.loaderOverlay.show();
                          departmentCodeController.text = RegionEntity.getCodeFromName(
                            departmentController.text,
                            await regionsFuture,
                          );
                          provinceCodeController.text = ProvinceEntity.getCodeFromName(
                            provinceController.text,
                            departmentCodeController.text,
                            await allProvincesFuture,
                          );
                          districtCodeController.text = DistrictEntity.getCodeFromName(
                            districtController.text,
                            provinceCodeController.text,
                            departmentCodeController.text,
                            districts,
                          );

                          final userProfile = ref.watch(userProfileNotifierProvider);

                          final success = await ref.read(
                            updateUserProfileFutureProvider(
                              userProfile.copyWith(
                                firstName: firstNameController.text,
                                lastName: lastNameController.text,
                                documentNumber: docNumberController.text,
                                region: departmentCodeController.text,
                                provincia: '${departmentCodeController.text}${provinceCodeController.text}',
                                distrito:
                                    '${departmentCodeController.text}${provinceCodeController.text}${districtCodeController.text}',
                                civilStatus: MaritalStatusMapper().mapStatus(civilStateController.text),
                                address: addressController.text,
                                occupation: occupationController.text,
                              ),
                            ).future,
                          );
                          if (success) {
                            context.loaderOverlay.hide();
                            CustomSnackbar.show(context, 'Sus datos se actualizaron correctamente', 'success');
                          } else {
                            context.loaderOverlay.hide();
                            CustomSnackbar.show(context, 'Error al actualizar', 'error');
                          }
                        } catch (e) {
                          context.loaderOverlay.hide();
                          CustomSnackbar.show(context, 'Error al actualizar', 'error');
                        }

                        // Navigator.pushNamed(context, '/home_home');
                      },
                      child: Text(
                        editar.value ? 'Guardar' : 'Editar',
                        style: TextStyle(
                          color: themeProvider.isDarkMode ? const Color(primaryDark) : const Color(whiteText),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
