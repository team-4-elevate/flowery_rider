// features/apply/presentation/pages/apply_page.dart
import 'dart:convert';
import 'dart:io';
import 'package:flowery_rider/core/base/base_state.dart';
import 'package:flowery_rider/core/routes/routes.dart';
import 'package:flowery_rider/core/theme/app_colors.dart';
import 'package:flowery_rider/core/theme/app_styles.dart';
import 'package:flowery_rider/core/utils/validator.dart';
import 'package:flowery_rider/core/widget/dialog_utils.dart';
import 'package:flowery_rider/features/apply/data/model/apply/country_data.dart';
import 'package:flowery_rider/features/apply/data/model/apply/country_model.dart';
import 'package:flowery_rider/features/apply/domain/entities/apply_entity.dart';
import 'package:flowery_rider/features/apply/presentation/cubit/auth_cubit.dart';
import 'package:flowery_rider/features/apply/presentation/widgets/apply_widgets/form_section.dart';
import 'package:flowery_rider/features/apply/presentation/widgets/apply_widgets/gender_selection.dart';
import 'package:flowery_rider/features/apply/presentation/widgets/apply_widgets/searchable_dropdown_field.dart';
import 'package:flowery_rider/features/apply/presentation/widgets/apply_widgets/upload_field.dart';
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
  // Form key for validation
  final _formKey = GlobalKey<FormState>();

  // Form controllers
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _vehicleNumberController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _idNumberController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // Selection values
  Country? _selectedCountry;
  String? _selectedVehicleType = 'Car';
  String _gender = 'male';

  // File upload states
  File? _licensePhoto;
  File? _idPhoto;
  bool _isSubmitting = false;

  // Countries list
  List<Country> _countries = [];

  // Vehicle types
  final List<String> _vehicleTypes = ['Car', 'Motorcycle', 'Bicycle', 'Van'];

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCountries();
  }

  Future<void> _loadCountries() async {
    try {
      // Load country data from assets
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

  // Pick image from gallery or camera
  Future<void> _pickImage(bool isLicensePhoto) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? pickedFile =
          await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        setState(() {
          if (isLicensePhoto) {
            _licensePhoto = File(pickedFile.path);
          } else {
            _idPhoto = File(pickedFile.path);
          }
        });
      }
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

  Widget _buildBody() {
    return SingleChildScrollView(
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
                'Welcome!!',
                style: getMediumStyle(
                  fontSize: 20.sp,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 5.h),
              Text(
                'You want to be a delivery man?\nJoin our team',
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
    );
  }

// ------------------------------------- Widgets country dropdown
  Widget _buildCountryDropdown() {
    return SearchableDropdownField<Country>(
      label: 'Country',
      hint: 'Search country',
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

  Widget _buildPersonalInfoSection() {
    return FormSection(
      title: LocaleKeys.auth_apply_account_information.tr(),
      children: [
        ///first name
        TextFormField(
          decoration: InputDecoration(
            hintText: 'Enter first legal name',
            labelText: 'first legal name',
            floatingLabelBehavior: FloatingLabelBehavior.always,
          ),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          controller: _firstNameController,
          validator: Validator.firstNameValidation,
          keyboardType: TextInputType.name,
        ),

        ///second name3
        TextFormField(
          decoration: InputDecoration(
            hintText: 'Enter Second legal name',
            labelText: 'Second legal name',
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

  Widget _buildVehicleInfoSection() {
    return FormSection(
      title: LocaleKeys.auth_apply_vehicle_information.tr(),
      children: [
        SearchableDropdownField<String>(
          label: 'Vehicle type',
          hint: 'Search vehicle type',
          value: _selectedVehicleType,
          items: _vehicleTypes,
          displayStringForOption: (String vehicleType) => vehicleType,
          onChanged: (String newValue) {
            setState(() {
              _selectedVehicleType = newValue;
            });
          },
          itemBuilder: (String vehicleType) {
            return Text(vehicleType);
          },
        ),
        TextFormField(
          decoration: InputDecoration(
            hintText: 'Enter vehicle number',
            labelText: 'Vehicle number',
            floatingLabelBehavior: FloatingLabelBehavior.always,
          ),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          controller: _vehicleNumberController,
          validator: Validator.validateVehicleNumber,
          keyboardType: TextInputType.text,
        ),
        UploadField(
          label: 'Vehicle license',
          hintText: 'Upload license photo',
          file: _licensePhoto,
          onTap: () => _pickImage(true),
        ),
      ],
    );
  }

  Widget _buildEmailAndPhoneSection() {
    return FormSection(
      title: LocaleKeys.auth_apply_account_information.tr(),
      children: [
        TextFormField(
          decoration: InputDecoration(
            hintText: 'Enter your email',
            labelText: 'Email',
            floatingLabelBehavior: FloatingLabelBehavior.always,
          ),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          controller: _emailController,
          validator: Validator.emailValidate,
          keyboardType: TextInputType.emailAddress,
        ),
        TextFormField(
          decoration: InputDecoration(
            hintText: 'Enter phone number',
            labelText: 'Phone number',
            floatingLabelBehavior: FloatingLabelBehavior.always,
          ),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          controller: _phoneController,
          validator: Validator.validateRequired,
          keyboardType: TextInputType.phone,
        ),
      ],
    );
  }

  Widget _buildIdInfoSection() {
    return FormSection(
      title: LocaleKeys.auth_apply_id_number.tr(),
      children: [
        TextFormField(
          decoration: InputDecoration(
            hintText: 'Enter national ID number',
            labelText: 'ID number',
            floatingLabelBehavior: FloatingLabelBehavior.always,
          ),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          controller: _idNumberController,
          validator: Validator.validateRequired,
          keyboardType: TextInputType.number,
        ),
        UploadField(
          label: 'ID image',
          hintText: 'Upload ID image',
          file: _idPhoto,
          onTap: () => _pickImage(false),
        ),
      ],
    );
  }

  Widget _buildAccountInfoSection() {
    return FormSection(
      title: LocaleKeys.auth_apply_account_information.tr(),
      children: [
        TextFormField(
          decoration: InputDecoration(
            hintText: 'Enter password',
            labelText: 'Password',
            floatingLabelBehavior: FloatingLabelBehavior.always,
          ),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          controller: _passwordController,
          validator: Validator.passwordValidation,
          obscureText: true,
          keyboardType: TextInputType.visiblePassword,
        ),
        TextFormField(
          decoration: InputDecoration(
            hintText: 'Confirm password',
            labelText: 'Confirm password',
            floatingLabelBehavior: FloatingLabelBehavior.always,
          ),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          controller: _confirmPasswordController,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return LocaleKeys.validation_required.tr();
            }
            if (value != _passwordController.text) {
              return LocaleKeys.validation_passwordMatch.tr();
            }
            return null;
          },
          obscureText: true,
          keyboardType: TextInputType.visiblePassword,
        ),
      ],
    );
  }

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

  Widget _buildSubmitButton() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ElevatedButton(
          onPressed: _isSubmitting ? null : _submitForm,
          child: _isSubmitting
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
        ),
      ],
    );
  }

  bool _validateForm() {
    if (!_formKey.currentState!.validate()) {
      return false;
    }

    if (_licensePhoto == null || _idPhoto == null) {
      GetIt.I<DialogUtils>().showSnackBar(
        textColor: Colors.white,
        message: LocaleKeys.auth_apply_upload_required_files.tr(),
        context: context,
      );
      return false;
    }

    return true;
  }

  void _setLoading(bool isLoading) {
    setState(() {
      _isSubmitting = isLoading;
    });
  }

  Future<void> _submitForm() async {
    if (!_validateForm()) return;

    _setLoading(true);

    final entity = ApplyEntity.fromFormData(
      firstName: _firstNameController.text,
      lastName: _lastNameController.text,
      email: _emailController.text,
      phone: _phoneController.text,
      countryCode: _selectedCountry?.phoneCode ?? '+20',
      gender: _gender,
      vehicleType: _selectedVehicleType ?? 'Car',
      vehicleNumber: _vehicleNumberController.text,
      idNumber: _idNumberController.text,
      password: _passwordController.text,
      licensePhoto: _licensePhoto,
      idPhoto: _idPhoto,
    );

    context.read<AuthCubit>().apply(entity);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listenWhen: (previous, current) =>
          previous.applyState != current.applyState,
      listener: (context, state) {
        if (state.applyState is BaseLoadingState) {
          setState(() {
            _isSubmitting = true;
          });
        } else if (state.applyState is BaseSuccessState) {
          setState(() {
            _isSubmitting = false;
          });
          Navigator.pushReplacementNamed(
            context,
            Routes.successApply,
          );
        } else if (state.applyState is BaseErrorState) {
          setState(() {
            _isSubmitting = false;
          });
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
        body: _buildBody(),
      ),
    );
  }
}
