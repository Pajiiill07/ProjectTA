import 'package:frontend_mobile/app/data/model/datauser_model.dart';
import 'package:frontend_mobile/app/data/model/education_model.dart';
import 'package:frontend_mobile/app/data/model/experience_model.dart';
import 'package:frontend_mobile/app/data/model/skill_model.dart';

class CVData {
  DataUserModel? personalData;
  List<EducationModel> educations;
  List<ExperienceModel> experiences;
  List<SkillModel> skills;

  CVData({
    this.personalData,
    this.educations = const [],
    this.experiences = const [],
    this.skills = const [],
  });

  factory CVData.fromJson(Map<String, dynamic> json) {
    return CVData(
      personalData: json['personalData'] != null
          ? DataUserModel.fromJson(json['personalData'])
          : null,
      educations: (json['educations'] as List?)
          ?.map((e) => EducationModel.fromJson(e))
          .toList() ?? [],
      experiences: (json['experiences'] as List?)
          ?.map((e) => ExperienceModel.fromJson(e))
          .toList() ?? [],
      skills: (json['skills'] as List?)
          ?.map((e) => SkillModel.fromJson(e))
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'personalData': personalData?.toJson(),
      'educations': educations.map((e) => e.toJson()).toList(),
      'experiences': experiences.map((e) => e.toJson()).toList(),
      'skills': skills.map((e) => e.toJson()).toList(),
    };
  }

  bool get hasPersonalData => personalData != null;
  bool get hasEducation => educations.isNotEmpty;
  bool get hasExperience => experiences.isNotEmpty;
  bool get hasSkills => skills.isNotEmpty;
}