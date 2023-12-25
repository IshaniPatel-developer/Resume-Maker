import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'basic info/model/basic_info_model.dart';
import 'basic info/widget/basic_info_widget.dart';
import 'education info/model/education_info_model.dart';
import 'education info/widget/education_info_widget.dart';
import 'enum.dart';

class ResumeBuilder extends StatefulWidget {
  const ResumeBuilder({super.key});

  @override
  _ResumeBuilderState createState() => _ResumeBuilderState();
}

class _ResumeBuilderState extends State<ResumeBuilder> {
  late BasicInfoModel basicInfo;
  late EducationInfoModel educationInfo;
  List<ResumeSection> resumeSection = [];
  List<ResumeSection> allSection = [
    ResumeSection.basic,
    ResumeSection.education
  ];

  void _addResumeItem() {
    setState(() {
      if (resumeSection.isEmpty) {
        resumeSection.add(ResumeSection.basic);
        basicInfo = BasicInfoModel(fullName: 'Name', summary: '', email: '');
      } else if (resumeSection.length != allSection.length) {
        allSection.forEach((element) {
          if (!resumeSection.contains(element)) {
            resumeSection.add(element);

            if (element == ResumeSection.basic) {
              basicInfo =
                  BasicInfoModel(fullName: 'Name', summary: '', email: '');
            } else if (element == ResumeSection.education) {
              educationInfo = EducationInfoModel(educationData: [
                EducationData(
                  course: 'Education',
                  institution: '',
                  date: '',
                )
              ]);
            }
          }
        });
      }
    });
  }

  void _updateResumeItem(
      {BasicInfoModel? basicInfoModel,
      EducationInfoModel? educationInfoModel}) {
    setState(() {
      if (basicInfoModel != null) {
        basicInfo = basicInfoModel;
      }

      if (educationInfoModel != null) {
        educationInfo = educationInfoModel;
      }
    });
  }

  void _generatePDF() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resume Builder'),
      ),
      body: ListView.builder(
        itemCount: resumeSection.length,
        itemBuilder: (context, index) {
          return getSectionCardWidget(resumeSection[index]);
        },
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: _addResumeItem,
            tooltip: 'Add Item',
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            onPressed: _generatePDF,
            tooltip: 'Generate PDF',
            child: const Icon(Icons.picture_as_pdf),
          ),
        ],
      ),
    );
  }

  Widget getSectionCardWidget(ResumeSection section) {
    if (section == ResumeSection.basic) {
      return GestureDetector(
        onTap: () {
          _navigateToEditScreen(section);
        },
        child: Material(
          elevation: 1,
          child: Container(
            margin: const EdgeInsets.all(15.0),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(8),
            ),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                basicInfo.fullName,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(
                height: 2,
              ),
              Text(basicInfo.email),
              const SizedBox(
                height: 2,
              ),
              Text(basicInfo.summary)
            ]),
          ),
        ),
      );
    }

    if (section == ResumeSection.education) {
      return Container(
        width: double.infinity,
        margin: const EdgeInsets.all(15.0),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Expanded(
            child: ListView.builder(
          shrinkWrap: true, // 1st add
          physics: const ClampingScrollPhysics(),
          itemCount: educationInfo.educationData.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                _navigateToEditScreen(section, index: index);
              },
              child: Material(
                elevation: 1,
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        margin: const EdgeInsets.all(15.0),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                educationInfo.educationData[index].course,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              const SizedBox(
                                height: 2,
                              ),
                              Text(
                                  educationInfo.educationData[index].institution),
                              const SizedBox(
                                height: 2,
                              ),
                              Text(educationInfo.educationData[index].date)
                            ]),
                      ),
                    ),
                    Visibility(visible: educationInfo.educationData.length == index + 1,
                      child: GestureDetector(onTap: () {
                        setState(() {
                          educationInfo.educationData.add(EducationData(
                            course: 'Education',
                            institution: '',
                            date: '',
                          ));
                        });
                      },
                        child: SizedBox(
                          child: Container(
                              height: 30,
                              width: 30,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.blueAccent),
                              child: const Icon(
                                Icons.add,
                                color: Colors.white,
                                size: 15.0,
                                semanticLabel: 'Add a new item',
                              )),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    )
                  ],
                ),
              ),
            );
          },
        )),
      );
    }

    return Container();
  }

  void _navigateToEditScreen(ResumeSection? section, {int? index}) async {
    if (section == ResumeSection.basic) {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BasicInfoWidget(
            resumeItem: basicInfo,
          ),
        ),
      );

      if (result != null) {
        if (section == ResumeSection.basic) {
          _updateResumeItem(basicInfoModel: result);
        }
      }
    } else if (section == ResumeSection.education) {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EducationInfoWidget(
            resumeItem: educationInfo,
            index: index ?? 0,
          ),
        ),
      );

      if (result != null) {
        if (section == ResumeSection.education) {
          _updateResumeItem(educationInfoModel: result,);
        }
      }
    }
  }
}
