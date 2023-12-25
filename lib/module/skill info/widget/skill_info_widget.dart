import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../model/skill_info_model.dart';

class SkillInfoWidget extends StatefulWidget {

  final SkillInfoModel resumeItem;
  final int index;

  const SkillInfoWidget({required this.resumeItem, required this.index});

  @override
  _SkillInfoWidgetState createState() => _SkillInfoWidgetState();
}

class _SkillInfoWidgetState extends State<SkillInfoWidget> {
  late TextEditingController skillsController;


  @override
  void initState() {
    super.initState();
    skillsController = TextEditingController(
        text: widget.resumeItem.skillList[widget.index]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Skill'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: skillsController,
                decoration: const InputDecoration(
                  labelText: 'Skill',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  final SkillInfoModel updatedSkillInfo;
          
                  updatedSkillInfo = widget.resumeItem;
          
                  updatedSkillInfo.skillList[widget.index] = skillsController.text;
          
                  Navigator.pop(
                    context,
                    updatedSkillInfo,
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
