enum MessageTrigger {
  openWhenSad,
  openWhenCramps,
  openWhenHappy,
  openWhenAnxious,
  openWhenMissing,
  openWhenAngry,
  openWhenSick,
  openWhenNeedHug,
  openWhenBirthday,
  openWhenAnniversary,
  general;

  String get label => switch (this) {
        MessageTrigger.openWhenSad => 'Open When You Feel Sad',
        MessageTrigger.openWhenCramps => 'Open When You Have Cramps',
        MessageTrigger.openWhenHappy => 'Open When You Feel Happy',
        MessageTrigger.openWhenAnxious => 'Open When You Feel Anxious',
        MessageTrigger.openWhenMissing => 'Open When You Miss Me',
        MessageTrigger.openWhenAngry => 'Open When You Feel Angry',
        MessageTrigger.openWhenSick => 'Open When You Feel Sick',
        MessageTrigger.openWhenNeedHug => 'Open When You Need a Hug',
        MessageTrigger.openWhenBirthday => 'Open On Your Birthday',
        MessageTrigger.openWhenAnniversary => 'Open On Our Anniversary',
        MessageTrigger.general => 'A Letter For You',
      };

  String get emoji => switch (this) {
        MessageTrigger.openWhenSad => '🌧️',
        MessageTrigger.openWhenCramps => '💗',
        MessageTrigger.openWhenHappy => '✨',
        MessageTrigger.openWhenAnxious => '🌿',
        MessageTrigger.openWhenMissing => '💕',
        MessageTrigger.openWhenAngry => '🌊',
        MessageTrigger.openWhenSick => '🌡️',
        MessageTrigger.openWhenNeedHug => '🤗',
        MessageTrigger.openWhenBirthday => '🎂',
        MessageTrigger.openWhenAnniversary => '💍',
        MessageTrigger.general => '💌',
      };
}
