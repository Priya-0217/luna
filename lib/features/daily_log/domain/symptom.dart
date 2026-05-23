enum Symptom {
  cramps,
  headache,
  backPain,
  bloating,
  nausea,
  fatigue,
  dizzy,
  fever,
  breastTenderness,
  spotting;

  String get label => switch (this) {
        Symptom.cramps => 'Cramps',
        Symptom.headache => 'Headache',
        Symptom.backPain => 'Back Pain',
        Symptom.bloating => 'Bloating',
        Symptom.nausea => 'Nausea',
        Symptom.fatigue => 'Fatigue',
        Symptom.dizzy => 'Dizzy',
        Symptom.fever => 'Fever',
        Symptom.breastTenderness => 'Tenderness',
        Symptom.spotting => 'Spotting',
      };

  String get emoji => switch (this) {
        Symptom.cramps => '😣',
        Symptom.headache => '🤕',
        Symptom.backPain => '😩',
        Symptom.bloating => '🫃',
        Symptom.nausea => '🤢',
        Symptom.fatigue => '🪫',
        Symptom.dizzy => '😵',
        Symptom.fever => '🌡️',
        Symptom.breastTenderness => '💗',
        Symptom.spotting => '🩸',
      };

  String get illustrationKey => switch (this) {
        Symptom.cramps => 'char_cramps',
        Symptom.headache => 'char_headache',
        Symptom.backPain => 'char_back_pain',
        Symptom.bloating => 'char_bloating',
        Symptom.nausea => 'char_nauseous',
        Symptom.fatigue => 'char_low_energy',
        Symptom.dizzy => 'char_dizzy',
        Symptom.fever => 'char_feverish',
        Symptom.breastTenderness => 'char_in_pain',
        Symptom.spotting => 'char_in_pain',
      };
}
