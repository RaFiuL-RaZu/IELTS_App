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

  // --- 12 Comprehensive Band 8.0+ Topic-Wise Vocabulary Sets ---
  static const List<IeltsVocabularyTopic> vocabularyTopics = [
    IeltsVocabularyTopic(
      topicName: "Environment & Climate",
      icon: "ðŸŒ±",
      words: [
        IeltsVocabWord(word: "Degradation", meaning: "Deterioration of environmental quality", collocation: "Environmental degradation", example: "Deforestation significantly accelerates environmental degradation in tropical regions."),
        IeltsVocabWord(word: "Mitigate", meaning: "To make less severe or serious", collocation: "Mitigate the consequences", example: "Renewable energy adoption helps mitigate the devastating impact of global warming."),
        IeltsVocabWord(word: "Depletion", meaning: "Reduction in the number or quantity of something", collocation: "Depletion of natural resources", example: "Over-mining leads to the irreversible depletion of fossil fuels."),
        IeltsVocabWord(word: "Biodiversity", meaning: "The variety of plant and animal life in a particular habitat", collocation: "Preserve biodiversity", example: "National parks are vital to preserve fragile global biodiversity."),
        IeltsVocabWord(word: "Combustion", meaning: "The process of burning something", collocation: "Fossil fuel combustion", example: "Automobile combustion emissions remain the primary culprit of urban smog."),
        IeltsVocabWord(word: "Contamination", meaning: "The action of making something impure or poisonous", collocation: "Toxic contamination", example: "Industrial effluent causes severe chemical contamination in freshwater reservoirs."),
        IeltsVocabWord(word: "Sustainability", meaning: "Avoidance of the depletion of natural resources in order to maintain ecological balance", collocation: "Environmental sustainability", example: "Achieving environmental sustainability requires sweeping reforms in agricultural practices."),
        IeltsVocabWord(word: "Ecosystem", meaning: "A biological community of interacting organisms and their physical environment", collocation: "Fragile ecosystem", example: "Rising sea temperatures pose an existential threat to marine ecosystems."),
        IeltsVocabWord(word: "Deforestation", meaning: "The action of clearing a wide area of trees", collocation: "Unchecked deforestation", example: "Unchecked deforestation displaces indigenous wildlife and accelerates desertification."),
        IeltsVocabWord(word: "Inexhaustible", meaning: "Unable to be used up because existing in abundance", collocation: "Inexhaustible energy source", example: "Solar radiation provides an inexhaustible source of clean electricity."),
      ],
    ),
    IeltsVocabularyTopic(
      topicName: "Technology & AI",
      icon: "ðŸ¤–",
      words: [
        IeltsVocabWord(word: "Ubiquitous", meaning: "Present, appearing, or found everywhere", collocation: "Ubiquitous presence", example: "Smartphones have achieved a ubiquitous presence in modern adolescent life."),
        IeltsVocabWord(word: "Automate", meaning: "Convert to largely automatic operations", collocation: "Automate routine tasks", example: "Machine learning algorithms can automate tedious administrative functions."),
        IeltsVocabWord(word: "Obsolescence", meaning: "The process of becoming outdated or obsolete", collocation: "Technological obsolescence", example: "Rapid software upgrades cause premature hardware obsolescence."),
        IeltsVocabWord(word: "Paradigm", meaning: "A typical example or pattern of something; a model", collocation: "Paradigm shift", example: "Generative AI represents a transformative paradigm shift in knowledge industries."),
        IeltsVocabWord(word: "Algorithmic", meaning: "Relating to a set of rules used in calculations", collocation: "Algorithmic bias", example: "Developers must rigorously test models to eliminate algorithmic bias."),
        IeltsVocabWord(word: "Cybersecurity", meaning: "The state of being protected against criminal use of electronic data", collocation: "Cybersecurity vulnerabilities", example: "Financial institutions invest billions to patch potential cybersecurity vulnerabilities."),
        IeltsVocabWord(word: "Disruptive", meaning: "Innovatively transforming a traditional sector", collocation: "Disruptive innovation", example: "Ride-sharing applications proved to be a disruptive innovation in urban transit."),
        IeltsVocabWord(word: "Augment", meaning: "Make something greater by adding to it; enhance", collocation: "Augment human capabilities", example: "Robotic exoskeletons augment the physical capabilities of factory workers."),
        IeltsVocabWord(word: "Virtual", meaning: "Not physically existing as such but made by software", collocation: "Virtual reality simulation", example: "Medical students practice surgical procedures through immersive virtual reality simulations."),
        IeltsVocabWord(word: "Breakthrough", meaning: "A sudden, dramatic, and important discovery or development", collocation: "Scientific breakthrough", example: "Quantum computing represents a monumental scientific breakthrough."),
      ],
    ),
    IeltsVocabularyTopic(
      topicName: "Education & Pedagogy",
      icon: "ðŸŽ“",
      words: [
        IeltsVocabWord(word: "Pedagogy", meaning: "The method and practice of teaching", collocation: "Innovative pedagogy", example: "Student-centered pedagogy improves retention compared to passive rote memorization."),
        IeltsVocabWord(word: "Curriculum", meaning: "The subjects comprising a course of study", collocation: "Well-rounded curriculum", example: "Schools should integrate critical thinking into their standard national curriculum."),
        IeltsVocabWord(word: "Acumen", meaning: "The ability to make good judgments and quick decisions", collocation: "Intellectual acumen", example: "Higher education equips graduates with the intellectual acumen necessary for leadership."),
        IeltsVocabWord(word: "Holistic", meaning: "Characterized by the treatment of the whole person", collocation: "Holistic development", example: "Extracurricular activities are indispensable for a child's holistic development."),
        IeltsVocabWord(word: "Rote", meaning: "Habitual, repetitive learning without deep thought", collocation: "Rote memorization", example: "Examiners discourage rote learning in favor of analytical problem solving."),
        IeltsVocabWord(word: "Compulsory", meaning: "Required by law or a rule; obligatory", collocation: "Compulsory education", example: "Primary and secondary schooling is compulsory in most developed jurisdictions."),
        IeltsVocabWord(word: "Cognitive", meaning: "Relating to the mental processes of perception and judgment", collocation: "Cognitive development", example: "Early childhood storytelling fosters vital cognitive development and linguistic fluency."),
        IeltsVocabWord(word: "Didactic", meaning: "Intended to teach, particularly in having moral instruction", collocation: "Didactic approach", example: "Traditional didactic lectures often fail to stimulate creative debate among students."),
        IeltsVocabWord(word: "Literacy", meaning: "The ability to read and write", collocation: "Digital literacy", example: "Developing digital literacy is as critical today as basic reading and mathematical skills."),
        IeltsVocabWord(word: "Erudite", meaning: "Having or showing great knowledge or learning", collocation: "Erudite scholar", example: "The professor was an erudite scholar renowned worldwide for historical treatises."),
      ],
    ),
    IeltsVocabularyTopic(
      topicName: "Health & Medicine",
      icon: "ðŸ©º",
      words: [
        IeltsVocabWord(word: "Sedentary", meaning: "Tending to spend much time seated; inactive", collocation: "Sedentary lifestyle", example: "A sedentary lifestyle is a direct precursor to cardiovascular disease."),
        IeltsVocabWord(word: "Preventative", meaning: "Designed to keep something undesirable from occurring", collocation: "Preventative healthcare", example: "Investing in preventative healthcare reduces long-term hospitalization costs."),
        IeltsVocabWord(word: "Epidemic", meaning: "A widespread occurrence of an infectious disease", collocation: "Obesity epidemic", example: "Governments must implement sugar taxes to curb the growing obesity epidemic."),
        IeltsVocabWord(word: "Detrimental", meaning: "Tending to cause harm", collocation: "Detrimental effect", example: "Chronic sleep deprivation exerts a profoundly detrimental effect on cognitive focus."),
        IeltsVocabWord(word: "Longevity", meaning: "Long life or existence", collocation: "Promote longevity", example: "A balanced Mediterranean diet and regular aerobic exercise significantly promote longevity."),
        IeltsVocabWord(word: "Immunization", meaning: "The process whereby a person is made immune to an infectious disease", collocation: "Mass immunization campaign", example: "Universal immunization campaigns have successfully eradicated smallpox worldwide."),
        IeltsVocabWord(word: "Therapeutic", meaning: "Relating to the healing of disease", collocation: "Therapeutic benefits", example: "Mindfulness meditation provides measurable therapeutic benefits for anxiety disorders."),
        IeltsVocabWord(word: "Diagnosis", meaning: "The identification of the nature of an illness by examination", collocation: "Early diagnosis", example: "Early diagnosis of malignant tumors drastically enhances patient recovery rates."),
        IeltsVocabWord(word: "Nourishment", meaning: "The food necessary for growth, health, and good condition", collocation: "Essential nourishment", example: "School lunch programs ensure underprivileged children receive essential daily nourishment."),
        IeltsVocabWord(word: "Psychological", meaning: "Related to the mental and emotional state of a person", collocation: "Psychological resilience", example: "Counseling services help university students cultivate psychological resilience during exams."),
      ],
    ),
    IeltsVocabularyTopic(
      topicName: "Society & Globalization",
      icon: "ðŸŒ",
      words: [
        IeltsVocabWord(word: "Homogenization", meaning: "The process of making things uniform or similar", collocation: "Cultural homogenization", example: "Global retail chains contribute to the cultural homogenization of high streets."),
        IeltsVocabWord(word: "Disparity", meaning: "A great difference or inequality", collocation: "Economic disparity", example: "Progressive taxation aims to mitigate the widening economic disparity between social classes."),
        IeltsVocabWord(word: "Cosmopolitan", meaning: "Familiar with and at ease in many different countries and cultures", collocation: "Cosmopolitan metropolis", example: "London and Singapore are shining examples of vibrant cosmopolitan metropolises."),
        IeltsVocabWord(word: "Marginalize", meaning: "Treat a person or group as insignificant or peripheral", collocation: "Marginalized communities", example: "Inclusive policies must uplift marginalized communities across urban sectors."),
        IeltsVocabWord(word: "Demographics", meaning: "Statistical data relating to the population and particular groups within it", collocation: "Shifting demographics", example: "An aging population represents one of the most critical shifting demographics in East Asia."),
        IeltsVocabWord(word: "Infrastructure", meaning: "The basic physical and organizational structures needed for the operation of a society", collocation: "Public infrastructure", example: "Substantial capital investment in public infrastructure is essential for economic growth."),
        IeltsVocabWord(word: "Assimilation", meaning: "The process of taking in and fully understanding information or culture", collocation: "Cultural assimilation", example: "Language courses facilitate smoother cultural assimilation for incoming immigrants."),
        IeltsVocabWord(word: "Urbanization", meaning: "The process of making an area more urban", collocation: "Rapid urbanization", example: "Rapid urbanization places immense strain on sewage and water filtration utilities."),
        IeltsVocabWord(word: "Segregation", meaning: "The action of setting someone or something apart from others", collocation: "Social segregation", example: "Equitable zoning laws prevent economic and ethnic segregation in metropolitan areas."),
        IeltsVocabWord(word: "Socioeconomic", meaning: "Relating to the interaction of social and economic factors", collocation: "Socioeconomic background", example: "Children from disadvantaged socioeconomic backgrounds should receive supplemental academic aid."),
      ],
    ),
    IeltsVocabularyTopic(
      topicName: "Crime & Justice",
      icon: "âš–ï¸",
      words: [
        IeltsVocabWord(word: "Deterrent", meaning: "A thing that discourages or is intended to discourage someone from doing something", collocation: "Effective deterrent", example: "High conviction rates serve as a more effective deterrent than overly harsh prison sentences."),
        IeltsVocabWord(word: "Recidivism", meaning: "The tendency of a convicted criminal to reoffend", collocation: "High recidivism rate", example: "Vocational training programs in penitentiaries substantially reduce recidivism rates upon release."),
        IeltsVocabWord(word: "Incarceration", meaning: "The state of being confined in prison; imprisonment", collocation: "Long-term incarceration", example: "Criminologists argue that long-term incarceration fails to address the root causes of antisocial behavior."),
        IeltsVocabWord(word: "Rehabilitation", meaning: "The action of restoring someone to health or normal life through training", collocation: "Offender rehabilitation", example: "Prison reform must prioritize psychological counseling and offender rehabilitation over pure retribution."),
        IeltsVocabWord(word: "Delinquency", meaning: "Minor crime, especially that committed by young people", collocation: "Juvenile delinquency", example: "Community youth clubs play a pivotal role in preventing juvenile delinquency in suburban districts."),
        IeltsVocabWord(word: "Legislation", meaning: "Laws, considered collectively", collocation: "Enact strict legislation", example: "Parliaments must enact strict legislation to regulate unregulated online financial scams."),
        IeltsVocabWord(word: "Perpetrator", meaning: "A person who carries out a harmful, illegal, or immoral act", collocation: "Apprehend the perpetrator", example: "Law enforcement utilized forensic evidence to swiftly apprehend the perpetrator of the robbery."),
        IeltsVocabWord(word: "Surveillance", meaning: "Close observation, especially of a suspected spy or criminal", collocation: "CCTV surveillance", example: "Widespread CCTV surveillance enhances public safety in central business districts."),
        IeltsVocabWord(word: "Exonerate", meaning: "Absolve someone from blame for a fault or wrongdoing", collocation: "Exonerate an innocent suspect", example: "Modern DNA testing has the capability to unequivocally exonerate wrongfully convicted prisoners."),
        IeltsVocabWord(word: "Prohibit", meaning: "Formally forbid something by law, rule, or other authority", collocation: "Strictly prohibit", example: "Municipal authorities strictly prohibit open burning of refuse to safeguard atmospheric quality."),
      ],
    ),
    IeltsVocabularyTopic(
      topicName: "Economy & Business",
      icon: "ðŸ“ˆ",
      words: [
        IeltsVocabWord(word: "Fiscal", meaning: "Relating to government revenue, especially taxes", collocation: "Fiscal policy", example: "Central banks implement prudent fiscal policies to stabilize volatile national currencies."),
        IeltsVocabWord(word: "Inflation", meaning: "A general increase in prices and fall in the purchasing value of money", collocation: "Surging inflation", example: "Surging inflation diminishes the purchasing power of middle-income households."),
        IeltsVocabWord(word: "Prosperity", meaning: "The state of being prosperous; financial success", collocation: "Economic prosperity", example: "Stable governance and technological innovation underpin long-term national economic prosperity."),
        IeltsVocabWord(word: "Subsidy", meaning: "A sum of money granted by the government to assist an industry or business", collocation: "Government subsidy", example: "Government subsidies for clean energy accelerate the transition away from fossil fuels."),
        IeltsVocabWord(word: "Fluctuation", meaning: "An irregular rising and falling in number or amount; a variation", collocation: "Price fluctuation", example: "Commodity price fluctuations cause significant uncertainty for agricultural exporters."),
        IeltsVocabWord(word: "Monopoly", meaning: "The exclusive possession or control of the supply of or trade in a commodity", collocation: "Market monopoly", example: "Antitrust regulations prevent tech giants from establishing an unfair market monopoly."),
        IeltsVocabWord(word: "Entrepreneurship", meaning: "The activity of setting up a business or businesses, taking on financial risks", collocation: "Foster entrepreneurship", example: "Incubator programs foster young entrepreneurship and generate valuable employment opportunities."),
        IeltsVocabWord(word: "Consumption", meaning: "The using up of a resource or goods", collocation: "Domestic consumption", example: "A decline in domestic consumption often signals the onset of an economic recession."),
        IeltsVocabWord(word: "Viability", meaning: "Ability to work successfully; feasibility", collocation: "Commercial viability", example: "The commercial viability of hydrogen-powered transport depends on production cost reductions."),
        IeltsVocabWord(word: "Venture", meaning: "A risky or daring journey or business undertaking", collocation: "Joint venture", example: "The two pharmaceutical companies formed a joint venture to manufacture affordable vaccines."),
      ],
    ),
    IeltsVocabularyTopic(
      topicName: "Work & Career",
      icon: "ðŸ’¼",
      words: [
        IeltsVocabWord(word: "Competency", meaning: "The ability to do something successfully or efficiently", collocation: "Core competency", example: "Digital literacy and problem-solving represent core competencies in the twenty-first century workplace."),
        IeltsVocabWord(word: "Remuneration", meaning: "Money paid for work or a service", collocation: "Lucrative remuneration", example: "Software engineers often receive lucrative remuneration packages alongside stock equity."),
        IeltsVocabWord(word: "Monotonous", meaning: "Dull, tedious, and repetitious; lacking in variety and interest", collocation: "Monotonous task", example: "Automating monotonous data entry tasks allows workers to focus on creative strategic planning."),
        IeltsVocabWord(word: "Ergonomics", meaning: "The study of people's efficiency in their working environment", collocation: "Workplace ergonomics", example: "Investing in workplace ergonomics reduces chronic back injuries among office personnel."),
        IeltsVocabWord(word: "Productivity", meaning: "The effectiveness of productive effort", collocation: "Boost productivity", example: "Flexible working hours have been shown to boost employee productivity and overall morale."),
        IeltsVocabWord(word: "Freelance", meaning: "Working for different companies at different times rather than being permanently employed", collocation: "Freelance economy", example: "The rise of the freelance gig economy provides workers with unmatched autonomy."),
        IeltsVocabWord(word: "Collaboration", meaning: "The action of working with someone to produce something", collocation: "Cross-functional collaboration", example: "Complex scientific discoveries require intensive international cross-functional collaboration."),
        IeltsVocabWord(word: "Aptitude", meaning: "A natural ability to do something", collocation: "Demonstrate aptitude", example: "The interview process tests whether candidates demonstrate strong analytical aptitude."),
        IeltsVocabWord(word: "Promotion", meaning: "The action of raising someone to a higher position or rank", collocation: "Career promotion", example: "Merit-based evaluations ensure fair career promotion across diverse corporate teams."),
        IeltsVocabWord(word: "Balance", meaning: "A condition in which different elements are equal or in the correct proportions", collocation: "Work-life balance", example: "Maintaining a healthy work-life balance is crucial for preventing psychological burnout."),
      ],
    ),
    IeltsVocabularyTopic(
      topicName: "Arts & Culture",
      icon: "ðŸŽ¨",
      words: [
        IeltsVocabWord(word: "Heritage", meaning: "Valued objects and qualities such as historic buildings that have been passed down", collocation: "Cultural heritage", example: "UNESCO works tirelessly to preserve tangible and intangible cultural heritage globally."),
        IeltsVocabWord(word: "Aesthetics", meaning: "A set of principles concerned with the nature and appreciation of beauty", collocation: "Visual aesthetics", example: "Contemporary architectural design balances structural safety with minimalist visual aesthetics."),
        IeltsVocabWord(word: "Indigenous", meaning: "Originating or occurring naturally in a particular place; native", collocation: "Indigenous traditions", example: "Museums must actively celebrate and protect the rich folklore of indigenous traditions."),
        IeltsVocabWord(word: "Preserve", meaning: "Maintain something in its original or existing state", collocation: "Preserve historic monuments", example: "Municipal funding is necessary to restore and preserve historic monuments for posterity."),
        IeltsVocabWord(word: "Masterpiece", meaning: "A work of outstanding artistry, skill, or workmanship", collocation: "Artistic masterpiece", example: "The Renaissance era produced numerous artistic masterpieces that continue to captivate audiences."),
        IeltsVocabWord(word: "Avant-garde", meaning: "New and unusual or experimental ideas, especially in the arts", collocation: "Avant-garde movement", example: "The gallery showcases avant-garde sculptures that challenge traditional perspectives."),
        IeltsVocabWord(word: "Authenticity", meaning: "The quality of being authentic or genuine", collocation: "Preserve authenticity", example: "Tourists travel to rural villages seeking the cultural authenticity of native crafts."),
        IeltsVocabWord(word: "Folklore", meaning: "The traditional beliefs, customs, and stories of a community", collocation: "Traditional folklore", example: "Oral storytelling plays a vital role in passing down traditional folklore across generations."),
        IeltsVocabWord(word: "Expressionism", meaning: "A style of art in which the artist seeks to express emotional experience", collocation: "Artistic expressionism", example: "Expressionism allows painters to communicate visceral societal angst through vibrant colors."),
        IeltsVocabWord(word: "Diversity", meaning: "The state of being diverse; variety", collocation: "Cultural diversity", example: "Metropolitan cities thrive when they embrace and nurture rich cultural diversity."),
      ],
    ),
    IeltsVocabularyTopic(
      topicName: "Travel & Urban Life",
      icon: "âœˆï¸",
      words: [
        IeltsVocabWord(word: "Congestion", meaning: "The state of being overcrowded, especially with traffic", collocation: "Traffic congestion", example: "Implementing congestion pricing schemes reduces rush-hour traffic gridlock in central London."),
        IeltsVocabWord(word: "Ecotourism", meaning: "Tourism directed toward exotic, often threatened, natural environments", collocation: "Sustainable ecotourism", example: "Sustainable ecotourism generates revenue for wildlife conservation while empowering local communities."),
        IeltsVocabWord(word: "Indelible", meaning: "Making marks that cannot be removed; memorable", collocation: "Indelible impression", example: "Backpacking across the Himalayas left an indelible impression on my personal outlook."),
        IeltsVocabWord(word: "Influx", meaning: "An arrival or entry of large numbers of people or things", collocation: "Massive influx of tourists", example: "The coastal town experienced a massive influx of seasonal tourists during the summer."),
        IeltsVocabWord(word: "Horizon", meaning: "The limit of a person's mental perception, experience, or interest", collocation: "Broaden one's horizons", example: "Studying abroad allows young undergraduates to broaden their intellectual and cultural horizons."),
        IeltsVocabWord(word: "Hospitality", meaning: "The friendly and generous reception and entertainment of guests", collocation: "Profound hospitality", example: "Local homestays are renowned for their profound hospitality and home-cooked cuisine."),
        IeltsVocabWord(word: "Commute", meaning: "Travel some distance between one's home and place of work on a regular basis", collocation: "Daily commute", example: "High-speed electric trains drastically shorten the daily commute for suburban workers."),
        IeltsVocabWord(word: "Solitude", meaning: "The state or situation of being alone, often pleasant", collocation: "Peaceful solitude", example: "Hiking in remote national forests offers a rare sanctuary of peaceful solitude away from urban bustle."),
        IeltsVocabWord(word: "Metropolis", meaning: "A very large and densely populated industrial city", collocation: "Bustling metropolis", example: "Tokyo is a bustling metropolis known for cutting-edge transit infrastructure and efficiency."),
        IeltsVocabWord(word: "Destination", meaning: "The place to which someone or something is going or being sent", collocation: "Popular tourist destination", example: "Paris remains arguably the most popular tourist destination in continental Europe."),
      ],
    ),
    IeltsVocabularyTopic(
      topicName: "Media & Advertising",
      icon: "ðŸ“±",
      words: [
        IeltsVocabWord(word: "Sensationalism", meaning: "The use of shocking stories at the expense of accuracy in order to provoke interest", collocation: "Media sensationalism", example: "Tabloid journalism frequently relies on media sensationalism to maximize web traffic and click-through rates."),
        IeltsVocabWord(word: "Consumerism", meaning: "The protection or promotion of the interests of consumers; preoccupation with goods", collocation: "Rampant consumerism", example: "Aggressive billboard advertising fuels rampant consumerism and unnecessary household debt."),
        IeltsVocabWord(word: "Misinformation", meaning: "False or inaccurate information, especially that which is deliberately intended to deceive", collocation: "Spread misinformation", example: "Social networking algorithms can rapidly spread misinformation during public health emergencies."),
        IeltsVocabWord(word: "Censorship", meaning: "The suppression or prohibition of any parts of books, news, or films", collocation: "Government censorship", example: "Democratic societies advocate for press freedom while opposing arbitrary government censorship."),
        IeltsVocabWord(word: "Endorsement", meaning: "An act of giving one's public approval or support to someone or something", collocation: "Celebrity endorsement", example: "Companies pay substantial sums for celebrity endorsements to boost brand recognition."),
        IeltsVocabWord(word: "Commercialize", meaning: "Manage or exploit in a way designed to make a profit", collocation: "Commercialize sports", example: "Overzealous corporate sponsorship threatens to commercialize traditional athletic tournaments."),
        IeltsVocabWord(word: "Propaganda", meaning: "Information, especially of a biased nature, used to promote a political point of view", collocation: "Political propaganda", example: "Discerning readers cross-reference news sources to distinguish objective facts from political propaganda."),
        IeltsVocabWord(word: "Influence", meaning: "The capacity to have an effect on the character, development, or behavior of someone", collocation: "Pervasive influence", example: "Influencer marketing exerts a pervasive influence on teenage buying preferences."),
        IeltsVocabWord(word: "Broadcaster", meaning: "An organization that transmits a program or information by radio or television", collocation: "Public broadcaster", example: "Public broadcasters have a journalistic mandate to deliver unbiased reporting to citizens."),
        IeltsVocabWord(word: "Target", meaning: "Aim or direct something at", collocation: "Target audience", example: "Advertisers use demographic profiling to target their core audience with precision."),
      ],
    ),
    IeltsVocabularyTopic(
      topicName: "Science & Innovation",
      icon: "ðŸ”¬",
      words: [
        IeltsVocabWord(word: "Empirical", meaning: "Based on, concerned with, or verifiable by observation or experience rather than theory", collocation: "Empirical evidence", example: "Scientific peer review requires rigorous empirical evidence before accepting novel hypotheses."),
        IeltsVocabWord(word: "Hypothesis", meaning: "A proposed explanation made on the basis of limited evidence as a starting point", collocation: "Formulate a hypothesis", example: "Researchers formulate testable hypotheses before conducting randomized clinical trials."),
        IeltsVocabWord(word: "Phenomenon", meaning: "A fact or situation that is observed to exist or happen", collocation: "Global phenomenon", example: "Urban heat islands represent a well-documented meteorological phenomenon in large cities."),
        IeltsVocabWord(word: "Feasibility", meaning: "The state or degree of being easily or conveniently done", collocation: "Feasibility study", example: "Engineers conducted a comprehensive feasibility study before constructing the subsea tunnel."),
        IeltsVocabWord(word: "Terrestrial", meaning: "Of, on, or relating to the earth", collocation: "Terrestrial ecosystems", example: "Deforestation threatens both terrestrial and aquatic organisms across the biosphere."),
        IeltsVocabWord(word: "Celestial", meaning: "Positioned in or relating to the sky, or outer space as observed in astronomy", collocation: "Celestial bodies", example: "Deep-space telescopes capture high-resolution imagery of distant celestial bodies."),
        IeltsVocabWord(word: "Astronomical", meaning: "Relating to astronomy; or enormously large", collocation: "Astronomical cost", example: "The astronomical cost of space exploration is justified by subsequent technological spinoffs."),
        IeltsVocabWord(word: "Innovation", meaning: "The action or process of innovating; a new method, idea, product", collocation: "Technological innovation", example: "Continuous technological innovation is vital for maintaining international competitiveness."),
        IeltsVocabWord(word: "Extraterrestrial", meaning: "Originating or existing outside the earth or its atmosphere", collocation: "Extraterrestrial life", example: "Astrobiologists search for chemical biomarkers that indicate the potential presence of extraterrestrial life."),
      ],
    ),
  ];

  // --- 17 IELTS Topic-Wise Word Families (Noun, Verb, Adjective, Adverb) ---
  static const List<IeltsWordFamilyTopic> wordFamilyTopics = [
    // 1. Education
    IeltsWordFamilyTopic(
      topicName: "Education",
      icon: "",
      words: [
        IeltsWordFamily(noun: "education", verb: "educate", adjective: "educational / educated", adverb: "educationally"),
        IeltsWordFamily(noun: "significance", verb: "signify", adjective: "significant", adverb: "significantly"),
        IeltsWordFamily(noun: "development", verb: "develop", adjective: "developed / developing", adverb: "-"),
        IeltsWordFamily(noun: "improvement", verb: "improve", adjective: "improved / improving", adverb: "-"),
        IeltsWordFamily(noun: "success", verb: "succeed", adjective: "successful", adverb: "successfully"),
        IeltsWordFamily(noun: "instruction", verb: "instruct", adjective: "instructive", adverb: "instructively"),
        IeltsWordFamily(noun: "assessment", verb: "assess", adjective: "assessed", adverb: "-"),
        IeltsWordFamily(noun: "comprehension", verb: "comprehend", adjective: "comprehensive", adverb: "comprehensively"),
        IeltsWordFamily(noun: "qualification", verb: "qualify", adjective: "qualified", adverb: "-"),
        IeltsWordFamily(noun: "cognition", verb: "-", adjective: "cognitive", adverb: "cognitively"),
        IeltsWordFamily(noun: "literacy", verb: "-", adjective: "literate", adverb: "-"),
        IeltsWordFamily(noun: "memorization", verb: "memorize", adjective: "memorable", adverb: "memorably"),
      ],
    ),

    // 2. Technology
    IeltsWordFamilyTopic(
      topicName: "Technology",
      icon: "",
      words: [
        IeltsWordFamily(noun: "innovation", verb: "innovate", adjective: "innovative", adverb: "innovatively"),
        IeltsWordFamily(noun: "automation", verb: "automate", adjective: "automatic / automated", adverb: "automatically"),
        IeltsWordFamily(noun: "transformation", verb: "transform", adjective: "transformative", adverb: "-"),
        IeltsWordFamily(noun: "computation", verb: "compute", adjective: "computational", adverb: "computationally"),
        IeltsWordFamily(noun: "digitization", verb: "digitize", adjective: "digital", adverb: "digitally"),
        IeltsWordFamily(noun: "integration", verb: "integrate", adjective: "integrated", adverb: "-"),
        IeltsWordFamily(noun: "revolution", verb: "revolutionize", adjective: "revolutionary", adverb: "-"),
        IeltsWordFamily(noun: "mechanization", verb: "mechanize", adjective: "mechanical", adverb: "mechanically"),
        IeltsWordFamily(noun: "application", verb: "apply", adjective: "applicable / applied", adverb: "-"),
        IeltsWordFamily(noun: "modification", verb: "modify", adjective: "modified", adverb: "-"),
      ],
    ),

    // 3. Environment
    IeltsWordFamilyTopic(
      topicName: "Environment",
      icon: "",
      words: [
        IeltsWordFamily(noun: "sustainability", verb: "sustain", adjective: "sustainable", adverb: "sustainably"),
        IeltsWordFamily(noun: "pollution", verb: "pollute", adjective: "polluted / polluting", adverb: "-"),
        IeltsWordFamily(noun: "conservation", verb: "conserve", adjective: "conservative", adverb: "conservatively"),
        IeltsWordFamily(noun: "degradation", verb: "degrade", adjective: "degraded", adverb: "-"),
        IeltsWordFamily(noun: "depletion", verb: "deplete", adjective: "depleted", adverb: "-"),
        IeltsWordFamily(noun: "contamination", verb: "contaminate", adjective: "contaminated", adverb: "-"),
        IeltsWordFamily(noun: "preservation", verb: "preserve", adjective: "preserved", adverb: "-"),
        IeltsWordFamily(noun: "ecology", verb: "-", adjective: "ecological", adverb: "ecologically"),
        IeltsWordFamily(noun: "emission", verb: "emit", adjective: "emitted", adverb: "-"),
        IeltsWordFamily(noun: "extinction", verb: "extinguish", adjective: "extinct", adverb: "-"),
      ],
    ),

    // 4. Health
    IeltsWordFamilyTopic(
      topicName: "Health",
      icon: "",
      words: [
        IeltsWordFamily(noun: "prevention", verb: "prevent", adjective: "preventative / preventable", adverb: "preventively"),
        IeltsWordFamily(noun: "nourishment / nutrition", verb: "nourish", adjective: "nourishing / nutritious", adverb: "nutritionally"),
        IeltsWordFamily(noun: "infection", verb: "infect", adjective: "infectious / infected", adverb: "infectiously"),
        IeltsWordFamily(noun: "treatment", verb: "treat", adjective: "treatable", adverb: "-"),
        IeltsWordFamily(noun: "rehabilitation", verb: "rehabilitate", adjective: "rehabilitative", adverb: "-"),
        IeltsWordFamily(noun: "longevity", verb: "-", adjective: "long-lived", adverb: "-"),
        IeltsWordFamily(noun: "immunity / immunization", verb: "immunize", adjective: "immune", adverb: "-"),
        IeltsWordFamily(noun: "psychology", verb: "-", adjective: "psychological", adverb: "psychologically"),
        IeltsWordFamily(noun: "diagnosis", verb: "diagnose", adjective: "diagnostic", adverb: "diagnostically"),
        IeltsWordFamily(noun: "therapy", verb: "-", adjective: "therapeutic", adverb: "therapeutically"),
      ],
    ),

    // 5. Crime
    IeltsWordFamilyTopic(
      topicName: "Crime",
      icon: "",
      words: [
        IeltsWordFamily(noun: "deterrence / deterrent", verb: "deter", adjective: "deterrent", adverb: "-"),
        IeltsWordFamily(noun: "incarceration", verb: "incarcerate", adjective: "incarcerated", adverb: "-"),
        IeltsWordFamily(noun: "prohibition", verb: "prohibit", adjective: "prohibitive / prohibited", adverb: "prohibitively"),
        IeltsWordFamily(noun: "delinquency", verb: "-", adjective: "delinquent", adverb: "-"),
        IeltsWordFamily(noun: "investigation", verb: "investigate", adjective: "investigative", adverb: "-"),
        IeltsWordFamily(noun: "perpetration", verb: "perpetrate", adjective: "perpetrated", adverb: "-"),
        IeltsWordFamily(noun: "enforcement", verb: "enforce", adjective: "enforceable", adverb: "-"),
        IeltsWordFamily(noun: "conviction", verb: "convict", adjective: "convicted", adverb: "-"),
        IeltsWordFamily(noun: "rehabilitation", verb: "rehabilitate", adjective: "rehabilitated", adverb: "-"),
        IeltsWordFamily(noun: "violation", verb: "violate", adjective: "violated", adverb: "-"),
      ],
    ),

    // 6. Government
    IeltsWordFamilyTopic(
      topicName: "Government",
      icon: "",
      words: [
        IeltsWordFamily(noun: "governance / government", verb: "govern", adjective: "governmental / governing", adverb: "governmentally"),
        IeltsWordFamily(noun: "legislation", verb: "legislate", adjective: "legislative", adverb: "legislatively"),
        IeltsWordFamily(noun: "regulation", verb: "regulate", adjective: "regulatory / regulated", adverb: "-"),
        IeltsWordFamily(noun: "administration", verb: "administer", adjective: "administrative", adverb: "administratively"),
        IeltsWordFamily(noun: "implementation", verb: "implement", adjective: "implemented", adverb: "-"),
        IeltsWordFamily(noun: "authority", verb: "authorize", adjective: "authoritative / authorized", adverb: "authoritatively"),
        IeltsWordFamily(noun: "democracy", verb: "democratize", adjective: "democratic", adverb: "democratically"),
        IeltsWordFamily(noun: "subsidization / subsidy", verb: "subsidize", adjective: "subsidized", adverb: "-"),
        IeltsWordFamily(noun: "policy / politician", verb: "politicize", adjective: "political", adverb: "politically"),
        IeltsWordFamily(noun: "reform", verb: "reform", adjective: "reformed / reforming", adverb: "-"),
      ],
    ),

    // 7. Economy
    IeltsWordFamilyTopic(
      topicName: "Economy",
      icon: "",
      words: [
        IeltsWordFamily(noun: "finance", verb: "finance", adjective: "financial", adverb: "financially"),
        IeltsWordFamily(noun: "prosperity", verb: "prosper", adjective: "prosperous", adverb: "prosperously"),
        IeltsWordFamily(noun: "consumption", verb: "consume", adjective: "consumable / consumed", adverb: "-"),
        IeltsWordFamily(noun: "investment", verb: "invest", adjective: "invested", adverb: "-"),
        IeltsWordFamily(noun: "fluctuation", verb: "fluctuate", adjective: "fluctuating", adverb: "-"),
        IeltsWordFamily(noun: "commercialization", verb: "commercialize", adjective: "commercial", adverb: "commercially"),
        IeltsWordFamily(noun: "inflation", verb: "inflate", adjective: "inflationary / inflated", adverb: "-"),
        IeltsWordFamily(noun: "viability", verb: "-", adjective: "viable", adverb: "viably"),
        IeltsWordFamily(noun: "monopolization / monopoly", verb: "monopolize", adjective: "monopolistic", adverb: "-"),
        IeltsWordFamily(noun: "productivity", verb: "produce", adjective: "productive", adverb: "productively"),
      ],
    ),

    // 8. Employment
    IeltsWordFamilyTopic(
      topicName: "Employment",
      icon: "",
      words: [
        IeltsWordFamily(noun: "employment", verb: "employ", adjective: "employable / employed", adverb: "-"),
        IeltsWordFamily(noun: "productivity", verb: "produce", adjective: "productive", adverb: "productively"),
        IeltsWordFamily(noun: "compensation", verb: "compensate", adjective: "compensatory", adverb: "-"),
        IeltsWordFamily(noun: "collaboration", verb: "collaborate", adjective: "collaborative", adverb: "collaboratively"),
        IeltsWordFamily(noun: "remuneration", verb: "remunerate", adjective: "remunerative", adverb: "-"),
        IeltsWordFamily(noun: "specialization", verb: "specialize", adjective: "specialized", adverb: "-"),
        IeltsWordFamily(noun: "qualification", verb: "qualify", adjective: "qualified", adverb: "-"),
        IeltsWordFamily(noun: "motivation", verb: "motivate", adjective: "motivational / motivated", adverb: "-"),
        IeltsWordFamily(noun: "efficiency", verb: "-", adjective: "efficient", adverb: "efficiently"),
        IeltsWordFamily(noun: "promotion", verb: "promote", adjective: "promoted / promotional", adverb: "-"),
      ],
    ),

    // 9. Transportation
    IeltsWordFamilyTopic(
      topicName: "Transportation",
      icon: "",
      words: [
        IeltsWordFamily(noun: "congestion", verb: "congest", adjective: "congested", adverb: "-"),
        IeltsWordFamily(noun: "commute / commuter", verb: "commute", adjective: "commuting", adverb: "-"),
        IeltsWordFamily(noun: "navigation", verb: "navigate", adjective: "navigational", adverb: "-"),
        IeltsWordFamily(noun: "transit / transportation", verb: "transport / transit", adjective: "transportable", adverb: "-"),
        IeltsWordFamily(noun: "acceleration", verb: "accelerate", adjective: "accelerated", adverb: "-"),
        IeltsWordFamily(noun: "accessibility", verb: "access", adjective: "accessible", adverb: "accessibly"),
        IeltsWordFamily(noun: "electrification", verb: "electrify", adjective: "electric / electrified", adverb: "electrically"),
        IeltsWordFamily(noun: "expansion", verb: "expand", adjective: "expanded / expansive", adverb: "expansively"),
        IeltsWordFamily(noun: "modernization", verb: "modernize", adjective: "modernized / modern", adverb: "-"),
        IeltsWordFamily(noun: "mobility", verb: "mobilize", adjective: "mobile", adverb: "-"),
      ],
    ),

    // 10. Family
    IeltsWordFamilyTopic(
      topicName: "Family",
      icon: "",
      words: [
        IeltsWordFamily(noun: "nurture", verb: "nurture", adjective: "nurturing", adverb: "-"),
        IeltsWordFamily(noun: "parenthood", verb: "parent", adjective: "parental", adverb: "parentally"),
        IeltsWordFamily(noun: "cohesion", verb: "cohere", adjective: "cohesive", adverb: "cohesively"),
        IeltsWordFamily(noun: "dependence / dependency", verb: "depend", adjective: "dependent", adverb: "dependently"),
        IeltsWordFamily(noun: "socialization", verb: "socialize", adjective: "social", adverb: "socially"),
        IeltsWordFamily(noun: "maturity", verb: "mature", adjective: "mature", adverb: "maturely"),
        IeltsWordFamily(noun: "obligation", verb: "oblige", adjective: "obligatory / obligated", adverb: "-"),
        IeltsWordFamily(noun: "affection", verb: "-", adjective: "affectionate", adverb: "affectionately"),
        IeltsWordFamily(noun: "guidance", verb: "guide", adjective: "guided", adverb: "-"),
        IeltsWordFamily(noun: "generation", verb: "generate", adjective: "generational", adverb: "generationally"),
      ],
    ),

    // 11. Society
    IeltsWordFamilyTopic(
      topicName: "Society",
      icon: "",
      words: [
        IeltsWordFamily(noun: "socialization / society", verb: "socialize", adjective: "social / societal", adverb: "socially"),
        IeltsWordFamily(noun: "inequality / equality", verb: "equalize", adjective: "equal / unequal", adverb: "equally / unequally"),
        IeltsWordFamily(noun: "assimilation", verb: "assimilate", adjective: "assimilated", adverb: "-"),
        IeltsWordFamily(noun: "integration", verb: "integrate", adjective: "integrated", adverb: "-"),
        IeltsWordFamily(noun: "segregation", verb: "segregate", adjective: "segregated", adverb: "-"),
        IeltsWordFamily(noun: "cooperation", verb: "cooperate", adjective: "cooperative", adverb: "cooperatively"),
        IeltsWordFamily(noun: "marginalization", verb: "marginalize", adjective: "marginalized", adverb: "-"),
        IeltsWordFamily(noun: "harmony", verb: "harmonize", adjective: "harmonious", adverb: "harmoniously"),
        IeltsWordFamily(noun: "tolerance", verb: "tolerate", adjective: "tolerant", adverb: "tolerantly"),
        IeltsWordFamily(noun: "civility / civilization", verb: "civilize", adjective: "civil / civilized", adverb: "civilly"),
      ],
    ),

    // 12. Globalization
    IeltsWordFamilyTopic(
      topicName: "Globalization",
      icon: "",
      words: [
        IeltsWordFamily(noun: "globalization", verb: "globalize", adjective: "global", adverb: "globally"),
        IeltsWordFamily(noun: "homogenization", verb: "homogenize", adjective: "homogeneous", adverb: "homogeneously"),
        IeltsWordFamily(noun: "interdependence", verb: "-", adjective: "interdependent", adverb: "interdependently"),
        IeltsWordFamily(noun: "westernization", verb: "westernize", adjective: "westernized", adverb: "-"),
        IeltsWordFamily(noun: "interconnection", verb: "interconnect", adjective: "interconnected", adverb: "-"),
        IeltsWordFamily(noun: "multilateralism", verb: "-", adjective: "multilateral", adverb: "multilaterally"),
        IeltsWordFamily(noun: "standardization", verb: "standardize", adjective: "standardized", adverb: "-"),
        IeltsWordFamily(noun: "migration", verb: "migrate", adjective: "migrant / migratory", adverb: "-"),
        IeltsWordFamily(noun: "cosmopolitanism", verb: "-", adjective: "cosmopolitan", adverb: "-"),
        IeltsWordFamily(noun: "unification", verb: "unify", adjective: "unified", adverb: "-"),
      ],
    ),

    // 13. Media
    IeltsWordFamilyTopic(
      topicName: "Media",
      icon: "",
      words: [
        IeltsWordFamily(noun: "broadcasting / broadcaster", verb: "broadcast", adjective: "broadcast", adverb: "-"),
        IeltsWordFamily(noun: "censorship", verb: "censor", adjective: "censored", adverb: "-"),
        IeltsWordFamily(noun: "sensationalism", verb: "sensationalize", adjective: "sensational", adverb: "sensationally"),
        IeltsWordFamily(noun: "journalism / journalist", verb: "-", adjective: "journalistic", adverb: "journalistically"),
        IeltsWordFamily(noun: "dissemination", verb: "disseminate", adjective: "disseminated", adverb: "-"),
        IeltsWordFamily(noun: "distortion", verb: "distort", adjective: "distorted", adverb: "-"),
        IeltsWordFamily(noun: "coverage", verb: "cover", adjective: "covered", adverb: "-"),
        IeltsWordFamily(noun: "misinformation", verb: "misinform", adjective: "misinformed", adverb: "-"),
        IeltsWordFamily(noun: "publication / publisher", verb: "publish", adjective: "published", adverb: "-"),
        IeltsWordFamily(noun: "influence", verb: "influence", adjective: "influential", adverb: "influentially"),
      ],
    ),

    // 14. Advertising
    IeltsWordFamilyTopic(
      topicName: "Advertising",
      icon: "",
      words: [
        IeltsWordFamily(noun: "advertisement / advertiser", verb: "advertise", adjective: "advertised", adverb: "-"),
        IeltsWordFamily(noun: "persuasion", verb: "persuade", adjective: "persuasive", adverb: "persuasively"),
        IeltsWordFamily(noun: "consumerism / consumer", verb: "consume", adjective: "consumed", adverb: "-"),
        IeltsWordFamily(noun: "endorsement", verb: "endorse", adjective: "endorsed", adverb: "-"),
        IeltsWordFamily(noun: "manipulation", verb: "manipulate", adjective: "manipulative", adverb: "manipulatively"),
        IeltsWordFamily(noun: "sponsorship / sponsor", verb: "sponsor", adjective: "sponsored", adverb: "-"),
        IeltsWordFamily(noun: "commercialization", verb: "commercialize", adjective: "commercial", adverb: "commercially"),
        IeltsWordFamily(noun: "perception", verb: "perceive", adjective: "perceptive / perceived", adverb: "perceptively"),
        IeltsWordFamily(noun: "attraction", verb: "attract", adjective: "attractive", adverb: "attractively"),
        IeltsWordFamily(noun: "stimulation", verb: "stimulate", adjective: "stimulating", adverb: "-"),
      ],
    ),

    // 15. Culture
    IeltsWordFamilyTopic(
      topicName: "Culture",
      icon: "",
      words: [
        IeltsWordFamily(noun: "heritage", verb: "inherit", adjective: "hereditary", adverb: "-"),
        IeltsWordFamily(noun: "preservation", verb: "preserve", adjective: "preserved", adverb: "-"),
        IeltsWordFamily(noun: "authenticity", verb: "authenticate", adjective: "authentic", adverb: "authentically"),
        IeltsWordFamily(noun: "diversity", verb: "diversify", adjective: "diverse", adverb: "diversely"),
        IeltsWordFamily(noun: "expression", verb: "express", adjective: "expressive", adverb: "expressively"),
        IeltsWordFamily(noun: "tradition", verb: "-", adjective: "traditional", adverb: "traditionally"),
        IeltsWordFamily(noun: "symbolism", verb: "symbolize", adjective: "symbolic", adverb: "symbolically"),
        IeltsWordFamily(noun: "appreciation", verb: "appreciate", adjective: "appreciative", adverb: "appreciatively"),
        IeltsWordFamily(noun: "celebration", verb: "celebrate", adjective: "celebratory / celebrated", adverb: "-"),
        IeltsWordFamily(noun: "custom", verb: "customize", adjective: "customary", adverb: "customarily"),
      ],
    ),

    // 16. Tourism
    IeltsWordFamilyTopic(
      topicName: "Tourism",
      icon: "",
      words: [
        IeltsWordFamily(noun: "destination", verb: "destine", adjective: "destined", adverb: "-"),
        IeltsWordFamily(noun: "hospitality / host", verb: "host", adjective: "hospitable", adverb: "hospitably"),
        IeltsWordFamily(noun: "exploration / explorer", verb: "explore", adjective: "exploratory", adverb: "-"),
        IeltsWordFamily(noun: "overcrowding", verb: "overcrowd", adjective: "overcrowded", adverb: "-"),
        IeltsWordFamily(noun: "monument", verb: "-", adjective: "monumental", adverb: "monumentally"),
        IeltsWordFamily(noun: "ecotourism", verb: "-", adjective: "ecotouristic", adverb: "-"),
        IeltsWordFamily(noun: "accommodation", verb: "accommodate", adjective: "accommodating", adverb: "-"),
        IeltsWordFamily(noun: "recreation", verb: "recreate", adjective: "recreational", adverb: "recreationally"),
        IeltsWordFamily(noun: "adventure / adventurer", verb: "adventure", adjective: "adventurous", adverb: "adventurously"),
        IeltsWordFamily(noun: "attraction", verb: "attract", adjective: "attractive", adverb: "attractively"),
      ],
    ),

    // 17. Science
    IeltsWordFamilyTopic(
      topicName: "Science",
      icon: "",
      words: [
        IeltsWordFamily(noun: "experiment / experimentation", verb: "experiment", adjective: "experimental", adverb: "experimentally"),
        IeltsWordFamily(noun: "discovery", verb: "discover", adjective: "discoverable / discovered", adverb: "-"),
        IeltsWordFamily(noun: "hypothesis", verb: "hypothesize", adjective: "hypothetical", adverb: "hypothetically"),
        IeltsWordFamily(noun: "analysis / analyst", verb: "analyze", adjective: "analytical", adverb: "analytically"),
        IeltsWordFamily(noun: "evidence", verb: "evidence", adjective: "evident", adverb: "evidently"),
        IeltsWordFamily(noun: "quantification", verb: "quantify", adjective: "quantitative", adverb: "quantitatively"),
        IeltsWordFamily(noun: "feasibility", verb: "-", adjective: "feasible", adverb: "feasibly"),
        IeltsWordFamily(noun: "observation / observer", verb: "observe", adjective: "observant / observable", adverb: "observantly"),
        IeltsWordFamily(noun: "verification", verb: "verify", adjective: "verifiable / verified", adverb: "-"),
        IeltsWordFamily(noun: "precision", verb: "-", adjective: "precise", adverb: "precisely"),
      ],
    ),
  ];
  // --- Specific Grammar Topics: Each topic with clean Sub-items, Rules, and Examples ---
  static const List<GrammarTopicItem> specificGrammarTopics = [
    // 1. Parts of Speech
    GrammarTopicItem(
      id: 1,
      title: "1. Parts of Speech",
      category: "Foundation",
      subItems: [
        GrammarSubItem(
          name: "Noun",
          rule: "A word that names a person, place, thing, animal, or idea.",
          examples: [
            "Dhaka is a busy city.",
            "Education is important.",
            "She is a teacher.",
          ],
        ),
        GrammarSubItem(
          name: "Pronoun",
          rule: "A word used in place of a noun to avoid repetition.",
          examples: [
            "Rahim is a student. He studies hard.",
            "The students are tired. They need rest.",
            "This book is mine; that one is yours.",
          ],
        ),
        GrammarSubItem(
          name: "Verb",
          rule: "A word that expresses an action, occurrence, or state of being.",
          examples: [
            "I study English every day.",
            "She works in a multinational bank.",
            "They are very happy with their results.",
          ],
        ),
        GrammarSubItem(
          name: "Adjective",
          rule: "A word that describes or modifies a noun or pronoun (quality, number, feature).",
          examples: [
            "It is a beautiful and modern city.",
            "He is a hardworking and dedicated student.",
            "Climate change is an important global issue.",
          ],
        ),
        GrammarSubItem(
          name: "Adverb",
          rule: "A word that modifies a verb, an adjective, or another adverb (manner, time, degree).",
          examples: [
            "He speaks English fluently and clearly.",
            "She completed the task carefully.",
            "The price of housing increased significantly.",
          ],
        ),
        GrammarSubItem(
          name: "Preposition",
          rule: "A word showing the relationship of a noun/pronoun to another word in the sentence.",
          examples: [
            "I live in Bangladesh.",
            "The document is on the desk.",
            "She went to the library for research.",
          ],
        ),
        GrammarSubItem(
          name: "Conjunction",
          rule: "A word that connects words, phrases, or clauses together.",
          examples: [
            "I study English because I want to study abroad.",
            "He is young but highly experienced.",
            "Although it was raining heavily, we went outside.",
          ],
        ),
      ],
    ),

    // 2. Sentence Structure
    GrammarTopicItem(
      id: 2,
      title: "2. Sentence Structure",
      category: "Foundation",
      subItems: [
        GrammarSubItem(
          name: "Rule 1: Subject + Verb",
          rule: "The simplest complete sentence with an actor and an intransitive verb.",
          examples: [
            "Birds fly.",
            "Children play.",
            "The sun rises in the east.",
          ],
        ),
        GrammarSubItem(
          name: "Rule 2: Subject + Verb + Object",
          rule: "A transitive verb that directly acts upon a direct object.",
          examples: [
            "I study English.",
            "She reads academic articles.",
            "Governments build modern hospitals.",
          ],
        ),
        GrammarSubItem(
          name: "Rule 3: Subject + Verb + Complement",
          rule: "A linking verb followed by a word or phrase that describes the subject.",
          examples: [
            "He is an undergraduate student.",
            "She became a successful doctor.",
            "The proposed policy seems effective.",
          ],
        ),
        GrammarSubItem(
          name: "Rule 4: Subject + Verb + Indirect Object + Direct Object",
          rule: "A verb that transfers an item to a recipient (Indirect Object).",
          examples: [
            "He gave me a valuable reference book.",
            "She sent him an urgent email.",
            "The tutor offered the students helpful feedback.",
          ],
        ),
        GrammarSubItem(
          name: "Rule 5: Subject + Verb + Object + Complement",
          rule: "The complement describes or defines the object.",
          examples: [
            "They elected him committee chairman.",
            "Exercise keeps your body healthy.",
            "The examiner found the candidate answer impressive.",
          ],
        ),
      ],
    ),

    // 3. Subject-Verb Agreement
    GrammarTopicItem(
      id: 3,
      title: "3. Subject-Verb Agreement",
      category: "Foundation",
      subItems: [
        GrammarSubItem(
          name: "Rule 1: Singular Subject takes Singular Verb",
          rule: "He, She, It, or singular nouns take verbs ending in -s/-es or is/was/has.",
          examples: [
            "He goes to school every morning.",
            "She writes essays daily.",
            "The student studies hard for IELTS.",
          ],
        ),
        GrammarSubItem(
          name: "Rule 2: Plural Subject takes Plural Verb",
          rule: "They, We, or plural nouns take base verbs or are/were/have.",
          examples: [
            "They go to school together.",
            "We study English at university.",
            "The students work diligently on assignments.",
          ],
        ),
        GrammarSubItem(
          name: "Rule 3: I / You take Base Verb",
          rule: "First and second person singular use the base form of the verb (except 'I am' / 'I was').",
          examples: [
            "I write essays every weekend.",
            "You speak English very fluently.",
            "I study economics at the library.",
          ],
        ),
        GrammarSubItem(
          name: "Rule 4: Each / Every / Everyone takes Singular Verb",
          rule: "Indefinite singular pronouns always take singular verbs, even when followed by 'of the [plural]'.",
          examples: [
            "Every student is responsible for homework.",
            "Each of the participants was awarded a certificate.",
            "Everyone in the room wants to achieve Band 8.",
          ],
        ),
        GrammarSubItem(
          name: "Rule 5: There is vs There are",
          rule: "Use 'There is' before singular/uncountable nouns; use 'There are' before plural nouns.",
          examples: [
            "There is a problem with the current transportation system.",
            "There are many students preparing for higher education.",
            "There is substantial evidence supporting renewable energy.",
          ],
        ),
      ],
    ),

    // 4. Articles
    GrammarTopicItem(
      id: 4,
      title: "4. Articles",
      category: "Foundation",
      subItems: [
        GrammarSubItem(
          name: "Rule 1: Article 'A' with Consonant Sounds",
          rule: "Use 'a' before singular countable nouns beginning with a consonant sound.",
          examples: [
            "He is a dedicated teacher.",
            "She bought a new laptop.",
            "Dhaka is a bustling city.",
            "He studies at a university. (starts with /j/ consonant sound)",
          ],
        ),
        GrammarSubItem(
          name: "Rule 2: Article 'An' with Vowel Sounds",
          rule: "Use 'an' before singular countable nouns beginning with a vowel sound (a, e, i, o, u sound).",
          examples: [
            "She is an intelligent and hardworking student.",
            "It is an urgent problem that requires attention.",
            "He will arrive in an hour. ('h' is silent)",
          ],
        ),
        GrammarSubItem(
          name: "Rule 3: Article 'The' for Specific Things",
          rule: "Use 'the' when referring to a specific item known to both speaker and listener.",
          examples: [
            "The book you lent me was fascinating.",
            "I met the professor who teaches linguistic research.",
            "The government announced a new environmental policy.",
          ],
        ),
        GrammarSubItem(
          name: "Rule 4: Article 'The' with Superlatives",
          rule: "Always use 'the' before superlative adjectives and ordinal numbers.",
          examples: [
            "Mount Everest is the highest mountain in the world.",
            "This is the most effective solution for urban congestion.",
            "He was the first candidate to complete the exam.",
          ],
        ),
        GrammarSubItem(
          name: "Rule 5: Article 'The' with Unique Global Entities",
          rule: "Use 'the' with unique natural and institutional systems (the sun, the moon, the internet, the environment).",
          examples: [
            "The earth revolves around the sun.",
            "The internet has revolutionized modern education.",
            "We must protect the environment from pollution.",
          ],
        ),
      ],
    ),

    // 5. Countable & Uncountable Nouns
    GrammarTopicItem(
      id: 5,
      title: "5. Countable & Uncountable Nouns",
      category: "Foundation",
      subItems: [
        GrammarSubItem(
          name: "Rule 1: Countable Nouns with 'Many' and 'Few'",
          rule: "Countable nouns have singular and plural forms; use 'many', 'a few', or exact numbers.",
          examples: [
            "There are many students in the lecture hall.",
            "A few countries have banned single-use plastics.",
            "I read three articles on climate change.",
          ],
        ),
        GrammarSubItem(
          name: "Rule 2: Uncountable Nouns with 'Much' and 'Little'",
          rule: "Uncountable nouns cannot be counted directly; use 'much', 'a little', or 'an amount of'.",
          examples: [
            "There is much information available on the internet.",
            "He has little experience in software engineering.",
            "A large amount of money was allocated to healthcare.",
          ],
        ),
        GrammarSubItem(
          name: "Common IELTS Mistakes: Uncountable Nouns",
          rule: "Nouns like information, advice, equipment, homework, furniture, and traffic never take -s or 'a/an'.",
          examples: [
            "âŒ She gave me an advice. âž” âœ… She gave me advice / a piece of advice.",
            "âŒ Many informations were provided. âž” âœ… Much information was provided.",
            "âŒ New equipments were purchased. âž” âœ… New equipment was purchased.",
          ],
        ),
      ],
    ),

    // 6. Tenses
    GrammarTopicItem(
      id: 6,
      title: "6. Tenses",
      category: "Tense & Verb",
      subItems: [
        GrammarSubItem(
          name: "Present Simple",
          rule: "Expresses universal truths, habitual routines, and permanent states.",
          examples: [
            "I study English every day.",
            "Water boils at 100 degrees Celsius.",
            "Many people live in metropolitan cities.",
          ],
        ),
        GrammarSubItem(
          name: "Present Continuous",
          rule: "Describes actions happening right now or temporary evolving trends.",
          examples: [
            "The global climate is changing rapidly.",
            "More students are studying online these days.",
            "She is working on an important research project.",
          ],
        ),
        GrammarSubItem(
          name: "Present Perfect",
          rule: "Connects past actions or experiences to the present moment.",
          examples: [
            "I have completed my undergraduate degree.",
            "Technology has transformed human communication.",
            "Over the last decade, electric car sales have risen significantly.",
          ],
        ),
        GrammarSubItem(
          name: "Past Simple",
          rule: "Describes actions completed at a definite specific time in the past.",
          examples: [
            "The government built the bridge in 2015.",
            "The sales of smartphones increased significantly in 2020.",
            "He graduated from university last year.",
          ],
        ),
        GrammarSubItem(
          name: "Past Continuous",
          rule: "Describes an ongoing background activity interrupted by a past event.",
          examples: [
            "I was studying when the phone rang.",
            "While the population was growing, public resources were declining.",
          ],
        ),
        GrammarSubItem(
          name: "Past Perfect",
          rule: "Shows an action completed before another past event or milestone.",
          examples: [
            "By 2010, renewable energy generation had already surpassed coal.",
            "The train had left before I arrived at the station.",
          ],
        ),
        GrammarSubItem(
          name: "Future Simple & Projections",
          rule: "Expresses future predictions and forecasts in IELTS Task 1 and Task 2.",
          examples: [
            "The world population will reach 10 billion by 2050.",
            "Car production is projected to increase over the next decade.",
            "Renewable energy is anticipated to replace fossil fuels.",
          ],
        ),
      ],
    ),

    // 7. Modals
    GrammarTopicItem(
      id: 7,
      title: "7. Modals",
      category: "Tense & Verb",
      subItems: [
        GrammarSubItem(
          name: "Can / Could (Ability & Possibility)",
          rule: "Expresses physical/mental capability or general possibility.",
          examples: [
            "Technology can solve many environmental challenges.",
            "Education could improve the living standards of poor families.",
          ],
        ),
        GrammarSubItem(
          name: "Should / Ought to (Recommendation & Advice)",
          rule: "Offers recommendations, ethical guidance, or ideal solutions.",
          examples: [
            "Governments should invest heavily in public healthcare.",
            "Individuals ought to reduce single-use plastic consumption.",
          ],
        ),
        GrammarSubItem(
          name: "Must / Have to (Necessity & Compulsion)",
          rule: "Denotes mandatory requirements, strict obligation, or legal enforcement.",
          examples: [
            "Authorities must enforce strict emission standards for factories.",
            "Students have to submit their dissertations on time.",
          ],
        ),
        GrammarSubItem(
          name: "May / Might (Hedging & Probability)",
          rule: "Used to avoid overgeneralization in academic writing.",
          examples: [
            "Social media may negatively influence adolescent mental health.",
            "Stricter penalties might deter criminal behavior.",
          ],
        ),
      ],
    ),

    // 8. Gerund & Infinitive
    GrammarTopicItem(
      id: 8,
      title: "8. Gerund & Infinitive",
      category: "Tense & Verb",
      subItems: [
        GrammarSubItem(
          name: "Gerund as Sentence Subject",
          rule: "Using Verb-ing as the subject creates concise, formal academic topic openers.",
          examples: [
            "Reading academic books improves analytical thinking.",
            "Exercising daily reduces the risk of chronic illness.",
            "Traveling to foreign countries broadens personal perspectives.",
          ],
        ),
        GrammarSubItem(
          name: "Verbs followed by Gerund (Verb + ing)",
          rule: "Certain verbs like enjoy, avoid, consider, suggest, and prohibit take gerunds.",
          examples: [
            "She enjoys reading scholarly articles.",
            "Governments should consider banning private vehicles in city centers.",
            "We must avoid wasting natural resources.",
          ],
        ),
        GrammarSubItem(
          name: "Verbs followed by Infinitive (to + Verb)",
          rule: "Verbs like want, decide, hope, plan, and attempt take to-infinitives.",
          examples: [
            "Many young graduates plan to study abroad.",
            "The committee decided to implement the new policy.",
            "He hopes to achieve Band 8 in IELTS.",
          ],
        ),
      ],
    ),

    // 9. Passive Voice
    GrammarTopicItem(
      id: 9,
      title: "9. Passive Voice",
      category: "Tense & Verb",
      subItems: [
        GrammarSubItem(
          name: "Agentless Passive for Academic Objectivity",
          rule: "Omit subjective agents to keep focus on results, facts, and processes.",
          examples: [
            "Millions of tons of plastic waste are produced every year.",
            "A new environmental policy was introduced by the ministry.",
            "Subsidized housing must be built for low-income families.",
          ],
        ),
        GrammarSubItem(
          name: "Impersonal Reporting Passive ('It is argued that')",
          rule: "Introduce public opinions and debates objectively without personal pronouns.",
          examples: [
            "It is widely argued that artificial intelligence will create new jobs.",
            "It is believed that early childhood education shapes future success.",
            "It has been suggested that higher taxes on sugary drinks reduce obesity.",
          ],
        ),
      ],
    ),

    // 10. Clauses
    GrammarTopicItem(
      id: 10,
      title: "10. Clauses",
      category: "Advanced Sentence",
      subItems: [
        GrammarSubItem(
          name: "Independent Clause",
          rule: "A clause containing a subject and finite verb that can stand alone as a complete sentence.",
          examples: [
            "Renewable energy reduces carbon emissions.",
            "Public transport is affordable.",
          ],
        ),
        GrammarSubItem(
          name: "Dependent (Subordinate) Clause",
          rule: "Cannot stand alone and must connect to an independent clause.",
          examples: [
            "Because fossil fuels are depleting rapidly, countries must adopt solar power.",
            "Although the project was expensive, it delivered significant long-term benefits.",
          ],
        ),
      ],
    ),

    // 11. Relative Clauses
    GrammarTopicItem(
      id: 11,
      title: "11. Relative Clauses",
      category: "Advanced Sentence",
      subItems: [
        GrammarSubItem(
          name: "Defining Relative Clauses (who, which, that)",
          rule: "Provides essential identifying information about the noun without commas.",
          examples: [
            "Students who study consistently achieve high band scores.",
            "The policies that support green technology boost economic growth.",
          ],
        ),
        GrammarSubItem(
          name: "Non-Defining Relative Clauses (with commas)",
          rule: "Adds extra non-essential details enclosed in commas using 'which' or 'who'.",
          examples: [
            "Solar energy, which is completely renewable, produces zero carbon emissions.",
            "Dr. Rahim, who lectures in economics, published an acclaimed study.",
          ],
        ),
      ],
    ),

    // 12. Conditionals
    GrammarTopicItem(
      id: 12,
      title: "12. Conditionals",
      category: "Advanced Sentence",
      subItems: [
        GrammarSubItem(
          name: "Zero Conditional (Scientific Facts)",
          rule: "If + Present Simple, Present Simple â€” for universal laws and guaranteed outcomes.",
          examples: [
            "If water reaches 100 degrees Celsius, it boils.",
            "If people do not exercise regularly, their physical health deteriorates.",
          ],
        ),
        GrammarSubItem(
          name: "First Conditional (Real Future Possibilities)",
          rule: "If + Present Simple, will + Base Verb â€” for realistic future consequences.",
          examples: [
            "If governments invest in renewable energy, pollution will decrease.",
            "If you practice writing essays daily, your band score will improve.",
          ],
        ),
        GrammarSubItem(
          name: "Second Conditional (Hypothetical Scenarios)",
          rule: "If + Past Simple, would + Base Verb â€” for imaginary or unlikely situations.",
          examples: [
            "If the government banned private cars, urban air quality would improve.",
            "If I had more time, I would learn a third language.",
          ],
        ),
        GrammarSubItem(
          name: "Third Conditional (Unreal Past Situations)",
          rule: "If + had + V3, would have + V3 â€” for evaluating past mistakes and counterfactuals.",
          examples: [
            "If authorities had invested earlier in subway lines, traffic would not have become severe.",
          ],
        ),
      ],
    ),

    // 13. Comparison
    GrammarTopicItem(
      id: 13,
      title: "13. Comparison",
      category: "Advanced Sentence",
      subItems: [
        GrammarSubItem(
          name: "Comparative Forms (er / more ... than)",
          rule: "Compares differences between two entities in Task 1 reports and Task 2 arguments.",
          examples: [
            "Solar power is more sustainable than fossil fuel energy.",
            "The literacy rate in urban areas was higher than in rural sectors.",
          ],
        ),
        GrammarSubItem(
          name: "Superlative Forms (the -est / the most)",
          rule: "Expresses the highest or lowest extreme among three or more items.",
          examples: [
            "Climate change is arguably the most critical challenge facing humanity.",
            "Coal remained the largest source of electricity in 2010.",
          ],
        ),
        GrammarSubItem(
          name: "Double Comparatives ('The more..., the more...')",
          rule: "Shows direct or inverse proportional relationships between two continuous variables.",
          examples: [
            "The more educated a population is, the stronger the national economy becomes.",
            "The higher the demand for housing, the more expensive rent gets.",
          ],
        ),
      ],
    ),

    // 14. Conjunctions & Linking Words
    GrammarTopicItem(
      id: 14,
      title: "14. Conjunctions & Linking Words",
      category: "IELTS Writing & Speaking",
      subItems: [
        GrammarSubItem(
          name: "Coordinating Conjunctions (FANBOYS)",
          rule: "For, And, Nor, But, Or, Yet, So connect grammatically equal words or independent clauses.",
          examples: [
            "The tuition fee was high, but the quality of teaching was exceptional.",
            "He studied hard, so he achieved Band 8.5.",
          ],
        ),
        GrammarSubItem(
          name: "Subordinating Conjunctions",
          rule: "Because, although, while, since, whereas establish causal and concessional relationships.",
          examples: [
            "Although technological automation creates efficiency, it temporarily displaces jobs.",
            "Whereas urban areas expanded rapidly, rural populations remained stable.",
          ],
        ),
        GrammarSubItem(
          name: "Academic Transitional Connectors",
          rule: "Furthermore, Moreover, However, Consequently, Therefore transition between sentences.",
          examples: [
            "Electric vehicles reduce emissions; furthermore, they lower fuel dependency.",
            "The budget was limited; therefore, authorities prioritized essential infrastructure.",
          ],
        ),
      ],
    ),

    // 15. Complex & Compound Sentences
    GrammarTopicItem(
      id: 15,
      title: "15. Complex & Compound Sentences",
      category: "IELTS Writing & Speaking",
      subItems: [
        GrammarSubItem(
          name: "Compound Sentence",
          rule: "Two independent clauses joined by a comma and coordinating conjunction (and, but, so).",
          examples: [
            "Online education offers great flexibility, and it allows students to study at their own pace.",
          ],
        ),
        GrammarSubItem(
          name: "Complex Sentence",
          rule: "One independent clause combined with one or more dependent clauses.",
          examples: [
            "Since renewable energy sources are inexhaustible, governments must accelerate solar adoption.",
          ],
        ),
        GrammarSubItem(
          name: "Compound-Complex Sentence (Band 8+)",
          rule: "At least two independent clauses combined with at least one dependent clause.",
          examples: [
            "Although digital tools enhance productivity, they create screen fatigue, and schools must balance digital learning with physical activity.",
          ],
        ),
      ],
    ),

    // 16. Punctuation
    GrammarTopicItem(
      id: 16,
      title: "16. Punctuation",
      category: "IELTS Writing & Speaking",
      subItems: [
        GrammarSubItem(
          name: "Comma after Introductory Phrases",
          rule: "Always place a comma after introductory dependent clauses, prepositional phrases, and linkers.",
          examples: [
            "In conclusion, environmental preservation requires both governmental and individual effort.",
            "According to recent research, sleep deprivation reduces cognitive productivity.",
          ],
        ),
        GrammarSubItem(
          name: "Semicolon between Independent Clauses",
          rule: "Connects two closely linked independent clauses without a conjunction.",
          examples: [
            "Tertiary education has become prohibitively expensive; consequently, student loans have surged.",
          ],
        ),
      ],
    ),

    // 17. Common Grammar Errors
    GrammarTopicItem(
      id: 17,
      title: "17. Common Grammar Errors",
      category: "IELTS Writing & Speaking",
      subItems: [
        GrammarSubItem(
          name: "Fragment Sentences (Incomplete Thoughts)",
          rule: "Avoid ending sentences on dependent clauses lacking a main clause.",
          examples: [
            "âŒ Because many people studying abroad. âž” âœ… Because many people study abroad, cross-cultural understanding improves.",
          ],
        ),
        GrammarSubItem(
          name: "Run-on Sentences & Comma Splices",
          rule: "Never join two complete sentences with only a comma; use a period, semicolon, or conjunction.",
          examples: [
            "âŒ Tuition is high, students work part-time. âž” âœ… Tuition is high; consequently, students work part-time.",
          ],
        ),
        GrammarSubItem(
          name: "Faulty Parallelism",
          rule: "Items in a list or series must share the same grammatical form (all gerunds, all nouns, or all infinitives).",
          examples: [
            "âŒ The course improves writing, to speak fluently, and reading. âž” âœ… The course improves writing, speaking, and reading.",
          ],
        ),
      ],
    ),

    // 18. IELTS Writing Grammar (Task 1 & Task 2)
    GrammarTopicItem(
      id: 18,
      title: "18. IELTS Writing Grammar (Task 1 & Task 2)",
      category: "IELTS Writing & Speaking",
      subItems: [
        GrammarSubItem(
          name: "Task 1: Prepositions of Data Trends",
          rule: "Use 'by' for margin of change, 'to' for end level, and 'at' for static points.",
          examples: [
            "Sales increased by 15% and reached a peak of 50,000 units.",
            "The unemployment rate peaked at 9.5% in 2012 before dropping to 4.2%.",
          ],
        ),
        GrammarSubItem(
          name: "Task 2: Concession & Complex Assertions",
          rule: "Use 'While' and 'Although' to balance opposing perspectives before stating your thesis.",
          examples: [
            "While online learning offers unparalleled flexibility, it cannot completely replace the interactive value of physical classrooms.",
          ],
        ),
        GrammarSubItem(
          name: "Task 2: Objective Conclusion Sentences",
          rule: "Summarize key points objectively with an overarching concluding perspective.",
          examples: [
            "In conclusion, while technological progress poses minor adjustment challenges, its overall societal benefits remain indisputable.",
          ],
        ),
      ],
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

class GrammarSubItem {
  final String name;
  final String rule;
  final List<String> examples;
  final String? note;

  const GrammarSubItem({
    required this.name,
    required this.rule,
    required this.examples,
    this.note,
  });
}

class GrammarTopicItem {
  final int id;
  final String title;
  final String category;
  final List<GrammarSubItem> subItems;

  const GrammarTopicItem({
    required this.id,
    required this.title,
    required this.category,
    required this.subItems,
  });
}
class IeltsWordFamily {
  final String noun;
  final String verb;
  final String adjective;
  final String adverb;

  const IeltsWordFamily({
    this.noun = "—",
    this.verb = "—",
    this.adjective = "—",
    this.adverb = "—",
  });
}

class IeltsWordFamilyTopic {
  final String topicName;
  final String icon;
  final List<IeltsWordFamily> words;

  const IeltsWordFamilyTopic({
    required this.topicName,
    required this.icon,
    required this.words,
  });
}