class ExperienceInfoModel {
  List<ExperienceData> experienceData;

  ExperienceInfoModel({required this.experienceData});
}

class ExperienceData {
  String course;
  String institution;
  String date;

  ExperienceData({required this.course, required this.institution, required this.date});
}