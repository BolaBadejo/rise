class OnBoardingContentModel {
  String image;
  String title;
  String description;
  String tAndC;

  OnBoardingContentModel(
      {required this.image,
      required this.title,
      required this.description,
      required this.tAndC});
}

List<OnBoardingContentModel> contents = [
  OnBoardingContentModel(
      image: "assets/images/one.png",
      title: "Earn More on Rise",
      description:
          "Refer 3 businesses/ users\n and earnup to N5000 in Rise\n credit.",
      tAndC: "T&Cs apply"),
  OnBoardingContentModel(
      image: "assets/images/two.png",
      title: "Earn More on Rise",
      description:
          "Refer 3 businesses/ users\n and earnup to N5000 in Rise\n credit.",
      tAndC: "T&Cs apply"),
  OnBoardingContentModel(
      image: "assets/images/three.png",
      title: "Earn More on Rise",
      description:
          "Refer 3 businesses/ users\n and earnup to N5000 in Rise\n credit.",
      tAndC: "T&Cs apply"),
];
