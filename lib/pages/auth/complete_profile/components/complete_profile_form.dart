import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:sizer/sizer.dart';

import '../../../../business_logic/artisan/register_new_user/register_new_user_bloc.dart';
import '../../../../constants.dart';
import '../../../../data_artisan/model/register_new_user/register_new_user_request_model.dart';
import '../../../../widgets/custom_snack_bar.dart';
import '../../../../widgets/rise_button.dart';
import '../../../user/home/account_type_selection.dart';

class CompleteProfileForm extends StatefulWidget {
  const CompleteProfileForm({Key? key, required this.phoneNumber})
      : super(key: key);
  final String phoneNumber;

  @override
  State<StatefulWidget> createState() {
    return CompleteProfileFormState();
  }
}

class CompleteProfileFormState extends State<CompleteProfileForm> {
  static final _formKey = GlobalKey<FormState>();

  bool checked = false;

  bool switchStatus = false;

  bool _isHidden = true;
  bool _isHiddenConfirmPassword = true;

  void _togglePasswordView() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  void _toggleConfirmPasswordView() {
    setState(() {
      _isHiddenConfirmPassword = !_isHiddenConfirmPassword;
    });
  }

  static final TextEditingController emailEditingController =
      TextEditingController();
  static final TextEditingController fullNameEditingController =
      TextEditingController();
  static final TextEditingController passwordEditingController =
      TextEditingController();
  static final TextEditingController confirmPasswordEditingController =
      TextEditingController();
  static final TextEditingController refEditingController =
      TextEditingController();

  List<String> accountTypeList = [
    "Vendor",
    "Artisan",
  ];
  var selectedAccountType;

  RegisterNewUserRequest? registerNewUserRequest;

  @override
  initState() {
    registerNewUserRequest = RegisterNewUserRequest();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SizedBox(height: 16.0),
        //const TextFieldName(text: "Email Address"),
        TextFormField(
          controller: emailEditingController,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            hintText: "Email Address",
            hintStyle: TextStyle(
              color: const Color(0xffb5b5b5).withOpacity(0.5),
              fontWeight: FontWeight.w500,
              fontSize: 12.sp,
              // fontFamily: 'Outfit',
            ),
            fillColor: grayColor.withOpacity(0.27),
            filled: true,
            isDense: true,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 18.0),
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(50.0),
              ),
            ),
            // If  you are using latest version of flutter then lable text and hint text shown like this
            // if you r using flutter less then 1.20.* then maybe this is not working properly
          ),
          validator: emailValidator,
          onSaved: (email) => registerNewUserRequest!.email = email!,
        ),
        const SizedBox(height: 20.0),
        TextFormField(
          controller: fullNameEditingController,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            hintText: "Full Name",
            hintStyle: TextStyle(
              // fontFamily: 'Outfit',
              color: const Color(0xffb5b5b5).withOpacity(0.5),
              fontWeight: FontWeight.w500,
              fontSize: 12.sp,
            ),
            fillColor: grayColor.withOpacity(0.27),
            filled: true,
            isDense: true,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 18.0),
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(50.0),
              ),
            ),
            // If  you are using latest version of flutter then lable text and hint text shown like this
            // if you r using flutter less then 1.20.* then maybe this is not working properly
          ),
          validator: RequiredValidator(errorText: "fullname is required"),
          onSaved: (username) => registerNewUserRequest!.fullName = username!,
        ),
        const SizedBox(height: 20.0),
        //const TextFieldName(text: "Password"),
        TextFormField(
          decoration: InputDecoration(
            hintText: "Password",
            hintStyle: TextStyle(
              // fontFamily: 'Outfit',
              color: const Color(0xffb5b5b5).withOpacity(0.5),
              fontWeight: FontWeight.w500,
              fontSize: 12.sp,
            ),
            suffixIcon: InkWell(
              onTap: _togglePasswordView,
              child: Icon(
                _isHidden ? Icons.visibility_off : Icons.visibility,
                color: _isHidden ? Colors.grey : primaryColor,
              ),
            ),
            fillColor: grayColor.withOpacity(0.27),
            filled: true,
            isDense: true,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 18.0),
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(50.0),
              ),
            ),
            // If  you are using latest version of flutter then lable text and hint text shown like this
            // if you r using flutter less then 1.20.* then maybe this is not working properly
          ),
          controller: passwordEditingController,
          obscureText: _isHidden,
          validator: passwordValidator,
          onSaved: (password) => registerNewUserRequest!.password = password!,
        ),
        const SizedBox(height: 20.0),
        // const TextFieldName(text: "Confirm Password"),
        TextFormField(
          decoration: InputDecoration(
            hintText: "Re-enter passwword",
            hintStyle: TextStyle(
              color: const Color(0xffb5b5b5).withOpacity(0.5),
              fontWeight: FontWeight.w500,
              fontSize: 12.sp,
              // fontFamily: 'Outfit',
            ),
            suffixIcon: InkWell(
              onTap: _toggleConfirmPasswordView,
              child: Icon(
                _isHiddenConfirmPassword
                    ? Icons.visibility_off
                    : Icons.visibility,
                color: _isHiddenConfirmPassword ? Colors.grey : primaryColor,
              ),
            ),
            fillColor: grayColor.withOpacity(0.27),
            filled: true,
            isDense: true,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 18.0),
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(50.0),
              ),
            ),
            // If  you are using latest version of flutter then lable text and hint text shown like this
            // if you r using flutter less then 1.20.* then maybe this is not working properly
          ),
          controller: confirmPasswordEditingController,
          obscureText: _isHiddenConfirmPassword,
          onSaved: (password) =>
              registerNewUserRequest!.passwordConfirmation = password!,
          validator: (pass) =>
              MatchValidator(errorText: "Password do not match")
                  .validateMatch(pass!, passwordEditingController.text),
        ),
        // const SizedBox(height: 20.0),
        // Container(
        //   padding:
        //       const EdgeInsets.only(left: 16, right: 16, top: 3, bottom: 3),
        //   decoration: BoxDecoration(
        //       color: grayColor.withOpacity(0.29),
        //       borderRadius: BorderRadius.circular(50.0)),
        //   child: DropdownButton(
        //     hint: Text(
        //       "Choose Account type",
        //       style: TextStyle(
        //           // fontFamily: 'Outfit',
        //           color: grayColor.withOpacity(0.9)),
        //     ),
        //     dropdownColor: Colors.white,
        //     icon: const Icon(Icons.arrow_drop_down),
        //     iconSize: 22,
        //     isExpanded: true,
        //     underline: const SizedBox(),
        //     style: const TextStyle(color: Colors.black, fontSize: 16),
        //     value: selectedAccountType,
        //     onChanged: (newValue) {
        //       setState(() {
        //         selectedAccountType = newValue;
        //       });
        //     },
        //     items: accountTypeList.map<DropdownMenuItem<String>>((valueItem) {
        //       return DropdownMenuItem(
        //         value: valueItem,
        //         child: Text(valueItem),
        //       );
        //     }).toList(),
        //   ),
        // ),
        // const SizedBox(height: 16.0),
        // Row(
        //   crossAxisAlignment: CrossAxisAlignment.start,
        //   mainAxisAlignment: MainAxisAlignment.start,
        //   children: [
        //     SizedBox(
        //       height: 20,
        //       child: Switch(
        //           value: switchStatus,
        //           activeColor: primaryColor,
        //           onChanged: (value) {
        //             setState(() {
        //               switchStatus = value;
        //             });
        //           }),
        //     ),
        //     Text(
        //       "By pressing sign up securely,you agree to \n Terms and Conditions and Privacy Policy.",
        //       style: TextStyle(
        //           color: grayColor,
        //           fontWeight: FontWeight.normal,
        //           fontSize: 12.sp),
        //     ),
        //   ],
        // ),
        SizedBox(
          height: 20,
        ),
        TextFormField(
          controller: refEditingController,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            hintText: "referral code",
            hintStyle: TextStyle(
              color: const Color(0xffb5b5b5).withOpacity(0.5),
              fontWeight: FontWeight.w500,
              fontSize: 12.sp,
              // fontFamily: 'Outfit',
            ),
            fillColor: grayColor.withOpacity(0.27),
            filled: true,
            isDense: true,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 18.0),
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(50.0),
              ),
            ),
            // If  you are using latest version of flutter then lable text and hint text shown like this
            // if you r using flutter less then 1.20.* then maybe this is not working properly
          ),
          // validator: emailValidator,
          // onSaved: (email) => registerNewUserRequest!.email = email!,
        ),
        SizedBox(height: 10.h),
        //button
        SizedBox(
          width: double.infinity,
          child: RiseButton(
            text: "Proceed",
            buttonColor: secondaryColor,
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                // AccountTypeSelection
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AccountTypeSelection(
                          ref: refEditingController.text.toString(),
                              phoneNumber: widget.phoneNumber,
                              email: emailEditingController.text.toString(),
                              fullName:
                                  fullNameEditingController.text.toString(),
                              password:
                                  passwordEditingController.text.toString(),
                              passwordConfirmation:
                                  passwordEditingController.text.toString(),
                            )));
                // registerNewUserRequest!.phoneNumber = widget.phoneNumber;
                // registerNewUserRequest?.userType = selectedAccountType;
                // BlocProvider.of<RegisterNewUserBloc>(context).add(
                //     LoadRegisterNewUserEvent(
                //         requestBody: registerNewUserRequest));
              }
            },
            textColor: primaryColor,
          ),
        ),
        const SizedBox(height: 64.0),
      ]),
    );
  }
}
