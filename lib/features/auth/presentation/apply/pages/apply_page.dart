// features/auth/presentation/apply/pages/apply_page.dart
import 'dart:convert';
import 'dart:io';
import 'package:flowery_rider/core/base/base_state.dart';
import 'package:flowery_rider/core/routes/routes.dart';
import 'package:flowery_rider/core/theme/app_colors.dart';
import 'package:flowery_rider/core/theme/app_styles.dart';
import 'package:flowery_rider/core/utils/validator.dart';
import 'package:flowery_rider/core/widget/dialog_utils.dart';
import 'package:flowery_rider/features/auth/data/models/apply/country_data.dart';
import 'package:flowery_rider/features/auth/data/models/apply/country_model.dart';
import 'package:flowery_rider/features/auth/presentation/apply/cubit/auth_cubit.dart';
import 'package:flowery_rider/features/auth/presentation/apply/widgets/form_section.dart';
import 'package:flowery_rider/features/auth/presentation/apply/widgets/gender_selection.dart';
import 'package:flowery_rider/features/auth/presentation/apply/widgets/searchable_dropdown_field.dart';
import 'package:flowery_rider/features/auth/presentation/apply/widgets/upload_field.dart';
import 'package:flowery_rider/features/auth/presentation/apply/widgets/vehicle_type_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flowery_rider/generated/locale_keys.g.dart';
import 'package:image_picker/image_picker.dart';
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

  Country? _selectedCountry;
  String? _selectedVehicleType = 'Car';
  String _gender = 'male';
  File? _licensePhoto;
  File? _idPhoto;

  // Lists to store multiple images
  final List<File> _idPhotos = [];
  final List<File> _licensePhotos = [];
  List<Country> _countries = [];

  final Map<String, String> _vehicleTypeMap = {
    'Car': LocaleKeys.auth_apply_car,
    'Motorcycle': LocaleKeys.auth_apply_motorcycle,
    'Bicycle': LocaleKeys.auth_apply_bicycle,
    'Van': LocaleKeys.auth_apply_van,
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
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? pickedFile =
          await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile == null) {
        return; 
      }
      final newFile = File(pickedFile.path);
      setState(() {
        if (isLicensePhoto) {
          _licensePhoto = newFile;
          if (_licensePhotos.isEmpty) {
            _licensePhotos.add(newFile);
          } else {
            bool isDuplicate = false;
            for (var file in _licensePhotos) {
              if (file.path == newFile.path) {
                isDuplicate = true;
                break;
              }
            }
            if (!isDuplicate) {
              _licensePhotos.add(newFile);
            }
          }
        } else {
          _idPhoto = newFile;
          if (_idPhotos.isEmpty) {
            _idPhotos.add(newFile);
          } else {
            bool isDuplicate = false;
            for (var file in _idPhotos) {
              if (file.path == newFile.path) {
                isDuplicate = true;
                break;
              }
            }
            if (!isDuplicate) {
              _idPhotos.add(newFile);
            }
          }
        }
      });
    } catch (e) {
      if (mounted) {
        GetIt.I<DialogUtils>().showSnackBar(
          textColor: AppColors.error,
          message: 'Error selecting image: $e',
          context: context,
        );
      }
    }
  }


//------------------------------------------------- Remove image
  void _removeImage(bool isLicensePhoto) {
    setState(() {
      if (isLicensePhoto) {
        _licensePhoto = null;
        _licensePhotos.clear();
      } else {
        _idPhoto = null;
        _idPhotos.clear();
      }
    });
  }
  void _removeSpecificImage(bool isLicensePhoto, File specificFile) {
    setState(() {
      if (isLicensePhoto) {
        _licensePhotos.removeWhere((file) => file.path == specificFile.path);
        if (_licensePhoto != null && _licensePhoto!.path == specificFile.path) {
          _licensePhoto =
              _licensePhotos.isNotEmpty ? _licensePhotos.last : null;
        }
      } else {
        _idPhotos.removeWhere((file) => file.path == specificFile.path);
        if (_idPhoto != null && _idPhoto!.path == specificFile.path) {
          _idPhoto = _idPhotos.isNotEmpty ? _idPhotos.last : null;
        }
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
          title: Text(LocaleKeys.auth_apply_title.tr()),
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
                    LocaleKeys.auth_apply_welcome.tr(),
                    style: getMediumStyle(
                      fontSize: 20.sp,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    LocaleKeys.auth_apply_join_team.tr(),
                    style: getRegularStyle(
                      fontSize: 14.sp,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 12.h),

                  // ------------------------------------- Country dropdown
                  _buildCountryDropdown(),
                  SizedBox(height: 15.h),
                  // ------------------------------------- personal info
                  _buildPersonalInfoSection(),
                  SizedBox(height: 15.h),

                  // ------------------------------------- Vehicle info
                  _buildVehicleInfoSection(),
                  SizedBox(height: 15.h),

                  // ------------------------------------- Email and phone
                  _buildEmailAndPhoneSection(),
                  SizedBox(height: 15.h),

                  // ------------------------------------- ID info
                  _buildIdInfoSection(),
                  SizedBox(height: 15.h),
                  // ------------------------------------- Account info
                  _buildAccountInfoSection(),
                  SizedBox(height: 20.h),
                  // ------------------------------------- Gender
                  _buildGenderSelection(),
                  SizedBox(height: 20.h),

                  // ------------------------------------- Submit button
                  _buildSubmitButton(),
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
    return SearchableDropdownField<Country>(
      label: LocaleKeys.auth_apply_country.tr(),
      hint: LocaleKeys.auth_apply_search_country.tr(),
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
            Text(country.name),
          ],
        );
      },
      selectedItemBuilder: (Country country) => Row(
        children: [
          Text(country.flag),
          SizedBox(width: 8.w),
          Text(
            country.name,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

//----------------------------------------------------------- first and last name
  Widget _buildPersonalInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocaleKeys.auth_apply_account_information.tr(),
          style: getMediumStyle(
            fontSize: 16.sp,
            color: AppColors.black,
          ),
        ),
        SizedBox(height: 15.h),
        
        ///first name
        TextFormField(
          decoration: InputDecoration(
            hintText: LocaleKeys.auth_apply_first_name_hint.tr(),
            labelText: LocaleKeys.auth_apply_first_name.tr(),
            floatingLabelBehavior: FloatingLabelBehavior.always,
          ),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          controller: _firstNameController,
          validator: Validator.firstNameValidation,
          keyboardType: TextInputType.name,
        ),
        SizedBox(height: 15.h),

        ///second name
        TextFormField(
          decoration: InputDecoration(
            hintText: LocaleKeys.auth_apply_last_name_hint.tr(),
            labelText: LocaleKeys.auth_apply_last_name.tr(),
            floatingLabelBehavior: FloatingLabelBehavior.always,
          ),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          controller: _lastNameController,
          validator: Validator.lastNameValidation,
          keyboardType: TextInputType.name,
        ),
      ],
    );
  }

//----------------------------------------------------------- vehicle info
  Widget _buildVehicleInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocaleKeys.auth_apply_vehicle_information.tr(),
          style: getMediumStyle(
            fontSize: 16.sp,
            color: AppColors.black,
          ),
        ),
        SizedBox(height: 15.h),
        
        VehicleTypeDropdown(
          selectedValue: _selectedVehicleType,
          onChanged: (String? newValue) {
            if (newValue != null) {
              setState(() {
                _selectedVehicleType = newValue;
              });
            }
          },
          options: _vehicleTypeMap.entries
              .map((entry) => VehicleTypeOption(entry.key, entry.value.tr()))
              .toList(),
          hintText: LocaleKeys.auth_apply_select_vehicle_type.tr(),
        ),
        SizedBox(height: 15.h),
        
        TextFormField(
          decoration: InputDecoration(
            hintText: LocaleKeys.auth_apply_vehicle_number_hint.tr(),
            labelText: LocaleKeys.auth_apply_vehicle_number.tr(),
            floatingLabelBehavior: FloatingLabelBehavior.always,
          ),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          controller: _vehicleNumberController,
          validator: Validator.validateVehicleNumber,
          keyboardType: TextInputType.text,
        ),
        SizedBox(height: 15.h),
        
        UploadField(
          label: LocaleKeys.auth_apply_vehicle_license.tr(),
          hintText: LocaleKeys.auth_apply_vehicle_license_hint.tr(),
          file: _licensePhoto,
          files: _licensePhotos,
          onTap: () => _pickImage(true),
          onRemove: () => _removeImage(true),
          onRemoveFile: (file) => _removeSpecificImage(true, file),
        ),
      ],
    );
  }

//----------------------------------------------------------- email and phone
  Widget _buildEmailAndPhoneSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocaleKeys.auth_apply_account_information.tr(),
          style: getMediumStyle(
            fontSize: 16.sp,
            color: AppColors.black,
          ),
        ),
        SizedBox(height: 15.h),
        
        TextFormField(
          decoration: InputDecoration(
            hintText: LocaleKeys.auth_apply_email_hint.tr(),
            labelText: LocaleKeys.auth_apply_email.tr(),
            floatingLabelBehavior: FloatingLabelBehavior.always,
          ),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          controller: _emailController,
          validator: Validator.emailValidate,
          keyboardType: TextInputType.emailAddress,
        ),
        SizedBox(height: 15.h),
        
        TextFormField(
          decoration: InputDecoration(
            hintText: LocaleKeys.auth_apply_phone_number_hint.tr(),
            labelText: LocaleKeys.auth_apply_phone_number.tr(),
            floatingLabelBehavior: FloatingLabelBehavior.always,
          ),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          controller: _phoneController,
          validator: Validator.phoneNumberValidation,
          keyboardType: TextInputType.phone,
          maxLength: 11,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
        ),
      ],
    );
  }

//----------------------------------------------------------- ID info
  Widget _buildIdInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocaleKeys.auth_apply_id_number.tr(),
          style: getMediumStyle(
            fontSize: 16.sp,
            color: AppColors.black,
          ),
        ),
        SizedBox(height: 15.h),
        
        TextFormField(
          decoration: InputDecoration(
            hintText: LocaleKeys.auth_apply_id_hint.tr(),
            labelText: LocaleKeys.auth_apply_id_number.tr(),
            floatingLabelBehavior: FloatingLabelBehavior.always,
          ),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          controller: _idNumberController,
          validator: Validator.validateRequired,
          keyboardType: TextInputType.number,
        ),
        SizedBox(height: 15.h),
        
        UploadField(
          label: LocaleKeys.auth_apply_id_docs.tr(),
          hintText: LocaleKeys.auth_apply_id_image_hint.tr(),
          file: _idPhoto,
          files: _idPhotos,
          onTap: () => _pickImage(false),
          onRemove: () => _removeImage(false),
          onRemoveFile: (file) => _removeSpecificImage(false, file),
        ),
      ],
    );
  }

//----------------------------------------------------------- password and confirm password
  Widget _buildAccountInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocaleKeys.auth_apply_account_information.tr(),
          style: getMediumStyle(
            fontSize: 16.sp,
            color: AppColors.black,
          ),
        ),
        SizedBox(height: 15.h),
        
        /// Password fields in a row
        Row(
          children: [
            Expanded(
              child: TextFormField(
                decoration: InputDecoration(
                  hintText: LocaleKeys.auth_apply_password_hint.tr(),
                  labelText: LocaleKeys.auth_apply_password.tr(),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                ),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: _passwordController,
                validator: Validator.passwordValidation,
                obscureText: true,
                keyboardType: TextInputType.visiblePassword,
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: TextFormField(
                decoration: InputDecoration(
                  hintText: LocaleKeys.auth_apply_confirm_password_hint.tr(),
                  labelText: LocaleKeys.auth_apply_confirm_password.tr(),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                ),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: _confirmPasswordController,
                validator: (value) => Validator.confirmPasswordValidation(value, _passwordController.text),
                obscureText: true,
                keyboardType: TextInputType.visiblePassword,
              ),
            ),
          ],
        ),
      ],
    );
  }

//----------------------------------------------------------- gender(male or female)
  Widget _buildGenderSelection() {
    return GenderSelection(
      selectedGender: _gender,
      onChanged: (value) {
        setState(() {
          _gender = value;
        });
      },
    );
  }

//----------------------------------------------------------- Apply button
  Widget _buildSubmitButton() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        BlocBuilder<AuthCubit, AuthState>(
          buildWhen: (previous, current) =>
              previous.applyState.runtimeType != current.applyState.runtimeType,
          builder: (context, state) {
            final isLoading = state.applyState is BaseLoadingState;

            return ElevatedButton(
              onPressed: isLoading
                  ? null
                  : () {
                      if (!_formKey.currentState!.validate()) return;

                      if (_licensePhoto == null || _idPhoto == null) {
                        GetIt.I<DialogUtils>().showSnackBar(
                          textColor: AppColors.error,
                          message:
                              LocaleKeys.auth_apply_upload_required_files.tr(),
                          context: context,
                        );
                        return;
                      }

                      final formData = {
                        'firstName': _firstNameController.text.trim(),
                        'lastName': _lastNameController.text.trim(),
                        'email': _emailController.text.trim().toLowerCase(),
                        'phone': _phoneController.text.trim(),
                        'countryCode': _selectedCountry?.phoneCode ?? '+20',
                        'gender': _gender,
                        'vehicleType': _selectedVehicleType ?? 'Car',
                        'vehicleNumber': _vehicleNumberController.text.trim(),
                        'idNumber': _idNumberController.text.trim(),
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
                                color: Colors.white, strokeWidth: 2.5)),
                        const SizedBox(width: 10),
                        Text(LocaleKeys.auth_apply_processing.tr()),
                      ],
                    )
                  : Text(LocaleKeys.auth_apply_submit_application.tr()),
            );
          },
        ),
      ],
    );
  }

}
