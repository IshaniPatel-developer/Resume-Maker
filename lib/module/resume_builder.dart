import 'package:resume/common/pdf_handler.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:resume/module/skill%20info/model/skill_info_model.dart';
import 'package:resume/module/skill%20info/widget/skill_info_widget.dart';
import '../common/enum.dart';
import 'basic info/model/basic_info_model.dart';
import 'basic info/widget/basic_info_widget.dart';
import 'education info/model/education_info_model.dart';
import 'education info/widget/education_info_widget.dart';
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
  late SkillInfoModel skillInfo;

  List<ResumeSection> resumeSection = []; // final result
  List<ResumeSection> allSection = [
    ResumeSection.basic,
    ResumeSection.education,
    ResumeSection.experience,
    ResumeSection.skills
  ];

  //To add new section in resume
  void _addResumeItem() {
    setState(() {
      if (resumeSection.isEmpty) {
        resumeSection.add(ResumeSection.basic);
        basicInfo = BasicInfoModel(fullName: 'Basics', summary: '', email: '');
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
                  designation: 'Experience',
                  organization: '',
                  date: '',
                )
              ]);
              break;
            }else if (element == ResumeSection.skills) {
              skillInfo = SkillInfoModel(skillList: ['Skill']);
              break;
            }
          }
        }
      }
    });
  }

  //To delete section and inner section
  void deleteItem(int index,
      {bool? isDeleteSubChild, ResumeSection? section, int? mainIndex}) {
    if (isDeleteSubChild == true) {
      if (section == ResumeSection.education) {
        if (index >= 0 && index < educationInfo.educationData.length) {
          // Use removeAt to delete the item at the specified index
          setState(() {
            if (educationInfo.educationData.length == 1) {
              deleteItem(mainIndex ?? 0);
            } else {
              educationInfo.educationData.removeAt(index);
            }
          });
        } else {
          // Handle the case where the index is out of bounds
          print("Invalid index to delete");
        }
      } else if (section == ResumeSection.experience) {
        if (index >= 0 && index < experienceInfo.experienceData.length) {
          // Use removeAt to delete the item at the specified index
          setState(() {
            if (experienceInfo.experienceData.length == 1) {
              deleteItem(mainIndex ?? 0);
            } else {
              experienceInfo.experienceData.removeAt(index);
            }
          });
        } else {
          // Handle the case where the index is out of bounds
          print("Invalid index to delete");
        }
      }else if (section == ResumeSection.skills) {
        if (index >= 0 && index < skillInfo.skillList.length) {
          // Use removeAt to delete the item at the specified index
          setState(() {
            if (skillInfo.skillList.length == 1) {
              deleteItem(mainIndex ?? 0);
            } else {
              skillInfo.skillList.removeAt(index);
            }
          });
        } else {
          // Handle the case where the index is out of bounds
          print("Invalid index to delete");
        }
      }
    } else if (index >= 0 && index < resumeSection.length) {
      // Use removeAt to delete the item at the specified index
      setState(() {
        resumeSection.removeAt(index);
      });
    } else {
      // Handle the case where the index is out of bounds
      print("Invalid index to delete");
    }
  }

  //To update resume data
  void _updateResumeItem({
    BasicInfoModel? basicInfoModel,
    EducationInfoModel? educationInfoModel,
    ExperienceInfoModel? experienceInfoModel,
    SkillInfoModel? skillInfoModel
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

      if (skillInfoModel != null) {
        skillInfo = skillInfoModel;
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Resume Builder'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: resumeSection.length,
              itemBuilder: (context, index) {
                return getSectionCardWidget(resumeSection[index], index);
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: _addResumeItem,
                  child: Container(
                      decoration: BoxDecoration(
                          color: Colors.blueAccent,
                          borderRadius: BorderRadius.all(Radius.circular(8))
                      ),
                    height: 50,

                      width: (MediaQuery.of(context).size.width / 2 )- 20,
                      child: const Icon(Icons.add,color: Colors.white,)),
                ),
                InkWell(
                  onTap: (){
                    PDFHandler.createPDF(
                        resumeSection, basicInfo, educationInfo, experienceInfo , skillInfo);
                  },
                  child: Container(
                      decoration: BoxDecoration(
                          color: Colors.blueAccent,
                          borderRadius: BorderRadius.all(Radius.circular(8))
                      ),
                      height: 50,
                      width: (MediaQuery.of(context).size.width / 2 )- 20 ,
                      child: const Icon(Icons.picture_as_pdf,color: Colors.white,)),
                )

              ],
            ),
          )
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
                    "Basics",
                    style:
                    const TextStyle(fontWeight: FontWeight.normal, fontSize: 12),
                  ),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Education",
                      style:
                      const TextStyle(fontWeight: FontWeight.normal, fontSize: 12),
                    ),
                    ListView.builder(
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
                                Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        deleteItem(index,
                                            isDeleteSubChild: true,
                                            section: ResumeSection.education,
                                            mainIndex: mainindex);
                                      },
                                      child: SizedBox(
                                        child: Container(
                                            height: 30,
                                            width: 30,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(8),
                                                color: Colors.redAccent),
                                            child: const Icon(
                                              Icons.delete,
                                              color: Colors.white,
                                              size: 15.0,
                                              semanticLabel: 'Add a new item',
                                            )),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Visibility(
                                      visible: educationInfo.educationData.length ==
                                          index + 1,
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            educationInfo.educationData
                                                .add(EducationData(
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
                                                  borderRadius:
                                                  BorderRadius.circular(8),
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
                                  ],
                                ),
                                const SizedBox(
                                  width: 5,
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    )
                  ],
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Experience",
                      style:
                      const TextStyle(fontWeight: FontWeight.normal, fontSize: 12),
                    ),

                  ListView.builder(
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
                                            experienceInfo
                                                .experienceData[index].designation,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18),
                                          ),
                                          const SizedBox(
                                            height: 2,
                                          ),
                                          Text(experienceInfo
                                              .experienceData[index].organization),
                                          const SizedBox(
                                            height: 2,
                                          ),
                                          Text(
                                              experienceInfo.experienceData[index].date)
                                        ]),
                                  ),
                                ),
                                Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        deleteItem(index,
                                            isDeleteSubChild: true,
                                            section: ResumeSection.experience,
                                            mainIndex: mainindex);
                                      },
                                      child: SizedBox(
                                        child: Container(
                                            height: 30,
                                            width: 30,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(8),
                                                color: Colors.redAccent),
                                            child: const Icon(
                                              Icons.delete,
                                              color: Colors.white,
                                              size: 15.0,
                                              semanticLabel: 'Add a new item',
                                            )),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Visibility(
                                      visible: experienceInfo.experienceData.length ==
                                          index + 1,
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            experienceInfo.experienceData
                                                .add(ExperienceData(
                                              designation: 'Experience',
                                              organization: '',
                                              date: '',
                                            ));
                                          });
                                        },
                                        child: SizedBox(
                                          child: Container(
                                              height: 30,
                                              width: 30,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                  BorderRadius.circular(8),
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
                                  ],
                                ),
                                const SizedBox(
                                  width: 5,
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    )
                  ],
                )),
          )),
          upDownButton(mainindex),
          const SizedBox(
            width: 5,
          )
        ],
      );
    }

    if (section == ResumeSection.skills) {
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
                    child:Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Skills",
                          style:
                          const TextStyle(fontWeight: FontWeight.normal, fontSize: 12),
                        ),
                        ListView.builder(
                          shrinkWrap: true, // 1st add
                          physics: const ClampingScrollPhysics(),
                          itemCount: skillInfo.skillList.length,
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
                                                skillInfo.skillList[index],
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18),
                                              ),
                                            ]),
                                      ),
                                    ),
                                    Column(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            deleteItem(index,
                                                isDeleteSubChild: true,
                                                section: ResumeSection.skills,
                                                mainIndex: mainindex);
                                          },
                                          child: SizedBox(
                                            child: Container(
                                                height: 30,
                                                width: 30,
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(8),
                                                    color: Colors.redAccent),
                                                child: const Icon(
                                                  Icons.delete,
                                                  color: Colors.white,
                                                  size: 15.0,
                                                  semanticLabel: 'Add a new item',
                                                )),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Visibility(
                                          visible:  skillInfo.skillList.length ==
                                              index + 1,
                                          child: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                skillInfo.skillList.add("Skill");
                                              });
                                            },
                                            child: SizedBox(
                                              child: Container(
                                                  height: 30,
                                                  width: 30,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                      BorderRadius.circular(8),
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
                                      ],
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        )
                      ],
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

  //Build Button widget for updown swap
  Widget upDownButton(int mainindex) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            deleteItem(mainindex);
          },
          child: SizedBox(
            child: Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.redAccent),
                child: const Icon(
                  Icons.delete,
                  color: Colors.white,
                  size: 15.0,
                  semanticLabel: 'Add a new item',
                )),
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        Visibility(
            visible: resumeSection[mainindex - 1] != ResumeSection.basic,
            child: GestureDetector(
              onTap: () {
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
        Visibility(
          visible: resumeSection[mainindex - 1] != ResumeSection.basic,
          child: const SizedBox(
            height: 5,
          ),
        ),
        Visibility(
          visible: resumeSection.length != mainindex + 1,
          child: GestureDetector(
            onTap: () {
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

  //To swap sections
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
      } else if (direction == Direction.down &&
          index < resumeSection.length - 1) {
        // Swap the item with the one below it
        ResumeSection temp = resumeSection[index];
        resumeSection[index] = resumeSection[index + 1];
        resumeSection[index + 1] = temp;
      }
    });
  }

  //To navigate screen
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
    } else if (section == ResumeSection.experience) {
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
    }else if (section == ResumeSection.skills) {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SkillInfoWidget(resumeItem: skillInfo, index: index ?? 0)
        ),
      );

      if (result != null) {
        if (section == ResumeSection.skills) {
          _updateResumeItem(
            skillInfoModel: result,
          );
        }
      }
    }
  }
}
