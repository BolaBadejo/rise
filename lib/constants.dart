import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:sizer/sizer.dart';

const primaryColor = Color(0xFFA30218);
//const primaryColor = Color(0xFFB70019);
//const secondaryColor = Color(0xFFFF6B00);
const secondaryColor = Color(0xFFFFBF00);
const blackColor = Color(0xFF201E1E);
const grayColor = Color(0xFFc4c4c4);
const whiteColor = Color(0xFFffffff);
const greenColor = Color(0xFF4FCD54);

const defaultPadding = 16.0;
const onBoardingBigTextSize = 27.0;
const onBoardingSubTextSize = 20.0;
const bigTextSize = 24.0;
const mediumTextSize = 16.0;

const kycInfo =
    "You must be employed or self-employed with a proven source of income for the past 9 months."
    "If you are self-employed, you are required to have a steady daily or weekly source of income for the past 9months.\n\n"
    "If you are employed, you are required to have a consistent monthly income for the past 9 months i.e.\n\n"
    "Your payment date should be consistent As an employee with a private organization, you are required to have a domain-based email of your organization.";

final emailValidator = MultiValidator(
  [
    RequiredValidator(errorText: 'email is required'),
    EmailValidator(errorText: "Use a valid email!")
  ],
);

final passwordValidator = MultiValidator(
  [
    RequiredValidator(errorText: 'password is required'),
    MinLengthValidator(8, errorText: 'password must be at least 8 digits long'),
    // PatternValidator(r'(?=.*?[#?!@$%^&*-])',
    //     errorText: 'passwords must have at least one special character')
  ],
);

final phoneNumberValidator = MultiValidator(
  [
    RequiredValidator(errorText: 'phone is required'),
    MinLengthValidator(11,
        errorText: 'phone number must be at least 11 digits long'),
    // PatternValidator(r'(?=.*?[#?!@$%^&*-])',
    //     errorText: 'passwords must have at least one special character')
  ],
);

final tokenValidator = MultiValidator(
  [
    RequiredValidator(errorText: 'token is required'),
    MinLengthValidator(6,
        errorText: 'token should not be more than 6 digits long'),
    // PatternValidator(r'(?=.*?[#?!@$%^&*-])',
    //     errorText: 'passwords must have at least one special character')
  ],
);

// const apiBaseUrl = "http://178.62.29.92";
const testUrl = "178.62.29.92/api";
const apiBaseUrl = "https://admin.rise.ng/api";
const mapApiKey = "AIzaSyCKSLC39xq_jZaQ_J65K9FItsFrXWSz1PA";

List<String> listingCategoryList = [
  "Painters",
  "Electrician",
  "Fashion Designing",
  "Welder",
  "Vulcaniser",
  "Tailor",
  "Chef",
  "Plumber",
  "Mechanic",
  "Cleaning services",
  "Bartender",
  "Ushering services",
  "Interior decorations",
  "Makeup artist",
  "Graphics design",
  "Printing",
  "Generator repairs",
  "Hair making",
  "Upholstery",
  "Nails technician",
  "Food vendors",
  "Delivery company",
  "Cosmetics",
  "Laptop repairs",
  "Bricklaying",
  "Computer engineering",
  "Event decorations",
  "Tiling",
  "Gas vendor",
  "Carpenter",
  "Photographer",
  "Dstv installer",
  "Others",
];
