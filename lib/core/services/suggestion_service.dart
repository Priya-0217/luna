import 'package:her/features/home/domain/cycle_phase.dart';

class SuggestionService {
  SuggestionService._();

  static List<String> forPhase(CyclePhase phase) => switch (phase) {
    CyclePhase.menstrual => [
      "A warm heating pad on your lower belly can help with cramps 🌸",
      "Chamomile tea is your best friend right now ☕",
      "It's okay to cancel plans and just rest today",
      "A hot shower or bath can ease the achiness 🛁",
      "Dark chocolate has magnesium — doctor's orders 🍫",
      "Your body is working hard. Be gentle with yourself 💕",
    ],
    CyclePhase.follicular => [
      "Energy is rising — this is a great time to try something new 🌿",
      "Your skin tends to glow this week — enjoy it ✨",
      "Light exercise like a walk or yoga feels amazing right now",
      "Great time to start that project you've been thinking about 🌱",
      "Social energy is up — reach out to someone you love 💌",
    ],
    CyclePhase.ovulation => [
      "You're likely at your most radiant today ✨",
      "High energy day — make the most of it 🌟",
      "Your confidence peaks around now — own it 💪",
      "A great day for photos, dates, or anything social 💕",
      "Stay hydrated — your body needs extra water today 💧",
    ],
    CyclePhase.luteal => [
      "Gentle is the word today 🌙",
      "Craving carbs is completely normal right now — be kind to yourself",
      "Journaling can really help process emotions this week 📖",
      "Magnesium-rich foods (nuts, seeds, leafy greens) can ease PMS",
      "Early sleep tonight will make tomorrow feel lighter 🌙",
      "If you feel emotional, that's okay — it's just your hormones shifting",
    ],
  };

  static List<String> forMood(String mood) => switch (mood.toLowerCase()) {
    'sad' => [
      "It's okay to not be okay. He's thinking of you 💕",
      "Wrap yourself in something soft and breathe slowly 🌸",
      "You don't have to feel better right now. Just feel it.",
      "Check the From Him section — he left something for moments like this 💌",
    ],
    'anxious' => [
      "Breathe in for 4 counts, hold for 4, out for 4. You've got this 🌿",
      "Name 5 things you can see right now. Ground yourself.",
      "This feeling will pass. It always does 💕",
      "Gentle movement — even just stretching — can calm the nervous system",
    ],
    'tired' => [
      "Rest is not laziness — it's love for yourself 🌙",
      "Even 20 minutes of sleep can reset your energy",
      "A warm drink and quiet time counts as self-care today ☕",
      "You don't have to do everything today. One thing is enough.",
    ],
    'happy' || 'joyful' => [
      "Capture this feeling — write it down so future you can read it 🌸",
      "Share your joy with someone you love today 💕",
      "This is your natural state. You deserve to feel this way 🌟",
    ],
    _ => [
      "Taking a moment to check in with yourself is always a good idea 🌸",
      "You're doing better than you think 💕",
    ],
  };

  static List<String> selfCareFor(CyclePhase phase) => switch (phase) {
    CyclePhase.menstrual => ["Warm bath 🛁", "Heating pad", "Hot tea ☕", "Rest day", "Comfort movie 🎬"],
    CyclePhase.follicular => ["Light walk 🌿", "Skincare routine", "New recipe 🍳", "Creative project"],
    CyclePhase.ovulation => ["Dance 💃", "Social plans", "Face mask ✨", "Nature walk"],
    CyclePhase.luteal => ["Gentle yoga 🧘", "Journaling 📖", "Early bedtime 🌙", "Cozy reading"],
  };
}
