
class OnBoardingContentModel {
  String image;
  String title;
  String description;

  OnBoardingContentModel(
      {required this.image, required this.title, required this.description});
}

List<OnBoardingContentModel> contents = [
  OnBoardingContentModel(
      image: "assets/images/one.png",
      title: "Smart & Reliable way to Find Artisans / Vendors",
      description:
          "Get access to verified and efficient artisans / vendors at the click of a button."),
  OnBoardingContentModel(
      image: "assets/images/two.png",
      title: "Go Digital",
      description: "Harness Rise’s digital power to\nscale up your business."),
  OnBoardingContentModel(
      image: "assets/images/three.png",
      title: "Earn More on Rise",
      description:
          "Refer 3 businesses / users and earn\nup to N5000 in Rise credit.\nT&Cs apply "),
];

