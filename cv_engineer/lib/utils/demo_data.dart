import '../models/resume.dart';
import '../models/personal_info.dart';
import '../models/experience.dart';
import '../models/education.dart';
import '../models/skill.dart';
import '../models/language.dart';
import '../models/custom_section.dart';

/// Demo data for testing and showcasing app features
class DemoData {
  /// Create a sample resume for a Software Engineer
  static Resume createSoftwareEngineerResume() {
    return Resume(
      templateId: 'professional',
      personalInfo: PersonalInfo(
        fullName: 'Alex Johnson',
        email: 'alex.johnson@email.com',
        phone: '+1 (555) 123-4567',
        address: '123 Tech Street',
        city: 'San Francisco',
        country: 'USA',
        linkedin: 'linkedin.com/in/alexjohnson',
        github: 'github.com/alexjohnson',
        profileSummary: 'Experienced Full-Stack Software Engineer with 5+ years of expertise in building scalable web applications. Proven track record of delivering high-quality solutions using modern technologies and agile methodologies. Passionate about clean code, system architecture, and mentoring junior developers.',
      ),
      experiences: [
        Experience(
          jobTitle: 'Senior Software Engineer',
          company: 'TechCorp Solutions',
          location: 'San Francisco, CA',
          startDate: DateTime(2021, 3, 1),
          isCurrent: true,
          description: 'Leading development of cloud-native applications and mentoring team of 5 engineers.',
          responsibilities: [
            'Architected and implemented microservices architecture reducing deployment time by 60%',
            'Led migration from monolithic to microservices architecture serving 2M+ users',
            'Mentored 5 junior developers, improving team velocity by 40%',
            'Implemented CI/CD pipeline reducing deployment time from 2 hours to 15 minutes',
            'Conducted code reviews and established coding standards across the organization',
          ],
        ),
        Experience(
          jobTitle: 'Software Engineer',
          company: 'StartupXYZ',
          location: 'Palo Alto, CA',
          startDate: DateTime(2019, 6, 1),
          endDate: DateTime(2021, 2, 28),
          description: 'Developed and maintained full-stack web applications for e-commerce platform.',
          responsibilities: [
            'Built RESTful APIs using Node.js and Express serving 500K+ daily requests',
            'Developed responsive React applications improving user engagement by 35%',
            'Optimized database queries reducing average response time by 50%',
            'Implemented real-time features using WebSocket improving user experience',
          ],
        ),
        Experience(
          jobTitle: 'Junior Developer',
          company: 'Digital Agency Pro',
          location: 'San Jose, CA',
          startDate: DateTime(2018, 7, 1),
          endDate: DateTime(2019, 5, 31),
          description: 'Contributed to client projects and internal tools development.',
          responsibilities: [
            'Developed 15+ client websites using HTML, CSS, JavaScript, and WordPress',
            'Collaborated with designers to implement pixel-perfect UI components',
            'Maintained and updated legacy codebases for 20+ active clients',
          ],
        ),
      ],
      educations: [
        Education(
          degree: 'Bachelor of Science in Computer Science',
          institution: 'University of California, Berkeley',
          startDate: DateTime(2014, 9, 1),
          endDate: DateTime(2018, 5, 31),
          gpa: '3.8/4.0',
          achievements: [
            'Dean\'s List for 6 semesters',
            'President of Computer Science Club',
            'First place in University Hackathon 2017',
            'Published research paper on Machine Learning optimization',
          ],
        ),
      ],
      skills: [
        Skill(name: 'JavaScript', category: 'Programming Languages', proficiency: SkillProficiency.expert),
        Skill(name: 'TypeScript', category: 'Programming Languages', proficiency: SkillProficiency.expert),
        Skill(name: 'Python', category: 'Programming Languages', proficiency: SkillProficiency.advanced),
        Skill(name: 'Java', category: 'Programming Languages', proficiency: SkillProficiency.intermediate),
        Skill(name: 'React', category: 'Frameworks & Libraries', proficiency: SkillProficiency.expert),
        Skill(name: 'Node.js', category: 'Frameworks & Libraries', proficiency: SkillProficiency.expert),
        Skill(name: 'Express.js', category: 'Frameworks & Libraries', proficiency: SkillProficiency.advanced),
        Skill(name: 'Flutter', category: 'Frameworks & Libraries', proficiency: SkillProficiency.intermediate),
        Skill(name: 'Docker', category: 'Tools & Platforms', proficiency: SkillProficiency.advanced),
        Skill(name: 'Kubernetes', category: 'Tools & Platforms', proficiency: SkillProficiency.intermediate),
        Skill(name: 'AWS', category: 'Tools & Platforms', proficiency: SkillProficiency.advanced),
        Skill(name: 'Git', category: 'Tools & Platforms', proficiency: SkillProficiency.expert),
        Skill(name: 'PostgreSQL', category: 'Tools & Platforms', proficiency: SkillProficiency.advanced),
        Skill(name: 'MongoDB', category: 'Tools & Platforms', proficiency: SkillProficiency.advanced),
        Skill(name: 'Problem Solving', category: 'Soft Skills', proficiency: SkillProficiency.expert),
        Skill(name: 'Team Leadership', category: 'Soft Skills', proficiency: SkillProficiency.advanced),
        Skill(name: 'Agile/Scrum', category: 'Soft Skills', proficiency: SkillProficiency.advanced),
      ],
      languages: [
        Language(name: 'English', proficiency: LanguageProficiency.c2Native),
        Language(name: 'Spanish', proficiency: LanguageProficiency.b2UpperIntermediate),
      ],
      customSections: [
        CustomSection(
          title: 'Certifications',
          items: [
            CustomSectionItem(
              title: 'AWS Certified Solutions Architect',
              subtitle: 'Amazon Web Services',
              description: 'Professional level certification demonstrating expertise in designing distributed systems on AWS.',
            ),
            CustomSectionItem(
              title: 'MongoDB Certified Developer',
              subtitle: 'MongoDB Inc.',
              description: 'Certification in MongoDB database design and development.',
            ),
          ],
        ),
        CustomSection(
          title: 'Projects',
          items: [
            CustomSectionItem(
              title: 'E-Commerce Platform',
              subtitle: 'Personal Project',
              description: 'Full-stack e-commerce platform built with MERN stack',
              bulletPoints: [
                'Implemented payment processing using Stripe API',
                'Built admin dashboard with real-time analytics',
                'Deployed on AWS with auto-scaling capabilities',
              ],
            ),
            CustomSectionItem(
              title: 'Open Source Contributions',
              subtitle: 'Various Projects',
              bulletPoints: [
                'Contributed to React core library (3 merged PRs)',
                'Maintained popular npm package with 50K+ downloads',
                'Active contributor to Flutter community',
              ],
            ),
          ],
        ),
      ],
    );
  }

  /// Create a sample resume for a UX Designer
  static Resume createUXDesignerResume() {
    return Resume(
      templateId: 'creative',
      personalInfo: PersonalInfo(
        fullName: 'Sarah Martinez',
        email: 'sarah.martinez@design.com',
        phone: '+1 (555) 987-6543',
        city: 'New York',
        country: 'USA',
        linkedin: 'linkedin.com/in/sarahmartinez',
        profileSummary: 'Creative UX/UI Designer with 4+ years of experience crafting intuitive and beautiful digital experiences. Specialized in user research, wireframing, and prototyping. Passionate about accessibility and creating inclusive designs that delight users.',
      ),
      experiences: [
        Experience(
          jobTitle: 'Senior UX Designer',
          company: 'DesignHub',
          location: 'New York, NY',
          startDate: DateTime(2022, 1, 1),
          isCurrent: true,
          description: 'Leading UX design for mobile and web applications, conducting user research and usability testing.',
          responsibilities: [
            'Led design of mobile app redesign increasing user retention by 45%',
            'Conducted user research with 200+ participants to inform design decisions',
            'Created comprehensive design system used across 5 product teams',
            'Mentored 3 junior designers on UX best practices and tools',
          ],
        ),
        Experience(
          jobTitle: 'UX Designer',
          company: 'Creative Agency',
          location: 'Brooklyn, NY',
          startDate: DateTime(2020, 3, 1),
          endDate: DateTime(2021, 12, 31),
          description: 'Designed user interfaces for diverse client projects across various industries.',
          responsibilities: [
            'Designed 20+ client projects from concept to final delivery',
            'Collaborated with developers to ensure design implementation quality',
            'Conducted A/B testing improving conversion rates by average of 30%',
          ],
        ),
      ],
      educations: [
        Education(
          degree: 'Bachelor of Fine Arts in Graphic Design',
          institution: 'Parsons School of Design',
          startDate: DateTime(2016, 9, 1),
          endDate: DateTime(2020, 5, 31),
          gpa: '3.9/4.0',
          achievements: [
            'Graduated with Honors',
            'Best Thesis Project Award 2020',
            'President of Design Student Association',
          ],
        ),
      ],
      skills: [
        Skill(name: 'Figma', category: 'Design Tools', proficiency: SkillProficiency.expert),
        Skill(name: 'Adobe XD', category: 'Design Tools', proficiency: SkillProficiency.expert),
        Skill(name: 'Sketch', category: 'Design Tools', proficiency: SkillProficiency.advanced),
        Skill(name: 'Adobe Photoshop', category: 'Design Tools', proficiency: SkillProficiency.advanced),
        Skill(name: 'Adobe Illustrator', category: 'Design Tools', proficiency: SkillProficiency.advanced),
        Skill(name: 'User Research', category: 'UX Skills', proficiency: SkillProficiency.expert),
        Skill(name: 'Wireframing', category: 'UX Skills', proficiency: SkillProficiency.expert),
        Skill(name: 'Prototyping', category: 'UX Skills', proficiency: SkillProficiency.expert),
        Skill(name: 'Usability Testing', category: 'UX Skills', proficiency: SkillProficiency.advanced),
        Skill(name: 'HTML/CSS', category: 'Technical', proficiency: SkillProficiency.intermediate),
        Skill(name: 'Design Systems', category: 'UX Skills', proficiency: SkillProficiency.advanced),
      ],
      languages: [
        Language(name: 'English', proficiency: LanguageProficiency.c2Native),
        Language(name: 'Spanish', proficiency: LanguageProficiency.c2Native),
        Language(name: 'French', proficiency: LanguageProficiency.b1Intermediate),
      ],
      customSections: [
        CustomSection(
          title: 'Awards',
          items: [
            CustomSectionItem(
              title: 'Best Mobile App Design',
              subtitle: 'UX Design Awards 2023',
              description: 'Recognized for outstanding mobile app interface design.',
            ),
            CustomSectionItem(
              title: 'Innovation in Digital Design',
              subtitle: 'Creative Circle Awards 2022',
            ),
          ],
        ),
      ],
    );
  }

  /// Create a sample resume for a Marketing Manager
  static Resume createMarketingManagerResume() {
    return Resume(
      templateId: 'modern',
      personalInfo: PersonalInfo(
        fullName: 'Michael Chen',
        email: 'michael.chen@marketing.com',
        phone: '+1 (555) 456-7890',
        city: 'Austin',
        country: 'USA',
        linkedin: 'linkedin.com/in/michaelchen',
        profileSummary: 'Results-driven Marketing Manager with 6+ years of experience in digital marketing, brand strategy, and team leadership. Proven track record of increasing brand awareness and driving revenue growth through innovative marketing campaigns.',
      ),
      experiences: [
        Experience(
          jobTitle: 'Marketing Manager',
          company: 'Growth Tech Inc.',
          location: 'Austin, TX',
          startDate: DateTime(2021, 6, 1),
          isCurrent: true,
          description: 'Leading marketing team of 8 people, developing and executing comprehensive marketing strategies.',
          responsibilities: [
            'Increased brand awareness by 150% through integrated marketing campaigns',
            'Managed \$2M annual marketing budget with 45% ROI improvement',
            'Led team of 8 marketing professionals across content, social, and paid media',
            'Launched product resulting in \$5M revenue in first year',
            'Implemented marketing automation increasing lead generation by 200%',
          ],
        ),
        Experience(
          jobTitle: 'Digital Marketing Specialist',
          company: 'E-Commerce Plus',
          location: 'Dallas, TX',
          startDate: DateTime(2019, 3, 1),
          endDate: DateTime(2021, 5, 31),
          description: 'Managed digital marketing campaigns across multiple channels.',
          responsibilities: [
            'Managed PPC campaigns with \$500K budget achieving 3.5x ROAS',
            'Grew social media following from 10K to 150K in 18 months',
            'Implemented email marketing strategy increasing open rates by 40%',
          ],
        ),
      ],
      educations: [
        Education(
          degree: 'MBA in Marketing',
          institution: 'University of Texas at Austin',
          startDate: DateTime(2017, 9, 1),
          endDate: DateTime(2019, 5, 31),
          gpa: '3.85/4.0',
        ),
        Education(
          degree: 'Bachelor of Business Administration',
          institution: 'Texas A&M University',
          startDate: DateTime(2013, 9, 1),
          endDate: DateTime(2017, 5, 31),
          achievements: [
            'Summa Cum Laude',
            'Marketing Student of the Year 2017',
          ],
        ),
      ],
      skills: [
        Skill(name: 'Digital Marketing', category: 'Marketing', proficiency: SkillProficiency.expert),
        Skill(name: 'SEO/SEM', category: 'Marketing', proficiency: SkillProficiency.expert),
        Skill(name: 'Content Marketing', category: 'Marketing', proficiency: SkillProficiency.advanced),
        Skill(name: 'Social Media Marketing', category: 'Marketing', proficiency: SkillProficiency.expert),
        Skill(name: 'Email Marketing', category: 'Marketing', proficiency: SkillProficiency.advanced),
        Skill(name: 'Google Analytics', category: 'Tools', proficiency: SkillProficiency.expert),
        Skill(name: 'HubSpot', category: 'Tools', proficiency: SkillProficiency.advanced),
        Skill(name: 'Salesforce', category: 'Tools', proficiency: SkillProficiency.intermediate),
        Skill(name: 'Team Leadership', category: 'Soft Skills', proficiency: SkillProficiency.advanced),
        Skill(name: 'Strategic Planning', category: 'Soft Skills', proficiency: SkillProficiency.expert),
      ],
      languages: [
        Language(name: 'English', proficiency: LanguageProficiency.c2Native),
        Language(name: 'Chinese', proficiency: LanguageProficiency.c1Advanced),
      ],
      customSections: [
        CustomSection(
          title: 'Certifications',
          items: [
            CustomSectionItem(
              title: 'Google Analytics Certified',
              subtitle: 'Google',
            ),
            CustomSectionItem(
              title: 'HubSpot Inbound Marketing Certification',
              subtitle: 'HubSpot Academy',
            ),
            CustomSectionItem(
              title: 'Facebook Blueprint Certification',
              subtitle: 'Meta',
            ),
          ],
        ),
      ],
    );
  }

  /// Get all demo resumes
  static List<Resume> getAllDemoResumes() {
    return [
      createSoftwareEngineerResume(),
      createUXDesignerResume(),
      createMarketingManagerResume(),
    ];
  }

  /// Get demo resume names
  static List<String> getDemoResumeNames() {
    return [
      'Software Engineer',
      'UX Designer',
      'Marketing Manager',
    ];
  }
}
