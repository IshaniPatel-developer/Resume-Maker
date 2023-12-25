import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../model/education_info_model.dart';

class EducationInfoWidget extends StatefulWidget {
  final EducationInfoModel resumeItem;
  final int index;

  const EducationInfoWidget({required this.resumeItem, required this.index});

  @override
  _EducationInfoWidgetState createState() => _EducationInfoWidgetState();
}

class _EducationInfoWidgetState extends State<EducationInfoWidget> {
  late TextEditingController courseController;
  late TextEditingController institutionController;
  late TextEditingController dateController;

  @override
  void initState() {
    super.initState();
    courseController = TextEditingController(
        text: widget.resumeItem.educationData[widget.index].course);
    institutionController = TextEditingController(
        text: widget.resumeItem.educationData[widget.index].institution);
    dateController = TextEditingController(
        text: widget.resumeItem.educationData[widget.index].date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Education Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [

              TextField(
                controller: courseController,
                decoration: const InputDecoration(
                  labelText: 'Course',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: institutionController,
                decoration: const InputDecoration(
                  labelText: 'Institute',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: dateController,
                decoration: const InputDecoration(
                  labelText: 'Date or Date Range',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  final EducationInfoModel updatedEducationInfo;
                  updatedEducationInfo = widget.resumeItem;
                  updatedEducationInfo.educationData[widget.index] = EducationData(
                    course: courseController.text,
                    institution: institutionController.text,
                    date: dateController.text,
                  );
          
                  Navigator.pop(
                    context,
                    updatedEducationInfo,
                  );
                },
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
