# 🌙 LUNA — Agent Master Brief v2
> **Last updated:** May 26, 2026
> **Source files synthesized:** File 1 (Him App Integration Plan) · File 2 (Love Code + Onboarding + Shared) · Agent Update Log (May 26)
> **Purpose:** Single source of truth for all remaining build work. Read this before writing any code.

---

## 📍 CURRENT STATE — WHAT THE AGENT HAS BUILT

Based on the May 26 update log, the following is **complete and working**:

| Module | Status | What Was Built |
|:---|:---:|:---|
| Auth (email login/signup + profile) | ✅ Done | Freezed JSON mapping, relationship fields restored on restart |
| Onboarding (role select + setup flows) | ✅ Done | Her/Him branching, cycle setup for her |
| Love Code generation | ✅ Done | LUNA-WORD-WORD-XXXX format, shown in onboarding |
| QR Code display | ✅ Done | `qr_display_widget.dart` on ivory card |
| QR Code scanning | ✅ Done | `qr_scanner_screen.dart` with custom overlay |
| Partner linking (manual + QR) | ✅ Done | Batch Firestore transaction, atomic, both users updated |
| Deep link `luna://connect` | ✅ Done | Integrated into app router |
| "Us" tab — Days Together + Memories | ✅ Done | Real-time stream from `/shared/{coupleId}` |
| "Us" tab — Bucket List | ✅ Done | Both partners add/complete in real-time |
| Routing (6-tab nav including Us) | ✅ Done | ShellRoute with Us tab added |
| Auth refresh after linking | ✅ Done | `refresh()` method syncs Firestore state |

### ⚠️ Important Architecture Note
The agent added a **6th tab** to the bottom nav (making it 6 items). Per the original spec, the correct nav for **Her** is 5 items and **Him** is a different 5 items. The current 6-tab nav needs to be made **role-aware** as part of the next phase. Do not just add more tabs — replace with role-specific sets.

---

## 🔴 WHAT NEEDS TO BE BUILT NEXT (Priority Order)

### IMMEDIATE — Fix & Foundation
1. **Role-aware bottom nav** — replace 6-tab nav with proper Her(5) / Him(5) sets
2. **AppTheme role-awareness** — `buildTheme(AppRole role, Brightness)` wires up Him's slate blue palette
3. **GoRouter role guards** — `/cycle` → him redirects to `/him/care`; `/him/care` → her redirects to `/cycle`

### PHASE B — Him Home + Care Dashboard (highest UX impact)
4. **HimHomeScreen** — his entire home experience built around her
5. **CareDashboardScreen** — "How She's Doing" in care language
6. **Phase → Care Language utility** — never raw cycle data to him

### PHASE C — From Her (must match From Him quality — cinematic)
7. **FromHerScreen** — full mirror of From Him, blue wax seal
8. **Her write flow** — she composes content for him from her app

### PHASE D — His Personal Space
9. **HimMeScreen** — mood/stress/sleep/journal
10. **Him journal** — AES-256 encrypted, Caveat font, same as hers

### PHASE E — Deepen "Us" Screen
11. **Milestone timeline** — both add, chronological
12. **Our Song card** — either sets, both see
13. **Monthly Recap (AI)** — Claude API, couple context
14. **Love Language quiz** — independent answers, shared display
15. **Question of the Day** — 365 bank, both answer, reveal
16. **Thinking of You ping** — button, FCM, full-screen animation
17. **Couple Mood Board** — private masonry grid

### PHASE F — Her Write Flow (she composes for him)
18. **WriteMessageScreen, RecordVoiceScreen, ScheduleSurpriseScreen, AddSongScreen**
19. **Open When composer** — her labels for him

### PHASE G — Notifications (FCM complete system)
20. **FCM topic structure** — `her_{uid}`, `him_{uid}`, `couple_{coupleId}`
21. **Care-aware notifications** — cramp trigger, mood trigger, streak milestones

### PHASE H — Polish
22. **Dark theme** — him blue palette tested
23. **All empty states** — warm illustrations, never "No data"
24. **Settings** — partner disconnect, love code refresh, love language edit
25. **Solo mode** — app works beautifully before linking

---

## 🏗️ ARCHITECTURE — ONE CODEBASE, TWO ROLES

```
Stack: Flutter · Riverpod (code-gen) · GoRouter · Firebase (Auth + Firestore + Storage + FCM) · Hive (local cache)
```

### AppRole — The Master Switch
```dart
// lib/core/role/app_role.dart
enum AppRole { her, him }

// lib/core/role/role_provider.dart
@riverpod
AppRole appRole(AppRoleRef ref) {
  return ref.watch(authServiceProvider).currentRole;
}
```

**Rule:** Every screen, widget, provider that behaves differently for Her vs Him reads `ref.watch(appRoleProvider)`. No role-specific logic should be hardcoded into widgets directly — always branch through the provider.

### AppUser model fields (existing + additions needed)
```dart
// Already in Firestore from agent's work:
uid, email, displayName, role, myLoveCode,
partnerUid, partnerRole, partnerDisplayName,
coupleId, isLinked, onboardingComplete

// Add these if not already present:
partnerReadEnabled: bool   // she explicitly allows him to see her daily logs
herName: string?           // him stores her name for display throughout his app
himName: string?           // her app uses this in "From Him" header
```

---

## 🎨 DESIGN SYSTEM — COMPLETE SPECIFICATION

### Her Color Tokens (existing — do not modify)
```dart
roseSoft:    #FFE8ED   // card tints
roseMid:     #F0B8C8   // borders
rosePrimary: #D4587A   // CTAs, selected
roseDeep:    #B03060   // pressed states
mauveSoft:   #F5E6F0   // page backgrounds
mauveLight:  #EDD5E8   // section tints
```

### Him Color Tokens (NEW — `him_theme_extension.dart`)
```dart
slateBlueLight:   #EEF1FF   // page backgrounds (replaces mauveSoft)
slateBlueSoft:    #D0D9FF   // card tints (replaces roseSoft)
slateBlueMid:     #A8BBFF   // borders, dividers (replaces roseMid)
slateBluePrimary: #6B8EFF   // primary CTAs (replaces rosePrimary)
slateBlueDeep:    #4A6BE8   // active/pressed (replaces roseDeep)
slateBlueDark:    #2A45B0   // text on light blue bg
```

### Shared Tokens — NEVER CHANGE THESE
```dart
// Gold = love language, identical for both roles
goldSoft:    #FFF8E7
goldMid:     #FFD97D
goldPrimary: #FFB830
goldDeep:    #E09200

// Surfaces
ivory:       #FFFBF7   // card backgrounds
cream:       #FFF5EE   // secondary surfaces
charcoal:    #2D2420   // primary text

// Shadows
// Her:  BoxShadow(color: Color(0x14D4587A), blurRadius: 20, offset: Offset(0, 6))
// Him:  BoxShadow(color: Color(0x146B8EFF), blurRadius: 20, offset: Offset(0, 6))
// Gold: BoxShadow(color: Color(0x26FFB830), blurRadius: 20, offset: Offset(0, 6))
```

### AppTheme Implementation
```dart
// lib/core/theme/app_theme.dart — MODIFY
ThemeData buildTheme(AppRole role, Brightness brightness) {
  final colors = role == AppRole.her ? HerColors() : HimColors();
  return ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme(
      primary: colors.primary,
      secondary: AppColors.goldPrimary,
      surface: AppColors.ivory,
      // ...
    ),
    extensions: [LunaColors(colors: colors)],
    textTheme: _buildTextTheme(),  // same fonts both roles
  );
}

// In app.dart:
MaterialApp.router(
  theme: buildTheme(ref.watch(appRoleProvider), Brightness.light),
  darkTheme: buildTheme(ref.watch(appRoleProvider), Brightness.dark),
)
```

### Typography — both roles identical
```
Cormorant Garamond → emotional display, large numbers, from-partner messages
DM Sans            → body text, labels, subtitles, buttons
Caveat             → "from partner" messages, journal entries, personal notes
```

### Character Illustrations — same assets, different narrative
```
Both roles use: char_hello, char_happy, char_in_love, char_shy, char_excited,
                char_content, char_peaceful, char_tired, char_anxious, char_sad,
                char_warm, char_cozy, char_planning, char_journaling,
                char_meditating, char_productive, char_date_night, char_good_night

Her narrative: "He put this character here for you"
Him narrative: "She made this app and chose these for you"
```

---

## 📱 BOTTOM NAV — ROLE-AWARE (Fix This First)

The current 6-tab nav must be replaced with role-specific 5-tab navs.

### Her (5 tabs)
```dart
[Home 🏠, Cycle 🌙, Garden 🌿, From Him 💌, Me 👤]
routes: [/home, /cycle, /garden, /from-him, /me]
```

### Him (5 tabs)
```dart
[Home 🏠, From Her 💌, Her 💙, Us 👫, Me 👤]
routes: [/him/home, /from-her, /him/care, /us, /him/me]
```

### Implementation
```dart
// lib/core/router/app_router.dart — in ShellRoute builder
final role = ref.watch(appRoleProvider);

NavigationBar(
  destinations: role == AppRole.her
      ? _herDestinations()
      : _himDestinations(),
  onDestinationSelected: (i) {
    final routes = role == AppRole.her
        ? ['/home', '/cycle', '/garden', '/from-him', '/me']
        : ['/him/home', '/from-her', '/him/care', '/us', '/him/me'];
    context.go(routes[i]);
  },
)
```

### Bottom Nav Visual Spec
```
Her: rose-tinted selected indicator, rosePrimary icon color
Him: slate-blue-tinted selected indicator, slateBluePrimary icon color
Both: ivory background, DM Sans 11px labels, 60px height
Selected icon: filled variant; unselected: outlined variant
Active tab indicator: pill shape, 48px wide, 32px tall, 8% opacity primary color
```

---

## 🗺️ COMPLETE ROUTE MAP

### Her Routes (existing — do not break)
```
/home                    → HerHomeScreen
/cycle                   → CycleScreen           [HER ONLY — guard]
/garden                  → MoodGardenScreen       [interactive for her]
/from-him                → FromHimScreen
/from-him/envelope/:id   → EnvelopeOpenScreen
/from-him/gallery        → MemoryGalleryScreen
/from-him/playlist       → PlaylistScreen
/from-him/voice/:id      → VoiceNoteScreen
/me                      → HerMeScreen
/journal                 → HerJournalScreen
/journal/write           → JournalWriteScreen
```

### Him Routes (new — all need building)
```
/him/home                → HimHomeScreen
/from-her                → FromHerScreen
/from-her/envelope/:id   → HerEnvelopeOpenScreen  [blue wax seal]
/from-her/gallery        → HerMemoryGalleryScreen
/from-her/playlist       → HerPlaylistScreen
/from-her/voice/:id      → HerVoiceNoteScreen
/him/care                → CareDashboardScreen     [HIM ONLY — guard]
/him/me                  → HimMeScreen
/him/journal             → HimJournalScreen
/him/journal/write       → HimJournalWriteScreen
/him/write-to-her        → WriteMessageScreen
/him/record-for-her      → RecordVoiceScreen
/him/schedule-surprise   → ScheduleSurpriseScreen
/him/add-song            → AddSongScreen
```

### Shared Routes (both roles — `/us` partially built)
```
/us                      → RelationshipScreen      [partially built]
/us/memories             → MemoryTimelineScreen    [needs building]
/us/memories/add         → AddMemoryScreen         [needs building]
/us/milestones           → MilestonesScreen        [needs building]
/us/bucket-list          → BucketListScreen        [✅ built]
/us/recap                → MonthlyRecapScreen      [needs building]
/us/question             → QuestionOfDayScreen     [needs building]
/us/love-languages       → LoveLanguageScreen      [needs building]
/us/mood-board           → MoodBoardScreen         [needs building]
```

### Onboarding Routes (built — verify completeness)
```
/onboarding/welcome      → WelcomePage
/onboarding/role         → RoleSelectPage          [✅ built]
/onboarding/her/name     → HerNamePage
/onboarding/her/cycle    → CycleSetupPage
/onboarding/her/code     → HerLoveCodePage         [✅ built]
/onboarding/her/notifs   → HerNotificationsPage
/onboarding/her/ready    → HerReadyPage
/onboarding/him/name     → HimNamePage             [needs him name + her name field]
/onboarding/him/about    → HimAboutHerPage
/onboarding/him/code     → HimLoveCodePage         [✅ built]
/onboarding/him/notifs   → HimNotificationsPage
/onboarding/him/ready    → HimReadyPage
/onboarding/code-entry   → CodeEntryScreen         [✅ built]
```

### GoRouter Guards
```dart
// Add to every role-restricted route:
redirect: (context, state) {
  final role = ref.read(appRoleProvider);
  if (state.matchedLocation.startsWith('/cycle') && role == AppRole.him) {
    return '/him/care';
  }
  if (state.matchedLocation.startsWith('/him/care') && role == AppRole.her) {
    return '/cycle';
  }
  if (state.matchedLocation.startsWith('/him/home') && role == AppRole.her) {
    return '/home';
  }
  return null;
}
```

---

## 🔥 FIREBASE SCHEMA — COMPLETE

### `/users/{userId}`
```
uid: string
email: string
displayName: string
role: "her" | "him"
myLoveCode: string                 // "LUNA-ROSE-MOON-4821"
partnerUid: string?
partnerRole: "her" | "him"?
partnerDisplayName: string?        // always use this, never hardcode "him"/"her"
coupleId: string?                  // "{uid1}_{uid2}" alphabetically sorted
isLinked: bool
onboardingComplete: bool
partnerReadEnabled: bool           // she grants him read on her daily logs
herName: string?                   // him stores her first name for his UI copy
createdAt: timestamp
```

### `/loveCodes/{code}`
```
code: string                       // "LUNA-ROSE-MOON-4821"
ownerUid: string
ownerRole: "her" | "him"
ownerName: string
linkedUid: string?
linkedAt: timestamp?
createdAt: timestamp
expiresAt: timestamp               // createdAt + 6 months
isActive: bool
```

### `/fromHim/{userId}/messages/{messageId}` (existing, keep as-is)
```
type: 'text'|'voice'|'photo'|'openWhen'|'playlist'
title: string
content: string?
audioUrl: string?
photoUrl: string?
caption: string?
playlistItems: [{title, artist, url, note}]?
trigger: 'manual'|'scheduled'|'openWhen'
openWhenLabel: string?
scheduledDate: timestamp?
isOpened: bool
openedAt: timestamp?
isActive: bool
sortOrder: int
createdBy: string
```

### `/fromHer/{userId}/messages/{messageId}` (NEW — exact mirror)
Identical schema. `createdBy` = her userId. `userId` = him's uid (he reads it).

### `/fromHer/{userId}/hugs/{hugId}` (NEW)
```
sentAt: timestamp
seenAt: timestamp?
message: string?
```

### `/shared/{coupleId}/` (partially built — add missing fields)
```
herUid: string
himUid: string
linkedAt: timestamp
daysTogetherStart: timestamp       // editable — they may set a different date than linking
anniversaryDate: timestamp?
coupleStreakDays: int
lastHerLogDate: string?            // "YYYY-MM-DD"
lastHimLogDate: string?
ourSong: {title, artist, url, addedBy}?
relationshipNickname: string?
loveLanguages: {her: string?, him: string?}?
```

### `/shared/{coupleId}/memories/{memoryId}`
```
type: 'photo'|'note'|'song'|'place'|'milestone'
date: timestamp
caption: string
photoUrl: string?
songTitle: string?
songArtist: string?
locationName: string?
addedBy: string                    // uid
addedByRole: "her" | "him"
createdAt: timestamp
```

### `/shared/{coupleId}/milestones/{milestoneId}`
```
date: timestamp
label: string
emoji: string
photoUrl: string?
addedBy: string
```

### `/shared/{coupleId}/bucketList/{itemId}` (✅ built — verify schema matches)
```
title: string
emoji: string?
category: 'Travel'|'Food'|'Adventure'|'Cozy'|'BigDreams'
addedBy: string
isCompleted: bool
completedDate: timestamp?
```

### `/shared/{coupleId}/questions/{questionId}`
```
questionText: string
herAnswer: string?
himAnswer: string?
herAnsweredAt: timestamp?
himAnsweredAt: timestamp?
date: string                       // "YYYY-MM-DD" — one question per day
```

### `/users/{userId}/dailyLogs/{YYYY-MM-DD}` (existing — Her logs)
```
date: string
mood: string                       // 9-mood set
symptoms: string[]
hydrationGlasses: int
notes: string?
cyclePhase: string
cycleDay: int
createdAt: timestamp
```

### `/users/{userId}/himDailyLogs/{YYYY-MM-DD}` (NEW)
```
date: string
mood: 'happy'|'stressed'|'tired'|'excited'|'grateful'
stressLevel: int                   // 1–5
sleepHours: double?
sleepQuality: int?                 // 1–5
notes: string?
createdAt: timestamp
```

### `/users/{userId}/himJournalEntries/{id}` (NEW)
```
encryptedContent: string           // AES-256
mood: string
date: timestamp
wordCount: int
createdAt: timestamp
```

---

## 🔐 FIREBASE SECURITY RULES

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {

    // Own data: full access
    match /users/{userId}/{document=**} {
      allow read, write: if request.auth.uid == userId;
    }

    // Love codes: authenticated read (validation), owner write
    match /loveCodes/{code} {
      allow read: if request.auth != null;
      allow write: if request.auth != null
        && resource.data.ownerUid == request.auth.uid;
    }

    // From Him: she reads own, her partner writes
    match /fromHim/{userId}/{document=**} {
      allow read: if request.auth.uid == userId;
      allow write: if request.auth != null
        && get(/databases/$(database)/documents/users/$(userId))
            .data.partnerUid == request.auth.uid;
    }

    // From Her: he reads own, his partner (her) writes
    match /fromHer/{userId}/{document=**} {
      allow read: if request.auth.uid == userId;
      allow write: if request.auth != null
        && get(/databases/$(database)/documents/users/$(userId))
            .data.partnerUid == request.auth.uid;
    }

    // Her daily logs: she owns, partner reads if she enabled it
    match /users/{userId}/dailyLogs/{logId} {
      allow read: if request.auth.uid == userId
        || (request.auth != null
            && get(/databases/$(database)/documents/users/$(userId))
                .data.partnerUid == request.auth.uid
            && get(/databases/$(database)/documents/users/$(userId))
                .data.partnerReadEnabled == true);
      allow write: if request.auth.uid == userId;
    }

    // Shared couple space: both partners full access
    match /shared/{coupleId}/{document=**} {
      allow read, write: if request.auth != null
        && (coupleId.matches(request.auth.uid + '_.*')
            || coupleId.matches('.*_' + request.auth.uid));
    }
  }
}
```

---

## ☁️ CLOUD FUNCTIONS

### 1. `generateLoveCode` (may already be implemented — verify)
```typescript
// Triggered on: user completes role selection
// Input: { role: 'her' | 'him', userId: string, displayName: string }
// Logic: generates unique LUNA-WORD-WORD-XXXX, checks /loveCodes/ for uniqueness
// Writes: /loveCodes/{code} + /users/{userId}.myLoveCode
// Word pools:
//   her: words1=[ROSE,DAWN,SOFT,SILK,PETAL,BLUSH,BLOOM,PEARL]
//        words2=[MOON,MIST,GLOW,HAZE,LACE,DUSK,VEIL,HALO]
//   him: words1=[STAR,WAVE,PINE,STORM,FORGE,TIDE,NORTH,EMBER]
//        words2=[TIDE,CREST,PEAK,VALE,COVE,BLAZE,RIDGE,HAVEN]
```

### 2. `linkPartners` (✅ implemented as batch — verify all validation)
```typescript
// Must check ALL of these before linking:
// ✅ Code exists in /loveCodes/
// ✅ Not expired (createdAt + 6 months)
// ✅ Not already linkedUid set
// ✅ Caller and owner have OPPOSITE roles
// ✅ Caller is not the code owner (can't link to yourself)
// Creates: /shared/{coupleId} with herUid, himUid, linkedAt, daysTogetherStart
// Updates: both /users/{uid} docs atomically
// Returns: { success, coupleId, partnerName }
// Error codes: not-found, deadline-exceeded, already-exists, invalid-argument
```

### 3. `sendThinkingOfYou` (needs building)
```typescript
// Input: { toUid: string, fromRole: 'her'|'him' }
// Validates: 1/hour cooldown per sender (check /shared/{coupleId}/pings/)
// Writes: /shared/{coupleId}/pings/{id} with sentAt, fromUid
// Sends FCM to topic: her_{toUid} or him_{toUid}
```

### 4. `sendHug` (needs building)
```typescript
// Input: { toUid: string, fromRole: 'her'|'him' }
// Writes: /fromHer/{toUid}/hugs/{id} or /fromHim/{toUid}/hugs/{id}
// Sends FCM notification
```

### 5. `onHerDailyLogCreated` (trigger — needs building)
```typescript
// Fires on: new /users/{userId}/dailyLogs/{logId} document
// Reads: user.partnerUid, user.partnerReadEnabled
// If cramps in symptoms → send FCM to him: care notification
// If mood is 'anxious' or 'sad' → send FCM to him: check-in nudge
// If period day 1 detected → send FCM to him: period notification
```

### 6. `onHimDailyLogCreated` (trigger — needs building)
```typescript
// Fires on: new /users/{userId}/himDailyLogs/{logId}
// If stressLevel >= 4 for 3 consecutive days → notification: "She'd want you to rest 💙"
// Update /shared/{coupleId}.lastHimLogDate → triggers streak check
```

### 7. `checkCoupleStreak` (trigger — needs building)
```typescript
// Fires on: /shared/{coupleId} update when lastHerLogDate or lastHimLogDate changes
// Logic: if both logged today → increment coupleStreakDays
// Milestone notifications: 7, 14, 30, 100 days
```

### 8. `updatePartnerDisplayName` (callable — needs building)
```typescript
// Called when user updates displayName in settings
// Updates partnerDisplayName on their partner's user doc
```

---

## 🖥️ HIM HOME SCREEN — FULL SPEC

This is his most important screen. It's built around **her**, not him.

### Visual Structure
```
┌─────────────────────────────────────────────┐
│  PHASE-AWARE ANIMATED SKY (reads HER phase) │
│  ┌──────────────────────────────────────┐   │
│  │  Good morning, [HisName] 💙          │   │ ← Cormorant 28px
│  │  She made this for you               │   │ ← DM Sans italic 14px
│  └──────────────────────────────────────┘   │
├─────────────────────────────────────────────┤
│  GLASS CONTAINER (scrollable cards):         │
│                                              │
│  ┌──────────────────────────────────────┐   │
│  │ 💙 [char matching HER mood] (140px)  │   │ ← HerMoodCard
│  │ "She's feeling calm today"           │   │   IllustratedCard, slateBlueSoft bg
│  │ Follicular · Day 8                   │   │   Tap → CareDashboardScreen
│  └──────────────────────────────────────┘   │
│                                              │
│  ┌──────────────────────────────────────┐   │
│  │ ✨ Care tip for today    [goldSoft]  │   │ ← CareTipCard
│  │ "She'd love a simple 'I'm thinking  │   │   AI-generated, Claude API
│  │  of you' today."                    │   │   "She'd want you to know 💙"
│  └──────────────────────────────────────┘   │
│                                              │
│  ┌──────────────────────────────────────┐   │
│  │ 💌 From Her              [NEW badge] │   │ ← FromHerPeekCard
│  │ "She left something for you ✨"      │   │   Gold background, char_in_love
│  │                           char→      │   │   Tap → FromHerScreen
│  └──────────────────────────────────────┘   │
│                                              │
│  ┌──────────┐  ┌───────────────────────┐   │
│  │🤗 Send   │  │ 💌 Write to her       │   │ ← 2 action buttons
│  │   hug    │  │                       │   │   goldPrimary / slateBlueSoft
│  └──────────┘  └───────────────────────┘   │
│                                              │
│  ┌──────────────────────────────────────┐   │
│  │ 👫 47 days together 💕               │   │ ← Relationship mini-card
│  │ Couple streak: 5 days 🔥             │   │   Tap → /us
│  └──────────────────────────────────────┘   │
│                                              │
│  ┌──────────────────────────────────────┐   │
│  │ 💙 How are YOU today?               │   │ ← HisMoodQuickLog (daily)
│  │ [😊][😰][😴][🤩][🙏]               │   │   5 mood icons, tap to log
│  │  Happy  Stressed Tired Excited Grateful  │
│  └──────────────────────────────────────┘   │
└─────────────────────────────────────────────┘
```

### Phase-Aware Sky Colors (reads HER phase)
```dart
CyclePhase.menstrual  → LinearGradient(#1A1A3E → #2A2060)  // deep midnight blue
CyclePhase.follicular → LinearGradient(#D0D9FF → #A8BBFF)  // soft lavender
CyclePhase.ovulation  → LinearGradient(#6B8EFF → #FFD97D)  // blue to gold
CyclePhase.luteal     → LinearGradient(#3D4FA8 → #6B8EFF)  // deeper blue
// If her phase unknown: LinearGradient(#4A6BE8 → #6B8EFF)  // default him blue
```

### HimHomeRepository — What It Reads
```dart
// 1. Her today's daily log (requires partnerReadEnabled = true)
Stream<DailyLog?> watchHerTodayLog() =>
    firestore.collection('users').doc(partnerUid)
        .collection('dailyLogs').doc(todayKey).snapshots();

// 2. Couple data (streak, days together)
Stream<SharedData> watchSharedData() =>
    firestore.collection('shared').doc(coupleId).snapshots();

// 3. Unread messages in fromHer
Stream<int> watchUnreadFromHer() =>
    firestore.collection('fromHer').doc(uid)
        .collection('messages')
        .where('isOpened', isEqualTo: false)
        .snapshots().map((s) => s.docs.length);
```

---

## 💙 CARE DASHBOARD SCREEN — FULL SPEC

His second tab. Never clinical. Always "here's how to show up for her today."

```
Header: "How she's doing today 💙"
Subheader: "She shared this so you can take care of her"

SECTION 1 — Her Mood (large IllustratedCard)
  char matching her mood, 200px centered
  Mood in warmth language (see moodToCareCopy() below)
  Background: ivory, blue shadow
  If not logged: char_hello + "She hasn't shared yet today 🌸"

SECTION 2 — Her Phase (IllustratedCard, slateBlueSoft)
  Phase name + day in cycle
  Phase in care language (phaseToCareLanguage())
  Phase character illustration (char_cozy for menstrual, char_happy for follicular, etc.)

SECTION 3 — AI Care Tip (goldSoft card)
  Claude API call with:
    - Her phase + day
    - Her mood today
    - Her symptoms (if any)
    - His mood (if logged)
  Output: 2–3 warm sentences, what he can DO today
  Footer: "She'd want you to know this 💙" — Caveat italic 14px

SECTION 4 — Her Symptoms (only if she logged any)
  Warm chip display: "She logged cramps today 💙"
  Action: "Send her a hug" button → triggers hug animation on her phone
  NEVER clinical language

SECTION 5 — Her Self-Care Streak
  "She's been taking care of herself [X] days 🌸"
  char_productive or char_content
  "Send encouragement" → she gets notification: "He's cheering you on 💙"

SECTION 6 — Her Hydration (if she tracks water)
  "[X] of 8 glasses today"
  Animated water fill widget (same as hers)
  "Encourage her" → she gets: "He's cheering you on 💧"

SECTION 7 — Care Actions Grid (2×2)
  💌 Write to her  →  /him/write-to-her
  🤗 Send hug      →  full-screen animation on her device
  🎵 Add song      →  /him/add-song
  📅 Schedule      →  /him/schedule-surprise
```

---

## 🌸 FROM HER SCREEN — FULL SPEC

Must match the cinematic quality of the existing "From Him" screen.

```
HEADER (ivory bg, blue grain texture instead of rose):
  "From [HerName]" — Cormorant Garamond 32px
  "She made all of this for you 💙" — DM Sans 14px italic
  char_in_love: 140px, top-right position

SECTION — Hug Button (same gold as From Him)
  160px circle, gold gradient
  "Tap to feel a hug from her"
  Tap → full-screen bloom animation, char_in_love, "She loves you 💙"
  Gold — SAME GOLD as her hug button. Gold = love, role-independent.

SECTION — Open When Envelopes
  Horizontal scroll or grid, ivory cards
  Blue wax seal (slateBluePrimary) — replaces rose wax seal
  Each envelope: label in DM Sans, Caveat inside
  OPEN ANIMATION: identical to From Him — cinematic, full-screen flap
  char_shy → char_grateful on reveal (same as her app)
  Labels:
    "Open when work is stressful"
    "Open when you miss me"
    "Open when you need confidence"
    "Open when you feel alone"
    "Open when you did something amazing"
    "Open when you can't sleep"
    "Open when you need to smile"

SECTION — Her Voice Notes
  Same waveform playback UI
  Label: "Her voice, for you" — Cormorant italic 18px
  char_warm alongside first unplayed note

SECTION — Her Playlist
  Songs she picked for him
  Each song: title, artist, her "because..." note in Caveat italic
  Play button → deep link to Spotify/Apple Music

SECTION — Memory Photos (from her to him specifically)
  Same Polaroid cards as Her's memory gallery
  Rose-tinted left border (she added these) vs blue-tinted (he added)
  Caption in Caveat font

EMPTY STATE (before she's added anything):
  char_hello, centered, 160px
  "She hasn't left anything here yet — but she will 🌸"
  "Share your love code and she can start writing for you"
```

---

## 👤 HIM ME SCREEN — FULL SPEC

His private space. Warm. Not a productivity tracker.

```
HEADER:
  "Taking care of you, because she asked us to 💙"
  — DM Sans 14px italic, slateBlueDark

CARD 1 — Daily Mood Check-in
  "How are you today, [HisName]?"
  5 mood chips with char thumbnails:
    😊 Happy · 😰 Stressed · 😴 Tired · 🤩 Excited · 🙏 Grateful
  char matching selected mood, 120px, animates in on selection
  Saves to /users/{uid}/himDailyLogs/today

CARD 2 — Stress Tracker
  "How stressed are you today?" — DM Sans 16px
  5 soft circle buttons (1=calm, 5=overwhelmed)
  Selected: slateBluePrimary fill, glow ring
  If 4-5 for 3 days → notification: "She'd want you to rest 💙"

CARD 3 — Sleep Logger
  "How did you sleep?" — Cormorant italic 20px
  Hours slider: 4–10h in 0.5h increments
  Quality: 1-5 star tap (same stars as her app)
  char_good_night on card right

CARD 4 — His Journal
  "Your private space 💙" — Cormorant italic 22px
  Caveat font preview of last entry (truncated, blurred edge)
  char_journaling empty state
  Tap → HimJournalScreen (AES-256 encrypted)
  "Write to her" option inside journal → saves to /fromHim/{herUid}/messages/

CARD 5 — Care Reminders (private)
  His personal reminders — NEVER synced to Firebase
  LocalNotifications only
  Suggested by app: "Her period is in ~2 days"
  He can add custom: "Buy her favorite snacks"
  List shows upcoming, sortable
  Lock icon in card header: "Only you see these 🔒"

CARD 6 — His Stats (weekly)
  Mini summary:
  "This week: 5 check-ins · Avg stress 2.4 · Avg sleep 7.2h"
  "You checked in on her 6 times 💙"
  Tap → full history (future feature)
```

---

## 👫 US SCREEN — FULL SPEC (Deepen Existing)

The existing "Us" tab has Days Together + Memories + Bucket List. Add remaining features.

### Current "Us" Cards (existing) — verify these match spec:
```
Days Together counter — Cormorant 72px number, animated
Couple streak card
Memory timeline (basic)
Bucket list (✅ built)
```

### Add These to "Us" Screen:

#### Our Song Card (goldSoft background)
```
"Our Song 🎵" — Caveat 16px label
Song title — Cormorant 20px
Artist — DM Sans 14px muted
"because..." note — Caveat italic 14px, gold
Tap: opens music link
Either partner sets it from Settings → Relationship
Previous songs history accessible via long-press
```

#### Milestones Timeline
```
Vertical alternating left/right cards
Date: Cormorant italic
Label: DM Sans bold
Photo thumbnail optional
"+ Add milestone" FAB
Pre-populated suggestions: First date · First trip · Official · etc.
Anniversary countdown if < 30 days away
```

#### Love Language Cards (side by side)
```
After both complete the quiz:
  [HerName] — Words of Affirmation 💬
  [HisName] — Quality Time ⏱️
Care tip references this: "She feels loved through words today — tell her something."
```

#### Question of the Day
```
One question card per day (365 question bank)
"Both answer to reveal each other's response"
Both tap card → text input (Caveat font placeholder)
After both answer: side-by-side reveal with spring animation
"Save as memory?" shortcut
```

#### Thinking of You Button
```
Prominent pill button on home and Us screen
"Let her know you're thinking of her 💕"
One tap → she gets full-screen animation
1/hour cooldown → "You already sent one recently 💕"
Him sees: "She felt it 🌸" after she opens it
```

#### Monthly Recap Card (AI)
```
Shows on 1st of month (previous month's recap)
Claude API context: days, both moods, memories, streak stats, milestones
150-word warm narrative, Cormorant Garamond italic 18px
char_date_night right side
"[Month] Together" title
Gold divider + both names: "[HerName] & [HisName] 💕"
Left/right arrows to browse past months
"Share recap" → screenshot-friendly render
```

---

## 🤖 AI INTEGRATION — BOTH ROLES

### Claude API Call Pattern (for Artifacts / in-app features)
```javascript
const response = await fetch("https://api.anthropic.com/v1/messages", {
  method: "POST",
  headers: { "Content-Type": "application/json" },
  body: JSON.stringify({
    model: "claude-sonnet-4-20250514",
    max_tokens: 1000,
    system: buildSystemPrompt(role, context),
    messages: [{ role: "user", content: userPrompt }]
  })
});
```

### Her AI System Prompt (existing — do not change without care)
Focused on her cycle, mood, self-care, personal wellbeing.

### Him AI System Prompt (new)
```
You are a warm, emotionally intelligent companion for [HisName], who deeply
cares about [HerName]. You have access to her cycle phase, mood, and self-care
data with her permission. Your role is to help him take care of her — and
himself — in a warm, personal, non-clinical way.

Her current state:
- Phase: {herPhase} (Day {herCycleDay} of her cycle)
- Mood today: {herMood}
- Symptoms today: {herSymptoms}
- Care note for this phase: {phaseCareNote}

His current state:
- Mood today: {hisMood}
- Stress level: {hisStress}/5

Tone rules:
- Always second person — "you", never "he"
- Reference her as "[HerName]", him as "[HisName]"
- Never give medical advice
- Suggest one concrete care action he can take TODAY
- Keep it warm, brief (3-4 sentences for cards, longer for chat)
- End with something that reminds him she loves him
- Never be clinical. This is love, not a health report.
```

### Monthly Recap Prompt (shared)
```
Generate a warm, ~150-word narrative about [HerName] and [HisName]'s month together.

Data:
- Days together total: {daysTogether}
- Month: {month}
- [HerName]'s most frequent mood: {herTopMood}
- [HisName]'s most frequent mood: {himTopMood}
- Memories added this month: {memoryCount}
- Couple streak days this month: {streakDays}
- Milestones celebrated: {milestones}
- Messages sent to each other: {messageCount}

Format: flowing prose, Cormorant Garamond aesthetic in mind (elegant, warm, literary)
Start with the month name. Reference both names. End with something beautiful.
Do not list facts — weave them into a story.
```

---

## 💬 PHASE → CARE LANGUAGE (Complete Implementation)

```dart
// lib/features/him_care/domain/phase_care_language.dart

String phaseToCareCopy(CyclePhase phase, int dayInPhase) {
  return switch (phase) {
    CyclePhase.menstrual => dayInPhase <= 2
        ? "She might need extra comfort today. Be gentle with her 💙"
        : "Her energy is slowly returning. A check-in would mean a lot.",
    CyclePhase.follicular =>
        "She's feeling more energetic! Great day to plan something fun together.",
    CyclePhase.ovulation =>
        "She's at her brightest this week — she'd love to hear from you.",
    CyclePhase.luteal =>
        "She might feel more sensitive right now. Be extra patient today 💙",
  };
}

String phaseCareAction(CyclePhase phase) {
  return switch (phase) {
    CyclePhase.menstrual  => "Send her a hug — she needs it most now",
    CyclePhase.follicular => "Plan something fun together this week",
    CyclePhase.ovulation  => "Tell her something you love about her",
    CyclePhase.luteal     => "Check in more, ask how she's really doing",
  };
}

// Character to show for each phase (in him's care dashboard):
String phaseChar(CyclePhase phase) => switch (phase) {
  CyclePhase.menstrual  => 'char_cozy',
  CyclePhase.follicular => 'char_happy',
  CyclePhase.ovulation  => 'char_in_love',
  CyclePhase.luteal     => 'char_peaceful',
};
```

## 💙 HER MOOD → WARMTH LANGUAGE (Him's View)

```dart
// lib/features/him_care/domain/mood_care_language.dart

String moodToCareCopy(String mood) {
  return switch (mood) {
    'joyful'   => "She's happy today ☀️",
    'tired'    => "She's a bit tired today 🌙 — a gentle check-in?",
    'anxious'  => "She's feeling anxious. She might need you 💙",
    'sad'      => "She's feeling low. She'd love to hear from you.",
    'content'  => "She's feeling peaceful today 🌸",
    'stressed' => "She's feeling stressed. She'd love your support.",
    'excited'  => "She's excited about something today ✨",
    'grateful' => "She's in a grateful mood 🌸",
    _          => "She's doing her day 💙",
  };
}

// Character to show for her mood (in him's view):
String moodChar(String mood) => switch (mood) {
  'joyful'   => 'char_happy',
  'tired'    => 'char_cozy',
  'anxious'  => 'char_warm',
  'sad'      => 'char_warm',
  'content'  => 'char_peaceful',
  'stressed' => 'char_warm',
  'excited'  => 'char_excited',
  'grateful' => 'char_content',
  _          => 'char_hello',
};
```

---

## 🔔 NOTIFICATIONS — COMPLETE SYSTEM

### FCM Topic Structure
```dart
// Subscribe on login:
FirebaseMessaging.instance.subscribeToTopic('her_${userId}');   // for her
FirebaseMessaging.instance.subscribeToTopic('him_${userId}');   // for him
FirebaseMessaging.instance.subscribeToTopic('couple_${coupleId}'); // both
```

### Him Receives (care-aware, warm copy)
```dart
period_soon:    "💙 Her period starts in ~2 days. Maybe plan something cozy at home? 🏠"
period_day1:    "💙 She started her period today. She might need extra love right now."
she_cramps:     "💙 She logged cramps today. A small check-in would mean a lot."
she_anxious:    "💙 She's feeling anxious today. She'd love to hear from you."
she_low:        "💙 She's low energy today. Be gentle with her."
she_not_logged: "💙 She hasn't logged in 3 days — maybe check on her?"
her_streak_7:   "🌸 She's been taking care of herself 7 days in a row! She'd love your encouragement."
from_her_new:   "💌 She left you something new."
hug_from_her:   "🤗 She's thinking of you — open Luna to feel it."
stress_check:   "💙 You've been stressed 3 days in a row. She'd want you to rest."
her_happy:      "🌸 She's happy today. You probably had something to do with that 💙"
```

### She Receives (from him's actions)
```dart
hug_sent:          "He's thinking of you 💕"    → full-screen hug animation for her
thinking_ping:     "He's thinking of you right now 💙"
new_from_him:      "💌 He left you something new."
msg_opened:        "He opened your message — and it made him smile 💙"
encouragement:     "[Custom message he typed]"
watered_garden:    "He watered your garden today 🌸"
he_happy:          "💙 He's happy today. He probably thought of you."
```

### Both Receive (couple milestones)
```dart
streak_7:    "🔥 7 days of showing up for each other!"
streak_14:   "💕 Two weeks of logging together"
streak_30:   "✨ A whole month — 30 days together"
streak_100:  "💙🌸 100 days. That's everything."
anniversary: "💕 Happy anniversary, [HerName] & [HisName]!"
```

---

## 📦 PACKAGES — pubspec.yaml

```yaml
dependencies:
  # Already added by agent (verify):
  mobile_scanner: ^3.5.0
  qr_flutter: ^4.1.0

  # Add if not present:
  encrypt: ^5.0.1                         # AES-256 for him's journal
  flutter_local_notifications: ^16.0.0   # His private care reminders (NEVER Firebase)
  flutter_secure_storage: ^9.0.0         # Store AES key securely
  cloud_functions: ^4.6.0                # Call Cloud Functions
  cached_network_image: ^3.3.0           # Polaroid photos, memory gallery
  audio_waveforms: ^1.0.5                # Voice note waveform (same as her app)
  image_picker: ^1.0.7                   # Memory photos, mood board
  share_plus: ^7.2.1                     # Share love code, share recap
```

---

## 🔄 COMPLETE ONBOARDING FLOW

```
App Launch → check auth state
    │
    ├─ Logged in + linked     → role-aware home screen
    ├─ Logged in + unlinked   → home screen (solo mode)
    └─ Not logged in          → onboarding

ONBOARDING:
Page 1 — Welcome
  Her version: rose gradient, "A space made just for you 🌸"
  Him version: slate blue gradient, "Made with her in mind 💙"
  (Role is unknown here — show neutral or detect from deep link)
  Bottom: "Already have a code? Connect →"

Page 2 — Role Select (CRITICAL)
  Left card (roseSoft): char_in_love, "I'm her 🌸", "Track my cycle & wellbeing"
  Right card (slateBlueSoft): char_happy, "I'm him 💙", "Take care of her & myself"
  Select → theme switches immediately → routes to appropriate branch
  ┌──────────────────────────────────┬─────────────────────────────────┐
  │ HER BRANCH                       │ HIM BRANCH                      │
  │                                  │                                 │
  │ Page 3: Her Name                 │ Page H2: His Name + Her Name    │
  │   "What should we call you?"     │   Both fields, live preview     │
  │   Live: "Hello, [Name] 🌸"       │   char_in_love when her typed   │
  │                                  │                                 │
  │ Page 4: Cycle Setup              │ Page H3: About Her              │
  │   Last period date               │   Toggle: share cycle info?     │
  │   Cycle length slider (21-45d)   │   Toggle: care notifications?   │
  │   Period length slider (2-10d)   │   "One thing I love about her"  │
  │   char_cozy on date select       │   Encrypted locally, not shared │
  │                                  │                                 │
  │ Page 5: Her Love Code            │ Page H4: His Love Code          │
  │   Staggered reveal animation     │   Same reveal, blue accents     │
  │   Copy / Share / QR buttons      │   Copy / Share / QR buttons     │
  │   "Skip for now" option          │   + inline "Enter her code" box │
  │                                  │                                 │
  │ Page 6: Notifications            │ Page H5: Notifications          │
  │   Period · Hydration · Sleep     │   Period prediction · Mood      │
  │   From Him · Daily log           │   From Her · Care reminders     │
  │   "Written like messages from    │   "Written as gentle nudges 💙" │
  │    him, not system alerts 🌸"    │                                 │
  │                                  │                                 │
  │ Page 7: Ready                    │ Page H6: Ready                  │
  │   His pre-written note on card   │   Her pre-written note on card  │
  │   Caveat font, warm paper card   │   Caveat font, warm paper card  │
  │   "Open Luna 💕" — gold button   │   "Open Luna 💙" — blue button  │
  └──────────────────────────────────┴─────────────────────────────────┘

Solo mode if no code entered:
  → App works fully
  → From Him/Her section shows warm waiting state
  → Us screen shows "Share your code to unlock this space 💕"
  → Settings always shows "My Love Code" to share later
```

---

## 🎨 UI/UX COMPONENT SPECS

### IllustratedCard (shared widget — role-aware color)
```dart
IllustratedCard({
  required String title,
  String? subtitle,
  required String illustrationAsset, // char_*.png
  Color? backgroundColor,            // pass role color
  Color? textColor,
  VoidCallback? onTap,
  Widget? trailing,
})

// Her context: backgroundColor = AppColors.roseSoft
// Him context: backgroundColor = AppColors.slateBlueSoft
// Gold context: backgroundColor = AppColors.goldSoft
```

### GlassCard (for home screens — both roles)
```dart
// Frosted glass effect over the animated sky
Container(
  decoration: BoxDecoration(
    color: Colors.white.withOpacity(0.85),
    borderRadius: BorderRadius.circular(20),
    border: Border.all(color: Colors.white.withOpacity(0.6), width: 1.5),
    boxShadow: [roleShadow(role)],
  ),
  child: BackdropFilter(
    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
    child: content,
  ),
)
```

### HugButton (gold — identical for both roles)
```dart
// 160px circle, goldPrimary gradient, same for Her and Him
// This is intentional — gold = love, role-independent
Container(
  width: 160, height: 160,
  decoration: BoxDecoration(
    shape: BoxShape.circle,
    gradient: LinearGradient(
      colors: [AppColors.goldPrimary, AppColors.goldDeep],
    ),
    boxShadow: [AppColors.goldShadow],
  ),
)
```

### EnvelopeCard (role-aware wax seal color)
```dart
// Her app (From Him): rosePrimary wax seal
// Him app (From Her): slateBluePrimary wax seal
// Same animation, same cinematic quality, different seal color
```

### PolaroidCard (shared component)
```dart
// Role-tinted left border:
//   addedByRole == 'her': Border.left(color: roseSoft, width: 3)
//   addedByRole == 'him': Border.left(color: slateBlueSoft, width: 3)
// Caption: Caveat 14px
// White card, slight rotation (-2deg to +2deg random)
```

### EmptyState (warm — never cold)
```dart
// Always: char illustration (120–160px) + warm message + optional CTA
// Never: plain "No data available"
EmptyState(
  char: 'char_hello',
  message: "She hasn't left anything here yet — but she will 🌸",
  ctaLabel: "Share your code",        // optional
  onCta: () => context.push('/code'), // optional
)
```

---

## 🚨 EDGE CASES — COMPLETE HANDLING GUIDE

| Scenario | Exact Handling |
|:---|:---|
| She hasn't logged mood today | Show `char_hello` + "She hasn't shared yet today 🌸" — never blank |
| `partnerReadEnabled` is false | Same warm empty state everywhere — never show an error |
| He accesses `/cycle` | GoRouter redirect to `/him/care` — silent, instant |
| She accesses `/him/care` | GoRouter redirect to `/cycle` — silent, instant |
| Two Her accounts try to link | Cloud Function rejects with `invalid-argument` → UI: "This code belongs to someone like you 🌸" |
| Two Him accounts try to link | Same as above |
| Code expired (> 6 months) | "This code has expired. Ask them to generate a new one in Settings 🌸" |
| Code already used | "This code is already connected to someone else 💙" |
| Both link simultaneously | Firestore transaction first-write-wins; loser gets "already used" message |
| App deleted + reinstalled | Firebase Auth uid persists → same code → same link → full state restored |
| Partner unlinks | Soft delete 30 days; both get notification; both return to solo mode; new codes generated |
| Couple streak breaks | "Your streak paused at [X] days. Start fresh today 🌸" — never punitive, no shame |
| His stress level 4–5 for 3 days | Local notification: "She'd want you to rest 💙" |
| `partnerDisplayName` null | Fallback to "him" or "her" generically — never blank |
| No couple data yet (before linking) | Us screen: warm illustration + "Share your love code to start your story together 💕" |
| Anniversary within 30 days | Show countdown card on Us screen |
| Monthly recap (no data) | AI generates minimal warm note: "A quiet month — and those count too 💕" |
| Her hasn't set up cycle yet | Care dashboard shows "She hasn't set up her cycle yet 🌸" + no phase widgets |

---

## ✅ CRITICAL DO'S & DON'TS

### ❌ Never Do These
- Show raw cycle data to him — **always translate through `phaseToCareCopy()`**
- Use gray-tinted shadows in him's theme — always blue-tinted
- Let him access her journal — Firestore security rules must block this
- Use `rosePrimary` in him's theme anywhere
- Skip the envelope animation quality — it must be cinematic, matching From Him
- Sync his private care reminders to Firebase — **LocalNotifications only, period**
- Hardcode "From Him" / "From Her" — always `partnerDisplayName` from Firestore
- Display cold "No data" — every empty state has a character and warm copy
- Make couple streak punish missed days — warm and encouraging always
- Show blue wax seal in her app — her app uses rose wax seal
- Skip `role_select_page` — the entire experience depends on role being set correctly
- Use `rosePrimary` as a fallback anywhere in him's app

### ✅ Always Do These
- Him's home sky reads **HER phase color** — he experiences her cycle visually
- Caveat font for **anything "from her"** in his app (mirrors "from him" in hers)
- Gold = love language color for **both roles** — identical gold on hug buttons
- Same character illustrations for both — same assets, different narrative framing
- AI companion for him focuses on **what he can DO today** (not what she feels)
- Every card or screen in him's app ends with warmth — reinforcing her love for him
- `partnerReadEnabled` must be explicitly `true` before him sees any of her data
- Both must **explicitly link** accounts — no automatic linking ever
- His journal: **AES-256 encrypted**, same encryption level as hers
- Empty states: always char illustration + warm message
- Every notification copy feels **personal, warm, from someone who cares** — not system alerts

---

## 📁 COMPLETE FILE LIST — WHAT TO BUILD

### New Files Needed (not yet created by agent)
```
lib/core/theme/him_theme_extension.dart
lib/core/constants/app_strings_him.dart
lib/core/constants/app_strings_love_code.dart   ← verify exists

lib/features/him_home/data/him_home_repository.dart
lib/features/him_home/domain/him_home_state.dart
lib/features/him_home/presentation/him_home_screen.dart
lib/features/him_home/presentation/widgets/her_mood_card.dart
lib/features/him_home/presentation/widgets/her_phase_card.dart
lib/features/him_home/presentation/widgets/care_tip_card.dart
lib/features/him_home/presentation/widgets/from_her_peek_card.dart
lib/features/him_home/presentation/widgets/his_mood_quick_log.dart
lib/features/him_home/providers/him_home_provider.dart

lib/features/from_her/data/from_her_repository.dart
lib/features/from_her/data/from_her_remote_datasource.dart
lib/features/from_her/domain/her_love_message.dart
lib/features/from_her/domain/her_voice_note.dart
lib/features/from_her/domain/her_memory_photo.dart
lib/features/from_her/domain/her_comfort_playlist.dart
lib/features/from_her/presentation/from_her_screen.dart
lib/features/from_her/presentation/her_envelope_open_screen.dart
lib/features/from_her/presentation/her_voice_note_screen.dart
lib/features/from_her/presentation/her_memory_gallery_screen.dart
lib/features/from_her/presentation/her_comfort_playlist_screen.dart
lib/features/from_her/providers/from_her_provider.dart

lib/features/him_care/data/care_dashboard_repository.dart
lib/features/him_care/domain/care_suggestion.dart
lib/features/him_care/domain/partner_status.dart
lib/features/him_care/domain/phase_care_language.dart
lib/features/him_care/domain/mood_care_language.dart
lib/features/him_care/presentation/care_dashboard_screen.dart
lib/features/him_care/presentation/widgets/her_mood_display.dart
lib/features/him_care/presentation/widgets/her_phase_banner.dart
lib/features/him_care/presentation/widgets/care_action_card.dart
lib/features/him_care/presentation/widgets/her_hydration_peek.dart
lib/features/him_care/presentation/widgets/her_streak_display.dart
lib/features/him_care/presentation/widgets/care_suggestion_card.dart
lib/features/him_care/providers/care_dashboard_provider.dart

lib/features/him_me/data/him_log_repository.dart
lib/features/him_me/domain/him_mood.dart
lib/features/him_me/domain/him_daily_log.dart
lib/features/him_me/domain/him_journal_entry.dart
lib/features/him_me/presentation/him_me_screen.dart
lib/features/him_me/presentation/widgets/him_mood_selector.dart
lib/features/him_me/presentation/widgets/him_stress_tracker.dart
lib/features/him_me/presentation/widgets/him_sleep_logger.dart
lib/features/him_me/presentation/widgets/him_journal_card.dart
lib/features/him_me/providers/him_me_provider.dart

lib/features/from_him/presentation/write/write_message_screen.dart
lib/features/from_him/presentation/write/record_voice_screen.dart
lib/features/from_him/presentation/write/schedule_surprise_screen.dart
lib/features/from_him/presentation/write/add_song_screen.dart
lib/features/from_her/presentation/write/write_for_him_screen.dart
lib/features/from_her/presentation/write/record_for_him_screen.dart
lib/features/from_her/presentation/write/open_when_composer_screen.dart

lib/features/relationship/presentation/memory_timeline_screen.dart
lib/features/relationship/presentation/add_memory_screen.dart
lib/features/relationship/presentation/milestones_screen.dart
lib/features/relationship/presentation/monthly_recap_screen.dart
lib/features/relationship/presentation/question_of_day_screen.dart
lib/features/relationship/presentation/love_language_screen.dart
lib/features/relationship/presentation/mood_board_screen.dart
lib/features/relationship/presentation/widgets/our_song_card.dart
lib/features/relationship/presentation/widgets/milestone_timeline.dart
lib/features/relationship/presentation/widgets/monthly_recap_card.dart
lib/features/relationship/presentation/widgets/question_card.dart
lib/features/relationship/presentation/widgets/love_language_card.dart
lib/features/relationship/presentation/widgets/thinking_of_you_button.dart
lib/features/relationship/presentation/widgets/mood_board_grid.dart
lib/features/relationship/providers/memory_provider.dart
lib/features/relationship/providers/question_provider.dart

lib/core/widgets/illustrated_card.dart   ← ensure role-aware color param
lib/core/widgets/glass_card.dart
lib/core/widgets/hug_button.dart         ← gold, same both roles
lib/core/widgets/envelope_card.dart      ← role-aware wax seal
lib/core/widgets/polaroid_card.dart      ← role-tinted border
lib/core/widgets/empty_state.dart        ← warm always

functions/src/generateLoveCode.ts        ← verify exists
functions/src/linkPartners.ts            ← verify complete validation
functions/src/sendThinkingOfYou.ts
functions/src/sendHug.ts
functions/src/onHerDailyLogCreated.ts
functions/src/onHimDailyLogCreated.ts
functions/src/checkCoupleStreak.ts
functions/src/updatePartnerDisplayName.ts
```

### Files to Modify (existing — targeted changes only)
```
lib/core/router/app_router.dart          ← role-aware nav + all new routes + guards
lib/core/router/app_routes.dart          ← add all new route constants
lib/core/theme/app_theme.dart            ← accept AppRole param
lib/features/home/presentation/home_screen.dart  ← route to him/home for him role
lib/features/mood_garden/presentation/mood_garden_screen.dart ← him = view mode + water button
lib/core/services/ai_service.dart        ← role-aware system prompts
lib/core/services/notification_service.dart ← FCM topic subscription
```

---

## 🌟 BONUS FEATURES (Build After Core Is Solid)

1. **Care Mode Quick-Action Widget** — long press → send hug / ping / voice / call, no navigation needed
2. **Period Prep Mode** — 3 days before, UI subtly warmer, more frequent care tips
3. **"She Opened It" Receipts** — him sees in sent view when she reads his message
4. **His Own Streak** — "You've checked in on her 7 days in a row 💙"
5. **Couple Mood Match** — fun daily card: "You're excited, she's calm — a peaceful match ✨"
6. **Anniversary Mode** — cinematic open, confetti, special pre-written message from her
7. **Mood Board** — private masonry grid, both add photos/quotes/colors
8. **Hydration Mirror** — she logs water, he sees "Encourage her" button → she gets notification

---

## 🔗 DEEP LINK HANDLING

```dart
// android/app/src/main/AndroidManifest.xml — intent filter for luna://
// ios/Runner/Info.plist — CFBundleURLSchemes: luna

// In app_router.dart:
GoRoute(
  path: '/connect',
  redirect: (context, state) {
    final code = state.uri.queryParameters['code'];
    if (code != null) return '/onboarding/code-entry?prefill=$code';
    return null;
  },
)

// Share text (auto-filled):
// Her: "I made a space for us in Luna. Enter my code: LUNA-ROSE-MOON-4821 💕"
// Him: "I set something up for us in Luna. Enter my code: LUNA-STAR-TIDE-7743 💙"
// App store link appended automatically
```

---

*This brief synthesizes: File 1 (Him App Integration Plan) + File 2 (Love Code + Onboarding + Shared Features) + Agent Update Log May 26, 2026.*
*Status at brief creation: Auth · Onboarding · Linking · Basic "Us" tab → all complete.*
*Everything else in this document needs building.*

# 🌙 LUNA — Agent Master Brief V3
> **Last updated:** May 26, 2026  
> **Sources:** File 0 (Her Complete Build Plan v2) · File 1 (Him Integration Plan) · File 2 (Love Code + Onboarding + Shared) · Agent Update Log (May 26)  
> **Single source of truth. Read fully before writing any code.**

---

## 📍 EXACT CURRENT STATE — WHAT IS BUILT

Based on the May 26 agent update log, the following is **confirmed complete**:

| Module | Status | Notes |
|:---|:---:|:---|
| Email Auth (login/signup + profile enrichment) | ✅ Done | Freezed JSON mapping, relationship fields |
| Onboarding — role select + her/him branching | ✅ Done | Both flows |
| Love Code generation (LUNA-WORD-WORD-XXXX) | ✅ Done | Shown in onboarding |
| QR code display (`qr_display_widget.dart`) | ✅ Done | Ivory card |
| QR code scanning (`qr_scanner_screen.dart`) | ✅ Done | Custom overlay |
| Partner linking — manual code + QR | ✅ Done | Atomic Firestore batch |
| Deep link `luna://connect` | ✅ Done | In router |
| "Us" tab — Days Together counter | ✅ Done | Real-time Firestore stream |
| "Us" tab — Shared memory timeline (basic) | ✅ Done | Both partners add |
| "Us" tab — Bucket list | ✅ Done | Real-time, both complete |
| Auth refresh after linking | ✅ Done | `refresh()` re-syncs state |
| Routing (currently 6-tab nav) | ⚠️ Fix needed | Must become role-aware 5+5 |

### ⚠️ Critical Fix Before Anything Else
The agent built a 6-tab bottom nav. The spec requires **Her = 5 tabs, Him = 5 different tabs**. This must be fixed first — everything else branches from role-aware navigation.

---

## 🧭 THE GOLDEN RULE (Both Roles)

> **Her:** *"Someone who truly cares about me made this for me."*  
> **Him:** *"She made this for me because she loves me — and it helps me take care of her."*

Every screen, widget, empty state, and notification must feel like this. If it feels clinical, cold, or generic — rebuild it.

---

## 🏗️ ARCHITECTURE — ONE CODEBASE, TWO ROLES

**Stack:** Flutter · Riverpod (code-gen) · GoRouter · Firebase (Auth + Firestore + Storage + FCM) · Hive · Drift

### AppRole — The Master Switch
```dart
// lib/core/role/app_role.dart
enum AppRole { her, him }

// lib/core/role/role_provider.dart
@riverpod
AppRole appRole(AppRoleRef ref) {
  return ref.watch(authServiceProvider).currentRole;
}
```

**Rule:** Every screen/widget/provider that behaves differently reads `ref.watch(appRoleProvider)`. No role logic hardcoded in widgets — always through the provider.

### Layer Pattern (every feature)
```
Presentation  →  AsyncNotifier + Widgets + Pages
     ↓ calls
Domain        →  Freezed models + Repository interfaces
     ↓ implemented by
Data          →  Repository impl + Remote DS (Firebase) + Local DS (Drift/Hive)
     ↓ uses
Core          →  Firebase services · AI service · Encryption · Notifications · Role
```

### AppUser Model — Required Fields
```dart
// Firestore: /users/{userId}
uid: string
email: string
displayName: string
role: "her" | "him"
myLoveCode: string              // "LUNA-ROSE-MOON-4821"
partnerUid: string?
partnerRole: "her" | "him"?
partnerDisplayName: string?     // ALWAYS use this — never hardcode "him"/"her"
coupleId: string?               // "{uid1}_{uid2}" alphabetically sorted
isLinked: bool
onboardingComplete: bool
partnerReadEnabled: bool        // She explicitly allows him to read her daily logs
cycleAverageLength: int         // default 28
periodAverageLength: int        // default 5
notificationsEnabled: bool
appLockEnabled: bool
themeMode: 'light' | 'dark' | 'auto'
createdAt: timestamp
```

---

## 🎨 DESIGN SYSTEM — COMPLETE (Both Roles)

### 🌸 Her Color Tokens (existing — do not modify)
```dart
roseLight:    #FFF0F3   // page backgrounds
roseSoft:     #FFD6DE   // card tints, chip backgrounds
roseMid:      #FFB3C1   // borders, dividers
rosePrimary:  #FF6B8A   // CTAs, selected states, icons
roseDeep:     #E84D6F   // active/pressed
roseDark:     #B5294B   // text on light rose
mauveSoft:    #F5EEF8
mauveMid:     #D7A8E0
mauvePrimary: #B36CC8
mauveDeep:    #8B3FA8
```

### 💙 Him Color Tokens (new — `him_theme_extension.dart`)
```dart
// Him replaces rose with slate blue as the lead color
// Every place Her uses rosePrimary → Him uses slateBluePrimary
// Every place Her uses roseSoft → Him uses slateBlueSoft
// And so on — it's a 1:1 palette swap on the role color only

slateBlueLight:   #EEF1FF   // page backgrounds  (≈ roseLight)
slateBlueSoft:    #D0D9FF   // card tints         (≈ roseSoft)
slateBlueMid:     #A8BBFF   // borders, dividers  (≈ roseMid)
slateBluePrimary: #6B8EFF   // CTAs, selected     (≈ rosePrimary)
slateBlueDeep:    #4A6BE8   // active/pressed     (≈ roseDeep)
slateBlueDark:    #2A45B0   // text on light blue (≈ roseDark)
navySoft:         #E8ECFF   // (≈ mauveSoft)
navyMid:          #8FA8FF   // (≈ mauveMid)
navyPrimary:      #4A6BE8   // (≈ mauvePrimary)
navyDeep:         #2A45B0   // (≈ mauveDeep)
```

### 💛 Shared Tokens — IDENTICAL FOR BOTH ROLES (never change)
```dart
// Gold = love language. Same for Her and Him. Always.
goldSoft:    #FFF8E7
goldMid:     #FFD97D
goldPrimary: #FFB830
goldDeep:    #E09200

// Surfaces — identical both roles
ivory:       #FFFBF7
cream:       #FFF5EE
warmGray100: #F7F0EC
warmGray400: #BFB0A8
warmGray600: #8C7D76
warmGray800: #4A3D38
charcoal:    #2D2420

// Semantic — identical both roles
success:     #6DBF8A
warning:     #FFB347
error:       #FF6B6B

// Dark theme
darkBackground: #1A0F14
darkSurface:    #2D1B26
darkCard:       #3D2535
```

### AppTheme Implementation
```dart
// lib/core/theme/app_theme.dart — MODIFY to accept AppRole
ThemeData buildTheme(AppRole role, Brightness brightness) {
  final colors = role == AppRole.her ? HerColors() : HimColors();
  return ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme(
      primary: colors.primary,        // rosePrimary or slateBluePrimary
      secondary: AppColors.goldPrimary, // same for both
      surface: AppColors.ivory,
      brightness: brightness,
    ),
    extensions: [LunaColors(colors: colors)],
    textTheme: _buildTextTheme(),     // identical fonts both roles
  );
}

// In app.dart:
MaterialApp.router(
  theme: buildTheme(ref.watch(appRoleProvider), Brightness.light),
  darkTheme: buildTheme(ref.watch(appRoleProvider), Brightness.dark),
)
```

### Shadows — Role-Tinted (never gray)
```dart
// Her: rose-tinted
cardShadow:     BoxShadow(color: Color(0x14FF6B8A), blurRadius: 20, offset: Offset(0,6))
elevatedShadow: BoxShadow(color: Color(0x1EFF6B8A), blurRadius: 32, offset: Offset(0,12), spreadRadius: -4)
subtleShadow:   BoxShadow(color: Color(0x0AFF6B8A), blurRadius: 10, offset: Offset(0,2))

// Him: blue-tinted (same structure, different color)
cardShadow:     BoxShadow(color: Color(0x146B8EFF), blurRadius: 20, offset: Offset(0,6))
elevatedShadow: BoxShadow(color: Color(0x1E6B8EFF), blurRadius: 32, offset: Offset(0,12), spreadRadius: -4)
subtleShadow:   BoxShadow(color: Color(0x0A6B8EFF), blurRadius: 10, offset: Offset(0,2))

// Gold: same for both
goldShadow:     BoxShadow(color: Color(0x26FFB830), blurRadius: 20, offset: Offset(0,6))
```

### Typography — Identical Both Roles
```dart
// Fonts: Cormorant Garamond · DM Sans · Caveat
displayLarge:  CormorantGaramond, 40px, w300, letterSpacing -0.5
displayMedium: CormorantGaramond, 32px, w400
headlineLarge: CormorantGaramond, 26px, w500
headlineMed:   CormorantGaramond, 22px, w400  // italic for emotional moments
titleLarge:    DMSans, 18px, w500
titleMedium:   DMSans, 16px, w500
bodyLarge:     DMSans, 16px, w400, height 1.6
bodyMedium:    DMSans, 14px, w400, height 1.5
bodySmall:     DMSans, 12px, w400, height 1.4
labelMedium:   DMSans, 13px, w500, letterSpacing 0.2
handwritten:   Caveat, 18px, w400, height 1.5   // "from partner" messages
handwrittenSm: Caveat, 15px, w400, height 1.4
handwrittenLg: Caveat, 24px, w600, height 1.3   // big emotional moments
```

### Spacing & Radius — Identical Both Roles
```dart
// Spacing: xs=4, sm=8, md=12, lg=16, xl=24, xxl=32, xxxl=48
// Radius:  sm=8, md=12, lg=16, xl=24, card=20, pill=100
```

---

## 🎭 CHARACTER ILLUSTRATION SYSTEM

Same `char_*.png` asset set for **both roles**. Narrative differs:
- Her app: *"He put this character here for you"*
- Him app: *"She made this app and chose these for you"*

### Full Asset List (`assets/illustrations/`)
```
Emotional (+): char_happy, char_in_love, char_laughing, char_excited, char_shy,
               char_grateful, char_warm, char_hello, char_cheerful
Calm/Rest:     char_tired, char_sleepy, char_waking_up, char_cozy, char_relaxed,
               char_peaceful, char_meditating, char_deep_breath, char_content
Difficult:     char_sad, char_crying, char_anxious, char_stressed, char_overwhelmed,
               char_angry, char_frustrated, char_irritated, char_disappointed
Physical:      char_in_pain, char_cramps, char_bloating, char_headache, char_back_pain,
               char_nauseous, char_dizzy, char_feverish, char_low_energy
Activities:    char_studying, char_working, char_focused, char_planning, char_productive,
               char_creative, char_cooking, char_baking, char_cleaning
Self-care:     char_self_care, char_skin_care, char_hair_care, char_bath_time, char_spa_day,
               char_journaling, char_reading, char_music_time, char_movie_time
Special:       char_rainy_day, char_sunny_day, char_nature_love, char_traveling,
               char_beach_day, char_festival, char_party_time, char_date_night, char_good_night
```

### Mapping Logic (`lib/core/constants/app_illustrations.dart`)
```dart
static String forMood(String mood) => switch (mood) {
  'joyful'    => happy,    'calm'      => peaceful,  'tired'     => tired,
  'anxious'   => anxious,  'sad'       => sad,        'irritable' => irritated,
  'excited'   => excited,  'grateful'  => grateful,   'content'   => content,
  'cozy'      => cozy,     'crying'    => crying,     'stressed'  => stressed,
  // Him's 5 moods:
  'happy'     => happy,    'stressed'  => stressed,
  _           => hello,
};

static String forCyclePhase(String phase) => switch (phase) {
  'menstrual'  => cozy,      'follicular' => wakingUp,
  'ovulation'  => excited,   'luteal'     => deepBreath,
  _            => hello,
};

static String forSymptom(String symptom) => switch (symptom) {
  'cramps'   => cramps,   'headache' => headache,  'backPain' => backPain,
  'bloating' => bloating, 'nausea'   => nauseous,  'fatigue'  => lowEnergy,
  'dizzy'    => dizzy,    'fever'    => feverish,  _          => inPain,
};

static String forSelfCare(String activity) => switch (activity) {
  'bath'       => bathTime,    'skincare'   => skinCare,
  'meditation' => meditating,  'music'      => musicTime,
  'journal'    => journaling,  'reading'    => reading,
  'spa'        => spaDay,      _            => selfCare,
};
```

### Him's Character Mapping (when displaying HER data for him)
```dart
// Phase characters (him sees her phase in care language)
static String forHerPhaseInHisApp(String phase) => switch (phase) {
  'menstrual'  => cozy,      // she needs comfort
  'follicular' => happy,     // she's energetic
  'ovulation'  => inLove,    // she's at her brightest
  'luteal'     => peaceful,  // she needs patience
  _            => hello,
};

// Her mood characters (him sees her mood in care language)
static String forHerMoodInHisApp(String mood) => switch (mood) {
  'joyful'   => happy,    'calm'    => peaceful, 'tired'   => cozy,
  'anxious'  => warm,     'sad'     => warm,     'excited' => excited,
  'grateful' => grateful, 'content' => content,  'stressed' => warm,
  _          => hello,
};
```

---

## 📱 BOTTOM NAV — ROLE-AWARE (Fix This First)

### Her (5 tabs — existing structure, verify correct)
```dart
Tab 0: Home      → /home        Icon: Icons.home_outlined / home (filled)
Tab 1: Cycle     → /cycle       Icon: Icons.calendar_month_outlined / calendar_month
Tab 2: Garden    → /garden      Icon: Icons.local_florist_outlined / local_florist
Tab 3: From Him  → /from-him    Icon: Icons.mail_outlined / mail
Tab 4: Me        → /me          Icon: Icons.person_outlined / person
```

### Him (5 tabs — new, must match Her's layout quality exactly)
```dart
Tab 0: Home      → /him/home    Icon: Icons.home_outlined / home (filled)
Tab 1: From Her  → /from-her    Icon: Icons.mail_outlined / mail
Tab 2: Her       → /him/care    Icon: Icons.favorite_outlined / favorite
Tab 3: Us        → /us          Icon: Icons.people_outlined / people
Tab 4: Me        → /him/me      Icon: Icons.person_outlined / person
```

### Implementation
```dart
// lib/core/router/app_router.dart — in ShellRoute builder
final role = ref.watch(appRoleProvider);
final isHer = role == AppRole.her;

NavigationBar(
  backgroundColor: AppColors.ivory,
  indicatorColor: (isHer ? AppColors.rosePrimary : AppColors.slateBluePrimary)
      .withOpacity(0.12),
  selectedIndex: _selectedIndex(state.uri.path, isHer),
  destinations: isHer ? _herDestinations() : _himDestinations(),
  onDestinationSelected: (i) => context.go(
    isHer
        ? ['/home', '/cycle', '/garden', '/from-him', '/me'][i]
        : ['/him/home', '/from-her', '/him/care', '/us', '/him/me'][i],
  ),
)
```

### Nav Visual Spec
```
Background:  AppColors.ivory (#FFFBF7)
Height:      64px
Top shadow:  role cardShadow (very subtle, upward)
Selected icon + label color: rosePrimary (her) or slateBluePrimary (him)
Unselected:  warmGray400
Indicator:   pill shape, 48px wide, 32px tall, 8% opacity of role primary color
Label:       DM Sans 11px, w500
Icon size:   24px
Filled icon: selected state; outlined: unselected state
```

---

## 🗺️ COMPLETE ROUTE MAP

### Her Routes (do not break)
```
/home                   → HerHomeScreen
/cycle                  → CycleScreen              [HER ONLY — guard]
/garden                 → MoodGardenScreen          [interactive for her]
/from-him               → FromHimScreen
/from-him/envelope/:id  → EnvelopeOpenScreen
/from-him/gallery       → MemoryGalleryScreen
/from-him/playlist      → ComfortPlaylistScreen
/from-him/voice/:id     → VoiceNoteScreen
/me                     → HerMeScreen
/journal                → JournalScreen
/journal/write          → JournalEntryScreen
/self-care              → SelfCareScreen
/companion              → AiCompanionScreen
/insights               → InsightsScreen
/settings               → SettingsScreen
/settings/app-lock      → AppLockScreen
/daily-log/:date        → DailyLogScreen
```

### Him Routes (build in Phase B onwards)
```
/him/home                → HimHomeScreen
/from-her                → FromHerScreen
/from-her/envelope/:id   → HerEnvelopeOpenScreen   [blue wax seal]
/from-her/gallery        → HerMemoryGalleryScreen
/from-her/playlist       → HerPlaylistScreen
/from-her/voice/:id      → HerVoiceNoteScreen
/him/care                → CareDashboardScreen      [HIM ONLY — guard]
/him/me                  → HimMeScreen
/him/journal             → HimJournalScreen
/him/journal/write       → HimJournalWriteScreen
/him/write-to-her        → WriteMessageScreen
/him/record-for-her      → RecordVoiceScreen
/him/schedule-surprise   → ScheduleSurpriseScreen
/him/add-song            → AddSongScreen
/him/self-care           → HimSelfCareScreen
/him/companion           → HimCompanionScreen
/him/insights            → HimInsightsScreen
/him/settings            → HimSettingsScreen
```

### Shared Routes (both roles — /us partially built)
```
/us                      → RelationshipScreen       [partially built]
/us/memories             → MemoryTimelineScreen     [build next]
/us/memories/add         → AddMemoryScreen
/us/milestones           → MilestonesScreen
/us/bucket-list          → BucketListScreen         [✅ built]
/us/recap                → MonthlyRecapScreen
/us/question             → QuestionOfDayScreen
/us/love-languages       → LoveLanguageScreen
/us/mood-board           → MoodBoardScreen
```

### Onboarding Routes (verify completeness)
```
/onboarding/welcome          → WelcomePage
/onboarding/role             → RoleSelectPage        [✅ built]
/onboarding/her/name         → HerNamePage
/onboarding/her/cycle        → CycleSetupPage
/onboarding/her/code         → HerLoveCodePage       [✅ built]
/onboarding/her/notifs       → HerNotificationsPage
/onboarding/her/ready        → HerReadyPage
/onboarding/him/name         → HimNamePage           [needs: his name + her name fields]
/onboarding/him/about        → HimAboutHerPage
/onboarding/him/code         → HimLoveCodePage       [✅ built]
/onboarding/him/notifs       → HimNotificationsPage
/onboarding/him/ready        → HimReadyPage
/onboarding/code-entry       → CodeEntryScreen       [✅ built]
```

### GoRouter Guards
```dart
redirect: (context, state) {
  final role = ref.read(appRoleProvider);
  // Her-only routes
  if (state.matchedLocation.startsWith('/cycle') && role == AppRole.him)
    return '/him/care';
  if (state.matchedLocation.startsWith('/garden') && role == AppRole.him)
    return '/garden'; // him gets view-only mode — no redirect, just read-only flag
  // Him-only routes
  if (state.matchedLocation.startsWith('/him/care') && role == AppRole.her)
    return '/cycle';
  if (state.matchedLocation.startsWith('/him/home') && role == AppRole.her)
    return '/home';
  return null;
},
```

---

## 🖥️ SCREEN LAYOUT PARITY — HER vs HIM

**The Him app must match Her's layout structure exactly.** Same visual hierarchy, same component types, different colors and content. Think of it as a theme swap + content swap, not a redesign.

### Home Screen Structure (both roles — identical layout)
```
LAYER 1 (bottom): Full-bleed animated sky gradient (phase-aware)
LAYER 2:          FloatingParticles (role color)
LAYER 3:          Status bar (transparent)
LAYER 4 (top):    Greeting + avatar bar
LAYER 5:          Phase hero area (45% screen height) — IllustratedCard
LAYER 6:          Glassmorphism pull-up container (overlaps hero by ~60%)
LAYER 7 (scroll): Cards inside glass container

Her sky colors: rose/mauve/gold (cycle phase)
Him sky colors: slate blue tones (reads HER phase — he sees her world)
```

### Her Home Cards vs Him Home Cards
```
POSITION | HER CARD                           | HIM CARD
---------|------------------------------------|---------------------------------
Card 1   | Today Status (her mood + char)     | Her Mood Card (her char + warmth copy)
Card 2   | Period Countdown                   | Phase Care Tip (goldSoft, AI-generated)
Card 3   | From Him Peek ⭐                   | From Her Peek ⭐ (gold, char_in_love)
Card 4   | Wellness Quick Row (💧 😴)          | Care Actions Row (🤗 💌)
Card 5   | Self-care suggestion               | Days Together + Couple Streak
Card 6   | —                                  | His Quick Mood Log (5 moods)
```

### Her Phase Hero vs Him Phase Hero
```
HER:  Sky reads HER phase → shows HER phase character → "Follicular Phase · Day 8"
HIM:  Sky reads HER phase → shows HER phase character → "She's in follicular · Day 8"
      Both see the same phase, different framing
      Him: "She's full of energy this week" (care language)
      Her: "Day 8 — energy rising" (personal language)
```

### Phase-Aware Sky Colors
```dart
// HER HOME (her own phase)               // HIM HOME (her phase, his palette)
menstrual:  #E84D6F → #8B1A3C            #1A1A3E → #2A2060  (deep midnight blue)
follicular: #FFD6C0 → #FFB3C1            #D0D9FF → #A8BBFF  (soft lavender)
ovulation:  #FFD97D → #FFB347            #6B8EFF → #FFD97D  (blue to gold)
luteal:     #D7A8E0 → #B36CC8            #3D4FA8 → #6B8EFF  (deeper blue)
unknown:    rosePrimary gradient          slateBluePrimary gradient
```

---

## 💙 HIM HOME SCREEN — COMPLETE SPEC

### Visual Layout
```
┌──────────────────────────────────────────┐
│  PHASE-AWARE SKY (reads HER phase)       │  ← animated gradient, 45% height
│  ┌────────────────────────────────────┐  │
│  │ 💙 Good morning, [HisName]         │  │  Cormorant Garamond 28px, white
│  │    She made this for you 💙        │  │  DM Sans italic 14px, white 80%
│  │                    [char 160px→]   │  │  char = forHerPhaseInHisApp()
│  └────────────────────────────────────┘  │
│ ┌──────────────────────────────────────┐ │  ← Glassmorphism pull-up container
│ │                                      │ │     white 85% + blur 20px
│ │  ┌────────────────────────────────┐  │ │
│ │  │ Her Mood Card   [slateBlueSoft]│  │ │  IllustratedCard
│ │  │ [char matching HER mood] 120px │  │ │  "She's feeling calm today ☀️"
│ │  │ Follicular · Day 8             │  │ │  Tap → CareDashboardScreen
│ │  └────────────────────────────────┘  │ │
│ │                                      │ │
│ │  ┌────────────────────────────────┐  │ │
│ │  │ Care Tip       [goldSoft bg]   │  │ │  AI-generated, 2-3 sentences
│ │  │ "A simple 'I'm thinking of     │  │ │  Claude API, him-context prompt
│ │  │  you' today would mean a lot." │  │ │  Footer: "She'd want you to know 💙"
│ │  └────────────────────────────────┘  │ │     Caveat italic 13px
│ │                                      │ │
│ │  ┌────────────────────────────────┐  │ │
│ │  │ From Her Peek  [gold bg]  NEW● │  │ │  Gold gradient background
│ │  │ "She left something for you ✨" │  │ │  char_in_love 80px right
│ │  │                  [char_in_love]│  │ │  Tap → /from-her
│ │  └────────────────────────────────┘  │ │
│ │                                      │ │
│ │  ┌─────────────┐  ┌──────────────┐  │ │
│ │  │ 🤗 Send hug │  │ 💌 Write her │  │ │  goldPrimary / slateBlueSoft
│ │  └─────────────┘  └──────────────┘  │ │
│ │                                      │ │
│ │  ┌────────────────────────────────┐  │ │
│ │  │ 👫 47 days together 💕         │  │ │  Relationship card
│ │  │ Couple streak: 5 days 🔥        │  │ │  Tap → /us
│ │  └────────────────────────────────┘  │ │
│ │                                      │ │
│ │  ┌────────────────────────────────┐  │ │
│ │  │ 💙 How are YOU today, [Name]?  │  │ │  HisMoodQuickLog
│ │  │ [😊Happy][😰Stressed][😴Tired] │  │ │  5-mood daily check-in
│ │  │ [🤩Excited][🙏Grateful]        │  │ │  Saves to himDailyLogs
│ │  └────────────────────────────────┘  │ │
│ └──────────────────────────────────────┘ │
└──────────────────────────────────────────┘
```

---

## 💙 CARE DASHBOARD — "HER" TAB (Him Only)

Never clinical. Always: *"Here's how to show up for her today."*

```
Header:    "How she's doing today 💙" — Cormorant 28px
Subheader: "She shared this so you can take care of her" — DM Sans 14px italic

SECTION 1 — Her Mood (large IllustratedCard, slateBlueSoft bg)
  char = forHerMoodInHisApp(herMood), 200px centered
  Title: moodToCareCopy(herMood)
  Background: ivory, blue shadow
  If not logged + partnerReadEnabled=false: char_hello +
    "She hasn't shared yet today 🌸" + "She controls what she shares"
  If not logged + partnerReadEnabled=true: char_hello +
    "She hasn't logged today yet 🌸"

SECTION 2 — Her Phase (IllustratedCard, slateBlueSoft)
  Phase name + day + phaseCareLanguage
  char = forHerPhaseInHisApp(phase), 120px
  "She's in [Phase] — [phaseCareLanguage]"

SECTION 3 — AI Care Tip (goldSoft card)
  Claude API: phase + mood + symptoms + his mood → 2-3 sentences
  What HE can DO today, not what she feels
  Footer: "She'd want you to know this 💙" — Caveat italic 14px

SECTION 4 — Her Symptoms (only if she logged any today)
  Warm chips: "She logged cramps today 💙"
  Action: [Send her a hug] → triggers hug animation on her phone
  Never clinical. Warm chips, not medical tags.

SECTION 5 — Her Self-Care Streak
  "She's been taking care of herself [X] days 🌸"
  char_productive, 80px
  [Send encouragement] → she gets: "He's cheering you on 💙"

SECTION 6 — Her Hydration (if partnerReadEnabled and she tracks water)
  "[X] of 8 glasses today" — animated water fill (same widget as hers)
  [Encourage her] → she gets notification: "He's cheering you on 💧"

SECTION 7 — Care Actions Grid (2×2)
  [💌 Write to her]  [🤗 Send hug]
  [🎵 Add song]      [📅 Schedule]
```

---

## 💌 FROM HER SCREEN — COMPLETE SPEC

Must match the cinematic quality of From Him screen exactly. **Same layout, same quality, blue accents.**

```
HEADER (ivory bg, blue grain texture instead of rose grain):
  "From [HerName]" — Cormorant Garamond 32px
  "She made all of this for you 💙" — DM Sans 14px italic, warmGray600
  char_in_love: 140px, top-right, slightly overflowing header
  Background: warm ivory + subtle blue grain

HUG BUTTON (gold — IDENTICAL to Her's hug button):
  160px circle, gold gradient (goldSoft → goldPrimary)
  Center: heart icon, pulse animation (1.0 → 1.1 → 1.0, 2s loop)
  Label: "Tap to feel a hug from her" — DM Sans 14px
  On tap → HugAnimation fullscreen (same gold wash, same warmth)
  Note: Gold is love language — identical for both roles. Never blue.

OPEN WHEN ENVELOPES (horizontal scroll, same layout as From Him):
  Card size: 160×200px each
  Background: ivory #FFFBF7
  Wax seal dot: slateBluePrimary (replaces rosePrimary) ← only visual diff
  Label: Caveat 14px, warmGray800
  New badge: 8px slateBluePrimary dot, top-right
  Opened state: flap open, navySoft tint
  HIM'S LABELS:
    "Open when work is stressful"
    "Open when you miss me"
    "Open when you need confidence"
    "Open when you feel alone"
    "Open when you did something amazing"
    "Open when you can't sleep"
    "Open when you need to smile"
  ENVELOPE OPEN ANIMATION: identical cinematic quality to From Him
    Same stages: fullscreen expand → flap open → content reveal → character → particles
    Stage 4 character: char_shy → char_grateful (same as her app)

HER VOICE NOTES (same waveform UI as From Him):
  Title: "Her voice, for you" — Cormorant italic 18px
  Same AudioWaveforms widget, accent color: slateBluePrimary
  char_warm alongside first unplayed note

HER PLAYLIST (same layout as From Him):
  "Songs she picked for you 🎵" — Cormorant italic 20px
  Each song: cover art + title + artist + "because..." in Caveat italic
  Tap → deep link to Spotify/Apple Music

MEMORY PHOTOS (same Polaroid cards as From Him):
  Same 8px white border, slight rotation, Caveat caption
  Role-tinted left border: rose = she added it; blue = he added it
  All from /shared/{coupleId}/memories/ + /fromHer/{uid}/memories/

EMPTY STATE:
  char_hello, 160px, centered
  "She hasn't left anything here yet — but she will 🌸"
  DM Sans 14px, warmGray600
```

---

## 👤 HIM ME SCREEN — COMPLETE SPEC

Matches Her Me screen structure. Personal space, warm, not a productivity tracker.

```
HEADER:
  "Taking care of you, because she asked us to 💙"
  DM Sans 14px italic, slateBlueDark
  Mirrors Her: "A space made just for you 🌸"

CARD 1 — Daily Mood Check-in (top priority, same as Her's mood card)
  "How are you today, [HisName]?" — Cormorant italic 24px
  5 mood chips in same MoodSelector grid layout (2.5 cols or 5 in a row)
  Each: char thumbnail 48px + label DM Sans 12px
  😊 Happy · 😰 Stressed · 😴 Tired · 🤩 Excited · 🙏 Grateful
  On select: large character (180px) slides in from right — same as Her
  Background tints to mood color — same as Her
  Saves to /users/{uid}/himDailyLogs/today

CARD 2 — Stress Tracker (him-specific, no equivalent in Her)
  "How stressed are you today?" — DM Sans 16px
  5 soft circle buttons (1=calm → 5=overwhelmed)
  Selected: slateBluePrimary fill + glow ring
  If 4–5 for 3 consecutive days → local notification: "She'd want you to rest 💙"

CARD 3 — Sleep Logger (same as Her's sleep tracker widget)
  "How did you sleep?" — Cormorant italic 20px
  Hours slider: 4–10h in 0.5h steps (same slider style as Her's)
  Quality: 1–5 star tap (same star style as Her's)
  char_good_night, 80px, right side of card
  She can see his sleep (if both opt in) → she sends care accordingly

CARD 4 — His Journal (same quality as Her's journal)
  "Your private space 💙" — Cormorant italic 22px
  Caveat font preview of last entry (blurred edge, truncated)
  char_journaling empty state — same as Her
  AES-256 encrypted — same encryption as Her's journal
  Tap → HimJournalScreen
  "Write to her" option inside → saves to /fromHim/{herUid}/messages/

CARD 5 — Private Care Reminders (him-only, no equivalent in Her)
  "Only you see these 🔒" — DM Sans 12px + lock icon
  LocalNotifications ONLY — never syncs to Firebase
  App-suggested: "Her period is in ~2 days — maybe plan something cozy?"
  He can add custom reminders
  Lock icon reinforces privacy

CARD 6 — His Weekly Stats (mirrors Her's insights, simplified)
  "This week:" — DM Sans 14px
  "5 check-ins · Avg stress 2.4 · Avg sleep 7.2h"
  "You checked in on her 6 times 💙" ← him-specific metric
  Tap → HimInsightsScreen (future)
```

---

## 👫 US SCREEN — COMPLETE SPEC (Deepen Existing)

Both roles see identical content. Both contribute. Emotional center of the relationship.

### Current (verify matches spec):
```
Days Together counter — Cormorant 72px, animated number
Couple streak card
Memory timeline (basic, both add)
Bucket list (✅ built)
```

### Add These Sections (priority order):

#### Our Song Card
```
goldSoft background, gold border
"Our Song 🎵" — Caveat 16px label
Song title — Cormorant 20px
Artist — DM Sans 14px muted
"because..." note — Caveat italic 14px
Either partner sets it from Settings → Relationship
Tap → opens music link
```

#### Milestones Timeline
```
Vertical alternating left/right cards
Date: Cormorant italic; Label: DM Sans bold
Photo thumbnail optional; Either adds
Pre-suggestions: First date · First trip · Official · etc.
Anniversary countdown if < 30 days: goldSoft card at top
```

#### Love Language Cards
```
Side-by-side after both complete quiz
[HerName] — Words of Affirmation 💬
[HisName] — Quality Time ⏱️
Care tip references this
```

#### Question of the Day
```
One question per day (365-question bank)
Both tap → text input (Caveat font)
After both answer → side-by-side reveal, spring animation
"Save as memory?" shortcut
```

#### Thinking of You Ping
```
Prominent pill button on both home screens + Us screen
"Let [her/him] know you're thinking of them 💕"
One tap → partner gets fullscreen animation (phase color wash)
1/hour cooldown: "You already sent one recently 💕"
History: "She thought of you 8 hours ago"
```

#### Monthly Recap Card (AI)
```
Shows 1st of month (previous month)
Claude API: days + both moods + memories + streak + milestones
~150 words, Cormorant Garamond italic 18px, warm narrative prose
char_date_night right side, 140px
"[Month] Together" — Cormorant 28px
Gold divider + "[HerName] & [HisName] 💕"
Left/right arrows for past months
"Share recap" → screenshot-friendly render
```

---

## 🌱 MOOD GARDEN — HIM'S VIEW MODE

Her app: full interactive garden (existing behavior — do not change).
Him app: read-only beautiful view of HER garden.

```dart
// lib/features/mood_garden/presentation/mood_garden_screen.dart — MODIFY

final isOwner = ref.watch(appRoleProvider) == AppRole.her;

// Him sees:
//   - Her garden state exactly as it is (her streaks, her flowers)
//   - Cannot bloom flowers himself (those come from her logs)
//   - Header: "This is her garden. It grows when she takes care of herself 🌸"
//   - Can "water" once per day → sends her: "He watered your garden today 🌸"
//   - His watering: small sparkle animation on tap, not bloom

// Disable when isOwner == false:
//   - Log prompt FAB
//   - Streak-based bloom trigger
//   - Any interactive log elements

// Show when isOwner == false:
//   - [Water for her 💧] button, once per day, goldPrimary style
//   - Her streak overlay: "She's tended this garden X days 🌸"
```

---

## 🤖 AI COMPANION — BOTH ROLES

### Her AI Companion (existing — do not change system prompt without care)
Context: her cycle day, phase, mood, symptoms, recent logs.
Personality: warm, gentle, never clinical. Like a wise friend.

### Him AI Companion (new — `HimCompanionScreen`)
Same chat UI layout as Her's companion screen. Blue accent colors.

```
System prompt:
  "You are a warm, emotionally intelligent companion for [HisName],
   who deeply cares about [HerName]. You have access to her cycle
   phase, mood, and self-care data with her permission. Help him
   take care of her — and himself — warmly and personally.

   Her state: phase=[herPhase] day=[herCycleDay] mood=[herMood]
   symptoms=[herSymptoms] phaseCareNote=[phaseCareNote]

   His state: mood=[hisMood] stress=[hisStress]/5

   Rules:
   - Second person ('you', not 'he')
   - Reference her as '[HerName]', never 'your girlfriend'
   - Never give medical advice
   - Suggest one concrete action he can take TODAY
   - Warm, brief (3-4 sentences for cards, longer for chat)
   - End with something that reminds him she loves him
   - Never clinical — this is love, not a health report"
```

### Monthly Recap Prompt (shared — both trigger)
```
"Generate a warm ~150-word narrative about [HerName] and [HisName]'s
 month together. Data: days=[daysTogether] month=[month]
 her top mood=[herTopMood] his top mood=[himTopMood]
 memories this month=[memoryCount] streak days=[streakDays]
 milestones=[milestones] messages sent=[messageCount]

 Format: flowing prose, elegant and warm. Start with month name.
 Reference both names. End beautifully. Don't list facts — weave
 them into a story. Cormorant Garamond aesthetic in mind."
```

---

## 🔄 COMPLETE PHASE → CARE LANGUAGE

```dart
// lib/features/him_care/domain/phase_care_language.dart

String phaseToCareCopy(CyclePhase phase, int dayInPhase) => switch (phase) {
  CyclePhase.menstrual => dayInPhase <= 2
      ? "She might need extra comfort today. Be gentle with her 💙"
      : "Her energy is slowly returning. A check-in would mean a lot.",
  CyclePhase.follicular =>
      "She's feeling more energetic! Great day to plan something fun together.",
  CyclePhase.ovulation =>
      "She's at her brightest this week — she'd love to hear from you.",
  CyclePhase.luteal =>
      "She might feel more sensitive right now. Be extra patient today 💙",
};

String phaseCareAction(CyclePhase phase) => switch (phase) {
  CyclePhase.menstrual  => "Send her a hug — she needs it most now",
  CyclePhase.follicular => "Plan something fun together this week",
  CyclePhase.ovulation  => "Tell her something you love about her",
  CyclePhase.luteal     => "Check in more, ask how she's really doing",
};

String moodToCareCopy(String mood) => switch (mood) {
  'joyful'   => "She's happy today ☀️",
  'tired'    => "She's a bit tired today 🌙 — a gentle check-in?",
  'anxious'  => "She's feeling anxious. She might need you 💙",
  'sad'      => "She's feeling low. She'd love to hear from you.",
  'content'  => "She's feeling peaceful today 🌸",
  'stressed' => "She's feeling stressed. She'd love your support.",
  'excited'  => "She's excited about something today ✨",
  'grateful' => "She's in a grateful mood 🌸",
  _          => "She's doing her day 💙",
};
```

---

## 🔥 FIREBASE SCHEMA — COMPLETE

### `/users/{userId}` (full — including all relationship fields)
```
uid, email, displayName, role, myLoveCode
partnerUid, partnerRole, partnerDisplayName
coupleId, isLinked, onboardingComplete, partnerReadEnabled
cycleAverageLength: 28, periodAverageLength: 5
notificationsEnabled: bool, appLockEnabled: bool
themeMode: 'light'|'dark'|'auto', createdAt: timestamp
```

### `/loveCodes/{code}` (existing)
```
code, ownerUid, ownerRole, ownerName
linkedUid?, linkedAt?, createdAt, expiresAt (createdAt + 6mo), isActive
```

### `/users/{userId}/cycleEntries/{id}` (her only)
```
startDate, endDate?, cycleLength?, notes?, createdAt
```

### `/users/{userId}/dailyLogs/{YYYY-MM-DD}` (her only)
```
date, mood, flowLevel, symptoms[], energyLevel (1-5)
notes?, illustrationShown, createdAt, updatedAt
hydrationGlasses: int, cyclePhase: string, cycleDay: int
```

### `/users/{userId}/himDailyLogs/{YYYY-MM-DD}` (NEW — him only)
```
date: string
mood: 'happy'|'stressed'|'tired'|'excited'|'grateful'
stressLevel: int (1-5)
sleepHours: double?, sleepQuality: int (1-5)?
notes: string?, createdAt: timestamp
```

### `/users/{userId}/journalEntries/{id}` (her)
```
encryptedContent: string (AES-256)
mood, date, wordCount, createdAt
```

### `/users/{userId}/himJournalEntries/{id}` (NEW — him)
```
encryptedContent: string (AES-256)
mood, date, wordCount, createdAt
```

### `/users/{userId}/gardenState` (her only)
```
bloomCount, currentWeather, streakDays
lastLogDate, totalFlowers, unlockedElements[]
```

### `/fromHim/{userId}/messages/{messageId}` (existing)
```
type: 'text'|'voice'|'photo'|'openWhen'|'playlist'
title, content?, audioUrl?, photoUrl?, caption?
playlistItems?: [{title, artist, url, note}]
trigger: 'manual'|'scheduled'|'openWhen'|'day1'|'lowMood'|'cramps'
openWhenLabel?, scheduledDate?
isOpened: bool, openedAt?, isActive: bool, sortOrder: int
createdBy: string
```

### `/fromHer/{userId}/messages/{messageId}` (NEW — exact mirror)
```
Identical schema as fromHim. createdBy = her userId. userId = him (he reads it).
```

### `/fromHer/{userId}/hugs/{hugId}` (NEW)
```
sentAt: timestamp, seenAt?: timestamp, message?: string
```

### `/fromHim/{userId}/hugs/{hugId}` (existing — verify)
```
sentAt, seenAt?, message?
```

### `/shared/{coupleId}/` (partially built — verify + add missing)
```
herUid, himUid, linkedAt, daysTogetherStart
anniversaryDate?, coupleStreakDays: int
lastHerLogDate?: "YYYY-MM-DD", lastHimLogDate?: "YYYY-MM-DD"
ourSong?: {title, artist, url, addedBy}
loveLanguages?: {her: string?, him: string?}
relationshipNickname?: string
```

### `/shared/{coupleId}/memories/{id}`
```
type: 'photo'|'note'|'song'|'place'|'milestone'
date: timestamp, caption: string
photoUrl?, songTitle?, songArtist?, locationName?
addedBy: string, addedByRole: "her"|"him", createdAt
```

### `/shared/{coupleId}/milestones/{id}`
```
date, label, emoji, photoUrl?, addedBy
```

### `/shared/{coupleId}/bucketList/{id}` (✅ built — verify schema)
```
title, emoji?, category: 'Travel'|'Food'|'Adventure'|'Cozy'|'BigDreams'
addedBy, isCompleted: bool, completedDate?
```

### `/shared/{coupleId}/questions/{id}`
```
questionText, herAnswer?, himAnswer?
herAnsweredAt?, himAnsweredAt?, date: "YYYY-MM-DD"
```

---

## 🔐 FIREBASE SECURITY RULES (COMPLETE)

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {

    // Own data: full access
    match /users/{userId}/{document=**} {
      allow read, write: if request.auth.uid == userId;
    }

    // Love codes: authenticated read for validation, owner writes
    match /loveCodes/{code} {
      allow read: if request.auth != null;
      allow write: if request.auth != null
        && resource.data.ownerUid == request.auth.uid;
    }

    // From Him: she reads own, her partner (him) writes
    match /fromHim/{userId}/{document=**} {
      allow read: if request.auth.uid == userId;
      allow write: if request.auth != null
        && get(/databases/$(database)/documents/users/$(userId))
            .data.partnerUid == request.auth.uid;
    }

    // From Her: he reads own, his partner (her) writes
    match /fromHer/{userId}/{document=**} {
      allow read: if request.auth.uid == userId;
      allow write: if request.auth != null
        && get(/databases/$(database)/documents/users/$(userId))
            .data.partnerUid == request.auth.uid;
    }

    // Her daily logs: she owns; partner reads ONLY if partnerReadEnabled
    match /users/{userId}/dailyLogs/{logId} {
      allow read: if request.auth.uid == userId
        || (request.auth != null
            && get(/databases/$(database)/documents/users/$(userId))
                .data.partnerUid == request.auth.uid
            && get(/databases/$(database)/documents/users/$(userId))
                .data.partnerReadEnabled == true);
      allow write: if request.auth.uid == userId;
    }

    // Her journal: she ONLY — no partner access ever
    match /users/{userId}/journalEntries/{id} {
      allow read, write: if request.auth.uid == userId;
    }

    // Him journal: him ONLY — no partner access ever
    match /users/{userId}/himJournalEntries/{id} {
      allow read, write: if request.auth.uid == userId;
    }

    // Shared couple space: both partners full read/write
    match /shared/{coupleId}/{document=**} {
      allow read, write: if request.auth != null
        && (coupleId.matches(request.auth.uid + '_.*')
            || coupleId.matches('.*_' + request.auth.uid));
    }
  }
}
```

---

## ☁️ CLOUD FUNCTIONS NEEDED

### Already Built (verify completeness)
```typescript
// linkPartners — verify ALL validations:
// ✅ Code exists  ✅ Not expired (6mo)  ✅ Not already linked
// ✅ Opposite roles  ✅ Not linking to self
// Creates /shared/{coupleId}, updates both user docs atomically
// Returns: { success, coupleId, partnerName }
```

### Build These
```typescript
// 1. generateLoveCode
// On signup completion: unique LUNA-WORD-WORD-XXXX
// Her words: [ROSE,DAWN,SOFT,SILK,PETAL,BLUSH,BLOOM,PEARL] × [MOON,MIST,GLOW,HAZE,LACE,DUSK,VEIL,HALO]
// Him words: [STAR,WAVE,PINE,STORM,FORGE,TIDE,NORTH,EMBER] × [TIDE,CREST,PEAK,VALE,COVE,BLAZE,RIDGE,HAVEN]

// 2. sendThinkingOfYou
// Input: { toUid, fromRole }
// Validates: 1/hour cooldown (check pings subcollection)
// Writes ping record, sends FCM

// 3. sendHug
// Input: { toUid, fromRole }
// Writes to /fromHer/{toUid}/hugs/ or /fromHim/{toUid}/hugs/
// Sends FCM

// 4. onHerDailyLogCreated (Firestore trigger)
// Fires on new /users/{userId}/dailyLogs/{logId}
// If cramps in symptoms → FCM to him care notification
// If mood anxious/sad → FCM to him check-in nudge
// If period day 1 (no recent entry) → FCM period notification + trigger from-him auto-message
// Updates /shared/{coupleId}.lastHerLogDate → checkCoupleStreak

// 5. onHimDailyLogCreated (Firestore trigger)
// Fires on new /users/{userId}/himDailyLogs/{logId}
// If stressLevel >= 4 for 3 consecutive days → notification: "She'd want you to rest 💙"
// Updates /shared/{coupleId}.lastHimLogDate → checkCoupleStreak

// 6. checkCoupleStreak (called by both log triggers)
// If both logged today → increment coupleStreakDays
// Milestone FCM: 7, 14, 30, 100 days

// 7. updatePartnerDisplayName (callable)
// When user updates name → updates partnerDisplayName on partner's doc

// 8. scheduleFromPartnerMessage (callable)
// Sets scheduledDate on a message → Cloud Scheduler delivers it
```

---

## 🔔 NOTIFICATIONS — COMPLETE SYSTEM

### FCM Topics
```dart
// Subscribe on login:
FirebaseMessaging.instance.subscribeToTopic('her_${userId}');    // her receives
FirebaseMessaging.instance.subscribeToTopic('him_${userId}');    // him receives
FirebaseMessaging.instance.subscribeToTopic('couple_${coupleId}'); // both receive
```

### Him Receives (care-aware, warm, from-app copy)
```
period_soon:    "💙 Her period starts in ~2 days. Maybe plan something cozy at home? 🏠"
period_day1:    "💙 She started her period today. She might need extra love right now."
she_cramps:     "💙 She logged cramps today. A small check-in would mean a lot."
she_anxious:    "💙 She's feeling anxious today. She'd love to hear from you."
she_low_mood:   "💙 She's feeling low today. She'd love to hear from you."
she_not_logged: "💙 She hasn't logged in 3 days — maybe check on her?"
her_streak_7:   "🌸 She's been taking care of herself 7 days in a row!"
from_her_new:   "💌 She left you something new."
hug_from_her:   "🤗 She's thinking of you — open Luna to feel it."
stress_check:   "💙 You've been stressed 3 days in a row. She'd want you to rest."
her_happy:      "🌸 She's happy today. You probably had something to do with that 💙"
```

### She Receives (from his actions)
```
hug_sent:       "He's thinking of you 💕" → full-screen hug animation
thinking_ping:  "He's thinking of you right now 💙"
new_from_him:   "💌 He left you something new."
msg_opened:     "He opened your message — and it made him smile 💙"
watered_garden: "He watered your garden today 🌸"
encouragement:  "[Custom message he typed]"
```

### Her Receives (from app — existing system)
```
periodStartingSoon: "Luna 🌸 · Your period may start in ~2 days. He wanted you prepared 💕"
periodDay1:         "A message from him 💌 · He left something special for today."
dailyLog:           "How are you today? 🌸 · Take a moment for yourself."
streak7:            "7 days in a row 🌸 · Your garden is thriving. So are you."
gardenMissing:      "Your garden misses you 🌱 · Just a few seconds to check in?"
```

### Both Receive (couple milestones)
```
streak_7:    "🔥 7 days of showing up for each other!"
streak_14:   "💕 Two weeks of logging together"
streak_30:   "✨ A whole month — 30 days together"
streak_100:  "💙🌸 100 days. That's everything."
anniversary: "💕 Happy anniversary, [HerName] & [HisName]!"
```

---

## 🎬 ANIMATION SYSTEM (Both Roles)

All animations identical between Her and Him — only colors differ.

### Key Animations
```dart
// 1. Phase-aware sky — breathing gradient (5s loop, reverse)
AnimationController(duration: Duration(seconds: 5))..repeat(reverse: true)
TweenAnimationBuilder on phase change: 3s crossfade (easeInOutCubic)

// 2. Glassmorphism container spring entrance
// SlideTransition + FadeTransition, 400ms, Curves.easeOutBack

// 3. Character slide-in on mood selection (both roles)
// .slideX(begin: 0.3, duration: 300.ms, curve: Curves.easeOutBack).fadeIn()

// 4. Envelope open — CINEMATIC (both From Him and From Her — identical quality)
// Stage 1: card → fullscreen (500ms, Curves.elasticOut)
// Stage 2: flap opens (rotateX 0→-180°, 300ms)
// Stage 3: content fadeIn + slideY(begin: 0.2, 400ms)
// Stage 4: character fades in (300ms delay)
// Stage 5: particles (hearts/petals, Lottie)

// 5. Hug animation fullscreen (GOLD — identical both roles)
// Stage 1 (0-500ms):    gold wash expands from center (radial)
// Stage 2 (300-1200ms): 12 heart particles float up
// Stage 3 (600-2000ms): char_in_love fades in, 160px
// Stage 4 (1000-2500ms):"[He's/She's] thinking of you 💕" Cormorant 24px
// Stage 5 (2500-3000ms): gentle fade back to normal

// 6. Petal unfurl on log save (both roles — rose petals or blue sparkles)
// 8 petals/sparkles, CustomPainter, staggered 50ms, easeOutCubic

// 7. Card stagger entrance (all list screens, both roles)
// .fadeIn(delay: (index * 80).ms).slideY(begin: 0.05)

// 8. FloatingParticles (home screen, role color)
// Her: rose at 10-25% opacity; Him: slate blue at 10-25% opacity

// 9. Thinking of You ping (fullscreen, triggered by ping)
// Phase color wash expands, char_in_love, partner's name fades in
// Her receives: rose wash; Him receives: blue wash
```

### Animation Curves (both roles)
```dart
Curves.easeInOutCubic  // general transitions
Curves.elasticOut      // bouncy reveals
Curves.easeOutBack     // cards coming in
Curves.decelerate      // content fading in
Curves.easeInOut       // breathing, gradients
```

---

## 📦 PACKAGES — pubspec.yaml (complete, verify all present)

```yaml
dependencies:
  # State & Navigation
  flutter_riverpod: ^2.6.1
  riverpod_annotation: ^2.6.1
  go_router: ^14.0.0

  # Firebase
  firebase_core: ^3.0.0
  firebase_auth: ^5.0.0
  cloud_firestore: ^5.0.0
  firebase_storage: ^12.0.0
  firebase_messaging: ^15.0.0
  cloud_functions: ^4.6.0

  # Local Storage
  hive_flutter: ^1.1.0
  flutter_secure_storage: ^9.2.0
  drift: ^2.20.0
  sqlite3_flutter_libs: ^0.5.0

  # UI & Animation
  flutter_animate: ^4.5.0
  lottie: ^3.1.0
  google_fonts: ^6.2.0
  cached_network_image: ^3.3.1
  shimmer: ^3.0.0
  smooth_page_indicator: ^1.2.0
  flutter_svg: ^2.0.10+1

  # Love Code Features
  qr_flutter: ^4.1.0             # QR display (✅ added)
  mobile_scanner: ^3.5.0         # QR scanning (✅ added)

  # Audio
  just_audio: ^0.9.40
  record: ^5.1.0
  audio_waveforms: ^1.0.5

  # Media
  image_picker: ^1.1.2
  photo_view: ^0.15.0

  # Notifications
  flutter_local_notifications: ^17.2.2
  timezone: ^0.9.4

  # Security
  local_auth: ^2.3.0
  encrypt: ^5.0.3               # AES-256 for both journals

  # Charts & Data Vis
  fl_chart: ^0.68.0

  # Utils
  dio: ^5.7.0
  freezed_annotation: ^2.4.4
  json_annotation: ^4.9.0
  intl: ^0.19.0
  uuid: ^4.5.0
  url_launcher: ^6.3.0
  share_plus: ^10.0.0
  connectivity_plus: ^6.0.5
  path_provider: ^2.1.0
  confetti: ^0.7.0

dev_dependencies:
  build_runner: ^2.4.13
  riverpod_generator: ^2.6.2
  freezed: ^2.5.7
  json_serializable: ^6.8.0
  drift_dev: ^2.20.0
  mocktail: ^1.0.4
  flutter_lints: ^4.0.0
```

---

## 🔗 OPEN WHEN LABELS

### Her Opens (from him)
```
"Open when you feel low"         "Open when cramps hurt"
"Open when you miss me"          "Open when you feel beautiful"
"Open when you need strength"    "Open when you can't sleep"
Custom label (him writes)
```

### Him Opens (from her)
```
"Open when work is stressful"    "Open when you miss me"
"Open when you need confidence"  "Open when you feel alone"
"Open when you did something amazing"
"Open when you can't sleep"      "Open when you need to smile"
Custom label (she writes)
```

---

## 🏗️ COMPLETE FOLDER STRUCTURE (NEW FILES ONLY)

```
lib/
├── core/
│   ├── role/
│   │   ├── app_role.dart                         ← NEW
│   │   └── role_provider.dart                    ← NEW
│   ├── theme/
│   │   ├── him_theme_extension.dart              ← NEW: slate blue tokens
│   │   └── app_theme.dart                        ← MODIFY: accept AppRole
│   └── constants/
│       ├── app_strings_him.dart                  ← NEW: all him copy
│       └── app_strings_love_code.dart            ← NEW (verify exists)
│
├── features/
│   ├── onboarding/pages/
│   │   ├── him_name_page.dart                    ← NEW: his name + her name
│   │   ├── him_about_her_page.dart               ← NEW: care preferences
│   │   ├── him_notifications_page.dart           ← NEW: his notif prefs
│   │   ├── him_ready_page.dart                   ← NEW: his finale
│   │   └── onboarding_router.dart                ← NEW or MODIFY
│   │
│   ├── him_home/
│   │   ├── data/him_home_repository.dart
│   │   ├── domain/him_home_state.dart
│   │   ├── presentation/
│   │   │   ├── him_home_screen.dart
│   │   │   └── widgets/
│   │   │       ├── her_mood_card.dart            ← IllustratedCard, her char
│   │   │       ├── her_phase_card.dart           ← phase in care language
│   │   │       ├── care_tip_card.dart            ← AI, goldSoft bg
│   │   │       ├── from_her_peek_card.dart       ← gold, char_in_love
│   │   │       ├── his_mood_quick_log.dart       ← 5-mood quick log
│   │   │       └── him_relationship_card.dart    ← days + streak mini
│   │   └── providers/him_home_provider.dart
│   │
│   ├── from_her/
│   │   ├── data/
│   │   │   ├── from_her_repository.dart
│   │   │   └── from_her_remote_datasource.dart
│   │   ├── domain/
│   │   │   ├── her_love_message.dart
│   │   │   ├── her_voice_note.dart
│   │   │   ├── her_memory_photo.dart
│   │   │   └── her_comfort_playlist.dart
│   │   ├── presentation/
│   │   │   ├── from_her_screen.dart              ← blue accent, same layout as from_him
│   │   │   ├── her_envelope_open_screen.dart     ← blue wax seal, same animation
│   │   │   ├── her_voice_note_screen.dart
│   │   │   ├── her_memory_gallery_screen.dart
│   │   │   └── her_comfort_playlist_screen.dart
│   │   └── providers/from_her_provider.dart
│   │
│   ├── him_care/
│   │   ├── data/care_dashboard_repository.dart
│   │   ├── domain/
│   │   │   ├── care_suggestion.dart
│   │   │   ├── partner_status.dart
│   │   │   ├── phase_care_language.dart          ← phaseToCare, moodToCare fns
│   │   │   └── mood_care_language.dart
│   │   ├── presentation/
│   │   │   ├── care_dashboard_screen.dart
│   │   │   └── widgets/
│   │   │       ├── her_mood_display.dart         ← char 200px, warmth copy
│   │   │       ├── her_phase_banner.dart
│   │   │       ├── care_action_card.dart         ← 2×2 grid
│   │   │       ├── her_hydration_peek.dart
│   │   │       ├── her_streak_display.dart
│   │   │       └── care_suggestion_card.dart     ← AI tip, goldSoft
│   │   └── providers/care_dashboard_provider.dart
│   │
│   ├── him_me/
│   │   ├── data/him_log_repository.dart
│   │   ├── domain/
│   │   │   ├── him_mood.dart                     ← enum 5 moods
│   │   │   ├── him_daily_log.dart                ← Freezed
│   │   │   └── him_journal_entry.dart
│   │   ├── presentation/
│   │   │   ├── him_me_screen.dart
│   │   │   └── widgets/
│   │   │       ├── him_mood_selector.dart        ← same layout as Her MoodSelector
│   │   │       ├── him_stress_tracker.dart       ← 1-5 circles
│   │   │       ├── him_sleep_logger.dart         ← same style as Her's
│   │   │       └── him_journal_card.dart         ← same as Her's journal card
│   │   └── providers/him_me_provider.dart
│   │
│   ├── from_him/presentation/write/              ← ADD to existing feature
│   │   ├── write_message_screen.dart
│   │   ├── record_voice_screen.dart
│   │   ├── schedule_surprise_screen.dart
│   │   └── add_song_screen.dart
│   │
│   ├── from_her/presentation/write/              ← Her writes for him
│   │   ├── write_for_him_screen.dart
│   │   ├── record_for_him_screen.dart
│   │   └── open_when_composer_screen.dart
│   │
│   ├── relationship/presentation/               ← Deepen existing
│   │   ├── memory_timeline_screen.dart
│   │   ├── add_memory_screen.dart
│   │   ├── milestones_screen.dart
│   │   ├── monthly_recap_screen.dart
│   │   ├── question_of_day_screen.dart
│   │   ├── love_language_screen.dart
│   │   ├── mood_board_screen.dart
│   │   └── widgets/
│   │       ├── our_song_card.dart
│   │       ├── milestone_timeline_widget.dart
│   │       ├── monthly_recap_card.dart
│   │       ├── question_card.dart
│   │       ├── love_language_card.dart
│   │       ├── thinking_of_you_button.dart       ← same both roles
│   │       └── mood_board_grid.dart
│   │
│   └── mood_garden/presentation/
│       └── mood_garden_screen.dart               ← MODIFY: role-aware (owner vs view)

// Core widgets — ensure these exist and are role-aware:
lib/core/widgets/
├── illustrated_card.dart     ← role-aware backgroundColor param
├── glass_card.dart           ← frosted glass container
├── hug_button.dart           ← GOLD always, same both roles
├── envelope_card.dart        ← role-aware wax seal color
├── polaroid_card.dart        ← role-tinted left border
└── luna_empty_state.dart     ← warm always, char + message

functions/src/
├── generateLoveCode.ts        ← verify or build
├── linkPartners.ts            ← verify all 5 validations
├── sendThinkingOfYou.ts       ← build
├── sendHug.ts                 ← build
├── onHerDailyLogCreated.ts    ← build (Firestore trigger)
├── onHimDailyLogCreated.ts    ← build (Firestore trigger)
├── checkCoupleStreak.ts       ← build
└── updatePartnerDisplayName.ts ← build
```a

---

## 🔄 ONBOARDING FLOW (Complete)

```
App Launch → check auth
    ├─ logged in + linked   → role-aware home
    ├─ logged in + unlinked → home (solo mode)
    └─ not logged in        → onboarding

PAGE 1 — Welcome
  Animated gradient: rose→peach→mauve (her) | blue→gold→blue (him) [role unknown: neutral]
  FloatingParticles, char_hello 200px, "Luna" Cormorant 48px
  CTA: "Begin ✦"  |  bottom: "Already have a code? Connect →"

PAGE 2 — Role Select (CRITICAL — sets everything)
  Left card (roseSoft): char_in_love, "I'm her 🌸", "Track my cycle & wellbeing"
  Right card (slateBlueSoft): char_happy, "I'm him 💙", "Take care of her & myself"
  On select: theme switches immediately, routes to correct branch

         ┌─────── HER BRANCH ───────────┬──────── HIM BRANCH ──────────┐
         │                              │                               │
PAGE 3   │ Her Name                     │ His Name + Her Name           │
         │ "What should we call you?"   │ Both fields, live preview     │
         │ char_happy top-right         │ char_in_love when her typed   │
         │                              │                               │
PAGE 4   │ Cycle Setup                  │ About Her                     │
         │ Date + length sliders        │ Toggle: share cycle info?     │
         │ char_planning                │ Toggle: care notifications?   │
         │                              │ "One thing I love about her"  │
         │                              │ (encrypted locally, private)  │
         │                              │                               │
PAGE 5   │ Her Love Code                │ His Love Code                 │
         │ Staggered reveal animation   │ Same reveal, blue accent      │
         │ Copy / Share / QR            │ Copy / Share / QR             │
         │ "Skip for now" option        │ + "Enter her code" inline box │
         │                              │                               │
PAGE 6   │ Notifications (her)          │ Notifications (him)           │
         │ Period · Hydration · Sleep   │ Period pred · Mood · From Her │
         │ From Him · Daily log         │ Care reminders · Streak       │
         │                              │                               │
PAGE 7   │ Ready (his note for her)     │ Ready (her note for him)      │
         │ Caveat, warm paper card      │ Caveat, warm paper card       │
         │ "Open Luna 💕" gold button   │ "Open Luna 💙" blue button    │
         └──────────────────────────────┴───────────────────────────────┘
```

---

## 🚨 EDGE CASES — COMPLETE GUIDE

| Scenario | Exact Handling |
|:---|:---|
| She hasn't logged mood | char_hello + "She hasn't shared yet today 🌸" — never blank |
| `partnerReadEnabled` false | Same warm empty everywhere — never show an error |
| He accesses `/cycle` | GoRouter redirect → `/him/care` silently |
| She accesses `/him/care` | GoRouter redirect → `/cycle` silently |
| Two Her accounts try to link | Cloud Function rejects: "This code belongs to someone like you 🌸" |
| Code expired (>6mo) | "This code has expired. Ask them to refresh in Settings 🌸" |
| Code already used | "This code is already connected to someone else 💙" |
| Both enter each other's code simultaneously | Firestore transaction first-write-wins |
| App reinstalled | Firebase Auth uid persists → full state restored |
| Partner unlinks | 30-day soft delete, both solo mode, new codes, warm notification |
| Couple streak breaks | "Your streak paused at X days. Start fresh today 🌸" — never punitive |
| His stress 4–5 × 3 days | LocalNotification: "She'd want you to rest 💙" |
| `partnerDisplayName` null | Fallback: "him" / "her" generically — never blank |
| No couple data before linking | Us screen: warm illustration + "Share your code to start 💕" |
| Anniversary < 30 days | Countdown card appears on Us screen |
| No monthly recap data | "A quiet month — and those count too 💕" |
| She hasn't set cycle yet | Him care dashboard: "She hasn't set up yet 🌸" — no phase widgets |

---

## ✅ CRITICAL DO'S & DON'TS

### ❌ Never
- Show her raw cycle data to him — always translate through `phaseToCareCopy()`
- Use gray-tinted shadows — always role-tinted (rose / blue)
- Let him access her journal — Firestore rules block this
- Use `rosePrimary` in him's theme anywhere
- Skip envelope animation quality — both From Him AND From Her must be cinematic
- Sync his private care reminders to Firebase — **LocalNotifications only, period**
- Hardcode "From Him" / "From Her" — always `partnerDisplayName` from Firestore
- Show "No data" — every empty state: char + warm copy
- Make couple streak punitive — warm and encouraging always
- Show blue wax seal in her app — rose seal only in her app
- Skip `role_select_page` — the entire experience depends on it
- Build him's screens with less quality than her's — they must be equal

### ✅ Always
- Him's home sky reads **HER phase color** — he sees her world
- Caveat font for **"from partner"** messages in both apps
- Gold = love language for **both roles** — identical hug buttons
- Same character assets both apps — narrative framing differs
- Him's AI focuses on **what he can DO today**
- `partnerReadEnabled` must be explicitly `true` before him sees her data
- Both journals: **AES-256 encrypted**, same level
- Every empty state: char illustration + warm message
- Notifications feel **personal and warm**, not system alerts
- Him's screens must **structurally mirror Her's** (same layout quality, same component types)
- Test both roles in dark mode before shipping any phase

---

## 🌟 BONUS FEATURES (after core is solid)

1. **Care Mode Quick-Action** — long press home → send hug/ping/voice note, no nav needed
2. **Period Prep Mode** — 3 days before, UI subtly warmer, care tips more frequent
3. **"She Opened It" Receipts** — him sees when she reads his message
4. **His Own Streak** — "You've checked in on her 7 days in a row 💙"
5. **Couple Mood Match** — fun daily card: "You're excited, she's calm — a peaceful match ✨"
6. **Anniversary Mode** — cinematic open, confetti, special pre-written message
7. **Mood Board** — private masonry grid, both add photos/quotes/colors
8. **AI Insights for Him** — "Your last 2 weeks: avg stress 2.1, sleep 7.4h — you're doing well 💙"
9. **Her Hydration Encouragement** — she logs water, he sees "Encourage her" → she gets notification

---

## 🔗 DEEP LINK HANDLING

```dart
// Scheme: luna://  Host: connect  Path: ?code=LUNA-ROSE-MOON-4821&name=Priya
// android/AndroidManifest.xml + ios/Info.plist

GoRoute(
  path: '/connect',
  redirect: (context, state) {
    final code = state.uri.queryParameters['code'];
    if (code != null) return '/onboarding/code-entry?prefill=$code';
    return null;
  },
)

// Share text — pre-filled:
// Her: "I made a space for us in Luna. Enter my code: LUNA-ROSE-MOON-4821 💕 [link]"
// Him: "I set something up for us in Luna. Enter my code: LUNA-STAR-TIDE-7743 💙 [link]"
```

---

*This brief synthesizes all four source documents plus the May 26 agent update.*  
*Current confirmed status: Auth · Onboarding · Linking · Basic "Us" tab = complete.*  
*Everything else in this document is either in-progress or needs building.*  
*Him's experience must structurally and qualitatively match Her's — same layout grammar, different role colors and content.*