/// Common skills for autocomplete suggestions
class CommonSkills {
  // Programming Languages
  static const programmingLanguages = [
    'JavaScript',
    'TypeScript',
    'Python',
    'Java',
    'C++',
    'C#',
    'PHP',
    'Ruby',
    'Go',
    'Rust',
    'Swift',
    'Kotlin',
    'Dart',
    'Scala',
    'R',
    'MATLAB',
    'SQL',
    'HTML',
    'CSS',
    'Shell/Bash',
  ];

  // Frameworks & Libraries
  static const frameworks = [
    'React',
    'Angular',
    'Vue.js',
    'Next.js',
    'Node.js',
    'Express.js',
    'Django',
    'Flask',
    'Spring Boot',
    'ASP.NET',
    'Laravel',
    'Ruby on Rails',
    'Flutter',
    'React Native',
    'TensorFlow',
    'PyTorch',
    'jQuery',
    'Bootstrap',
    'Tailwind CSS',
    'Material-UI',
  ];

  // Tools & Platforms
  static const tools = [
    'Git',
    'GitHub',
    'GitLab',
    'Docker',
    'Kubernetes',
    'AWS',
    'Azure',
    'Google Cloud Platform',
    'Jenkins',
    'CI/CD',
    'Jira',
    'Confluence',
    'Postman',
    'VS Code',
    'IntelliJ IDEA',
    'Eclipse',
    'Figma',
    'Adobe XD',
    'Sketch',
    'MongoDB',
    'PostgreSQL',
    'MySQL',
    'Redis',
    'Elasticsearch',
    'Firebase',
    'Supabase',
  ];

  // Soft Skills
  static const softSkills = [
    'Leadership',
    'Communication',
    'Team Collaboration',
    'Problem Solving',
    'Critical Thinking',
    'Time Management',
    'Project Management',
    'Agile',
    'Scrum',
    'Adaptability',
    'Creativity',
    'Attention to Detail',
    'Analytical Skills',
    'Interpersonal Skills',
    'Presentation Skills',
    'Negotiation',
    'Conflict Resolution',
    'Mentoring',
    'Strategic Planning',
    'Decision Making',
  ];

  // Technical Skills
  static const technicalSkills = [
    'RESTful APIs',
    'GraphQL',
    'Microservices',
    'System Design',
    'Data Structures',
    'Algorithms',
    'Object-Oriented Programming',
    'Functional Programming',
    'Test-Driven Development',
    'Unit Testing',
    'Integration Testing',
    'Debugging',
    'Performance Optimization',
    'Security Best Practices',
    'Version Control',
    'Code Review',
    'Continuous Integration',
    'Continuous Deployment',
    'DevOps',
    'Cloud Computing',
    'Machine Learning',
    'Data Analysis',
    'Data Visualization',
    'Database Design',
    'API Development',
  ];

  // Design Skills
  static const designSkills = [
    'UI/UX Design',
    'Responsive Design',
    'Mobile Design',
    'Web Design',
    'Prototyping',
    'Wireframing',
    'User Research',
    'Usability Testing',
    'Design Systems',
    'Typography',
    'Color Theory',
    'Graphic Design',
    'Motion Design',
    'Interaction Design',
  ];

  // Business Skills
  static const businessSkills = [
    'Business Analysis',
    'Market Research',
    'Financial Analysis',
    'Budgeting',
    'Forecasting',
    'Stakeholder Management',
    'Vendor Management',
    'Requirements Gathering',
    'Process Improvement',
    'Risk Management',
    'Change Management',
    'Quality Assurance',
  ];

  /// Get all skills combined
  static List<String> getAllSkills() {
    return [
      ...programmingLanguages,
      ...frameworks,
      ...tools,
      ...softSkills,
      ...technicalSkills,
      ...designSkills,
      ...businessSkills,
    ]..sort();
  }

  /// Get skills by category
  static Map<String, List<String>> getSkillsByCategory() {
    return {
      'Programming Languages': programmingLanguages,
      'Frameworks & Libraries': frameworks,
      'Tools & Platforms': tools,
      'Soft Skills': softSkills,
      'Technical Skills': technicalSkills,
      'Design': designSkills,
      'Business': businessSkills,
    };
  }

  /// Search skills by query
  static List<String> searchSkills(String query) {
    if (query.isEmpty) return [];

    final allSkills = getAllSkills();
    final lowerQuery = query.toLowerCase();

    return allSkills
        .where((skill) => skill.toLowerCase().contains(lowerQuery))
        .take(10)
        .toList();
  }
}
