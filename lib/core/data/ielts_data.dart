class IeltsSkillModule {
  final String id;
  final String title;
  final String subTitle;
  final String duration;
  final String questionsCount;
  final String iconName;
  final List<String> tips;
  final List<IeltsQuestionSample> samples;

  const IeltsSkillModule({
    required this.id,
    required this.title,
    required this.subTitle,
    required this.duration,
    required this.questionsCount,
    required this.iconName,
    required this.tips,
    required this.samples,
  });
}

class IeltsQuestionSample {
  final String title;
  final String prompt;
  final String bandTarget;
  final String sampleAnswer;
  final List<String> keyVocabulary;

  const IeltsQuestionSample({
    required this.title,
    required this.prompt,
    required this.bandTarget,
    required this.sampleAnswer,
    required this.keyVocabulary,
  });
}

class IeltsCueCardItem {
  final String id;
  final String topicCategory;
  final String title;
  final List<String> bulletPoints;
  final String sampleAnswer;
  final List<String> part3Questions;
  final List<String> band8Vocabulary;
  final String difficulty;

  const IeltsCueCardItem({
    required this.id,
    required this.topicCategory,
    required this.title,
    required this.bulletPoints,
    required this.sampleAnswer,
    required this.part3Questions,
    required this.band8Vocabulary,
    this.difficulty = "Band 7.5+",
  });
}

class IeltsSpeakingPart1 {
  final String topic;
  final List<IeltsQuestionSample> questions;

  const IeltsSpeakingPart1({
    required this.topic,
    required this.questions,
  });
}

class IeltsBandDescriptor {
  final String band;
  final String level;
  final String fluency;
  final String lexical;
  final String grammar;
  final String pronunciation;

  const IeltsBandDescriptor({
    required this.band,
    required this.level,
    required this.fluency,
    required this.lexical,
    required this.grammar,
    required this.pronunciation,
  });
}

class IeltsMockTestRecord {
  final String id;
  final String testName;
  final String section;
  final double bandScore;
  final String date;
  final String notes;

  const IeltsMockTestRecord({
    required this.id,
    required this.testName,
    required this.section,
    required this.bandScore,
    required this.date,
    required this.notes,
  });
}

class IeltsData {
  static const List<String> categories = [
    "All",
    "Technology & AI",
    "Work & Study",
    "Environment & Nature",
    "Travel & Culture",
    "People & Society",
    "Events & Experiences",
  ];

  static const List<IeltsBandDescriptor> bandDescriptors = [
    IeltsBandDescriptor(
      band: "9.0",
      level: "Expert User",
      fluency: "Speaks fluently with only rare repetition or self-correction. Coherent with fully appropriate cohesive features.",
      lexical: "Uses full vocabulary flexibility and precision in all topics. Idiomatic language used naturally.",
      grammar: "Uses full range of structures naturally and appropriately. Produces consistently accurate structures.",
      pronunciation: "Uses a full range of pronunciation features with precision and subtlety. Effortless to understand.",
    ),
    IeltsBandDescriptor(
      band: "8.0",
      level: "Very Good User",
      fluency: "Speaks fluently with only occasional repetition or hesitation. Develops topics coherently and appropriately.",
      lexical: "Uses wide vocabulary readily and flexibly. Skilfully uses uncommon and idiomatic items.",
      grammar: "Uses a wide range of structures flexibly. Majority of sentences are completely error-free.",
      pronunciation: "Uses a wide range of pronunciation features. Sustains flexible use of features with only rare lapses.",
    ),
    IeltsBandDescriptor(
      band: "7.0",
      level: "Good User",
      fluency: "Speaks at length without noticeable effort. May demonstrate language-related hesitation at times.",
      lexical: "Uses vocabulary resource flexibly to discuss a variety of topics. Uses some less common and idiomatic vocabulary.",
      grammar: "Uses a range of complex structures with some flexibility. Frequently produces error-free sentences.",
      pronunciation: "Shows all positive features of Band 6 and some but not all of Band 8.",
    ),
    IeltsBandDescriptor(
      band: "6.0",
      level: "Competent User",
      fluency: "Willing to speak at length, though may lose coherence at times due to repetition or self-correction.",
      lexical: "Has a wide enough vocabulary to discuss topics at length and make meaning clear despite inaccuracies.",
      grammar: "Uses a mix of simple and complex structures, but with limited flexibility. May make frequent mistakes with complex structures.",
      pronunciation: "Uses a range of pronunciation features with mixed control. Generally intelligible throughout.",
    ),
    IeltsBandDescriptor(
      band: "5.0",
      level: "Modest User",
      fluency: "Usually maintains flow of speech but uses repetition and slow speech to keep going.",
      lexical: "Manages to talk about familiar topics, but uses vocabulary with limited flexibility.",
      grammar: "Produces basic sentence forms with reasonable accuracy. Uses a limited range of more complex structures.",
      pronunciation: "Shows all positive features of Band 4 and some but not all of Band 6.",
    ),
  ];

  static const List<IeltsCueCardItem> cueCards = [
    IeltsCueCardItem(
      id: "cue_1",
      topicCategory: "Technology & AI",
      title: "Describe an AI tool or piece of technology you find useful",
      bulletPoints: [
        "What it is and how you found out about it",
        "How often and for what purpose you use it",
        "What features make it stand out from others",
        "And explain why you consider it so useful in your daily life or studies",
      ],
      sampleAnswer:
          "I'd like to talk about an artificial intelligence productivity assistant that has revolutionized the way I organize my academic work. I first stumbled upon it through a tech podcast roughly a year ago, and since then, it has become an indispensable part of my daily routine.\n\nPrimarily, I utilize this tool for summarizing complex research papers, refining my writing style, and brainstorming novel ideas for university projects. What sets it apart from conventional software is its remarkable capability to understand nuanced natural language queries and generate highly context-aware solutions instantaneously.\n\nIn essence, I find it extraordinarily beneficial because it saves me countless hours of mundane administrative tasks, allowing me to channel my focus into critical thinking and deep analytical problem-solving.",
      part3Questions: [
        "Do you think artificial intelligence will replace human teachers in the future?",
        "How has modern technology influenced the attention span of teenagers?",
        "What ethical dilemmas arise from the rapid adoption of AI tools?",
      ],
      band8Vocabulary: [
        "Revolutionized",
        "Indispensable part",
        "Stumbled upon",
        "Nuanced queries",
        "Context-aware",
        "Mundane tasks",
      ],
      difficulty: "Band 8.0+",
    ),
    IeltsCueCardItem(
      id: "cue_2",
      topicCategory: "Work & Study",
      title: "Describe an ambitious goal you achieved in your studies or career",
      bulletPoints: [
        "What the goal was and when you set it",
        "What challenges you faced while pursuing it",
        "How you managed to overcome these obstacles",
        "And explain how you felt after reaching this milestone",
      ],
      sampleAnswer:
          "One of the most rewarding milestones I have achieved was attaining a first-class honors degree in my undergraduate studies. I established this ambitious objective during my freshman year, fully aware that it would require unwavering dedication and relentless effort.\n\nThe journey was fraught with difficulties, particularly balancing arduous coursework with part-time employment and extracurricular commitments. There were instances where burn-out felt inevitable, especially during examination periods.\n\nTo overcome these hurdles, I adopted meticulous time-management strategies, implementing structured study blocks and seeking timely feedback from my academic tutors. Crossing the finish line and receiving that accolade brought an overwhelming sense of accomplishment, reinforcing my belief that resilience and disciplined effort always pay dividends.",
      part3Questions: [
        "Why do some individuals set unrealistically high ambitions?",
        "Should parents set career goals for their children or allow them autonomy?",
        "How has globalization changed the career goals of young professionals?",
      ],
      band8Vocabulary: [
        "Rewarding milestone",
        "Fraught with difficulties",
        "Arduous coursework",
        "Meticulous planning",
        "Overwhelming accomplishment",
        "Pay dividends",
      ],
      difficulty: "Band 8.5+",
    ),
    IeltsCueCardItem(
      id: "cue_3",
      topicCategory: "Environment & Nature",
      title: "Describe an environmental initiative in your hometown that made a difference",
      bulletPoints: [
        "What the initiative was and who organized it",
        "How the local community participated",
        "What changes occurred as a result",
        "And explain your personal perspective on this project",
      ],
      sampleAnswer:
          "I'd like to share an inspiring green initiative launched in my neighborhood known as the 'Urban Reforestation and Waste Segregation Campaign'. It was spearheaded by a grassroots youth organization about two years ago in response to declining air quality and rampant littering.\n\nThe organizers engaged local residents by setting up community tree-planting drives and introducing color-coded recycling bins in every residential block. Workshops were also conducted to educate households on composting organic waste.\n\nThe transformation was tangible. Within months, our avenues were noticeably greener, and street litter plummeted significantly. From my viewpoint, this initiative proved that meaningful environmental sustainability doesn't solely rely on governmental policies; localized collective action can foster tremendous positive change.",
      part3Questions: [
        "What are the most pressing environmental threats facing developing nations today?",
        "How can schools instill eco-friendly values in primary school children?",
        "Is renewable energy capable of replacing fossil fuels completely in this decade?",
      ],
      band8Vocabulary: [
        "Spearheaded by",
        "Grassroots organization",
        "Rampant littering",
        "Tangible transformation",
        "Environmental sustainability",
        "Collective action",
      ],
      difficulty: "Band 8.0+",
    ),
    IeltsCueCardItem(
      id: "cue_4",
      topicCategory: "Travel & Culture",
      title: "Describe a memorable trip you took that broadened your horizons",
      bulletPoints: [
        "Where you went and with whom",
        "What unique activities or sights you experienced",
        "What cultural aspects surprised or fascinated you",
        "And explain why this journey left a lasting impression on you",
      ],
      sampleAnswer:
          "A truly unforgettable journey that completely transformed my worldview was a solo backpacking expedition to the mountainous regions of northern Nepal three years ago.\n\nDuring this two-week trek, I navigated steep Alpine trails, visited ancient Buddhist monasteries, and immersed myself in the tranquility of remote high-altitude villages. What fascinated me most was the profound hospitality of the Sherpa community, who embraced visitors with genuine warmth despite living in austere conditions.\n\nThis trip broadened my perspective on happiness and minimalism. It taught me that material luxury is secondary to inner peace and human connection, leaving an indelible mark on my personality and outlook on life.",
      part3Questions: [
        "How does international travel influence a person's cultural empathy?",
        "What negative repercussions can mass tourism have on delicate ecosystems?",
        "Do you think virtual tourism will ever replace actual physical journeys?",
      ],
      band8Vocabulary: [
        "Transformed my worldview",
        "Backpacking expedition",
        "High-altitude trails",
        "Profound hospitality",
        "Austere conditions",
        "Indelible mark",
      ],
      difficulty: "Band 8.5+",
    ),
    IeltsCueCardItem(
      id: "cue_5",
      topicCategory: "People & Society",
      title: "Describe an inspiring person you know who has made a positive social impact",
      bulletPoints: [
        "Who this person is and how you know them",
        "What noble work or social contributions they have made",
        "What challenges they encountered in their journey",
        "And explain why you admire them so deeply",
      ],
      sampleAnswer:
          "I would like to speak about a retired high school educator in my hometown named Mr. Chowdhury, who established a complimentary evening literacy program for underprivileged children.\n\nAfter dedicating four decades to teaching, he noticed that many children in slum communities lacked access to basic schooling. He single-handedly transformed a modest community shed into a vibrant classroom, providing free textbooks, stationery, and personalized tutoring.\n\nDespite facing severe financial constraints and skepticism from local authorities initially, his perseverance never wavered. Today, over two hundred students have graduated into mainstream secondary education. I hold immense admiration for his altruism and unwavering commitment to educational equity.",
      part3Questions: [
        "What qualities distinguish a great community leader from an ordinary citizen?",
        "Do you think younger generations are more socially conscious than previous ones?",
        "Should voluntary community service be made mandatory in high schools?",
      ],
      band8Vocabulary: [
        "Complimentary program",
        "Underprivileged children",
        "Skepticism",
        "Perseverance never wavered",
        "Immense admiration",
        "Educational equity",
      ],
      difficulty: "Band 8.0+",
    ),
    IeltsCueCardItem(
      id: "cue_6",
      topicCategory: "Events & Experiences",
      title: "Describe a public festival or cultural event that brought people together",
      bulletPoints: [
        "What the event was and where it took place",
        "What activities, music, or food were featured",
        "Who participated in this celebration",
        "And explain why this event was culturally significant",
      ],
      sampleAnswer:
          "I'd like to describe the annual Bengali New Year celebration, widely known as 'Pohela Boishakh', which takes place across Bangladesh every April.\n\nThe centerpiece of the festival is the 'Mangal Shobhajatra', a flamboyant cultural procession featuring gigantic handmade masks, colorful motifs of native wildlife, and traditional folk rhythms. People from all walks of life, irrespective of religion or socioeconomic background, dress in vibrant red and white attire, feast on traditional Hilsha fish and soaked rice, and celebrate cultural harmony.\n\nThis event is of paramount cultural significance because it serves as a powerful symbol of unity, secular heritage, and optimism for the upcoming year.",
      part3Questions: [
        "Why is it essential for modern nations to preserve traditional cultural festivals?",
        "How has commercialization affected traditional celebrations in recent decades?",
        "Can international sporting events promote world peace effectively?",
      ],
      band8Vocabulary: [
        "Centerpiece of the festival",
        "Flamboyant procession",
        "Socioeconomic background",
        "Paramount significance",
        "Secular heritage",
        "Cultural harmony",
      ],
      difficulty: "Band 8.5+",
    ),
    IeltsCueCardItem(
      id: "cue_7",
      topicCategory: "Technology & AI",
      title: "Describe a website or mobile application that changed how you learn",
      bulletPoints: [
        "What the platform is and how you discovered it",
        "What specific subjects or skills you learn with it",
        "How its features enhance your learning efficiency",
        "And explain why you prefer it over traditional learning methods",
      ],
      sampleAnswer:
          "I would like to talk about an interactive language learning and flashcard application named Anki, which utilizes spaced repetition algorithms to accelerate memory retention.\n\nI discovered it while preparing for standardized proficiency tests. The platform allows users to create customized digital flashcard decks embedded with audio clips, phonetic transcriptions, and contextual sentences.\n\nWhat makes it extraordinarily effective is its algorithmic scheduling—it prompts you to review a concept just before your brain is about to forget it. This active recall mechanism drastically reduces study time compared to passive textbook reading, making learning much more engaging and long-lasting.",
      part3Questions: [
        "How has online self-paced learning transformed higher education?",
        "Are smartphones more of a distraction or an educational asset for students?",
        "Will conventional printed textbooks become obsolete within the next decade?",
      ],
      band8Vocabulary: [
        "Spaced repetition algorithms",
        "Memory retention",
        "Phonetic transcriptions",
        "Active recall mechanism",
        "Passive reading",
        "Obsolete",
      ],
      difficulty: "Band 8.0+",
    ),
    IeltsCueCardItem(
      id: "cue_8",
      topicCategory: "Work & Study",
      title: "Describe a difficult decision you had to make regarding your career or education",
      bulletPoints: [
        "What the decision was and when you faced it",
        "What alternatives were available to you",
        "How you weighed the pros and cons",
        "And explain why you chose that particular path",
      ],
      sampleAnswer:
          "A pivotal crossroad in my academic journey occurred two years ago when I had to choose between accepting a secure corporate job offer or pursuing a rigorous postgraduate degree abroad.\n\nOn one hand, the employment opportunity guaranteed financial stability and immediate career advancement. On the other hand, the Master's program offered world-class faculty mentorship and specialized research exposure, though it required substantial financial investment and stepping outside my comfort zone.\n\nAfter deliberating thoroughly and consulting academic mentors, I resolved to pursue the degree. I recognized that short-term comfort could not rival the long-term intellectual growth and international career prospects that higher education provides.",
      part3Questions: [
        "Why do young graduates often struggle when making career choices?",
        "How important is parental guidance when choosing a university major?",
        "Should employers provide more internship opportunities to assist career exploration?",
      ],
      band8Vocabulary: [
        "Pivotal crossroad",
        "Rigorous postgraduate degree",
        "Substantial investment",
        "Comfort zone",
        "Deliberating thoroughly",
        "Rival long-term growth",
      ],
      difficulty: "Band 8.5+",
    ),
  ];

  static const List<IeltsSpeakingPart1> part1Topics = [
    IeltsSpeakingPart1(
      topic: "Hometown & Neighborhood",
      questions: [
        IeltsQuestionSample(
          title: "Hometown features",
          prompt: "What do you like most about your hometown?",
          bandTarget: "Band 8.5",
          sampleAnswer: "What I find most appealing is its vibrant cultural heritage blended seamlessly with lush green parks, offering a serene escape from urban chaos.",
          keyVocabulary: ["Vibrant heritage", "Blended seamlessly", "Serene escape"],
        ),
        IeltsQuestionSample(
          title: "Future living plans",
          prompt: "Do you plan to continue living there in the future?",
          bandTarget: "Band 8.0",
          sampleAnswer: "While I hold deep affection for my hometown, I aspire to relocate to an international metropolitan hub to pursue advanced career prospects.",
          keyVocabulary: ["Deep affection", "Metropolitan hub", "Career prospects"],
        ),
      ],
    ),
    IeltsSpeakingPart1(
      topic: "Studies & Daily Routine",
      questions: [
        IeltsQuestionSample(
          title: "Daily study habits",
          prompt: "What time of day do you find it easiest to focus on your studies?",
          bandTarget: "Band 8.5",
          sampleAnswer: "I am definitely an early bird. I find that my cognitive sharpness is at its peak in the early morning before the distractions of the day commence.",
          keyVocabulary: ["Cognitive sharpness", "Peak productivity", "Commence"],
        ),
      ],
    ),
  ];

  static List<IeltsCueCardItem> get cueCardPool => cueCards;
  static List<IeltsSpeakingPart1> get speakingPart1Topics => part1Topics;

  static const List<IeltsSkillModule> skillModules = [
    IeltsSkillModule(
      id: "speaking",
      title: "Speaking",
      subTitle: "3 Parts • 11-14 Minutes",
      duration: "11-14 min",
      questionsCount: "3 Parts",
      iconName: "mic",
      tips: [
        "Part 1: Give 2-3 sentence answers without one-word replies.",
        "Part 2: Use the 1-minute prep time to jot down bullet point keywords.",
        "Part 3: Structure answers using PEEL (Point, Explanation, Example, Link).",
        "Avoid filler words like 'umm' and 'uhh'; use natural discourse markers.",
      ],
      samples: [
        IeltsQuestionSample(
          title: "Part 1: Hometown",
          prompt: "Let's talk about your hometown. What is the most attractive feature of where you live?",
          bandTarget: "Band 8.5",
          sampleAnswer: "What I find most captivating about my hometown is its harmonious juxtaposition of historical architecture alongside lush, verdant green parks. It provides a peaceful sanctuary away from the hustle and bustle of city life.",
          keyVocabulary: ["Captivating", "Harmonious juxtaposition", "Verdant parks", "Sanctuary"],
        ),
      ],
    ),
    IeltsSkillModule(
      id: "listening",
      title: "Listening",
      subTitle: "4 Sections • 40 Questions",
      duration: "30+10 min",
      questionsCount: "40 Questions",
      iconName: "headset",
      tips: [
        "Underline keywords during the 30-second preview time before each audio section.",
        "Watch out for distractors where speakers correct themselves mid-sentence.",
        "Be careful with singular vs plural noun endings and spelling accuracy.",
        "Transfer answers accurately onto your answer sheet within the 10-minute transfer period.",
      ],
      samples: [
        IeltsQuestionSample(
          title: "Section 1: Social Conversation",
          prompt: "Form Completion: Booking a tour package for a weekend getaway.",
          bandTarget: "Band 9.0",
          sampleAnswer: "Pay close attention to dates, telephone numbers, and surname spellings. Example: 'That's double 'T' in Potter'.",
          keyVocabulary: ["Confirmation number", "Itinerary", "Provisional booking", "Dietary requirements"],
        ),
      ],
    ),
    IeltsSkillModule(
      id: "reading",
      title: "Reading",
      subTitle: "3 Passages • 40 Questions",
      duration: "60 min",
      questionsCount: "40 Questions",
      iconName: "menu_book",
      tips: [
        "Skim first for the gist, then scan for specific names, dates, and technical nouns.",
        "True/False/Not Given: True = matches passage, False = contradicts, Not Given = information is absent.",
        "Do not spend more than 20 minutes on any single passage.",
        "All answers must be copied directly during the 60-minute test period (no extra transfer time).",
      ],
      samples: [
        IeltsQuestionSample(
          title: "Passage 3: Academic Research",
          prompt: "Matching headings to paragraphs discussing the history of subterranean urban planning.",
          bandTarget: "Band 8.5",
          sampleAnswer: "Focus on topic sentences (first and last lines of each paragraph) to capture the central theme before selecting headings.",
          keyVocabulary: ["Subterranean", "Demographic influx", "Infrastructure feasibility", "Paradigm shift"],
        ),
      ],
    ),
    IeltsSkillModule(
      id: "writing",
      title: "Writing",
      subTitle: "2 Tasks • 150 & 250 Words",
      duration: "60 min",
      questionsCount: "2 Tasks",
      iconName: "edit_note",
      tips: [
        "Task 1: Spend 20 minutes writing at least 150 words describing main trends and key features.",
        "Task 2: Spend 40 minutes writing at least 250 words with a clear thesis statement and cohesive body paragraphs.",
        "Avoid memorized templates; demonstrate natural academic vocabulary and complex grammatical structures.",
        "Always leave 3-5 minutes at the end to proofread for subject-verb agreement and punctuation.",
      ],
      samples: [
        IeltsQuestionSample(
          title: "Task 2: Opinion Essay",
          prompt: "Some people argue that universities should prioritize job-ready skills over theoretical academic knowledge. To what extent do you agree or disagree?",
          bandTarget: "Band 8.5",
          sampleAnswer: "While equipping students with marketable vocational skills is undoubtedly paramount in modern economies, I strongly contend that a comprehensive theoretical foundation is equally crucial for fostering long-term innovation and adaptable intellect.",
          keyVocabulary: ["Vocational proficiency", "Paramount", "Intellectual agility", "Theoretical underpinnings"],
        ),
      ],
    ),
  ];

  static double calculateOverallBand({
    required double speaking,
    required double listening,
    required double reading,
    required double writing,
  }) {
    final average = (speaking + listening + reading + writing) / 4.0;
    final fractionalPart = average - average.floor();

    if (fractionalPart < 0.25) {
      return average.floorToDouble();
    } else if (fractionalPart < 0.75) {
      return average.floorToDouble() + 0.5;
    } else {
      return (average.floor() + 1).toDouble();
    }
  }

  static double rawScoreToListeningBand(int rawScore) {
    if (rawScore >= 39) return 9.0;
    if (rawScore >= 37) return 8.5;
    if (rawScore >= 35) return 8.0;
    if (rawScore >= 32) return 7.5;
    if (rawScore >= 30) return 7.0;
    if (rawScore >= 26) return 6.5;
    if (rawScore >= 23) return 6.0;
    if (rawScore >= 18) return 5.5;
    if (rawScore >= 16) return 5.0;
    if (rawScore >= 13) return 4.5;
    if (rawScore >= 10) return 4.0;
    return 3.5;
  }

  static double rawScoreToReadingAcademicBand(int rawScore) {
    if (rawScore >= 39) return 9.0;
    if (rawScore >= 37) return 8.5;
    if (rawScore >= 35) return 8.0;
    if (rawScore >= 33) return 7.5;
    if (rawScore >= 30) return 7.0;
    if (rawScore >= 27) return 6.5;
    if (rawScore >= 23) return 6.0;
    if (rawScore >= 19) return 5.5;
    if (rawScore >= 15) return 5.0;
    if (rawScore >= 13) return 4.5;
    if (rawScore >= 10) return 4.0;
    return 3.5;
  }

  // --- 10 Topic-Wise Band 8.0+ Vocabulary Sets ---
  static const List<IeltsVocabularyTopic> vocabularyTopics = [
    IeltsVocabularyTopic(
      topicName: "Environment & Climate",
      icon: "🌱",
      words: [
        IeltsVocabWord(word: "Degradation", meaning: "Deterioration of environmental quality", collocation: "Environmental degradation", example: "Deforestation significantly accelerates environmental degradation in tropical regions."),
        IeltsVocabWord(word: "Mitigate", meaning: "To make less severe or serious", collocation: "Mitigate the consequences", example: "Renewable energy adoption helps mitigate the devastating impact of global warming."),
        IeltsVocabWord(word: "Depletion", meaning: "Reduction in the number or quantity of something", collocation: "Depletion of natural resources", example: "Over-mining leads to the irreversible depletion of fossil fuels."),
        IeltsVocabWord(word: "Biodiversity", meaning: "The variety of plant and animal life in a particular habitat", collocation: "Preserve biodiversity", example: "National parks are vital to preserve fragile global biodiversity."),
        IeltsVocabWord(word: "Combustion", meaning: "The process of burning something", collocation: "Fossil fuel combustion", example: "Automobile combustion emissions remain the primary culprit of urban smog."),
      ],
    ),
    IeltsVocabularyTopic(
      topicName: "Technology & AI",
      icon: "🤖",
      words: [
        IeltsVocabWord(word: "Ubiquitous", meaning: "Present, appearing, or found everywhere", collocation: "Ubiquitous presence", example: "Smartphones have achieved a ubiquitous presence in modern adolescent life."),
        IeltsVocabWord(word: "Automate", meaning: "Convert to largely automatic operations", collocation: "Automate routine tasks", example: "Machine learning algorithms can automate tedious administrative functions."),
        IeltsVocabWord(word: "Obsolescence", meaning: "The process of becoming outdated or obsolete", collocation: "Technological obsolescence", example: "Rapid software upgrades cause premature hardware obsolescence."),
        IeltsVocabWord(word: "Paradigm", meaning: "A typical example or pattern of something; a model", collocation: "Paradigm shift", example: "Generative AI represents a transformative paradigm shift in knowledge industries."),
        IeltsVocabWord(word: "Algorithmic", meaning: "Relating to a set of rules used in calculations", collocation: "Algorithmic bias", example: "Developers must rigorously test models to eliminate algorithmic bias."),
      ],
    ),
    IeltsVocabularyTopic(
      topicName: "Education & Pedagogy",
      icon: "🎓",
      words: [
        IeltsVocabWord(word: "Pedagogy", meaning: "The method and practice of teaching", collocation: "Innovative pedagogy", example: "Student-centered pedagogy improves retention compared to passive rote memorization."),
        IeltsVocabWord(word: "Curriculum", meaning: "The subjects comprising a course of study", collocation: "Well-rounded curriculum", example: "Schools should integrate critical thinking into their standard national curriculum."),
        IeltsVocabWord(word: "Acumen", meaning: "The ability to make good judgments and quick decisions", collocation: "Intellectual acumen", example: "Higher education equips graduates with the intellectual acumen necessary for leadership."),
        IeltsVocabWord(word: "Holistic", meaning: "Characterized by the treatment of the whole person", collocation: "Holistic development", example: "Extracurricular activities are indispensable for a child's holistic development."),
        IeltsVocabWord(word: "Rote", meaning: "Habitual, repetitive learning without deep thought", collocation: "Rote memorization", example: "Examiners discourage rote learning in favor of analytical problem solving."),
      ],
    ),
    IeltsVocabularyTopic(
      topicName: "Health & Medicine",
      icon: "🩺",
      words: [
        IeltsVocabWord(word: "Sedentary", meaning: "Tending to spend much time seated; inactive", collocation: "Sedentary lifestyle", example: "A sedentary lifestyle is a direct precursor to cardiovascular disease."),
        IeltsVocabWord(word: "Preventative", meaning: "Designed to keep something undesirable from occurring", collocation: "Preventative healthcare", example: "Investing in preventative healthcare reduces long-term hospitalization costs."),
        IeltsVocabWord(word: "Epidemic", meaning: "A widespread occurrence of an infectious disease", collocation: "Obesity epidemic", example: "Governments must implement sugar taxes to curb the growing obesity epidemic."),
        IeltsVocabWord(word: "Detrimental", meaning: "Tending to cause harm", collocation: "Detrimental effect", example: "Chronic sleep deprivation exerts a profoundly detrimental effect on cognitive focus."),
      ],
    ),
    IeltsVocabularyTopic(
      topicName: "Society & Globalization",
      icon: "🌍",
      words: [
        IeltsVocabWord(word: "Homogenization", meaning: "The process of making things uniform or similar", collocation: "Cultural homogenization", example: "Global retail chains contribute to the cultural homogenization of high streets."),
        IeltsVocabWord(word: "Disparity", meaning: "A great difference or inequality", collocation: "Economic disparity", example: "Progressive taxation aims to mitigate the widening economic disparity between social classes."),
        IeltsVocabWord(word: "Cosmopolitan", meaning: "Familiar with and at ease in many different countries and cultures", collocation: "Cosmopolitan metropolis", example: "London and Singapore are shining examples of vibrant cosmopolitan metropolises."),
        IeltsVocabWord(word: "Marginalize", meaning: "Treat a person or group as insignificant or peripheral", collocation: "Marginalized communities", example: "Inclusive policies must uplift marginalized communities across urban sectors."),
      ],
    ),
  ];

  // --- Band 9.0 Grammar & Complex Sentence Structures ---
  static const List<IeltsGrammarLesson> grammarLessons = [
    IeltsGrammarLesson(
      title: "Inversion for Emphasis",
      targetBand: "Band 8.5 - 9.0",
      rule: "Place a negative or limiting adverb at the beginning of the clause and invert the subject and auxiliary verb.",
      formula: "Negative Adverb + Auxiliary Verb + Subject + Main Verb...",
      band6Example: "Governments rarely take action before a crisis happens.",
      band8Example: "Seldom do governments take decisive action before a crisis escalates.",
      explanation: "Using 'Seldom do...', 'Not only did...', or 'Under no circumstances should...' demonstrates advanced grammatical control to the examiner.",
    ),
    IeltsGrammarLesson(
      title: "Conditional Inversion (3rd / Mixed Conditionals)",
      targetBand: "Band 8.0 - 9.0",
      rule: "Omit 'If' and invert 'Had' or 'Should' or 'Were' with the subject.",
      formula: "Had + Subject + Past Participle, Subject + would have + Past Participle",
      band6Example: "If the city had invested in subways, traffic would not be terrible.",
      band8Example: "Had the municipality invested in rapid transit, current gridlock would have been averted.",
      explanation: "Replaces standard 'If I had...' with a formal academic tone that immediately secures high Grammatical Range & Accuracy (GRA) marks.",
    ),
    IeltsGrammarLesson(
      title: "Cleft Sentences (Focus & Theme)",
      targetBand: "Band 8.0 - 9.0",
      rule: "Use 'It is / It was... that...' or 'What... is...' to emphasize a specific element of the sentence.",
      formula: "It is/was + [Emphasized Element] + that/who + [Rest of clause]",
      band6Example: "Parents must teach children discipline, not teachers.",
      band8Example: "It is the parents, rather than educators, who bear primary responsibility for instilling discipline.",
      explanation: "Cleft sentences add sophistication and clarity to Task 2 thesis statements and body paragraph arguments.",
    ),
    IeltsGrammarLesson(
      title: "Participle Clauses (Economy of Words)",
      targetBand: "Band 7.5 - 8.5",
      rule: "Combine two actions performed by the same subject using a present (-ing) or past (-ed) participle clause.",
      formula: "Having + Past Participle + [Clause 1], [Subject] + [Main Clause]",
      band6Example: "Because they recognized the danger, officials closed the bridge.",
      band8Example: "Having recognized the imminent structural danger, authorities promptly closed the bridge.",
      explanation: "Participle clauses show natural sentence variety and concise academic prose in both Task 1 summaries and Task 2 essays.",
    ),
  ];
}

class IeltsVocabWord {
  final String word;
  final String meaning;
  final String collocation;
  final String example;

  const IeltsVocabWord({
    required this.word,
    required this.meaning,
    required this.collocation,
    required this.example,
  });
}

class IeltsVocabularyTopic {
  final String topicName;
  final String icon;
  final List<IeltsVocabWord> words;

  const IeltsVocabularyTopic({
    required this.topicName,
    required this.icon,
    required this.words,
  });
}

class IeltsGrammarLesson {
  final String title;
  final String targetBand;
  final String rule;
  final String formula;
  final String band6Example;
  final String band8Example;
  final String explanation;

  const IeltsGrammarLesson({
    required this.title,
    required this.targetBand,
    required this.rule,
    required this.formula,
    required this.band6Example,
    required this.band8Example,
    required this.explanation,
  });
}
