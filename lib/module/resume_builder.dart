import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'basic info/model/basic_info_model.dart';
import 'basic info/widget/basic_info_widget.dart';
import 'common/pdf_generator.dart';
import 'education info/model/education_info_model.dart';
import 'education info/widget/education_info_widget.dart';
import 'common/enum.dart';
import 'experience info/model/experience_info_model.dart';
import 'experience info/widget/education_info_widget.dart';

class ResumeBuilder extends StatefulWidget {
  const ResumeBuilder({super.key});

  @override
  _ResumeBuilderState createState() => _ResumeBuilderState();
}

class _ResumeBuilderState extends State<ResumeBuilder> {
  late BasicInfoModel basicInfo;
  late EducationInfoModel educationInfo;
  late ExperienceInfoModel experienceInfo;

  List<ResumeSection> resumeSection = []; // final result
  List<ResumeSection> allSection = [
    ResumeSection.basic,
    ResumeSection.education,
    ResumeSection.experience
  ];

  void _addResumeItem() {
    setState(() {
      if (resumeSection.isEmpty) {
        resumeSection.add(ResumeSection.basic);
        basicInfo = BasicInfoModel(fullName: 'Name', summary: '', email: '');
      } else if (resumeSection.length != allSection.length) {
        for (var element in allSection) {
          if (!resumeSection.contains(element)) {
            resumeSection.add(element);

            if (element == ResumeSection.basic) {
              basicInfo =
                  BasicInfoModel(fullName: 'Name', summary: '', email: '');
              break;
            } else if (element == ResumeSection.education) {
              educationInfo = EducationInfoModel(educationData: [
                EducationData(
                  course: 'Education',
                  institution: '',
                  date: '',
                )
              ]);
              break;
            } else if (element == ResumeSection.experience) {
              experienceInfo = ExperienceInfoModel(experienceData: [
                ExperienceData(
                  course: 'Experience',
                  institution: '',
                  date: '',
                )
              ]);
              break;
            }
          }
        }
      }
    });
  }

  void _updateResumeItem(
      {BasicInfoModel? basicInfoModel,
      EducationInfoModel? educationInfoModel,
        ExperienceInfoModel? experienceInfoModel,
      }) {
    setState(() {
      if (basicInfoModel != null) {
        basicInfo = basicInfoModel;
      }

      if (educationInfoModel != null) {
        educationInfo = educationInfoModel;
      }

      if (experienceInfoModel != null) {
        experienceInfo = experienceInfoModel;
      }
    });
  }

  void _generatePDF() async {
    final pdfBytes = await PDFGenerator.generatePDF(basicInfoModel: basicInfo, educationInfoModel: educationInfo, experienceInfoModel: experienceInfo);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resume Builder'),
      ),
      body: ListView.builder(
        itemCount: resumeSection.length,
        itemBuilder: (context, index) {
          return getSectionCardWidget(resumeSection[index], index);
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

  Widget getSectionCardWidget(ResumeSection section, int mainindex) {
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
      return Row(
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
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                                  const SizedBox(
                                    height: 2,
                                  ),
                                  Text(educationInfo
                                      .educationData[index].institution),
                                  const SizedBox(
                                    height: 2,
                                  ),
                                  Text(educationInfo.educationData[index].date)
                                ]),
                          ),
                        ),
                        Visibility(
                          visible:
                              educationInfo.educationData.length == index + 1,
                          child: GestureDetector(
                            onTap: () {
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
          )),
          upDownButton(mainindex),
          const SizedBox(
            width: 5,
          )
        ],
      );
    }

    if (section == ResumeSection.experience) {
      return Row(
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
                child: Expanded(
                    child: ListView.builder(
                      shrinkWrap: true, // 1st add
                      physics: const ClampingScrollPhysics(),
                      itemCount: experienceInfo.experienceData.length,
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
                                            experienceInfo.experienceData[index].course,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18),
                                          ),
                                          const SizedBox(
                                            height: 2,
                                          ),
                                          Text(experienceInfo.experienceData[index].institution),
                                          const SizedBox(
                                            height: 2,
                                          ),
                                          Text(experienceInfo.experienceData[index].date)
                                        ]),
                                  ),
                                ),
                                Visibility(
                                  visible:
                                  experienceInfo.experienceData.length == index + 1,
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        experienceInfo.experienceData.add(ExperienceData(
                                          course: 'Experience',
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
              )),
          upDownButton(mainindex),
          const SizedBox(
            width: 5,
          )
        ],
      );
    }

    return Container();
  }

  Widget upDownButton(int mainindex) {
    return Column(
      children: [
        Visibility(visible: resumeSection[mainindex - 1] != ResumeSection.basic,
            child: GestureDetector(onTap: () {
              moveItem(mainindex, Direction.up);
            },
              child: SizedBox(
                child: Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.blueAccent),
                    child: const Icon(
                      Icons.arrow_upward,
                      color: Colors.white,
                      size: 15.0,
                      semanticLabel: 'Add a new item',
                    )),
              ),
            )),

        Visibility(visible: resumeSection[mainindex - 1] != ResumeSection.basic,
          child: const SizedBox(
            height: 5,
          ),
        ),

        Visibility(visible: resumeSection.length != mainindex + 1,
          child: GestureDetector(onTap: () {
            moveItem(mainindex, Direction.down);
          },
            child: SizedBox(
              child: Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.blueAccent),
                  child: const Icon(
                    Icons.arrow_downward,
                    color: Colors.white,
                    size: 15.0,
                    semanticLabel: 'Add a new item',
                  )),
            ),
          ),
        )
      ],
    );
  }


  void moveItem(int index, Direction direction) {
    if (index < 0 || index >= resumeSection.length) {
      print('Invalid index');
      return;
    }

    setState(() {
      if (direction == Direction.up && index > 0) {
        // Swap the item with the one above it
        ResumeSection temp = resumeSection[index];
        resumeSection[index] = resumeSection[index - 1];
        resumeSection[index - 1] = temp;
      } else if (direction == Direction.down && index < resumeSection.length - 1) {
        // Swap the item with the one below it
        ResumeSection temp = resumeSection[index];
        resumeSection[index] = resumeSection[index + 1];
        resumeSection[index + 1] = temp;
      }
    });
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
          _updateResumeItem(
            educationInfoModel: result,
          );
        }
      }
    }  else if (section == ResumeSection.experience) {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ExperienceInfoWidget(
            resumeItem: experienceInfo,
            index: index ?? 0,
          ),
        ),
      );

      if (result != null) {
        if (section == ResumeSection.experience) {
          _updateResumeItem(
            experienceInfoModel: result,
          );
        }
      }
    }
  }
}
