import 'package:flutter/material.dart';

class SubjectModel{
  final String subject;
  final String id;
  final String subjectId;
  final String duration;
  final String registration;
  final String classTime;
  final String teacher;

  SubjectModel({
    required this.subject,
    required this.id,
    required this.subjectId,
    required this.duration,
    required this.classTime,
    required this.registration,
    required this.teacher
  });

}