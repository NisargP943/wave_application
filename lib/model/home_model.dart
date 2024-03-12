import 'package:wave_app/generated/assets.dart';

class HomeModel {
  String image;
  String name;

  HomeModel(this.image, this.name);
}

List<HomeModel> homeModelList = [
  HomeModel("http://kalasampurna.com/wavetech/webimages/home11.png",
      "Electronics Service"),
  HomeModel(Assets.imagesImageTwo, "Health Care"),
  HomeModel(Assets.imagesImageThree, "Event Organizer"),
  HomeModel(Assets.imagesImageFour, "Electronics Service"),
  HomeModel(Assets.imagesImageFive, "Plumbers"),
];
