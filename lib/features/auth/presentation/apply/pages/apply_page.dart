// features/auth/presentation/apply/pages/apply_page.dart
import 'dart:convert';
import 'dart:io';
import 'package:flowery_rider/core/base/base_state.dart';
import 'package:flowery_rider/core/routes/routes.dart';
import 'package:flowery_rider/core/services/image_picker_service.dart';
import 'package:flowery_rider/core/theme/app_colors.dart';
import 'package:flowery_rider/core/theme/app_styles.dart';
import 'package:flowery_rider/core/widget/dialog_utils.dart';
import 'package:flowery_rider/features/auth/data/models/apply/country_data.dart';
import 'package:flowery_rider/features/auth/data/models/apply/country_model.dart';
import 'package:flowery_rider/features/auth/presentation/apply/cubit/auth_cubit.dart';
import 'package:flowery_rider/features/auth/presentation/apply/widgets/account_info_section.dart';
import 'package:flowery_rider/features/auth/presentation/apply/widgets/email_phone_section.dart';
import 'package:flowery_rider/features/auth/presentation/apply/widgets/gender_selection.dart';
import 'package:flowery_rider/features/auth/presentation/apply/widgets/id_info_section.dart';
import 'package:flowery_rider/features/auth/presentation/apply/widgets/personal_info_section.dart';
import 'package:flowery_rider/features/auth/presentation/apply/widgets/searchable_dropdown.dart';
import 'package:flowery_rider/features/auth/presentation/apply/widgets/vehicle_info_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flowery_rider/generated/locale_keys.g.dart';
import 'package:get_it/get_it.dart';

class ApplyPage extends StatefulWidget {
  const ApplyPage({super.key});

  @override
  State<ApplyPage> createState() => _ApplyPageState();
}

class _ApplyPageState extends State<ApplyPage> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _vehicleNumberController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _idNumberController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _imagePickerService = ImagePickerService();

  Country? _selectedCountry;
  String? _selectedVehicleType = 'car';
  String _gender = 'male';
  File? _licensePhoto;
  File? _idPhoto;

  // Lists to store multiple images
  final List<File> _idPhotos = [];
  final List<File> _licensePhotos = [];
  List<Country> _countries = [];

  // Define vehicle types with proper translation keys
  final Map<String, String> _vehicleTypeMap = {
    'car': LocaleKeys.apply_car,
    'motorcycle': LocaleKeys.apply_motorcycle,
    'bicycle': LocaleKeys.apply_bicycle,
    'van': LocaleKeys.apply_van,
  };
  List<String> get _vehicleTypes => _vehicleTypeMap.keys.toList();

  bool _isLoading = true;

//------------------------------------------------- Load countries from json file
  Future<void> _loadCountries() async {
    try {
      final String data = await rootBundle.loadString('assets/country.json');
      final List<dynamic> jsonData = json.decode(data);

      setState(() {
        _countries = Country.fromJsonList(jsonData);
        _selectedCountry = _countries.firstWhere(
          (country) => country.name == 'Egypt',
          orElse: () => _countries.isNotEmpty
              ? _countries.first
              : CountryData.getDefaultCountry(),
        );
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _countries = CountryData.getDefaultCountries();
        _selectedCountry = _countries.first;
        _isLoading = false;
      });
    }
  }

  //------------------------------------- Pick image from gallery or camera
  Future<void> _pickImage(bool isLicensePhoto) async {
    final newFile = await _imagePickerService.pickImage(context);
    if (newFile == null) return;

    setState(() {
      if (isLicensePhoto) {
        _imagePickerService.addImageToCollection(
            newFile, _licensePhotos, (file) => _licensePhoto = file);
      } else {
        _imagePickerService.addImageToCollection(
            newFile, _idPhotos, (file) => _idPhoto = file);
      }
    });
  }

//------------------------------------------------- Remove image
  void _removeImage(bool isLicensePhoto) {
    setState(() {
      if (isLicensePhoto) {
        _imagePickerService.clearImages(
            _licensePhotos, (file) => _licensePhoto = file);
      } else {
        _imagePickerService.clearImages(_idPhotos, (file) => _idPhoto = file);
      }
    });
  }

//------------------------------------------------- Remove specific image
  void _removeSpecificImage(bool isLicensePhoto, File specificFile) {
    setState(() {
      if (isLicensePhoto) {
        _imagePickerService.removeSpecificImage(specificFile, _licensePhotos,
            _licensePhoto, (file) => _licensePhoto = file);
      } else {
        _imagePickerService.removeSpecificImage(
            specificFile, _idPhotos, _idPhoto, (file) => _idPhoto = file);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _loadCountries();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _vehicleNumberController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _idNumberController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listenWhen: (previous, current) =>
          previous.applyState != current.applyState,
      listener: (context, state) {
        if (state.applyState is BaseSuccessState) {
          Navigator.pushReplacementNamed(
            context,
            Routes.successApply,
          );
        } else if (state.applyState is BaseErrorState) {
          GetIt.I<DialogUtils>().showSnackBar(
            textColor: AppColors.error,
            message: (state.applyState as BaseErrorState).errorMessage,
            context: context,
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(LocaleKeys.apply_title.tr()),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ------------------------------------- Header
                  SizedBox(height: 10.h),
                  Text(
                    LocaleKeys.apply_welcome.tr(),
                    style: getMediumStyle(
                      fontSize: 20.sp,
                      color: AppColors.black,
                    ),
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    //LocaleKeys.auth_apply_join_team.tr(),
                  LocaleKeys.apply_description.tr(),
                    style: getRegularStyle(
                      fontSize: 14.sp,
                      color: AppColors.grey,
                    ),
                  ),
                  SizedBox(height: 12.h),

                  // ------------------------------------- Country dropdown
                  _buildCountryDropdown(),
                  SizedBox(height: 15.h),
                  PersonalInfoSection(
                    firstNameController: _firstNameController,
                    lastNameController: _lastNameController,
                  ),
                  SizedBox(height: 15.h),

                  // ------------------------------------- Vehicle info
                  VehicleInfoSection(
                    selectedVehicleType: _selectedVehicleType,
                    onVehicleTypeChanged: (newValue) {
                      if (newValue != null) {
                        setState(() {
                          _selectedVehicleType = newValue;
                        });
                      }
                    },
                    vehicleNumberController: _vehicleNumberController,
                    vehicleTypeMap: _vehicleTypeMap,
                    licensePhoto: _licensePhoto,
                    licensePhotos: _licensePhotos,
                    onPickLicensePhoto: () => _pickImage(true),
                    onRemoveLicensePhoto: () => _removeImage(true),
                    onRemoveSpecificLicensePhoto: (file) =>
                        _removeSpecificImage(true, file),
                  ),
                  SizedBox(height: 15.h),

                  // ------------------------------------- Email and phone
                  EmailPhoneSection(
                    emailController: _emailController,
                    phoneController: _phoneController,
                  ),
                  SizedBox(height: 15.h),

                  // ------------------------------------- ID info
                  IdInfoSection(
                    idNumberController: _idNumberController,
                    idPhoto: _idPhoto,
                    idPhotos: _idPhotos,
                    onPickIdPhoto: () => _pickImage(false),
                    onRemoveIdPhoto: () => _removeImage(false),
                    onRemoveSpecificIdPhoto: (file) =>
                        _removeSpecificImage(false, file),
                  ),
                  SizedBox(height: 15.h),
                  // ------------------------------------- Account info
                  AccountInfoSection(
                    passwordController: _passwordController,
                    confirmPasswordController: _confirmPasswordController,
                  ),
                  SizedBox(height: 20.h),
                  // ------------------------------------- Gender
                  GenderSelection(
                    selectedGender: _gender,
                    onChanged: (value) {
                      setState(() {
                        _gender = value;
                      });
                    },
                  ),
                  SizedBox(height: 20.h),

                  // ------------------------------------- Submit button
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      BlocBuilder<AuthCubit, AuthState>(
                        buildWhen: (previous, current) =>
                            previous.applyState.runtimeType !=
                            current.applyState.runtimeType,
                        builder: (context, state) {
                          final isLoading =
                              state.applyState is BaseLoadingState;

                          return ElevatedButton(
                            onPressed: isLoading
                                ? null
                                : () {
                                    if (!_formKey.currentState!.validate()) {
                                      return;
                                    }

                                    if (_licensePhoto == null ||
                                        _idPhoto == null) {
                                      GetIt.I<DialogUtils>().showSnackBar(
                                        textColor: AppColors.error,
                                        message: LocaleKeys.apply_upload_required_files
                                            .tr(),
                                        context: context,
                                      );
                                      return;
                                    }

                                    final formData = {
                                      'firstName':
                                          _firstNameController.text.trim(),
                                      'lastName':
                                          _lastNameController.text.trim(),
                                      'email': _emailController.text
                                          .trim()
                                          .toLowerCase(),
                                      'phone': _phoneController.text.trim(),
                                      'countryCode':
                                          _selectedCountry?.phoneCode ?? '+20',
                                      'gender': _gender,
                                      'vehicleType':
                                          _selectedVehicleType ?? 'car',
                                      'vehicleNumber':
                                          _vehicleNumberController.text.trim(),
                                      'idNumber':
                                          _idNumberController.text.trim(),
                                      'password': _passwordController.text,
                                      'licensePhoto': _licensePhoto,
                                      'idPhoto': _idPhoto,
                                    };

                                    context.read<AuthCubit>().apply(formData);
                                  },
                            child: isLoading
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                              color: AppColors.white,
                                              strokeWidth: 2.5)),
                                      const SizedBox(width: 10),
                                      Text(LocaleKeys.apply_processing
                                          .tr()),
                                    ],
                                  )
                                : Text(LocaleKeys.apply_submit_application
                                    .tr()),
                          );
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 30.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

// ----------------------------------------------------------- country dropdown
  Widget _buildCountryDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocaleKeys.apply_country.tr(),
          style: getRegularStyle(
            fontSize: 12.sp,
            color: AppColors.grey,
          ),
        ),
        SizedBox(height: 5.h),
        SearchableDropdown<Country>(
          hint: LocaleKeys.apply_search_country.tr(),
          value: _selectedCountry,
          items: _countries,
          displayStringForOption: (Country country) => country.name,
          onChanged: (Country newValue) {
            setState(() {
              _selectedCountry = newValue;
            });
          },
          itemBuilder: (Country country) {
            return Row(
              children: [
                Text(country.flag),
                SizedBox(width: 10.w),
                Text(
                  country.name,
                  style: TextStyle(fontSize: 14.sp),
                ),
              ],
            );
          },
          selectedItemBuilder: (Country country) => Row(
            children: [
              Text(country.flag),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  country.name,
                  style: TextStyle(fontSize: 14.sp),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
