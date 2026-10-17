import 'package:flutter/material.dart';

class UnbordingContent {
  String image; // استخدمنا أيقونات لتسهيل الأمر حالياً، يمكن تغييرها لصور لاحقاً
  String title;
  String description;

  UnbordingContent({
    required this.image,
    required this.title,
    required this.description,
  });
}

// قائمة جاهزة بالشاشات الثلاث
List<UnbordingContent> contents = [
  UnbordingContent(
    title: 'تتبع أموالك بسهولة',
    image: '💰', // يمكن استبدالها بمسار صورة assets/img.png
    description: "تعرف على أين تذهب أموالك وتحكم في مصاريفك اليومية بكل بساطة.",
  ),
  UnbordingContent(
    title: 'إحصائيات دقيقة',
    image: '📊',
    description: "رسوم بيانية توضح لك تفاصيل صرفك الشهري لتتمكن من التوفير.",
  ),
  UnbordingContent(
    title: 'أمان وخصوصية',
    image: '🔒',
    description: "بياناتك محفوظة بأمان تام على هاتفك الشخصي.",
  ),
];
