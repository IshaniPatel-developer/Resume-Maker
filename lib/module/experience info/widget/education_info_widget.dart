import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../model/experience_info_model.dart';

class ExperienceInfoWidget extends StatefulWidget {
  final ExperienceInfoModel resumeItem;
  final int index;

  const ExperienceInfoWidget({required this.resumeItem, required this.index});

  @override
  _ExperienceInfoWidgetState createState() => _ExperienceInfoWidgetState();
}

class _ExperienceInfoWidgetState extends State<ExperienceInfoWidget> {
  late TextEditingController designationController;
  late TextEditingController organizationController;
  late TextEditingController dateController;

  @override
  void initState() {
    super.initState();
    designationController = TextEditingController(
        text: widget.resumeItem.experienceData[widget.index].designation);
    organizationController = TextEditingController(
        text: widget.resumeItem.experienceData[widget.index].organization);
    dateController = TextEditingController(
        text: widget.resumeItem.experienceData[widget.index].date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Experience Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: designationController,
                decoration: const InputDecoration(
                  labelText: 'Designation',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: organizationController,
                decoration: const InputDecoration(
                  labelText: 'Organization',
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
                  final ExperienceInfoModel updatedEducationInfo;
          
                  updatedEducationInfo = widget.resumeItem;
          
                  updatedEducationInfo.experienceData[widget.index] = ExperienceData(
                    designation: designationController.text,
                    organization: organizationController.text,
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
