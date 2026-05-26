# LUNA — Complete User Flow & Screen Paths

---

## 1. APP LAUNCH

```
App Opens
    │
    ├── Logged in + Linked      ──► Role-Aware Home Screen
    ├── Logged in + Not Linked  ──► Home Screen (Solo Mode)
    └── Not Logged In           ──► Onboarding
```

---

## 2. ONBOARDING FLOW

### Page 1 — Welcome
```
Welcome Screen
    │
    ├── "Begin ✦"               ──► Role Select Page
    └── "Already have a code?"  ──► Code Entry Screen
```

### Page 2 — Role Select *(Critical — sets entire app experience)*
```
Role Select
    │
    ├── "I'm her 🌸"   ──► HER BRANCH
    └── "I'm him 💙"   ──► HIM BRANCH
```

---

### 2A. HER ONBOARDING BRANCH

```
Page 3: Her Name
    └──► Page 4: Cycle Setup (last period date, cycle length, period length)
              └──► Page 5: Her Love Code (generated: LUNA-WORD-WORD-XXXX)
                        │
                        ├── Copy Code
                        ├── Share Code
                        ├── Show QR Code
                        └── "Skip for now"
                              └──► Page 6: Notifications Setup
                                        └──► Page 7: Ready Screen
                                                  └──► Her Home Screen ✓
```

---

### 2B. HIM ONBOARDING BRANCH

```
Page 3: His Name + Her Name
    └──► Page 4: About Her (share cycle info toggle, care notifs toggle)
              └──► Page 5: His Love Code (generated: LUNA-WORD-WORD-XXXX)
                        │
                        ├── Copy Code
                        ├── Share Code
                        ├── Show QR Code
                        └── Enter Her Code (inline)
                              └──► Page 6: Notifications Setup
                                        └──► Page 7: Ready Screen
                                                  └──► Him Home Screen ✓
```

---

### 2C. CODE ENTRY / PARTNER LINKING

```
Code Entry Screen
    │
    ├── Enter code manually  ──► Validation ──► Link Success ──► Coupled Home
    ├── Scan QR Code         ──► Camera ──► Scan ──► Validation ──► Link Success
    └── Deep Link (luna://connect?code=XXXX) ──► Pre-filled Code Entry ──► Link
```

**Linking Validation States:**
```
Code invalid        ──► "Code not found"
Code expired        ──► "This code has expired. Ask them to refresh in Settings 🌸"
Code already used   ──► "This code is already connected to someone else 💙"
Same role attempt   ──► "This code belongs to someone like you 🌸"
```

---

## 3. HER APP — NAVIGATION (5 Tabs)

```
Bottom Nav: [Home] [Cycle] [Garden] [From Him] [Me]
```

---

### Tab 1 — Her Home `/home`

```
Her Home Screen
    │
    ├── Phase Hero Area (tap)    ──► Cycle Screen
    ├── Today Status Card (tap)  ──► Daily Log Screen
    ├── Period Countdown Card
    ├── From Him Peek Card (tap) ──► From Him Screen
    ├── Wellness Quick Row
    │       ├── Hydration        ──► Daily Log Screen
    │       └── Sleep            ──► Daily Log Screen
    └── Self-Care Suggestion     ──► Self-Care Screen
```

---

### Tab 2 — Cycle `/cycle` *(Her Only)*

```
Cycle Screen
    │
    ├── Current Phase Display
    ├── Cycle Calendar
    ├── Log Today (tap)          ──► Daily Log Screen
    │       ├── Mood selector
    │       ├── Symptoms
    │       ├── Flow level
    │       ├── Energy level
    │       ├── Hydration
    │       └── Notes (save)     ──► Back to Cycle Screen
    └── Insights (tap)           ──► Insights Screen
```

---

### Tab 3 — Garden `/garden`

```
Mood Garden Screen (Her — Interactive)
    │
    ├── View Garden (flowers bloom from her logs)
    ├── Tap to Log Today         ──► Daily Log Screen
    └── Garden Streak Display
```

---

### Tab 4 — From Him `/from-him`

```
From Him Screen
    │
    ├── Hug Button (tap)         ──► Hug Animation Fullscreen
    │
    ├── Open When Envelopes
    │       └── Tap envelope     ──► Envelope Open Screen (cinematic)
    │                                   └── Back to From Him
    │
    ├── His Voice Notes
    │       └── Tap note         ──► Voice Note Screen `/from-him/voice/:id`
    │
    ├── His Playlist
    │       └── Tap song         ──► External music app (Spotify / Apple Music)
    │
    └── Memory Photos
            └── Tap photo        ──► Memory Gallery Screen `/from-him/gallery`
```

---

### Tab 5 — Me `/me`

```
Her Me Screen
    │
    ├── Daily Mood Check-in (tap mood)
    ├── Self-Care Card           ──► Self-Care Screen `/self-care`
    ├── Journal Card (tap)       ──► Her Journal Screen `/journal`
    │       ├── View entries
    │       └── Write Entry      ──► Journal Write Screen `/journal/write`
    │                                   └── Save ──► Back to Journal
    ├── AI Companion (tap)       ──► AI Companion Screen `/companion`
    ├── Insights (tap)           ──► Insights Screen `/insights`
    └── Settings (tap)           ──► Settings Screen `/settings`
                                       └── App Lock  ──► `/settings/app-lock`
```

---

## 4. HIM APP — NAVIGATION (5 Tabs)

```
Bottom Nav: [Home] [From Her] [Her ♥] [Us] [Me]
```

---

### Tab 1 — Him Home `/him/home`

```
Him Home Screen
    │
    ├── Phase-Aware Sky (reads HER phase — view only)
    ├── Her Mood Card (tap)      ──► Care Dashboard Screen
    ├── Care Tip Card (AI)
    ├── From Her Peek Card (tap) ──► From Her Screen
    ├── Send Hug Button          ──► Hug sent ──► She sees animation
    ├── Write to Her (tap)       ──► Write Message Screen
    ├── Days Together + Streak   ──► Us Screen
    └── His Mood Quick Log       ──► Logs to himDailyLogs (stays on Home)
```

---

### Tab 2 — From Her `/from-her`

```
From Her Screen
    │
    ├── Hug Button (tap)         ──► Hug Animation Fullscreen
    │
    ├── Open When Envelopes
    │       └── Tap envelope     ──► Her Envelope Open Screen (cinematic, blue seal)
    │                                   └── Back to From Her
    │
    ├── Her Voice Notes
    │       └── Tap note         ──► Her Voice Note Screen `/from-her/voice/:id`
    │
    ├── Her Playlist
    │       └── Tap song         ──► External music app
    │
    └── Memory Photos
            └── Tap photo        ──► Her Memory Gallery Screen `/from-her/gallery`
```

---

### Tab 3 — Her (Care Dashboard) `/him/care` *(Him Only)*

```
Care Dashboard Screen — "How She's Doing Today"
    │
    ├── Her Mood Display
    ├── Her Phase Banner
    ├── AI Care Tip Card (goldSoft)
    ├── Her Symptoms (if logged)
    │       └── Send Hug          ──► Hug animation triggers on her phone
    ├── Her Self-Care Streak
    │       └── Send Encouragement ──► She gets notification
    ├── Her Hydration Peek
    │       └── Encourage Her     ──► She gets notification
    └── Care Actions Grid (2×2)
            ├── Write to Her      ──► `/him/write-to-her`
            ├── Send Hug          ──► Hug animation on her phone
            ├── Add Song          ──► `/him/add-song`
            └── Schedule Surprise ──► `/him/schedule-surprise`
```

---

### Tab 4 — Us `/us` *(Both Roles)*

```
Us Screen (Relationship Screen)
    │
    ├── Days Together Counter
    ├── Couple Streak
    ├── Our Song Card (tap)           ──► External music app
    │
    ├── Thinking of You Button        ──► Partner gets fullscreen animation
    │
    ├── Milestones (tap)              ──► Milestones Screen `/us/milestones`
    │       └── Add Milestone FAB     ──► Add milestone form ──► Back
    │
    ├── Memory Timeline (tap)         ──► Memory Timeline Screen `/us/memories`
    │       └── Add Memory FAB        ──► Add Memory Screen `/us/memories/add`
    │                                       └── Save ──► Back to Timeline
    │
    ├── Bucket List (tap)             ──► Bucket List Screen `/us/bucket-list`
    │       ├── Add item
    │       └── Mark complete
    │
    ├── Question of the Day (tap)     ──► Question of Day Screen `/us/question`
    │       ├── Her answers
    │       ├── Him answers
    │       └── Both answered         ──► Side-by-side reveal
    │
    ├── Love Language Cards (tap)     ──► Love Language Screen `/us/love-languages`
    │       └── Take quiz             ──► Answer questions ──► Shared result display
    │
    ├── Monthly Recap Card (tap)      ──► Monthly Recap Screen `/us/recap`
    │       └── ← → browse months
    │
    └── Mood Board (tap)              ──► Mood Board Screen `/us/mood-board`
            └── Add photo/quote
```

---

### Tab 5 — Him Me `/him/me`

```
Him Me Screen
    │
    ├── Daily Mood Check-in (tap mood)
    ├── Stress Tracker (1-5 levels)
    ├── Sleep Logger (hours + quality)
    ├── Journal Card (tap)            ──► Him Journal Screen `/him/journal`
    │       ├── View entries
    │       └── Write Entry           ──► Him Journal Write Screen `/him/journal/write`
    │               ├── Write entry (AES-256 encrypted)
    │               └── "Write to Her" option ──► `/him/write-to-her`
    ├── Private Care Reminders (local only, never synced)
    ├── His Weekly Stats
    ├── AI Companion (tap)            ──► Him Companion Screen `/him/companion`
    ├── Insights (tap)                ──► Him Insights Screen `/him/insights`
    └── Settings (tap)                ──► Him Settings Screen `/him/settings`
```

---

## 5. HIM — WRITE TO HER SCREENS

```
Write Message Screen `/him/write-to-her`
    ├── Text message
    ├── Open When label option
    ├── Schedule for later
    └── Send ──► Appears in her From Him

Record Voice Screen `/him/record-for-her`
    └── Record ──► Preview ──► Send ──► Appears in her From Him (voice notes)

Schedule Surprise Screen `/him/schedule-surprise`
    └── Date picker + message ──► Scheduled ──► Auto-delivered

Add Song Screen `/him/add-song`
    └── Song title + artist + "because..." note ──► Appears in her From Him (playlist)
```

---

## 6. MOOD GARDEN — HIM'S VIEW MODE

```
Him accesses /garden (view-only mode)
    │
    ├── Views her garden state (flowers from her logs)
    ├── Sees her streak overlay
    └── Water for Her button (once/day) ──► Sparkle animation
                                         ──► She gets notification: "He watered your garden 🌸"
```

---

## 7. ROUTER GUARDS (Auto-Redirects)

```
Him tries to access /cycle           ──► Redirected to /him/care
Her tries to access /him/care        ──► Redirected to /cycle
Him tries to access /him/home        ──► Stays (correct)
Her tries to access /home            ──► Stays (correct)
```

---

## 8. SOLO MODE PATHS (Before Linking)

```
From Him / From Her screen
    └── Empty state: "Share your love code to unlock this space 💕"

Us Screen
    └── Empty state: "Share your code to start your story together 💕"

Settings (always visible)
    └── "My Love Code" ──► Code display ──► Share / Copy / QR
```

---

## 9. NOTIFICATIONS → IN-APP PATHS

```
Him receives "She left you something new"    ──► Opens to From Her Screen
Him receives "She's thinking of you"         ──► Opens to Hug Animation Fullscreen
Him receives "She logged cramps today"       ──► Opens to Care Dashboard Screen
Her receives "He left you something new"     ──► Opens to From Him Screen
Her receives "He's thinking of you"          ──► Opens to Hug Animation Fullscreen
Both receive "X days together streak"        ──► Opens to Us Screen
```

---

## 10. SETTINGS PATHS

```
Settings Screen
    │
    ├── Profile / Display Name (edit)
    ├── My Love Code              ──► Code display + Share
    ├── App Lock                  ──► `/settings/app-lock` (biometric setup)
    ├── Theme (light/dark/auto)
    ├── Notifications preferences
    ├── Relationship Settings
    │       ├── Our Song (set/change)
    │       ├── Anniversary Date
    │       ├── Love Language Quiz ──► `/us/love-languages`
    │       └── Partner Read Access toggle (Her controls — partnerReadEnabled)
    └── Disconnect Partner        ──► Confirmation ──► Solo mode + new code generated
```

---

## 11. FULL SCREEN INVENTORY

| Screen | Route | Who Sees |
|:---|:---|:---|
| Welcome | `/onboarding/welcome` | Both |
| Role Select | `/onboarding/role` | Both |
| Her Name | `/onboarding/her/name` | Her |
| Cycle Setup | `/onboarding/her/cycle` | Her |
| Her Love Code | `/onboarding/her/code` | Her |
| Her Notifications | `/onboarding/her/notifs` | Her |
| Her Ready | `/onboarding/her/ready` | Her |
| Him Name | `/onboarding/him/name` | Him |
| About Her | `/onboarding/him/about` | Him |
| Him Love Code | `/onboarding/him/code` | Him |
| Him Notifications | `/onboarding/him/notifs` | Him |
| Him Ready | `/onboarding/him/ready` | Him |
| Code Entry | `/onboarding/code-entry` | Both |
| Her Home | `/home` | Her |
| Cycle | `/cycle` | Her only |
| Daily Log | `/daily-log/:date` | Her |
| Mood Garden | `/garden` | Her (interactive) · Him (view) |
| From Him | `/from-him` | Her |
| Envelope Open | `/from-him/envelope/:id` | Her |
| Voice Note | `/from-him/voice/:id` | Her |
| Memory Gallery | `/from-him/gallery` | Her |
| Comfort Playlist | `/from-him/playlist` | Her |
| Her Me | `/me` | Her |
| Her Journal | `/journal` | Her |
| Journal Write | `/journal/write` | Her |
| Self-Care | `/self-care` | Her |
| AI Companion | `/companion` | Her |
| Insights | `/insights` | Her |
| Him Home | `/him/home` | Him |
| From Her | `/from-her` | Him |
| Her Envelope Open | `/from-her/envelope/:id` | Him |
| Her Voice Note | `/from-her/voice/:id` | Him |
| Her Memory Gallery | `/from-her/gallery` | Him |
| Her Playlist | `/from-her/playlist` | Him |
| Care Dashboard | `/him/care` | Him only |
| Him Me | `/him/me` | Him |
| Him Journal | `/him/journal` | Him |
| Him Journal Write | `/him/journal/write` | Him |
| Write Message | `/him/write-to-her` | Him |
| Record Voice | `/him/record-for-her` | Him |
| Schedule Surprise | `/him/schedule-surprise` | Him |
| Add Song | `/him/add-song` | Him |
| Him Companion | `/him/companion` | Him |
| Him Insights | `/him/insights` | Him |
| Him Settings | `/him/settings` | Him |
| Us (Relationship) | `/us` | Both |
| Memory Timeline | `/us/memories` | Both |
| Add Memory | `/us/memories/add` | Both |
| Milestones | `/us/milestones` | Both |
| Bucket List | `/us/bucket-list` | Both |
| Monthly Recap | `/us/recap` | Both |
| Question of Day | `/us/question` | Both |
| Love Language | `/us/love-languages` | Both |
| Mood Board | `/us/mood-board` | Both |
| Settings | `/settings` | Both |
| App Lock | `/settings/app-lock` | Both |