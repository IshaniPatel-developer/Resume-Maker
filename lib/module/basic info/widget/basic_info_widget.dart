import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../model/basic_info_model.dart';

class BasicInfoWidget extends StatefulWidget {
  final BasicInfoModel resumeItem;

  const BasicInfoWidget({required this.resumeItem});

  @override
  _BasicInfoWidgetState createState() => _BasicInfoWidgetState();
}

class _BasicInfoWidgetState extends State<BasicInfoWidget> {
  late TextEditingController fullNameController;
  late TextEditingController emailController;
  late TextEditingController summaryController;

  @override
  void initState() {
    super.initState();
    fullNameController = TextEditingController(text: widget.resumeItem.fullName);
    emailController = TextEditingController(text: widget.resumeItem.email);
    summaryController = TextEditingController(text: widget.resumeItem.summary);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Basic Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: fullNameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: summaryController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Summary',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(
                    context,
                    BasicInfoModel(
                      fullName: fullNameController.text,
                      email: emailController.text,
                      summary: summaryController.text,
                    ),
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
