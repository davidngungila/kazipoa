class Job {
  final String id;
  final String title;
  final String company;
  final String location;
  final String salary;
  final DateTime postedDate;
  final String description;

  Job({
    required this.id,
    required this.title,
    required this.company,
    required this.location,
    required this.salary,
    required this.postedDate,
    required this.description,
  });

  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(
      id: json['id'] as String,
      title: json['title'] as String,
      company: json['company'] as String,
      location: json['location'] as String,
      salary: json['salary'] as String,
      postedDate: DateTime.parse(json['postedDate'] as String),
      description: json['description'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'company': company,
      'location': location,
      'salary': salary,
      'postedDate': postedDate.toIso8601String(),
      'description': description,
    };
  }
}
