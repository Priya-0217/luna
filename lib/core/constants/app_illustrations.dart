class AppIllustrations {
  AppIllustrations._();

  static const String basePath = 'assets/illustrations/';

  // === EMOTIONAL STATES ===
  static const String happy        = '${basePath}char_happy.png';
  static const String inLove       = '${basePath}char_in_love.png';
  static const String laughing     = '${basePath}char_laughing.png';
  static const String excited      = '${basePath}char_excited.png';
  static const String shy          = '${basePath}char_shy.png';
  static const String grateful     = '${basePath}char_grateful.png';
  static const String warm         = '${basePath}char_warm.png';
  static const String hello        = '${basePath}char_hello.png';
  static const String cheerful     = '${basePath}char_cheerful.png';

  // === CALM & REST STATES ===
  static const String tired        = '${basePath}char_tired.png';
  static const String sleepy       = '${basePath}char_sleepy.png';
  static const String wakingUp     = '${basePath}char_waking_up.png';
  static const String cozy         = '${basePath}char_cozy.png';
  static const String relaxed      = '${basePath}char_relaxed.png';
  static const String peaceful     = '${basePath}char_peaceful.png';
  static const String meditating   = '${basePath}char_meditating.png';
  static const String deepBreath   = '${basePath}char_deep_breath.png';
  static const String content      = '${basePath}char_content.png';

  // === DIFFICULT EMOTIONS ===
  static const String sad          = '${basePath}char_sad.png';
  static const String crying       = '${basePath}char_crying.png';
  static const String anxious      = '${basePath}char_anxious.png';
  static const String stressed     = '${basePath}char_stressed.png';
  static const String overwhelmed  = '${basePath}char_overwhelmed.png';
  static const String angry        = '${basePath}char_angry.png';
  static const String frustrated   = '${basePath}char_frustrated.png';
  static const String irritated    = '${basePath}char_irritated.png';
  static const String disappointed = '${basePath}char_disappointed.png';

  // === PHYSICAL SYMPTOMS ===
  static const String inPain       = '${basePath}char_in_pain.png';
  static const String cramps       = '${basePath}char_cramps.png';
  static const String bloating     = '${basePath}char_bloating.png';
  static const String headache     = '${basePath}char_headache.png';
  static const String backPain     = '${basePath}char_back_pain.png';
  static const String nauseous     = '${basePath}char_nauseous.png';
  static const String dizzy        = '${basePath}char_dizzy.png';
  static const String feverish     = '${basePath}char_feverish.png';
  static const String lowEnergy    = '${basePath}char_low_energy.png';

  // === ACTIVITIES & PRODUCTIVITY ===
  static const String studying     = '${basePath}char_studying.png';
  static const String working      = '${basePath}char_working.png';
  static const String focused      = '${basePath}char_focused.png';
  static const String planning     = '${basePath}char_planning.png';
  static const String productive   = '${basePath}char_productive.png';
  static const String creative     = '${basePath}char_creative.png';
  static const String cooking      = '${basePath}char_cooking.png';
  static const String baking       = '${basePath}char_baking.png';
  static const String cleaning     = '${basePath}char_cleaning.png';

  // === SELF-CARE & WELLNESS ===
  static const String selfCare     = '${basePath}char_self_care.png';
  static const String skinCare     = '${basePath}char_skin_care.png';
  static const String hairCare     = '${basePath}char_hair_care.png';
  static const String bathTime     = '${basePath}char_bath_time.png';
  static const String spaDay       = '${basePath}char_spa_day.png';
  static const String journaling   = '${basePath}char_journaling.png';
  static const String reading      = '${basePath}char_reading.png';
  static const String musicTime    = '${basePath}char_music_time.png';
  static const String movieTime    = '${basePath}char_movie_time.png';

  // === SPECIAL & OCCASIONS ===
  static const String rainyDay     = '${basePath}char_rainy_day.png';
  static const String sunnyDay     = '${basePath}char_sunny_day.png';
  static const String natureLove   = '${basePath}char_nature_love.png';
  static const String traveling    = '${basePath}char_traveling.png';
  static const String beachDay     = '${basePath}char_beach_day.png';
  static const String festival     = '${basePath}char_festival.png';
  static const String partyTime    = '${basePath}char_party_time.png';
  static const String dateNight    = '${basePath}char_date_night.png';
  static const String goodNight    = '${basePath}char_good_night.png';

  // === MAP MOOD → CHARACTER ===
  static String forMood(String mood) {
    return switch (mood.toLowerCase()) {
      'happy'      => happy,
      'in_love'    => inLove,
      'excited'    => excited,
      'cheerful'   => cheerful,
      'grateful'   => grateful,
      'cozy'       => cozy,
      'content'    => content,
      'relaxed'    => relaxed,
      'calm' || 'peaceful' => peaceful,
      'tired'      => tired,
      'anxious'    => anxious,
      'sad'        => sad,
      'stressed'   => stressed,
      'crying'     => crying,
      'irritable'  => irritated,
      'down'       => disappointed,
      'overwhelmed'=> overwhelmed,
      'angry'      => angry,
      _            => hello,
    };
  }

  // === MAP SYMPTOM → CHARACTER ===
  static String forSymptom(String symptom) {
    return switch (symptom.toLowerCase()) {
      'cramps'         => cramps,
      'headache'       => headache,
      'backache' || 'back_pain' => backPain,
      'bloating'       => bloating,
      'nausea' || 'nauseous' => nauseous,
      'fatigue' || 'low_energy' => lowEnergy,
      'dizzy'          => dizzy,
      'fever' || 'feverish' => feverish,
      _                => inPain,
    };
  }

  // === MAP CYCLE PHASE → CHARACTER ===
  static String forCyclePhase(String phase) {
    return switch (phase.toLowerCase()) {
      'menstrual'  => cozy,
      'follicular' => wakingUp,
      'ovulation'  => excited,
      'luteal'     => deepBreath,
      _            => hello,
    };
  }

  // === MAP SELF-CARE ACTIVITY → CHARACTER ===
  static String forSelfCare(String activity) {
    final key = activity.toLowerCase();
    if (key.contains('bath'))       return bathTime;
    if (key.contains('skin'))       return skinCare;
    if (key.contains('meditat') || key.contains('yoga')) return meditating;
    if (key.contains('music'))      return musicTime;
    if (key.contains('journal'))    return journaling;
    if (key.contains('read'))       return reading;
    if (key.contains('spa'))        return spaDay;
    if (key.contains('movie'))      return movieTime;
    if (key.contains('hair'))       return hairCare;
    if (key.contains('breath') || key.contains('deep')) return deepBreath;
    return selfCare;
  }
}
