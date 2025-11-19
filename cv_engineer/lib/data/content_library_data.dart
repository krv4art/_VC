// data/content_library_data.dart
// Pre-written content library for resumes

class ContentLibraryData {
  // Action Verbs
  static const List<String> actionVerbs = [
    'Achieved', 'Improved', 'Trained', 'Managed', 'Created', 'Designed',
    'Developed', 'Implemented', 'Increased', 'Decreased', 'Reduced', 'Led',
    'Launched', 'Initiated', 'Established', 'Founded', 'Formulated', 'Executed',
    'Delivered', 'Generated', 'Built', 'Solved', 'Analyzed', 'Assessed',
    'Streamlined', 'Optimized', 'Enhanced', 'Strengthened', 'Transformed',
    'Pioneered', 'Spearheaded', 'Orchestrated', 'Coordinated', 'Collaborated',
    'Innovated', 'Modernized', 'Revitalized', 'Accelerated', 'Maximized',
    'Minimized', 'Automated', 'Standardized', 'Consolidated', 'Integrated',
  ];

  // Professional Summaries by Role
  static const Map<String, List<String>> professionalSummaries = {
    'Software Engineer': [
      'Results-driven Software Engineer with 5+ years of experience in full-stack development. Expert in JavaScript, React, and Node.js with a proven track record of delivering scalable web applications.',
      'Passionate Full-Stack Developer specializing in modern web technologies. Strong background in cloud architecture, microservices, and agile methodologies.',
      'Innovative Software Engineer with expertise in building high-performance applications. Skilled in Python, Java, and distributed systems design.',
    ],
    'Data Scientist': [
      'Data Scientist with 4+ years of experience in machine learning and statistical analysis. Proven ability to derive actionable insights from complex datasets.',
      'Analytics-focused Data Scientist specializing in predictive modeling and big data technologies. Expert in Python, R, and SQL.',
      'Results-oriented Data Scientist with strong background in deep learning and natural language processing. Published researcher with industry experience.',
    ],
    'Product Manager': [
      'Strategic Product Manager with 6+ years of experience leading cross-functional teams. Track record of launching successful products and driving revenue growth.',
      'Customer-focused Product Manager skilled in agile methodologies and data-driven decision making. Experience in B2B and B2C product development.',
      'Innovative Product Leader with expertise in product strategy, roadmap planning, and stakeholder management. Proven ability to deliver products that exceed customer expectations.',
    ],
    'UX Designer': [
      'Creative UX Designer with 5+ years of experience crafting user-centered digital experiences. Expert in user research, wireframing, and prototyping.',
      'Detail-oriented UX/UI Designer specializing in mobile and web applications. Strong background in design systems and accessibility.',
      'User-focused Designer with expertise in information architecture and interaction design. Passionate about creating intuitive and delightful user experiences.',
    ],
    'Marketing Manager': [
      'Results-driven Marketing Manager with 7+ years of experience in digital marketing and brand strategy. Proven track record of increasing market share and customer engagement.',
      'Strategic Marketing Professional specializing in content marketing, SEO, and social media. Data-driven approach to campaign optimization.',
      'Innovative Marketing Leader with expertise in growth marketing and customer acquisition. Experience managing cross-channel campaigns and teams.',
    ],
  };

  // Experience Bullet Points by Role
  static const Map<String, List<String>> experienceBulletPoints = {
    'Software Engineer': [
      'Developed and maintained scalable web applications serving 1M+ daily active users',
      'Reduced application load time by 40% through performance optimization techniques',
      'Led migration from monolithic to microservices architecture, improving system reliability by 30%',
      'Implemented automated testing framework, increasing code coverage from 60% to 95%',
      'Collaborated with product and design teams to deliver features on schedule',
      'Mentored 5 junior developers, conducting code reviews and pair programming sessions',
      'Built RESTful APIs using Node.js and Express, handling 10K+ requests per second',
      'Optimized database queries, reducing response time by 50%',
    ],
    'Data Scientist': [
      'Developed machine learning models with 92% accuracy for customer churn prediction',
      'Analyzed 10M+ customer records to identify key trends and insights',
      'Built automated data pipeline processing 2TB of data daily',
      'Created interactive dashboards using Tableau, enabling data-driven decision making',
      'Reduced model training time by 60% through feature engineering and optimization',
      'Presented findings to C-level executives, influencing strategic decisions',
      'Collaborated with engineering team to deploy ML models to production',
      'Conducted A/B tests resulting in 25% improvement in conversion rates',
    ],
    'Product Manager': [
      'Launched 3 major product features, resulting in 40% increase in user engagement',
      'Managed product roadmap for flagship product with $50M annual revenue',
      'Conducted user research with 200+ customers to identify pain points and opportunities',
      'Collaborated with engineering, design, and marketing teams to deliver products on time',
      'Increased customer retention by 30% through data-driven feature prioritization',
      'Defined and tracked KPIs, presenting monthly reports to stakeholders',
      'Led cross-functional team of 15 members across multiple time zones',
      'Reduced time-to-market by 25% by implementing agile methodologies',
    ],
    'UX Designer': [
      'Designed user interfaces for mobile app with 500K+ downloads',
      'Conducted user research with 100+ participants, resulting in actionable insights',
      'Created wireframes and prototypes using Figma, reducing development time by 20%',
      'Improved user satisfaction scores from 3.5 to 4.5 stars through redesign',
      'Established design system used across 10+ products',
      'Collaborated with developers to ensure pixel-perfect implementation',
      'Led usability testing sessions, identifying and addressing 50+ usability issues',
      'Increased task completion rate by 35% through intuitive navigation design',
    ],
    'Marketing Manager': [
      'Increased website traffic by 150% through SEO optimization and content strategy',
      'Managed $500K marketing budget, achieving 300% ROI',
      'Led social media campaigns resulting in 50K+ new followers',
      'Developed email marketing campaigns with 25% open rate and 8% CTR',
      'Coordinated product launches, generating $2M in first-quarter revenue',
      'Analyzed campaign performance data to optimize marketing spend',
      'Managed team of 5 marketing specialists and external agencies',
      'Implemented marketing automation, saving 20 hours per week',
    ],
  };

  // Skills by Category
  static const Map<String, List<String>> skillsByCategory = {
    'Programming Languages': [
      'JavaScript', 'Python', 'Java', 'TypeScript', 'C++', 'C#', 'Ruby', 'Go',
      'Swift', 'Kotlin', 'PHP', 'Rust', 'Scala', 'R', 'MATLAB',
    ],
    'Web Development': [
      'React', 'Angular', 'Vue.js', 'Node.js', 'Express', 'Django', 'Flask',
      'Spring Boot', 'ASP.NET', 'HTML5', 'CSS3', 'SASS', 'Webpack', 'Babel',
    ],
    'Mobile Development': [
      'React Native', 'Flutter', 'iOS Development', 'Android Development',
      'Swift UI', 'Jetpack Compose', 'Xamarin', 'Ionic',
    ],
    'Data & Analytics': [
      'SQL', 'PostgreSQL', 'MongoDB', 'Redis', 'Elasticsearch', 'Tableau',
      'Power BI', 'Data Warehousing', 'ETL', 'Data Modeling',
    ],
    'Machine Learning': [
      'TensorFlow', 'PyTorch', 'Scikit-learn', 'Keras', 'NLP', 'Computer Vision',
      'Deep Learning', 'Neural Networks', 'Pandas', 'NumPy',
    ],
    'Cloud & DevOps': [
      'AWS', 'Azure', 'Google Cloud', 'Docker', 'Kubernetes', 'CI/CD',
      'Jenkins', 'GitLab CI', 'Terraform', 'Ansible', 'Monitoring',
    ],
    'Design': [
      'Figma', 'Sketch', 'Adobe XD', 'Photoshop', 'Illustrator', 'InVision',
      'Wireframing', 'Prototyping', 'User Research', 'Usability Testing',
    ],
    'Soft Skills': [
      'Leadership', 'Communication', 'Problem Solving', 'Teamwork',
      'Project Management', 'Agile/Scrum', 'Time Management', 'Critical Thinking',
      'Adaptability', 'Collaboration', 'Presentation Skills',
    ],
  };

  // Achievement Templates
  static const List<String> achievementTemplates = [
    'Increased [metric] by [X]% through [action]',
    'Reduced [metric] by [X]% by implementing [solution]',
    'Managed [X] [projects/team members/budget] resulting in [outcome]',
    'Led [initiative] that generated [X] in [revenue/savings]',
    'Improved [process] efficiency by [X]% through [method]',
    'Delivered [project] under budget by [X]% and ahead of schedule by [Y] days',
    'Built [product/feature] used by [X]+ users daily',
    'Optimized [system] performance, reducing [metric] by [X]%',
  ];

  // Common Certifications by Field
  static const Map<String, List<String>> certifications = {
    'Technology': [
      'AWS Certified Solutions Architect',
      'Google Cloud Professional',
      'Microsoft Azure Fundamentals',
      'Certified Kubernetes Administrator',
      'CompTIA Security+',
      'Cisco CCNA',
      'PMP (Project Management Professional)',
      'Scrum Master Certification',
    ],
    'Data Science': [
      'Google Data Analytics Certificate',
      'IBM Data Science Professional',
      'TensorFlow Developer Certificate',
      'Cloudera Certified Data Analyst',
    ],
    'Design': [
      'Adobe Certified Expert',
      'Google UX Design Certificate',
      'Interaction Design Foundation Certificate',
    ],
    'Marketing': [
      'Google Ads Certification',
      'HubSpot Inbound Marketing',
      'Facebook Blueprint Certification',
      'Hootsuite Social Marketing',
    ],
  };

  // Get content by type
  static List<String> getActionVerbs() => actionVerbs;

  static List<String> getProfessionalSummaries(String role) {
    return professionalSummaries[role] ?? [];
  }

  static List<String> getExperienceBulletPoints(String role) {
    return experienceBulletPoints[role] ?? [];
  }

  static Map<String, List<String>> getAllSkills() => skillsByCategory;

  static List<String> getSkillsByCategory(String category) {
    return skillsByCategory[category] ?? [];
  }

  static List<String> getAchievementTemplates() => achievementTemplates;

  static List<String> getCertifications(String field) {
    return certifications[field] ?? [];
  }

  // Search across all content
  static List<Map<String, String>> searchContent(String query) {
    final results = <Map<String, String>>[];
    final lowerQuery = query.toLowerCase();

    // Search in action verbs
    for (final verb in actionVerbs) {
      if (verb.toLowerCase().contains(lowerQuery)) {
        results.add({'type': 'Action Verb', 'content': verb});
      }
    }

    // Search in summaries
    professionalSummaries.forEach((role, summaries) {
      for (final summary in summaries) {
        if (summary.toLowerCase().contains(lowerQuery)) {
          results.add({'type': 'Summary ($role)', 'content': summary});
        }
      }
    });

    // Search in bullet points
    experienceBulletPoints.forEach((role, points) {
      for (final point in points) {
        if (point.toLowerCase().contains(lowerQuery)) {
          results.add({'type': 'Bullet Point ($role)', 'content': point});
        }
      }
    });

    return results;
  }
}
