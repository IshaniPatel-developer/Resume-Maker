import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'basic info/model/basic_info_model.dart';
import 'basic info/widget/basic_info_widget.dart';
import 'enum.dart';

class ResumeBuilder extends StatefulWidget {
  const ResumeBuilder({super.key});

  @override
  _ResumeBuilderState createState() => _ResumeBuilderState();
}

class _ResumeBuilderState extends State<ResumeBuilder> {
  late BasicInfoModel basicInfo;
  List<ResumeSection> resumeSection = [];

  void _addResumeItem() {
    setState(() {
      if (resumeSection.isEmpty) {
        resumeSection.add(ResumeSection.basic);
        basicInfo = BasicInfoModel(fullName: 'Name', summary: '', email: '');
      }
    });
  }

  void _updateResumeItem({BasicInfoModel? basicInfoModel}) {
    setState(() {
      if (basicInfoModel != null) {
        basicInfo = basicInfoModel;
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
            padding: const EdgeInsets.all(3.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(8),
            ),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                basicInfo.fullName,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
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

    return Container();
  }

  void _navigateToEditScreen(ResumeSection? section) async {
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
    }
  }
}
