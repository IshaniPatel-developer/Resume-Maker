class ExperienceInfoModel {
  List<ExperienceData> experienceData;

  ExperienceInfoModel({required this.experienceData});
}

class ExperienceData {
  String designation;
  String organization;
  String date;

  ExperienceData({required this.designation, required this.organization, required this.date});
}