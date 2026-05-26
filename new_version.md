# 💕 Luna — Love Code System + Separate Onboarding + Shared Relationship Features
> One code connects two people. Every relationship has its own secret.
> Built on the existing Flutter · Riverpod · GoRouter · Firebase stack.

---

## TABLE OF CONTENTS
1. [Love Code System — Architecture](#1-love-code-system)
2. [Her Onboarding — Full Spec](#2-her-onboarding)
3. [Him Onboarding — Full Spec](#3-him-onboarding)
4. [Code Entry + Linking Flow](#4-code-entry--linking-flow)
5. [Firebase Schema — Love Code Layer](#5-firebase-schema)
6. [QR Code Sharing](#6-qr-code-sharing)
7. [Shared Relationship Features](#7-shared-relationship-features)
8. [New Files to Create](#8-new-files)
9. [Build Order](#9-build-order)
10. [Edge Cases + Error States](#10-edge-cases)

---

## 1. LOVE CODE SYSTEM

### The concept

Every couple gets a unique 4-word love code when either partner signs up.
Format: `LUNA-[WORD1]-[WORD2]-[DIGITS]`

Examples:
```
LUNA-ROSE-MOON-4821    ← her code (rose-toned words)
LUNA-STAR-TIDE-7743    ← his code (nature-toned words)
LUNA-DAWN-MIST-3312
LUNA-SOFT-GLOW-9054
```

The code is:
- Generated server-side (Cloud Function) on first signup completion
- Unique globally — checked against `/loveCodes/` collection before assigning
- Permanent — never changes unless explicitly reset
- 6 months expiry on unlinked codes (prevents stale orphans)
- Shown beautifully on a dedicated screen — shareable via native share sheet, copy, or QR

### Code generation logic (Cloud Function)

```typescript
// functions/src/generateLoveCode.ts

const HER_WORDS_1 = ['ROSE', 'DAWN', 'SOFT', 'SILK', 'PETAL', 'BLUSH', 'BLOOM', 'PEARL'];
const HER_WORDS_2 = ['MOON', 'MIST', 'GLOW', 'HAZE', 'LACE', 'DUSK', 'VEIL', 'HALO'];
const HIM_WORDS_1 = ['STAR', 'WAVE', 'PINE', 'STORM', 'FORGE', 'TIDE', 'NORTH', 'EMBER'];
const HIM_WORDS_2 = ['TIDE', 'CREST', 'PEAK', 'VALE', 'COVE', 'BLAZE', 'RIDGE', 'HAVEN'];

async function generateLoveCode(role: 'her' | 'him'): Promise<string> {
  const words1 = role === 'her' ? HER_WORDS_1 : HIM_WORDS_1;
  const words2 = role === 'her' ? HER_WORDS_2 : HIM_WORDS_2;
  let code: string;
  let attempts = 0;

  do {
    const w1 = words1[Math.floor(Math.random() * words1.length)];
    const w2 = words2[Math.floor(Math.random() * words2.length)];
    const digits = String(Math.floor(1000 + Math.random() * 9000));
    code = `LUNA-${w1}-${w2}-${digits}`;
    attempts++;
    if (attempts > 20) throw new Error('Code generation failed');
  } while (await codeExists(code));  // check Firestore for uniqueness

  return code;
}
```

### Code card design

```
┌──────────────────────────────────────────┐
│                                          │
│   Your love code                         │  ← DM Sans 13px, muted
│                                          │
│   LUNA · ROSE · MOON · 4821              │  ← Cormorant Garamond 32px
│                                          │     letter-spacing 6px
│   ──────────────────────────────────     │  ← goldMid divider
│                                          │
│   Share with your partner so they can   │  ← DM Sans 14px
│   connect with you in Luna              │
│                                          │
│   [ 📋 Copy ]  [ 📤 Share ]  [ ⬛ QR ]  │  ← three action buttons
│                                          │
│   Code expires in 6 months if unused    │  ← DM Sans 12px, warmGray400
│                                          │
└──────────────────────────────────────────┘
```

Visually:
- Card background: ivory `#FFFBF7`
- Code text: Cormorant Garamond 32px, `#2D2420` (charcoal), letter-spacing 6px
- Middle dots (·) between words: `goldPrimary` color
- Gold divider line
- Buttons: pill shape, outlined
- Her card: subtle rose border + floating `char_in_love` 80px top-right
- His card: subtle slate-blue border + floating `char_in_love` 80px top-right

---

## 2. HER ONBOARDING — FULL SPEC

Her onboarding is warm, personal, cycle-focused. 7 pages total.

### Page 1 — Splash / Welcome

```
Background: animated gradient (rose → warm peach → mauve, 8s loop)
Floating particles: 15 rose particles, slow drift upward

Center:
  "Luna" — Cormorant Garamond 52px, white, letterSpacing -1
  "A space made just for you." — DM Sans italic 16px, white 80%

Character: char_hello, 200px, bottom-center, gentle float animation

CTA: "Begin 🌸" — rosePrimary, pill, 200px wide

Bottom: "Already have a code? Connect →" — DM Sans 12px, white 60%
        (skips to code entry screen)
```

### Page 2 — Who Are You? (ROLE SELECT)

```
Title: "First — who are you?" — Cormorant 28px
Subtitle: "This shapes your entire Luna experience" — DM Sans 14px, muted

TWO CARDS side by side:

Left card (rose tones):
  char_in_love, 80px, top-center
  "I'm her 🌸"
  "Track my cycle, moods & wellbeing"
  Background: roseSoft
  Border: roseMid 1px

Right card (slate blue):
  char_happy, 80px, top-center
  "I'm him 💙"
  "Take care of her & myself"
  Background: slateBlueSoft
  Border: slateBlueMid 1px

Selected: scale 1.04, glow border (role color), checkmark badge top-right

Note: selecting "I'm him 💙" transitions to HIM ONBOARDING flow (Page H1 below)
      selecting "I'm her 🌸" continues to Page 3 below
```

### Page 3 — Her Name

```
Background: soft white glassmorphism card on rose gradient bg
Character: char_happy, 100px, top-right of card

Title: "What should we call you?" — Cormorant 28px
Input: single large text field, centered, DM Sans 20px
       placeholder: "Your name..."
Live preview: "Hello, [Name] 🌸" — Cormorant italic 24px, rosePrimary

Validation: min 2 chars, letters only, no numbers
CTA: "That's me →" — rosePrimary, activates after 2+ chars
```

### Page 4 — Cycle Setup

```
Character: char_planning, 100px, top-right

Title: "Let's set up your cycle"
Subtitle: "This helps Luna understand and care for you"

Fields:
  1. "When did your last period start?"
     Custom date picker — soft rose calendar
     Character changes to char_cozy when date is selected

  2. "How long is your cycle usually?"
     Slider: 21–45 days, default 28
     Label: "[X] days" updates live in Cormorant italic

  3. "How long does your period last?"
     Slider: 2–10 days, default 5
     Label: "[X] days" updates live

Footer note: "You can always change this later 🌸"
CTA: "Looks right →"
```

### Page 5 — Her Love Code (CRITICAL NEW SCREEN)

```
This is the emotional peak of her onboarding.

Background: ivory with floating rose particles
Character: char_shy, then char_excited after code reveals (animated)

Title: "Your love code" — Cormorant 32px
Subtitle: "Share this with him so he can find you" — DM Sans 14px

[CODE REVEAL ANIMATION — 800ms]:
  Cards flip one by one: LUNA · [word1] · [word2] · [4 digits]
  Each segment fades + scales in with 150ms stagger
  After all 4 reveal: character swaps to char_excited
  Gold shimmer sweeps across the code (CustomPainter animation)

CODE CARD (full spec from Section 1)

Skip option: "Skip for now, connect later" — small text below buttons
             (takes her to app solo mode — From Him section shows "waiting" state)

CTA: "Done, take me in! 💕"

Copy behavior: copies "LUNA-ROSE-MOON-4821" to clipboard
               Toast: "Copied! Send it to him 💙"
Share behavior: native share sheet, pre-filled text:
               "I made a space for us in Luna. Enter my code to connect:
                LUNA-ROSE-MOON-4821 💕 Download: [link]"
```

### Page 6 — Notifications

```
Character: char_warm, 140px, centered

Title: "May I check in on you?"
Subtitle: "He set up Luna to take care of you.\nThese reminders help it do that."

Options (soft toggle cards, not raw system UI):
  🌸 Period reminders       — "2 days before, day 1"
  💧 Hydration nudges       — "Phase-aware, gentle"
  🌙 Sleep reminders        — "Wind-down time"
  💌 From Him notifications  — "When he leaves something"
  📅 Daily log reminder      — "Your time to check in"

"Yes to all" button → requests permission then continues
"I'll choose later" → skips, can configure in settings

Note under options: "Written like messages from him, not system alerts 🌸"
```

### Page 7 — Ready (Emotional Finale)

```
Full-screen warm gradient: deep rose → gold
Character: char_in_love, 180px, bottom-center

His pre-written message (Caveat 20px, on warm paper card):
  "I made this for you. I hope every time you open it,
   you feel how much I love you.
   — [His Name, if linked; otherwise 'him'] 💙"

If not yet linked:
  "Someone special will leave a note here
   when you connect with them 🌸"

Button: "Open Luna 💕" — gold gradient, pill, 240px
Loading screen: "Made with love by [His Name / someone who loves you]"
```

---

## 3. HIM ONBOARDING — FULL SPEC

His onboarding is warmer, quicker, focused on her care and his love code. 6 pages.

The emotional tone: "she matters to you, and this app helps you show it."

### Page H1 — Welcome (Him version)

```
Background: animated gradient — slate blue → warm gold → deep blue, 8s loop
Particles: 15 slate-blue + 5 gold particles drifting

Center:
  "Luna" — Cormorant Garamond 52px, white
  "Made with her in mind." — DM Sans italic 16px, white 80%

Character: char_in_love, 200px, bottom-center

CTA: "Begin 💙" — slateBluePrimary, pill

Bottom: "Already have a code? Connect →"
```

### Page H2 — His Name + Her Name

```
Character: char_happy, 100px, top-right

Two fields on same page:

  "What's your name?"
  Input: "Your name..."
  Live: "Hey, [HisName] 💙"

  "What's her name?" (the person you're setting this up for)
  Input: "Her name..."
  Live: "You're setting this up for [HerName] 🌸"
       Character swaps to char_in_love when her name is typed

Note: "Her name will appear throughout the app wherever it says 'From Her'"

CTA: "That's us →"
```

### Page H3 — About Her (Optional but Personal)

```
Character: char_content, 100px, top-right
Subtitle: "A few things to help Luna care for her better"

Soft toggle options (none required):
  🌸 "She's shared her cycle with me"     → enables care dashboard
  💙 "I want notifications about her"     → enables care notifications
  🤫 "Keep my care reminders private"     → local-only reminders (default ON)

Note: "She controls what she shares. These just set your preferences."

Below: One text field (optional):
  "One thing you love about her (secret — just for you)"
  Caveat font, 3 lines, placeholder: "Write anything..."
  Saved encrypted locally, never shared, shown to HIM in his private space as a reminder

CTA: "Sounds right →"
```

### Page H4 — His Love Code (CRITICAL NEW SCREEN)

```
Same emotional weight as her code screen, blue tones.

Background: ivory with floating slate-blue + gold particles
Character: char_shy → char_excited after reveal

Title: "Your love code" — Cormorant 32px
Subtitle: "Share this with her so she can find you" — DM Sans 14px

[CODE REVEAL — same animation, blue color accent]
  LUNA · STAR · TIDE · 7743

CODE CARD (blue tones, same structure as hers)

Share pre-filled text:
  "I set something up for us in Luna. Enter my code to connect:
   LUNA-STAR-TIDE-7743 💙 Download: [link]"

Below code card:
  "OR — enter her code instead"
  Small text input field: "Paste her code here..."
  → if she's already signed up, can link right here
  → shows: "Found! Connect with [HerName]?" → confirm button

CTA: "Done, take me in! 💙"
```

### Page H5 — Notifications (Him version)

```
Character: char_warm, 130px

Title: "May I help you take care of her?"

Options:
  🌸 Period predictions       — "Before her cycle starts"
  💙 Mood check-ins           — "When she's feeling low"
  💌 From Her notifications   — "When she leaves something"
  🛒 Care reminders           — "Private — only you see these"
  🔔 Couple streak alerts     — "When you're on a roll together"

Note: "These are written as gentle nudges, not alarms 💙"
CTA: "Yes, keep me in the loop →"
```

### Page H6 — Ready (His Emotional Finale)

```
Full-screen gradient: deep slate blue → gold
Character: char_in_love, 180px, bottom-center

Her pre-written message (Caveat 20px, warm paper card):
  "I made this for you because you always take care of me.
   Now let me take care of you too.
   — [HerName, if linked; otherwise 'her'] 🌸"

If not yet linked:
  "She'll leave a note here once you connect.
   She made this space for you 💙"

Button: "Open Luna 💙" — slateBluePrimary gradient, pill
Loading screen: "Made with love by [HerName / her]"
```

---

## 4. CODE ENTRY + LINKING FLOW

### Entry screen design

Shown when either partner taps "Enter their code" — can appear:
- During onboarding (after their own code is shown)
- From settings → "Connect with partner"
- From home screen "waiting" state in From Him/Her section

```
┌─────────────────────────────────────────┐
│                                         │
│   char_in_love, 120px, top-center       │
│                                         │
│   "Enter their love code"               │  ← Cormorant 26px
│   "They got it when they signed up"     │  ← DM Sans 14px, muted
│                                         │
│   ┌─────────────────────────────────┐   │
│   │  LUNA - ____ - ____ - ____     │   │  ← 4 segments auto-advance
│   └─────────────────────────────────┘   │     Cormorant 24px, letter-spacing 4px
│                                         │
│   [ Validate → ]                        │  ← activates when 4 segments filled
│                                         │
│   ──── or ────                          │
│                                         │
│   [ Scan QR Code ]                      │  ← opens camera
│                                         │
└─────────────────────────────────────────┘
```

### Code input UX details

```dart
// 4-segment input, each auto-advances to next:
// Segment 1: "LUNA" — pre-filled, disabled (it's always LUNA)
// Segment 2: 4–6 letters, auto-capitalize
// Segment 3: 4–6 letters, auto-capitalize
// Segment 4: exactly 4 digits

// On each segment fill → HapticFeedback.selectionClick()
// On full fill → HapticFeedback.lightImpact() + auto-validate
// Input displays in Cormorant Garamond for premium feel

// Auto-paste: if clipboard has "LUNA-XXXX-XXXX-0000" format
// → auto-fill all segments on focus with gentle animation
```

### Validation states

```
VALIDATING:
  Spinner inside button
  Code segments pulse with gentle opacity animation
  "Checking..." — DM Sans 13px below input

SUCCESS:
  char_in_love scales up 120% → back to 100% with spring
  Gold shimmer sweeps across the screen
  "Found! [PartnerName] is waiting for you 💕" — Cormorant 22px
  Character swaps to char_excited
  Confirm button: "Connect with [PartnerName] 💕" — goldPrimary gradient

WRONG CODE:
  Input shakes (translateX animation, 3 oscillations)
  HapticFeedback.heavyImpact()
  char_sad fades in
  "That code doesn't seem right. Double-check and try again 🌸"
  No red color — just warm disappointment, not alarm

ALREADY LINKED:
  "This code is already connected to someone else 💙"
  char_warm illustration
  "Ask them to share their code again"

SAME ROLE ERROR:
  (He tries to enter another him's code, or vice versa)
  "This code belongs to someone with the same role.
   Each couple needs one of her and one of him 🌸"

EXPIRED CODE:
  "This code has expired. Ask them to generate a new one
   from Settings → My Love Code → Refresh"
```

### Linking Cloud Function

```typescript
// functions/src/linkPartners.ts

exports.linkPartners = functions.https.onCall(async (data, context) => {
  const { partnerCode } = data;
  const callerId = context.auth?.uid;
  if (!callerId) throw new functions.https.HttpsError('unauthenticated', 'Login required');

  // 1. Find code in /loveCodes/{code}
  const codeDoc = await db.collection('loveCodes').doc(partnerCode).get();
  if (!codeDoc.exists) throw new functions.https.HttpsError('not-found', 'Code not found');

  const codeData = codeDoc.data()!;

  // 2. Check not expired (6 months)
  const createdAt = codeData.createdAt.toDate();
  const sixMonths = 1000 * 60 * 60 * 24 * 180;
  if (Date.now() - createdAt.getTime() > sixMonths) {
    throw new functions.https.HttpsError('deadline-exceeded', 'Code expired');
  }

  // 3. Check not already linked
  if (codeData.linkedUid) {
    throw new functions.https.HttpsError('already-exists', 'Code already used');
  }

  // 4. Get both users, verify opposite roles
  const [callerDoc, partnerDoc] = await Promise.all([
    db.collection('users').doc(callerId).get(),
    db.collection('users').doc(codeData.ownerUid).get(),
  ]);
  const callerRole = callerDoc.data()?.role;
  const partnerRole = partnerDoc.data()?.role;
  if (callerRole === partnerRole) {
    throw new functions.https.HttpsError('invalid-argument', 'Same role conflict');
  }

  // 5. Create coupleId (sorted uid concat)
  const ids = [callerId, codeData.ownerUid].sort();
  const coupleId = ids.join('_');

  // 6. Batch write: link both users + create shared doc + mark code used
  const batch = db.batch();
  batch.update(db.collection('users').doc(callerId), {
    partnerUid: codeData.ownerUid,
    partnerRole,
    partnerDisplayName: partnerDoc.data()?.displayName,
    coupleId,
  });
  batch.update(db.collection('users').doc(codeData.ownerUid), {
    partnerUid: callerId,
    partnerRole: callerRole,
    partnerDisplayName: callerDoc.data()?.displayName,
    coupleId,
  });
  batch.set(db.collection('shared').doc(coupleId), {
    herUid: callerRole === 'her' ? callerId : codeData.ownerUid,
    himUid: callerRole === 'him' ? callerId : codeData.ownerUid,
    linkedAt: admin.firestore.FieldValue.serverTimestamp(),
    daysTogetherStart: admin.firestore.FieldValue.serverTimestamp(),
  });
  batch.update(db.collection('loveCodes').doc(partnerCode), {
    linkedUid: callerId,
    linkedAt: admin.firestore.FieldValue.serverTimestamp(),
  });
  await batch.commit();

  // 7. Send FCM to partner: "Someone connected with your code!"
  // ... (notification send)

  return { success: true, coupleId, partnerName: partnerDoc.data()?.displayName };
});
```

---

## 5. FIREBASE SCHEMA — LOVE CODE LAYER

```
/loveCodes/{code}
  code: "LUNA-ROSE-MOON-4821"
  ownerUid: string
  ownerRole: "her" | "him"
  ownerName: string
  linkedUid: string?           ← null until partner connects
  linkedAt: timestamp?
  createdAt: timestamp
  expiresAt: timestamp         ← createdAt + 6 months
  isActive: bool

/users/{userId}
  ...existing fields...
  role: "her" | "him"          ← set during onboarding
  myLoveCode: string           ← "LUNA-ROSE-MOON-4821" (their own)
  partnerUid: string?
  partnerRole: "her" | "him"?
  partnerDisplayName: string?
  coupleId: string?            ← "{uid1}_{uid2}" sorted
  isLinked: bool               ← quick check flag
  onboardingComplete: bool

/shared/{coupleId}
  herUid: string
  himUid: string
  linkedAt: timestamp
  daysTogetherStart: timestamp ← the date they started counting from
  anniversaryDate: timestamp?  ← can be different from linkedAt
  coupleStreakDays: int
  lastHerLogDate: string?      ← "YYYY-MM-DD"
  lastHimLogDate: string?
  ourSong: {title, artist, url, addedBy}?
  relationshipNickname: string?  ← "my sunshine", "bubs" etc.
```

---

## 6. QR CODE SHARING

### Implementation

```dart
// Use package: qr_flutter (add to pubspec.yaml)
// qr_flutter: ^4.1.0

// lib/features/love_code/presentation/widgets/love_code_qr.dart

QrImageView(
  data: 'luna://connect?code=LUNA-ROSE-MOON-4821&name=Priya',
  version: QrVersions.auto,
  size: 180,
  backgroundColor: Colors.transparent,
  eyeStyle: QrEyeStyle(
    eyeShape: QrEyeShape.square,
    color: AppColors.charcoal,
  ),
  dataModuleStyle: QrDataModuleStyle(
    dataModuleShape: QrDataModuleShape.square,
    color: AppColors.charcoal,
  ),
)
```

### QR Screen

```
Bottom sheet opens from "QR" button on code card:
  Glass bottom sheet, 75% screen height
  Center: QR code on ivory card, 200×200px
  Below: "LUNA-ROSE-MOON-4821" in Cormorant
  Below: "Let them scan this to connect instantly"
  char_in_love peeking from bottom-right corner of QR card

Other side scans with:
  flutter_barcode_scanner or mobile_scanner package
  Deep link: luna://connect?code=LUNA-ROSE-MOON-4821&name=Priya
  → opens code validation screen with code pre-filled
  → shows "Connecting with Priya... 💕" immediately
```

---

## 7. SHARED RELATIONSHIP FEATURES

These live in the "Us" tab (her) and "Us" tab (him). Both contribute, both see.

### SR-1: Days Together Counter

```dart
// /shared/{coupleId}.daysTogetherStart
// Display: big Cormorant number + soft animation

int daysTogether = DateTime.now()
    .difference(daysTogetherStart.toDate()).inDays;

// Hero widget: 72px number, Cormorant Garamond
// Below: "days together 💕"
// Below: "since [formatted start date]"
// Tapping lets them edit the start date (if they want to use first date, not linking date)
```

### SR-2: Couple Streak

```
Both must log on the same calendar day for the streak to count.
Her: any daily log entry counts
Him: his simplified mood log counts

Display:
  "You both logged [X] days in a row"
  Streak fire emoji (animated when new record)
  Best streak shown below: "Your best: [Y] days"

When streak breaks (one didn't log):
  Warm, non-judgmental: "Your streak paused at [X] days. Start fresh today 🌸"
  Option: "Restore streak" → one free pass per month (premium feature idea)

Milestone celebrations:
  7 days:  confetti animation + "A whole week! 🎉"
  14 days: "Two weeks of showing up for each other 💕"
  30 days: "A full month together 💙" + special golden badge
  100 days: cinematic full-screen animation, permanent badge
```

### SR-3: Shared Memory Timeline

```
Both can add. Both can see. Timeline ordered newest-first.

Memory types:
  📸 Photo moment   — Polaroid card, caption in Caveat
  ✍️  Written note  — text card, Caveat font, tinted with poster's role color
  🎵  Song memory   — song card with "because..." note
  📍  Place memory  — location tag + photo
  🏆  Milestone      — special card with emoji, bold Cormorant title

Adding a memory:
  FAB on memories screen → bottom sheet
  Choose type → fill in → saves to /shared/{coupleId}/memories/

Each card shows:
  "Added by [Name]" — small DM Sans 11px, muted
  Date in Cormorant italic
  Role-colored left border (rose = her, blue = him)

Animations:
  New memory added → gentle bloom animation → slides into timeline
  Tap photo → full-screen Polaroid with caption
```

### SR-4: Shared Bucket List

```
"Things to do together" — both add, both check off

List screen:
  Uncompleted items: white card, simple checkbox
  Completed items: strikethrough, mauveSoft background, date completed
  Categories (filterable): Travel · Food · Adventure · Cozy · Big dreams

Adding items:
  Text input + emoji selector + category tag
  Each item shows "added by [Name]"

Completion moment:
  Check it off → confetti burst animation
  Toast: "You did it! Add a memory of this moment? 📸"
  → quick link to add a memory with the bucket list item as caption

Stats card (bottom of screen):
  "[X] of [Y] dreams completed 💕"
  Progress bar in goldMid
```

### SR-5: Relationship Milestones

```
Timeline of special moments in their story.

Pre-seeded suggestions (they confirm/edit/skip):
  🌸 First time we met
  💕 Our first date
  💍 When we became official
  ✈️  First trip together
  🏠  Moving in together (if applicable)
  etc.

Adding:
  They pick from suggestions or write custom
  Date picker (can be in the past)
  Optional photo + caption

Display:
  Vertical timeline with alternating left/right cards
  Date in Cormorant, milestone in DM Sans bold
  Photo thumbnail if added
  Tap → full view

"Next milestone" card:
  If anniversary < 30 days away: shows countdown
  "Your [X]-month anniversary in [Y] days 💕"
```

### SR-6: Our Song

```
Pinned permanently at top of the Us screen.

Setting it:
  Either partner can set it
  Search by song name → links to Spotify/Apple Music URL
  OR manually enter: title, artist
  "Why this song?" — Caveat font, 1-2 lines optional note

Display:
  Gold card at top of Us screen
  Music note icon, song title in Cormorant 20px
  Artist in DM Sans 14px muted
  "Our song 🎵" label in Caveat
  Tap → opens music app link

History: can see "previous songs" — all songs ever set as Our Song
```

### SR-7: Monthly Recap (AI-generated)

```
Every month on the 1st, Claude generates a warm recap.

Context injected:
  - Days together count
  - Both moods across the month (her 9-mood log, his 5-mood log)
  - Memories added that month
  - Milestone celebrated?
  - Couple streak stats
  - Messages sent to each other

Output format (Cormorant italic, warm prose, ~150 words):
  "January was full of quiet moments and shared energy...
   You both showed up for each other 23 days this month.
   Priya was mostly feeling calm and grateful.
   Arjun checked in on her 18 times..."

Displayed as:
  Full-screen card, ivory background, warm paper texture feeling
  Cormorant Garamond italic, 18px
  char_date_night illustration right side
  "Your [Month] Together" title in Cormorant 28px
  Gold divider + both names at bottom: "Priya & Arjun 💕"

Navigation: left/right arrow to see past months
Shareable: screenshot-friendly layout, "Share our recap" button
```

### SR-8: Love Language Tracker

```
A gentle, fun tracker of how they show love.

Setup (first time):
  Both independently answer 5 quick questions
  App calculates their top love language:
    Words of Affirmation / Acts of Service / Receiving Gifts
    Quality Time / Physical Touch

Display on Us screen:
  Two mini cards side by side
  "She feels loved through: Words of Affirmation"
  "He feels loved through: Quality Time"
  char_in_love between them

Practical use:
  Care tip card considers this:
  "She feels most loved through words — a heartfelt message today would go a long way."

Update anytime from Settings → Relationship → Love Languages
```

### SR-9: Relationship Questions Game

```
A new card each day (or on-demand) with a relationship question.
Both answer independently → then see each other's answers.

Question examples:
  "What's one small thing the other does that makes you smile?"
  "Where would you go if you could travel anywhere together?"
  "What's something you've never told them but want to?"
  "Describe your perfect lazy Sunday together."

Flow:
  Card on Us screen: "Today's question 💭"
  Tap → both get a text input (Caveat font)
  After both answer → "They answered! See their response 💕"
  Reveal: side-by-side display, both answers in Caveat
  Save to memory timeline option: "Save this as a memory 📸"

Question bank: 365 unique questions (Claude-generated, categorized by depth)
Categories: Fun / Deep / Dreams / Daily life / Love & connection
```

### SR-10: "Thinking of You" Ping

```
Simplest feature. Most powerful.

She taps a single button → he gets:
  Full-screen rose animation
  "She's thinking of you right now 💙"
  char_in_love full screen, 3s fade in/out

He taps a single button → she gets:
  Full-screen gold animation
  "He's thinking of you right now 💕"
  char_in_love full screen, 3s fade in/out

Design of the button (both apps):
  On home screen, prominent pill button
  "Let them know you're thinking of them 💕"
  One tap — no confirmation, no text needed
  Cooldown: 1 per hour max (prevents spam)

Notification copy (from her to him):
  "She's thinking of you 💙"
  Opens to: full-screen warm animation

In-app history (private to each):
  "You sent a hug 3 days ago"
  "She thought of you 8 hours ago"
```

### SR-11: Couple Mood Board (Shared)

```
A private, beautiful shared moodboard.
Both can add: photos, text quotes, images, colors.

Think: a private Pinterest just for them.

Layout: masonry grid, mixed sizes
Content types:
  📸 Photo from camera/gallery
  💬 Quote or text they love
  🎨 Color (for when they're feeling a vibe)
  🖼️  Saved image from web (URL)

Use cases:
  Trip planning vibes
  Home decor goals
  Dream life collage
  Things that remind them of each other

Each item has: added-by badge (rose/blue dot), date, optional caption
```

---

## 8. NEW FILES TO CREATE

```
lib/
├── features/
│   ├── love_code/                           ← NEW feature folder
│   │   ├── data/
│   │   │   └── love_code_repository.dart
│   │   ├── domain/
│   │   │   └── love_code.dart              ← Freezed model
│   │   ├── presentation/
│   │   │   ├── love_code_screen.dart       ← "Your love code" reveal screen
│   │   │   ├── code_entry_screen.dart      ← Enter partner's code
│   │   │   ├── qr_scanner_screen.dart      ← Scan partner's QR
│   │   │   └── widgets/
│   │   │       ├── love_code_card.dart     ← The beautiful code display
│   │   │       ├── code_reveal_animation.dart  ← Staggered segment reveal
│   │   │       ├── qr_display_widget.dart  ← QR code display
│   │   │       └── partner_found_card.dart ← Success state display
│   │   └── providers/
│   │       └── love_code_provider.dart
│   │
│   ├── onboarding/
│   │   └── pages/
│   │       ├── role_select_page.dart        ← NEW: Her or Him chooser
│   │       ├── her_name_page.dart           ← RENAME from name_page.dart
│   │       ├── him_name_page.dart           ← NEW: name + her name
│   │       ├── him_about_her_page.dart      ← NEW: preferences about her
│   │       ├── love_code_page.dart          ← NEW: code reveal (shared widget, both)
│   │       ├── him_notifications_page.dart  ← NEW: him-specific notification prefs
│   │       ├── him_ready_page.dart          ← NEW: his finale screen
│   │       └── onboarding_router.dart       ← NEW: routes Her vs Him pages
│   │
│   ├── relationship/                        ← NEW (from previous plan)
│   │   ├── data/
│   │   │   └── relationship_repository.dart
│   │   ├── domain/
│   │   │   ├── couple_data.dart
│   │   │   ├── memory.dart
│   │   │   ├── milestone.dart
│   │   │   ├── bucket_list_item.dart
│   │   │   ├── relationship_question.dart
│   │   │   └── love_language.dart
│   │   ├── presentation/
│   │   │   ├── relationship_screen.dart    ← "Us" tab, shared
│   │   │   ├── memory_timeline_screen.dart
│   │   │   ├── add_memory_screen.dart
│   │   │   ├── bucket_list_screen.dart
│   │   │   ├── milestones_screen.dart
│   │   │   ├── monthly_recap_screen.dart
│   │   │   ├── question_of_day_screen.dart
│   │   │   ├── love_language_screen.dart
│   │   │   ├── mood_board_screen.dart
│   │   │   └── widgets/
│   │   │       ├── days_together_hero.dart
│   │   │       ├── couple_streak_card.dart
│   │   │       ├── memory_polaroid_card.dart
│   │   │       ├── milestone_timeline.dart
│   │   │       ├── our_song_card.dart
│   │   │       ├── monthly_recap_card.dart
│   │   │       ├── question_card.dart
│   │   │       ├── love_language_card.dart
│   │   │       ├── thinking_of_you_button.dart
│   │   │       └── mood_board_grid.dart
│   │   └── providers/
│   │       ├── relationship_provider.dart
│   │       ├── memory_provider.dart
│   │       └── question_provider.dart

functions/
├── src/
│   ├── generateLoveCode.ts                  ← NEW Cloud Function
│   ├── linkPartners.ts                      ← NEW Cloud Function
│   └── sendThinkingOfYou.ts                 ← NEW Cloud Function (FCM)
```

---

## 9. BUILD ORDER

### PHASE 0 — Love Code Backend (do first, everything depends on it)

```
0.1  Cloud Functions setup: generateLoveCode.ts
0.2  Cloud Functions: linkPartners.ts with all validation
0.3  Cloud Functions: sendThinkingOfYou.ts (FCM)
0.4  Firebase rules: /loveCodes/ collection rules
0.5  Firebase rules: /shared/{coupleId}/ rules (both partners r/w)
0.6  Test: generate code, link two test accounts, verify shared doc created
```

### PHASE 1 — Role Select + Onboarding Routing

```
1.1  role_select_page.dart (her/him chooser, Page 2 of onboarding)
1.2  onboarding_router.dart (routes to her pages or him pages based on role)
1.3  AppRole set at role selection → stored in Hive before Firebase auth
1.4  Her onboarding pages (Pages 3–7, mostly existing + love code page)
1.5  Him onboarding pages (Pages H1–H6, all new)
1.6  love_code_page.dart (shared widget, adapts to role for colors)
1.7  code_reveal_animation.dart (staggered reveal)
1.8  Test: both onboarding flows complete, role stored correctly
```

### PHASE 2 — Code Entry + Linking

```
2.1  love_code_card.dart (beautiful code display)
2.2  code_entry_screen.dart (4-segment input, auto-advance)
2.3  All validation states (wrong/expired/same-role/already-linked)
2.4  qr_display_widget.dart (qr_flutter package)
2.5  qr_scanner_screen.dart (mobile_scanner package)
2.6  Deep link handling: luna://connect?code=XXXX
2.7  partner_found_card.dart (success animation)
2.8  love_code_repository.dart + love_code_provider.dart
2.9  Test: full link flow both directions (she enters his, he enters hers)
2.10 Test: all error states render correctly
```

### PHASE 3 — Relationship / Us Screen (core shared features)

```
3.1  relationship_repository.dart (reads/writes /shared/{coupleId}/)
3.2  Days together counter (hero widget)
3.3  Couple streak logic + display
3.4  Shared memory timeline + add_memory_screen
3.5  Polaroid card widget
3.6  Milestone timeline
3.7  Our song card
3.8  Bucket list (add, complete, celebrate)
3.9  Relationship screen (assemble all above)
3.10 RelationshipProvider
```

### PHASE 4 — Deeper Relationship Features

```
4.1  Monthly recap (Claude API call with couple context)
4.2  Love language quiz + display
4.3  Question of the day (365 question bank, both answer, reveal)
4.4  Thinking of You ping (button + FCM + full-screen animation)
4.5  Mood board (photo/text/color grid, both contribute)
4.6  All celebration animations (streak milestones, bucket list complete)
```

### PHASE 5 — Polish

```
5.1  "Waiting to connect" state on From Him/Her screens (before code linked)
5.2  Settings → My Love Code (view/share/refresh code)
5.3  Settings → Relationship → edit start date, love languages
5.4  Unlink partner flow (with confirmation + data handling)
5.5  Solo mode — full app works without linking (From Him/Her sections show warm empty states)
```

---

## 10. EDGE CASES + ERROR STATES

### Code system edge cases

```
SOLO MODE (no partner linked yet):
  From Him/Her section: char_hello + "Waiting for [him/her] to connect 🌸"
  Days Together: shows 0 with "Connect with your partner to start counting 💕"
  Us screen: "Your shared space is ready. Share your love code to unlock it 💙"
  All features work except shared ones

BOTH TRY TO ENTER EACH OTHER'S CODE AT SAME TIME:
  Cloud Function handles with Firestore transaction
  First write wins, second gets "Already linked" response
  Both apps refresh: both see linked state

PARTNER UNLINKS:
  Soft delete: shared data stays in Firestore for 30 days
  Both get notification: "[Name] has disconnected from Luna"
  Both apps return to solo mode
  Love codes regenerated (new codes for both if they re-link)
  Option to re-link with new code

TWO HER ACCOUNTS TRY TO LINK:
  Cloud Function rejects: "same role conflict"
  Error: "This code belongs to someone like you. Luna needs one of her and one of him 🌸"

CODE REFRESHED BUT PARTNER TRIES OLD CODE:
  Old code marked expired in /loveCodes/
  Error: "This code has been refreshed. Ask them to share their new one 🌸"

APP DELETED AND REINSTALLED:
  Firebase Auth persists → uid same → code same → link same
  App state restored from Firestore on login

BOTH SIGN UP BUT NEITHER ENTERS A CODE:
  Both in solo mode indefinitely until one enters the other's code
  Reminder nudge in settings: "Connect with your partner ✨"
  No expiry on accounts, only on unlinked codes (6 months)
```

### Onboarding edge cases

```
EXITS ONBOARDING MIDWAY:
  State saved to Hive at each completed page
  On reopen: resumes from last completed page
  Role is saved first (Page 2), so never lost

SKIPS CODE PAGE:
  Code still generated in background (Cloud Function called silently)
  User can share from Settings → My Love Code later
  From Him/Her section shows "waiting" state with gentle prompt

HER TRIES TO ENTER ANOTHER HER'S CODE:
  Same-role error shown
  "Ask him to sign up and share his love code 💙"

HE SIGNS UP FIRST (before her):
  His onboarding Page H4 has: "OR — enter her code instead"
  She can enter her code there
  OR: he waits, shares his code, she signs up and enters his code
  Both flows work

NAME CHANGE AFTER ONBOARDING:
  Settings → Profile → Name
  Updates partnerDisplayName on partner's user doc via Cloud Function
```

---

## LOVE CODE UX COPY — COMPLETE STRINGS

```dart
// lib/core/constants/app_strings_love_code.dart

// Her code screen
static const herCodeTitle         = "Your love code";
static const herCodeSubtitle      = "Share this with him so he can find you";
static const herCodeShareText     = "I made a space for us in Luna. Enter my code:\n{code}\nDownload: {link}";
static const herCodeCopied        = "Copied! Send it to him 💙";
static const herCodeSkip          = "Skip for now, connect later";

// Him code screen
static const himCodeTitle         = "Your love code";
static const himCodeSubtitle      = "Share this with her so she can find you";
static const himCodeShareText     = "I set something up for us in Luna. Enter my code:\n{code}\nDownload: {link}";
static const himCodeCopied        = "Copied! Send it to her 🌸";

// Code entry
static const enterCodeTitle       = "Enter their love code";
static const enterCodeSubtitle    = "They got it when they signed up";
static const enterCodeValidating  = "Checking...";
static const enterCodeSuccess     = "Found! {name} is waiting for you 💕";
static const enterCodeConfirm     = "Connect with {name} 💕";
static const enterCodeWrongCode   = "That code doesn't seem right. Double-check and try again 🌸";
static const enterCodeExpired     = "This code has expired. Ask them to generate a new one in Settings 🌸";
static const enterCodeUsed        = "This code is already connected to someone else 💙";
static const enterCodeSameRole    = "This code belongs to someone with the same role 🌸";

// Waiting state (From Him/Her before linking)
static const herWaitingTitle      = "Waiting for him to connect 🌸";
static const herWaitingSubtitle   = "Share your love code and he'll appear here 💕";
static const himWaitingTitle      = "Waiting for her to connect 💙";
static const himWaitingSubtitle   = "Share your love code and she'll appear here 💕";

// Thinking of you
static const herThinkingOf        = "She's thinking of you right now 💙";
static const himThinkingOf        = "He's thinking of you right now 💕";
static const thinkingCooldown     = "You already sent one recently 💕 Wait a little";
```