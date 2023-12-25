class EducationInfoModel {
  List<EducationData> educationData;

  EducationInfoModel({required this.educationData});
}

class EducationData {
  String course;
  String institution;
  String date;

  EducationData({required this.course, required this.institution, required this.date});
}