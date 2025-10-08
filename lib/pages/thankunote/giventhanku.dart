import 'package:flutter/material.dart';
import 'package:grip/utils/theme/Textheme.dart';
import 'package:sizer/sizer.dart';
import 'package:intl/intl.dart'; // ✅ for date & number formatting
import 'package:grip/backend/api-requests/imageurl.dart';

class GiventhankyouPage extends StatelessWidget {
  final Map<String, dynamic> note;

  const GiventhankyouPage({super.key, required this.note});

  String? buildImageUrl(Map<String, dynamic>? image) {
    if (image == null) return null;
    final docPath = image['docPath'];
    final docName = image['docName'];
    if (docPath == null || docName == null) return null;
    return "${UrlService.imageBaseUrl}/$docPath/$docName";
  }

  String formatDate(String? isoString) {
    if (isoString == null) return "N/A";
    try {
      final dateTime = DateTime.parse(isoString).toLocal();
      return DateFormat('dd/MM/yyyy').format(dateTime); // ✅ e.g. 05/09/2025
    } catch (e) {
      return "Invalid date";
    }
  }

  String formatAmount(dynamic rawAmount) {
    if (rawAmount == null) return '0';
    try {
      final num amountNum = rawAmount is String
          ? num.tryParse(rawAmount) ?? 0
          : rawAmount as num;
      return NumberFormat.decimalPattern('en_IN').format(amountNum);
    } catch (e) {
      return rawAmount.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    final to = note['toMember']?['personalDetails'];
    final toName =
        "${to?['firstName'] ?? ''} ${to?['lastName'] ?? ''}".trim();
    final designation = to?['companyName'] ?? 'Knights';
    final amount = formatAmount(note['amount']);
    final comment = note['comments'] ?? 'No comments provided';

    final createdAt = note['createdAt']; // ✅ take from API
    final date = formatDate(createdAt);

    final profileImageMap = to?['profileImage'];
    final imageUrl = buildImageUrl(profileImageMap);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Given Thank You Note",
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 🔝 Gradient Header
            Container(
              height: 22.h, // increased height to fit logo
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFFFF3534), // Soft red
                    Color(0xFF575757), // Muted gray
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Logo at the top
                  SizedBox(
                    height: 10.h,
                    width: 30.w,
                    child: Image.asset(
                      "assets/images/Griplogo.png",
                      color: Colors.white,
                      fit: BoxFit.contain,
                    ),
                  ),
                  SizedBox(height: 1.h), // spacing between logo and row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.handshake,
                              color: Colors.white, size: 25),
                          SizedBox(width: 2.w),
                          Text(
                            "To: ${toName.isNotEmpty ? toName : "No Name"}",
                            style: TTextStyles.tkname,
                          ),
                        ],
                      ),
                      Text(
                        "Date: $date",
                        style: TTextStyles.tkname,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // 📄 Content
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(5.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 2.h),
                    Text("Thank you to:", style: TTextStyles.tkRivenrefsmall),

                    SizedBox(height: 1.h),
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundImage: imageUrl != null
                              ? NetworkImage(imageUrl)
                              : const AssetImage('assets/images/person.png')
                                  as ImageProvider,
                        ),
                        SizedBox(width: 3.w),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              toName.isNotEmpty ? toName : 'No Name',
                              style: TTextStyles.tktext
                                  
                            ),
                            Text(designation, style: TTextStyles.tktext),
                          ],
                        ),
                      ],
                    ),

                    SizedBox(height: 3.h),
                    Text("For a referral in the amount of:",
                        style: TTextStyles.tkRivenrefsmall),
                    SizedBox(height: 1.h),

                    Container(
                      height: 12.h,
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 2.h),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFFFF3534), // Soft red
                            Color(0xFF575757), // Muted gray
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        "₹ $amount",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    SizedBox(height: 3.h),
                    Text("Comments:", style: TTextStyles.tkRivenrefsmall),
                    SizedBox(height: 0.5.h),
                    Text(comment, style: TTextStyles.tktext),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
