import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:resume/module/basic%20info/model/basic_info_model.dart';
import 'package:resume/module/education%20info/model/education_info_model.dart';
import 'package:resume/module/experience%20info/model/experience_info_model.dart';
import 'package:resume/module/skill%20info/model/skill_info_model.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'dart:js' as js;
import 'enum.dart';

class PDFHandler {

  static Future<void> createPDF(List<ResumeSection> resumeSection , BasicInfoModel basicInfo , EducationInfoModel educationInfo ,ExperienceInfoModel experienceInfo , SkillInfoModel skillsInfo) async {
    //Create a new PDF document
    PdfDocument document = PdfDocument();
    final PdfPage page = document.pages.add();
    final PdfGraphics graphics = page.graphics;
    var yAxis = 20.0;
    for (int index = 0; index < resumeSection.length; index++) {
      if (index == 0 && basicInfo != null) {
        // Draw text on the page
        graphics.drawString(
            basicInfo.fullName, PdfStandardFont(PdfFontFamily.helvetica, 16),
            bounds: Rect.fromLTWH(0, 20, page.getClientSize().width, 24),
            format: PdfStringFormat(alignment: PdfTextAlignment.left));

        graphics.drawString(
            basicInfo.email, PdfStandardFont(PdfFontFamily.helvetica, 12),
            brush: PdfBrushes.blue,
            bounds: Rect.fromLTWH(0, 40, page.getClientSize().width, 14),
            format: PdfStringFormat(alignment: PdfTextAlignment.left));

        graphics.drawString(
            basicInfo.summary, PdfStandardFont(PdfFontFamily.helvetica, 12),
            bounds: Rect.fromLTWH(0, 60, page.getClientSize().width, 14),
            format: PdfStringFormat(alignment: PdfTextAlignment.left));

        yAxis = 80;
      }

      if (resumeSection[index] == ResumeSection.education &&
          educationInfo != null) {
        var titleSpace = yAxis + 20;
        var lineSpace = titleSpace + 20.0;
        var space = lineSpace + 10.0;
        var space2 = space + 20.0;

        // Draw text on the page
        graphics.drawString(
            "Education", PdfStandardFont(PdfFontFamily.helvetica, 10),
            brush: PdfBrushes.gray,
            bounds:
            Rect.fromLTWH(0, titleSpace, page.getClientSize().width, 24),
            format: PdfStringFormat(alignment: PdfTextAlignment.left));

        page.graphics.drawLine(
          PdfPen(PdfColor(128, 128, 128), width: 1),
          Offset(0, lineSpace),
          Offset(page.getClientSize().width, lineSpace),
        );

        for (int index = 0;
        index < educationInfo.educationData.length;
        index++) {
          graphics.drawString(educationInfo.educationData[index].course,
              PdfStandardFont(PdfFontFamily.helvetica, 16),
              bounds: Rect.fromLTWH(0, space, page.getClientSize().width, 24),
              format: PdfStringFormat(alignment: PdfTextAlignment.left));
          graphics.drawString(
              "${educationInfo.educationData[index].institution} - ${educationInfo.educationData[index].date}",
              PdfStandardFont(PdfFontFamily.helvetica, 12),
              bounds: Rect.fromLTWH(0, space2, page.getClientSize().width, 14),
              format: PdfStringFormat(alignment: PdfTextAlignment.left));
          space = space + 40;
          space2 = space2 + 40;
          yAxis = space2;
        }
      }

      if (resumeSection[index] == ResumeSection.experience &&
          experienceInfo != null) {
        var titleSpace = yAxis + 20;
        var lineSpace = titleSpace + 20.0;
        var space = lineSpace + 10.0;
        var space2 = space + 20.0;

        // Draw text on the page
        graphics.drawString(
            "Experience", PdfStandardFont(PdfFontFamily.helvetica, 10),
            brush: PdfBrushes.gray,
            bounds:
            Rect.fromLTWH(0, titleSpace, page.getClientSize().width, 24),
            format: PdfStringFormat(alignment: PdfTextAlignment.left));

        page.graphics.drawLine(
          PdfPen(PdfColor(128, 128, 128), width: 1),
          Offset(0, lineSpace),
          Offset(page.getClientSize().width, lineSpace),
        );

        for (int index = 0;
        index < experienceInfo.experienceData.length;
        index++) {
          graphics.drawString(experienceInfo.experienceData[index].designation,
              PdfStandardFont(PdfFontFamily.helvetica, 16),
              bounds: Rect.fromLTWH(0, space, page.getClientSize().width, 24),
              format: PdfStringFormat(alignment: PdfTextAlignment.left));
          graphics.drawString(
              "${experienceInfo.experienceData[index].organization} - ${experienceInfo.experienceData[index].date}",
              PdfStandardFont(PdfFontFamily.helvetica, 12),
              bounds: Rect.fromLTWH(0, space2, page.getClientSize().width, 14),
              format: PdfStringFormat(alignment: PdfTextAlignment.left));
          space = space + 40;
          space2 = space2 + 40;
          yAxis = space2;
        }
      }

      if (resumeSection[index] == ResumeSection.skills &&
          experienceInfo != null) {
        var titleSpace = yAxis + 20;
        var lineSpace = titleSpace + 20.0;
        var space = lineSpace + 10.0;


        // Draw text on the page
        graphics.drawString(
            "Skills", PdfStandardFont(PdfFontFamily.helvetica, 10),
            brush: PdfBrushes.gray,
            bounds:
            Rect.fromLTWH(0, titleSpace, page.getClientSize().width, 24),
            format: PdfStringFormat(alignment: PdfTextAlignment.left));

        page.graphics.drawLine(
          PdfPen(PdfColor(128, 128, 128), width: 1),
          Offset(0, lineSpace),
          Offset(page.getClientSize().width, lineSpace),
        );

        for (int index = 0;
        index < skillsInfo.skillList.length;
        index++) {
          graphics.drawString(skillsInfo.skillList[index],
              PdfStandardFont(PdfFontFamily.helvetica, 16),
              bounds: Rect.fromLTWH(0, space, page.getClientSize().width, 24),
              format: PdfStringFormat(alignment: PdfTextAlignment.left));
          space = space + 20;

          yAxis = space;
        }
      }
    }

    List<int> bytes = await document.save();
    //Dispose the document
    document.dispose();

    if (!kIsWeb) {
      //Get external storage directory
      final directory = await getApplicationSupportDirectory();
      final path = directory.path;
      //Create an empty file to write PDF data
      var fileName = '$path/Output${DateTime.now()}.pdf';
      File file = File(fileName);
      //Write PDF data
      await file.writeAsBytes(bytes, flush: true);
      //Open the PDF document in mobile
      OpenFile.open(fileName);
   } else {
      js.context['pdfData'] = base64.encode(bytes);
      js.context['filename'] = 'Output${DateTime.now()}.pdf';
      Timer.run(() {
        js.context.callMethod('download');
      });
   }
  }
}