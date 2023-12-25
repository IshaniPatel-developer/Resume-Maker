import 'dart:typed_data';
import 'package:pdf/widgets.dart' as pw;
import '../basic info/model/basic_info_model.dart';
import '../education info/model/education_info_model.dart';
import '../experience info/model/experience_info_model.dart';


class PDFGenerator {
  static Future<Uint8List> generatePDF({BasicInfoModel? basicInfoModel,EducationInfoModel? educationInfoModel, ExperienceInfoModel? experienceInfoModel }) async {
    final pdf = pw.Document();

    // Add a page to the PDF
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Center(
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              _buildSectionTitle(basicInfoModel?.fullName ?? ""),
            ],
          ),
        ),
      ),
    );

    // Save the PDF to a Uint8List
    return pdf.save();
  }



  static pw.Widget _buildSectionTitle(String title) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 8.0),
      child: pw.Text(
        title,
        style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
      ),
    );
  }

}
