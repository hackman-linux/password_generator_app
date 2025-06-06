import 'package:equatable/equatable.dart';

class TeamMember extends Equatable {
  final String name;
  final double contributionPercentage;
  final String role;
  final String? photoUrl;
  final String? email;
  final String? github;
  final String? linkedin;

  const TeamMember({
    required this.name,
    required this.contributionPercentage,
    required this.role,
    this.photoUrl,
    this.email,
    this.github,
    this.linkedin,
  });

  TeamMember copyWith({
    String? name,
    double? contributionPercentage,
    String? role,
    String? photoUrl,
    String? email,
    String? github,
    String? linkedin,
  }) {
    return TeamMember(
      name: name ?? this.name,
      contributionPercentage: contributionPercentage ?? this.contributionPercentage,
      role: role ?? this.role,
      photoUrl: photoUrl ?? this.photoUrl,
      email: email ?? this.email,
      github: github ?? this.github,
      linkedin: linkedin ?? this.linkedin,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'contributionPercentage': contributionPercentage,
      'role': role,
      'photoUrl': photoUrl,
      'email': email,
      'github': github,
      'linkedin': linkedin,
    };
  }

  factory TeamMember.fromJson(Map<String, dynamic> json) {
    return TeamMember(
      name: json['name'] ?? '',
      contributionPercentage: (json['contributionPercentage'] ?? 0.0).toDouble(),
      role: json['role'] ?? '',
      photoUrl: json['photoUrl'],
      email: json['email'],
      github: json['github'],
      linkedin: json['linkedin'],
    );
  }

  @override
  List<Object?> get props => [
    name,
    contributionPercentage,
    role,
    photoUrl,
    email,
    github,
    linkedin,
  ];

  @override
  String toString() {
    return 'TeamMember(name: $name, contributionPercentage: $contributionPercentage%, role: $role)';
  }
}

// Static data for your 6 team members
class TeamData {
  static List<TeamMember> getTeamMembers() {
    return [
      const TeamMember(
        name: 'NDJODO NGOUH SOULEMAN. L', // You'll replace these with actual names
        contributionPercentage: 34.0,
        role: 'Project Manager & UI/UX Designer',
      ),
      const TeamMember(
        name: 'FOUDA BERTINE',
        contributionPercentage: 18.0,
        role: 'Lead Flutter Developer',
      ),
      const TeamMember(
        name: 'WANSI ARNOLD',
        contributionPercentage: 16.0,
        role: 'Backend Developer & Security',
      ),
      const TeamMember(
        name: 'NDI NATHAN',
        contributionPercentage: 16.0,
        role: 'Frontend Developer',
      ),
      const TeamMember(
        name: 'FEUDJIO MIGUEL',
        contributionPercentage: 16.0,
        role: 'Quality Assurance & Testing',
      ),
      // const TeamMember(
      //   name: 'NDI NATHAN',
      //   contributionPercentage: 14.0,
      //   role: 'Documentation & DevOps',
      // ),
    ];
  }

  static double getTotalPercentage() {
    return getTeamMembers()
        .map((member) => member.contributionPercentage)
        .reduce((a, b) => a + b);
  }

  static int getTeamSize() {
    return getTeamMembers().length;
  }
}