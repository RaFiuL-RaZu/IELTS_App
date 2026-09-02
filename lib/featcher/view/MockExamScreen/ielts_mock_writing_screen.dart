import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:justtsham/core/services/ielts_local_storage_service.dart';
import 'package:justtsham/core/services/ielts_gemini_ai_service.dart';

class IeltsMockWritingScreen extends StatefulWidget {
  final int testNumber;

  const IeltsMockWritingScreen({
    super.key,
    this.testNumber = 1,
  });

  @override
  State<IeltsMockWritingScreen> createState() => _IeltsMockWritingScreenState();
}

class _IeltsMockWritingScreenState extends State<IeltsMockWritingScreen> {
  int _selectedTaskIndex = 0; // 0: Task 1, 1: Task 2
  int _secondsRemaining = 3600; // 60 minutes
  Timer? _timer;
  bool _isTimerPaused = false;
  bool _isSubmitted = false;

  final TextEditingController _task1Controller = TextEditingController();
  final TextEditingController _task2Controller = TextEditingController();

  int _task1WordCount = 0;
  int _task2WordCount = 0;

  double _task1Band = 0.0;
  double _task2Band = 0.0;
  double _overallBand = 0.0;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!_isTimerPaused && _secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
      } else if (_secondsRemaining <= 0) {
        timer.cancel();
        Get.snackbar(
          "Time's Up! ⏱️",
          "The 60-minute Cambridge Writing test has ended. Please submit your answers.",
          backgroundColor: const Color(0xFFEA580C),
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _task1Controller.dispose();
    _task2Controller.dispose();
    super.dispose();
  }

  void _calculateWords(int taskNumber, String text) {
    final words = text.trim().split(RegExp(r'\s+')).where((w) => w.isNotEmpty).toList();
    setState(() {
      if (taskNumber == 1) {
        _task1WordCount = words.length;
      } else {
        _task2WordCount = words.length;
      }
    });
  }

  String _formatDuration(int totalSeconds) {
    final m = (totalSeconds ~/ 60).toString().padLeft(2, '0');
    final s = (totalSeconds % 60).toString().padLeft(2, '0');
    return "$m:$s";
  }

  double _evaluateSingleTask(String text, int targetWords, bool isTask1) {
    final words = text.trim().split(RegExp(r'\s+')).where((w) => w.isNotEmpty).toList();
    final count = words.length;

    if (count < 20) return 4.0;

    // Word Count & Task Achievement
    double ta;
    if (count >= targetWords) {
      ta = count >= (targetWords + 30) ? 8.5 : 8.0;
    } else if (count >= targetWords * 0.8) {
      ta = 7.0;
    } else if (count >= targetWords * 0.6) {
      ta = 6.0;
    } else {
      ta = 5.0;
    }

    // Coherence & Linkers
    final linkers = [
      "furthermore", "moreover", "however", "consequently", "therefore", "in addition",
      "nevertheless", "on the other hand", "firstly", "secondly", "finally", "in conclusion",
      "overall", "whereas", "while", "in contrast", "as a result", "subsequently"
    ];
    final lower = text.toLowerCase();
    int linkerHits = 0;
    for (final l in linkers) {
      if (lower.contains(l)) linkerHits++;
    }
    final paragraphs = text.split(RegExp(r'\n+')).where((p) => p.trim().isNotEmpty).length;

    double cc;
    if (paragraphs >= (isTask1 ? 3 : 4) && linkerHits >= 3) {
      cc = 8.0;
    } else if (paragraphs >= 2 && linkerHits >= 2) {
      cc = 7.0;
    } else {
      cc = 6.0;
    }

    // Lexical Resource
    final uniqueWords = words.map((w) => w.toLowerCase()).toSet().length;
    final diversity = words.isNotEmpty ? uniqueWords / words.length : 0.0;
    double lr = (diversity > 0.52 && count >= targetWords) ? 8.0 : (diversity > 0.44 ? 7.0 : 6.0);

    // Grammatical Accuracy
    final hasPunctuation = text.contains('.') && text.contains(',');
    double gra = hasPunctuation ? (count >= targetWords ? 7.5 : 7.0) : 6.0;

    return (ta + cc + lr + gra) / 4.0;
  }

  Future<void> _handleSubmit() async {
    if (_isSubmitted) {
      // Reset test
      setState(() {
        _isSubmitted = false;
        _task1Controller.clear();
        _task2Controller.clear();
        _task1WordCount = 0;
        _task2WordCount = 0;
        _secondsRemaining = 3600;
        _isTimerPaused = false;
      });
      return;
    }

    if (_task1WordCount < 20 && _task2WordCount < 20) {
      Get.snackbar(
        "Insufficient Writing ⚠️",
        "Please write at least 20 words in Task 1 or Task 2 before submitting.",
        snackPosition: SnackPosition.TOP,
        backgroundColor: const Color(0xFFEA580C),
        colorText: Colors.white,
      );
      return;
    }

    // Show Gemini AI Evaluator Loading Dialog
    Get.dialog(
      barrierDismissible: false,
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: Colors.white,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 28.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: const Color(0xFF325E6A).withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: const SizedBox(
                  width: 32,
                  height: 32,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    color: Color(0xFF325E6A),
                  ),
                ),
              ),
              SizedBox(height: 18.h),
              Text(
                "🤖 Gemini AI Mock Examiner",
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w800, color: const Color(0xFF0F172A)),
              ),
              SizedBox(height: 8.h),
              Text(
                "Evaluating Task 1 & Task 2 using official Cambridge IELTS band descriptors...",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12.5.sp, color: const Color(0xFF64748B), height: 1.45),
              ),
            ],
          ),
        ),
      ),
    );

    double t1 = _evaluateSingleTask(_task1Controller.text, 150, true);
    double t2 = _evaluateSingleTask(_task2Controller.text, 250, false);

    // If Task 2 is written, evaluate via Gemini AI
    if (_task2WordCount >= 20) {
      final aiRes2 = await IeltsGeminiAiService.evaluateWriting(
        taskType: "Task 2 Discursive Essay",
        prompt: "Task 2 Mock Prompt",
        userEssay: _task2Controller.text,
      );
      t2 = aiRes2.overallBand;
    }

    // If Task 1 is written, evaluate via Gemini AI
    if (_task1WordCount >= 20) {
      final aiRes1 = await IeltsGeminiAiService.evaluateWriting(
        taskType: "Task 1 Report",
        prompt: "Task 1 Mock Prompt",
        userEssay: _task1Controller.text,
      );
      t1 = aiRes1.overallBand;
    }

    if (Get.isDialogOpen == true) {
      Get.back();
    }

    // Official weighting: Task 2 is 2/3 (67%) and Task 1 is 1/3 (33%)
    final double rawOverall;
    if (_task1WordCount >= 20 && _task2WordCount >= 20) {
      rawOverall = (t1 * 1.0 / 3.0) + (t2 * 2.0 / 3.0);
    } else if (_task2WordCount >= 20) {
      rawOverall = t2;
    } else {
      rawOverall = t1;
    }

    // Rounding to nearest 0.5
    final frac = rawOverall - rawOverall.floor();
    double finalBand;
    if (frac < 0.25) {
      finalBand = rawOverall.floorToDouble();
    } else if (frac < 0.75) {
      finalBand = rawOverall.floorToDouble() + 0.5;
    } else {
      finalBand = (rawOverall.floor() + 1).toDouble();
    }

    setState(() {
      _task1Band = t1;
      _task2Band = t2;
      _overallBand = finalBand;
      _isSubmitted = true;
      _isTimerPaused = true;
    });

    if (Get.isRegistered<IeltsProgressController>()) {
      final ctrl = IeltsProgressController.to;
      ctrl.writingTaskDone.value = true;
      ctrl.writingBand.value = finalBand;
      ctrl.addTestResult(
        skill: "Writing",
        testName: "Mock Test ${widget.testNumber} - Writing",
        score: _task1WordCount + _task2WordCount,
        totalQuestions: 400,
        bandScore: finalBand,
        isMockExam: true,
      );
      ctrl.saveToLocalStorage();
    }

    Get.snackbar(
      "Gemini AI Writing Evaluated! 🎯",
      "Overall Band: ${finalBand.toStringAsFixed(1)} (Task 1: ${t1.toStringAsFixed(1)}, Task 2: ${t2.toStringAsFixed(1)}) • Logged to Mock Exam history!",
      snackPosition: SnackPosition.TOP,
      backgroundColor: const Color(0xFF325E6A),
      colorText: Colors.white,
      duration: const Duration(seconds: 4),
    );
  }

  @override
  Widget build(BuildContext context) {
    final progressCtrl = Get.isRegistered<IeltsProgressController>() ? IeltsProgressController.to : null;
    final isGeneral = progressCtrl?.examModule.value == "General Training";

    // Task 1 by testNumber
    final String task1Title;
    final String task1Prompt;
    final String task1Model;

    if (widget.testNumber == 2) {
      task1Title = isGeneral ? "GT Task 1: Semi-Formal Letter" : "Academic Task 1: Commuter Transport Trends";
      task1Prompt = isGeneral
          ? "You have recently moved into a rented apartment and discovered serious maintenance defects in the bathroom and kitchen.\n\nWrite a letter to your property landlord. In your letter:\n• Explain when you moved in and reference your tenancy agreement\n• Describe the specific maintenance defects in detail\n• Request urgent repairs and state when you expect a contractor to visit.\n\nWrite at least 150 words. You do not need to write any addresses."
          : "The bar chart below compares the proportion of urban commuters using public metro, buses, and private vehicles across four metropolitan centers (London, Tokyo, New York, Berlin) between 2010 and 2025.\n\nSummarise the information by selecting and reporting the main features, and make comparisons where relevant.\n\nWrite at least 150 words.";
      task1Model = isGeneral
          ? "Dear Mr. Henderson,\n\nI am writing to formally report multiple urgent plumbing and electrical maintenance faults in flat 4B, following my tenancy commencement on 1st September under agreement ref #TN-4019.\n\nUpon moving in, I discovered that the central kitchen drain is severely obstructed, causing stagnant water accumulation. Additionally, the bathroom electrical shower unit repeatedly trips the circuit breaker, posing a severe safety hazard.\n\nUnder our tenancy terms, structural and utility repairs remain the landlord's responsibility. I request that you dispatch a certified technician to inspect and rectify these issues by Thursday. Please contact me at your earliest convenience to arrange property access.\n\nYours sincerely,\nCandidate."
          : "The bar chart provides a comparative analysis of commuting modal shares across London, Tokyo, New York, and Berlin over a 15-year period from 2010 to 2025.\n\nOverall, public metro transit experienced substantial growth across all four cities, with Tokyo and Berlin recording the highest reliance on rapid rail. In contrast, private vehicular usage exhibited a downward trend, most notably in Tokyo.\n\nIn 2010, approximately 45% of Tokyo commuters utilized subway systems, rising to nearly 68% by 2025. London also registered steady metro gains from 38% to 52%. Conversely, private automobile reliance in New York remained the highest among all surveyed cities, declining only marginally from 55% to 46% over the period.";
    } else if (widget.testNumber == 3) {
      task1Title = isGeneral ? "GT Task 1: Formal Request Letter" : "Academic Task 1: Global Carbon Emissions";
      task1Prompt = isGeneral
          ? "You recently attended an international academic seminar, but your certification of completion contained several typographical errors.\n\nWrite a formal letter to the conference director. In your letter:\n• State which conference you attended and when\n• Detail the errors on your certificate and provide the correct details\n• Request a revised official digital and print copy.\n\nWrite at least 150 words."
          : "The pie charts illustrate carbon emissions breakdown across four major industrial sectors (Manufacturing, Energy Generation, Transport, and Agriculture) in 2000 and 2025.\n\nSummarise the information by selecting and reporting the main features, and make comparisons where relevant.\n\nWrite at least 150 words.";
      task1Model = "The two pie charts delineate sectoral contributions to global greenhouse emissions across two specific years: 2000 and 2025.\n\nOverall, energy generation and transportation constituted the dominant sources of emissions in both years. However, while transport emissions experienced a noticeable surge, manufacturing registered a modest contraction over the quarter-century.\n\nIn 2000, energy production accounted for 40% of emissions, whereas transport comprised 22%. By 2025, transport expanded significantly to 31%, reflecting accelerated global freight and personal mobility. Conversely, industrial manufacturing decreased from 25% to 18%, driven by enhanced energy-efficiency standards and clean factory automation.";
    } else if (widget.testNumber == 4) {
      task1Title = isGeneral ? "GT Task 1: Formal Complaint Letter" : "Academic Task 1: Electric Vehicle Sales";
      task1Prompt = isGeneral
          ? "You purchased a laptop from a computer store, but it malfunctioned within one week. The store staff refused to replace it.\n\nWrite a letter to the store manager. In your letter:\n• Provide details of purchase and the defect\n• Explain the unhelpful response of the sales assistant\n• State what action you require (full refund or immediate exchange).\n\nWrite at least 150 words."
          : "The line graph delineates sales volumes of electric vehicles compared to conventional internal combustion vehicles across four countries between 2015 and 2030 (projected).\n\nSummarise the information by selecting and reporting the main features, and make comparisons where relevant.\n\nWrite at least 150 words.";
      task1Model = "The line graph provides historical and projected sales volumes for electric vehicles (EVs) versus traditional combustion engine cars across four countries from 2015 to 2030.\n\nOverall, electric vehicle adoption displays an exponential upward trajectory across all nations, with projected figures overtaking conventional vehicle sales by 2028.\n\nStarting at fewer than 50,000 units in 2015, EV deliveries grew steadily before accelerating sharply after 2020. By 2030, EV sales are forecast to exceed 1.2 million units annually, whereas internal combustion purchases drop by more than 60% over the same timeframe.";
    } else {
      task1Title = isGeneral ? "GT Task 1: Formal Letter" : "Academic Task 1: Comparative Report";
      task1Prompt = isGeneral
          ? "You recently purchased an airline travel package, but when you made an emergency refund claim, the customer service department unfairly rejected it.\n\nWrite a formal letter to the airline claims director. In your letter:\n• Explain when and what package you purchased\n• Describe the circumstances and why your refund claim is valid\n• State clearly what resolution or reimbursement you expect.\n\nWrite at least 150 words. You do not need to write any addresses."
          : "The chart below illustrates renewable energy generation across four European countries (Germany, United Kingdom, Spain, and France) between 2000 and 2020.\n\nSummarise the information by selecting and reporting the main features, and make comparisons where relevant.\n\nWrite at least 150 words.";
      task1Model = isGeneral
          ? "Dear Sir or Madam,\n\nI am writing to formally contest the rejection of my refund claim regarding booking reference #BA-89210, which was unexpectedly declined by your customer service department on 14th August.\n\nLast month, I purchased an all-inclusive flexible European travel package. Due to an unforeseen medical emergency that led to immediate hospitalization, I had to cancel my itinerary 72 hours prior to departure, fully complying with Clause 4.2 of your cancellation policy.\n\nI have attached full medical verification documents and the original booking invoice. In light of these facts, I request an immediate reassessment and a full reimbursement of £840 to my account within ten working days.\n\nYours faithfully,\nCandidate."
          : "The line graph delineates renewable power production in four European nations over a 20-year span from 2000 to 2020, measured in gigawatt-hours.\n\nOverall, renewable generation experienced a substantial upward trajectory across all surveyed countries, with Germany demonstrating the most pronounced growth throughout the two decades.\n\nIn 2000, Germany and the UK produced approximately 30 GWh and 20 GWh respectively. Over the subsequent decade, German clean generation rose exponentially, peaking at 125 GWh by 2020. Simultaneously, the UK recorded consistent gains, culminating at 85 GWh.\n\nIn contrast, Spain and France commenced at lower levels of 15 GWh and 10 GWh. While French output witnessed steady increments to reach 55 GWh, Spanish generation surged sharply after 2012, finishing the period at 70 GWh.";
    }

    // Task 2 by testNumber
    final String task2Title;
    final String task2Prompt;
    final String task2Model;

    if (widget.testNumber == 2) {
      task2Title = "Task 2: Discursive Essay";
      task2Prompt = "Some people argue that tertiary education should be fully funded by the state for all citizens, while others believe that students should finance their own university degrees because higher education primarily benefits the individual.\n\nDiscuss both views and give your own opinion.\n\nWrite at least 250 words.";
      task2Model = "The financing of higher education remains a contentious socio-economic debate worldwide. While proponents of state-subsidized tertiary schooling advocate for egalitarian access, opponents argue that individual beneficiaries must bear the fiscal burden. In this essay, I will explore both perspectives before arguing that state-funded university tuition yields indispensable collective societal dividends.\n\nAdvocates of private financing contend that higher education predominantly confers substantial private economic gains upon graduates. Empirical studies consistently demonstrate that degree holders command significantly higher lifetime earnings compared to non-graduates. Consequently, taxing general taxpayers—many of whom did not attend university—to subsidize elite future earners is deemed regressive.\n\nConversely, treating university education as an accessible public good catalyses social mobility and intellectual innovation. When tuition fees become prohibitive, bright students from disadvantaged socio-economic backgrounds are systematically excluded, perpetuating intergenerational inequality. Furthermore, societies require highly trained doctors, engineers, and teachers whose contributions enrich economic infrastructure far beyond their personal compensation.\n\nIn conclusion, although university graduates undeniably harvest private financial rewards, the overarching societal advancements spawned by an educated populace justify robust governmental funding.";
    } else if (widget.testNumber == 3) {
      task2Title = "Task 2: Discursive Essay";
      task2Prompt = "The shift toward remote telecommuting has accelerated globally. Some believe this development greatly enhances workers' productivity and lifestyle balance, while others worry it degrades corporate collaboration and mental health.\n\nDiscuss both views and give your opinion.\n\nWrite at least 250 words.";
      task2Model = "The widespread transition toward remote working has fundamentally revolutionized contemporary employment paradigms. While critics contend that telecommuting erodes corporate camaraderie and blurs domestic boundaries, I maintain that flexible remote arrangements confer unprecedented productivity gains and environmental advantages when managed effectively.\n\nDetractors emphasize the psychological and collaborative drawbacks of decentralized teams. Spontaneous workplace interactions, which frequently spark innovative breakthroughs, are inherently diminished in virtual environments. Additionally, telecommuters frequently report feelings of professional isolation and difficulties in dissociating vocational duties from domestic life, leading to insidious burnout.\n\nNonetheless, the advantages of telecommuting are multifaceted. Eliminating arduous daily commutes saves workers hundreds of hours annually, substantially mitigating psychological fatigue. Moreover, asynchronous communication empowers individuals to engage in deep, uninterrupted focus, yielding higher-quality work output. From an institutional viewpoint, remote operations drastically cut commercial real-estate expenditures and reduce vehicular emissions.\n\nIn conclusion, while organizations must intentionally cultivate digital community to combat alienation, the immense flexibility and efficiency advantages of telecommuting make it an enduring and positive workplace evolution.";
    } else if (widget.testNumber == 4) {
      task2Title = "Task 2: Discursive Essay";
      task2Prompt = "Some people believe that international mass tourism causes irreparable harm to historical heritage and fragile local cultures. Others argue that tourism is essential for cultural preservation and economic development.\n\nDiscuss both views and give your opinion.\n\nWrite at least 250 words.";
      task2Model = "International mass tourism has burgeoned into one of the world's most lucrative industries, yet its environmental and cultural footprint continues to provoke controversy. While excessive tourist congestion undeniably endangers fragile heritage sites, I contend that sustainable tourism generates vital fiscal capital indispensable for heritage preservation.\n\nCritics highlight the detrimental impacts of overtourism. Historic monuments, such as ancient temples or medieval alleys, suffer physical degradation from continuous foot traffic and vandalism. Furthermore, commercialization often trivializes sacred local customs into superficial spectacles tailored for consumer entertainment, diluting authentic traditions.\n\nConversely, well-regulated tourism provides the primary economic engine required to finance costly archaeological restorations. Without tourist admissions and heritage levies, municipal governments in developing regions would lack the budgetary means to maintain historical architecture. Furthermore, cross-cultural tourism dismantles insular stereotypes, fostering global mutual understanding.\n\nIn conclusion, while unchecked tourism risks cultural commodification and physical damage, strategic regulatory frameworks allow tourism revenue to safeguard cultural treasures for future generations.";
    } else {
      task2Title = "Task 2: Discursive Essay";
      task2Prompt = "Some people believe that artificial intelligence and automation will completely replace human professionals such as educators, medical practitioners, and financial advisors in the coming decades, while others argue that essential human empathy and creative judgment can never be replicated.\n\nDiscuss both views and give your own opinion.\n\nGive reasons for your answer and include any relevant examples from your own knowledge or experience.\n\nWrite at least 250 words.";
      task2Model = "In contemporary society, the meteoric rise of artificial intelligence has sparked intense debate concerning the future viability of human professions. While some contend that algorithmic automation will render human practitioners obsolete, I firmly maintain that empathetic moral judgment and genuine human interpersonal rapport remain fundamentally irreplaceable.\n\nAdvocates of total automation point to the unmatched computational velocity and diagnostic precision of modern AI. Machine learning algorithms can parse millions of radiological scans or financial transactions in seconds, diagnosing ailments with negligible error rates. In education, AI-driven adaptive platforms tailor curriculum content to the unique cognitive pacing of individual learners, optimizing knowledge transfer without human fatigue.\n\nNevertheless, the core of professions like medicine and teaching transcends mere factual analysis. A compassionate physician does not merely prescribe pharmacotherapy; they provide emotional solace, navigate ethical ambiguities, and deliver devastating prognoses with sensitivity. Similarly, inspiring teachers mold ethical values and critical thinking, instilling resilience that no code can replicate.\n\nIn conclusion, while artificial intelligence will undoubtedly transform professional landscapes by handling algorithmic workflows, human empathetic connection and critical ethics will ensure that educators and doctors remain irreplaceable.";
    }

    final activeTitle = _selectedTaskIndex == 0 ? task1Title : task2Title;
    final activePrompt = _selectedTaskIndex == 0 ? task1Prompt : task2Prompt;
    final activeModel = _selectedTaskIndex == 0 ? task1Model : task2Model;
    final activeController = _selectedTaskIndex == 0 ? _task1Controller : _task2Controller;
    final activeWordCount = _selectedTaskIndex == 0 ? _task1WordCount : _task2WordCount;
    final activeTarget = _selectedTaskIndex == 0 ? 150 : 250;
    final isWordTargetMet = activeWordCount >= activeTarget;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 65.h,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF0F172A), size: 20),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          "IELTS Writing Arena",
          style: TextStyle(
            color: Color(0xFF0F172A),
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: const LinearGradient(
                  colors: [Color(0xFF1E3C45), Color(0xFF284F5A), Color(0xFF325E6A)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF325E6A).withOpacity(0.28),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            "⏱️ 60-MIN TIMED SIMULATION",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFFB0D5DE),
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _isTimerPaused = !_isTimerPaused;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.18),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                _isTimerPaused ? Icons.play_arrow_rounded : Icons.pause_rounded,
                                color: Colors.white,
                                size: 14,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                _isTimerPaused ? "Resume" : "Pause",
                                style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w800),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 14.h),
                  Text(
                    "Mock Test ${widget.testNumber} - Writing",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  const Text(
                    "Task 1: Min 150 Words (20 mins) • Task 2: Min 250 Words (40 mins)",
                    style: TextStyle(
                      fontSize: 12.5,
                      color: Color(0xFFD3E7EC),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 14.h),

                  // Countdown & Word Statistics Row
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.timer_outlined, color: Color(0xFFB0D5DE), size: 18),
                            SizedBox(width: 6.w),
                            Text(
                              _formatDuration(_secondsRemaining),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                fontFamily: 'monospace',
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(Icons.edit_note_rounded, color: Color(0xFFB0D5DE), size: 18),
                            SizedBox(width: 6.w),
                            Text(
                              "T1: $_task1WordCount/150w • T2: $_task2WordCount/250w",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 18.h),

            // Segmented Task Switcher
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedTaskIndex = 0),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: EdgeInsets.symmetric(vertical: 10.h),
                        decoration: BoxDecoration(
                          color: _selectedTaskIndex == 0 ? const Color(0xFF325E6A) : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            "Task 1 ($_task1WordCount/150w)",
                            style: TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w800,
                              color: _selectedTaskIndex == 0 ? Colors.white : const Color(0xFF64748B),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedTaskIndex = 1),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: EdgeInsets.symmetric(vertical: 10.h),
                        decoration: BoxDecoration(
                          color: _selectedTaskIndex == 1 ? const Color(0xFF325E6A) : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            "Task 2 ($_task2WordCount/250w)",
                            style: TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w800,
                              color: _selectedTaskIndex == 1 ? Colors.white : const Color(0xFF64748B),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 16.h),

            // Prompt Card
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFE2E8F0)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          activeTitle,
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                        decoration: BoxDecoration(
                          color: const Color(0xFF325E6A).withOpacity(0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          _selectedTaskIndex == 0 ? "Min 150w" : "Min 250w",
                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Color(0xFF325E6A)),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    activePrompt,
                    style: const TextStyle(fontSize: 13.5, height: 1.5, color: Color(0xFF334155)),
                  ),
                ],
              ),
            ),

            SizedBox(height: 16.h),

            // Collapsible Model Answer & Strategy (Matching Listening Tapescript)
            ExpansionTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
                side: const BorderSide(color: Color(0xFFE2E8F0)),
              ),
              collapsedShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
                side: const BorderSide(color: Color(0xFFE2E8F0)),
              ),
              backgroundColor: Colors.white,
              collapsedBackgroundColor: Colors.white,
              initiallyExpanded: false,
              title: const Text(
                "💡 Band 9 Model Answer & Structure Guide",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF325E6A)),
              ),
              children: [
                Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        activeModel,
                        style: const TextStyle(fontSize: 13, height: 1.5, fontStyle: FontStyle.italic, color: Color(0xFF374151)),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: 22.h),

            // Question Answer Sheet Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Candidate Answer Sheet:",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF0F172A),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: isWordTargetMet ? const Color(0xFFE8F5E9) : const Color(0xFF325E6A).withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isWordTargetMet ? const Color(0xFFA5D6A7) : const Color(0xFF325E6A).withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isWordTargetMet ? Icons.check_circle_rounded : Icons.info_outline_rounded,
                        size: 14,
                        color: isWordTargetMet ? const Color(0xFF2E7D32) : const Color(0xFF325E6A),
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        "$activeWordCount / $activeTarget Words",
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w800,
                          color: isWordTargetMet ? const Color(0xFF2E7D32) : const Color(0xFF325E6A),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),

            // Writing TextField Card
            Container(
              padding: EdgeInsets.all(14.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: _isSubmitted
                      ? const Color(0xFF2E7D32)
                      : (isWordTargetMet ? const Color(0xFF325E6A) : const Color(0xFFE2E8F0)),
                  width: _isSubmitted ? 1.5 : 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: activeController,
                maxLines: 14,
                minLines: 9,
                enabled: !_isSubmitted,
                onChanged: (val) => _calculateWords(_selectedTaskIndex == 0 ? 1 : 2, val),
                style: const TextStyle(fontSize: 14, color: Color(0xFF0F172A), height: 1.55),
                decoration: InputDecoration(
                  hintText: "Begin drafting your response here...\nEnsure clear paragraphing and cohesive transitions.",
                  hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
                  border: InputBorder.none,
                ),
              ),
            ),

            if (_isSubmitted) ...[
              SizedBox(height: 16.h),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: const Color(0xFF325E6A).withOpacity(0.08),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: const Color(0xFF325E6A).withOpacity(0.25)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Official Evaluated Band Score",
                          style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800, color: Color(0xFF325E6A)),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                          decoration: BoxDecoration(
                            color: const Color(0xFF325E6A),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            "Band ${_overallBand.toStringAsFixed(1)}",
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      "Task 1: Band ${_task1Band.toStringAsFixed(1)} (33% weighting) • Task 2: Band ${_task2Band.toStringAsFixed(1)} (67% weighting)\nAssessment criteria checked: Task Achievement, Coherence & Cohesion, Lexical Resource, Grammatical Accuracy.",
                      style: const TextStyle(fontSize: 12, color: Color(0xFF1E3C45), height: 1.4),
                    ),
                  ],
                ),
              ),
            ],

            SizedBox(height: 22.h),

            // Action Button matching Listening & Reading
            GestureDetector(
              onTap: _handleSubmit,
              child: Container(
                height: 48.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFF325E6A),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF325E6A).withOpacity(0.28),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    _isSubmitted ? "Reset & Retry Test" : "Submit Writing Sheet",
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}
