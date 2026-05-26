# 🌙 LUNA — Detailed Development Plan (New Tasks)

## 📌 Development Philosophy
- **Dynamic Role Routing**: The app must feel like two different products depending on the user's role (`Her` vs `Him`).
- **Care Language**: "Him" should never see raw cycle data. He sees "How she's doing" and actionable care tips.
- **Cinematic UX**: High-quality animations (flutter_animate), premium typography (Cormorant Garamond), and haptic feedback.
- **Atomic State**: Riverpod-first architecture with consistent role-branching.

---

## 🏗️ Phase 1: The Multi-Role Foundation (Crucial)
*Goal: Fix the navigation and theme to strictly respect the chosen role.*

| ID | Task | Success Criteria | Status |
|:---|:---|:---|:---:|
| 1.1 | Implement `AppRole` & `RoleProvider` | Global provider to track `her` vs `him` | ⚪ Not Started |
| 1.2 | Role-Aware Navigation Bar | Bottom nav dynamically shows 5 items based on role | ⚪ Not Started |
| 1.3 | Unified `AppTheme` Factory | `buildTheme(role)` handles Slate Blue vs Rose Rose palettes | ⚪ Not Started |
| 1.4 | GoRouter Role Guards | Prevents Her from accessing Him screens and vice-versa | ⚪ Not Started |

## 💙 Phase 2: The "Him" Experience (Core Features)
*Goal: Build the companion experience for the partner.*

| ID | Task | Success Criteria | Status |
|:---|:---|:---|:---:|
| 2.1 | `HimHomeScreen` Dashboard | Hero card showing "Today with Her" + emotional pulse | ⚪ Not Started |
| 2.2 | `CareDashboardScreen` | Translates cycle phase into "Care Level" & "Action Tips" | ⚪ Not Started |
| 2.3 | Cycle → Care Utility | Map phase logic to human/emotional language for Him | ⚪ Not Started |
| 2.4 | `HimMeScreen` | Personal stats for him (stress, sleep, mood) | ⚪ Not Started |
| 2.5 | Encrypted Private Journal | AES-256 local-first journal for his own thoughts | ⚪ Not Started |

## 🌸 Phase 3: The "From Her" Experience (Cinematic)
*Goal: The space where he receives her love.*

| ID | Task | Success Criteria | Status |
|:---|:---|:---|:---:|
| 3.1 | `FromHerScreen` | Blue wax seal aesthetic / Mirror of "From Him" | ⚪ Not Started |
| 3.2 | Her Composer Suite | UI for her to send letters, voice, & songs to him | ⚪ Not Started |
| 3.3 | "Open When" Management | System for her to schedule content for him | ⚪ Not Started |

## 🧑‍🤝‍🧑 Phase 4: Deepening "Us" (Shared Intimacy)
*Goal: Beyond the counter — real interaction.*

| ID | Task | Success Criteria | Status |
|:---|:---|:---|:---:|
| 4.1 | "Thinking of You" Ping | Full-screen Rive/Lottie animation triggered by partner | ⚪ Not Started |
| 4.2 | Question of the Day | Daily prompt, hidden answers until both complete | ⚪ Not Started |
| 4.3 | Love Language Quiz | In-app test and shared results comparison | ⚪ Not Started |
| 4.4 | Shared Milestone Timeline | Chronological feed of "Firsts" with photo support | ⚪ Not Started |
| 4.5 | Monthly AI Recap | AI-generated summary of their month (Firestore + LLM) | ⚪ Not Started |

## 🔔 Phase 5: Notification & Polish
*Goal: The heartbeat of the app.*

| ID | Task | Success Criteria | Status |
|:---|:---|:---|:---:|
| 5.1 | Care-Aware FCM | He gets "She might need extra rest" pings | ⚪ Not Started |
| 5.2 | Streak & Milestone Alerts | "Happy 100 days!" notifications | ⚪ Not Started |
| 5.3 | Empty State Illustrations | Custom warm art for all empty lists | ⚪ Not Started |
| 5.4 | Dark Mode Testing | Verifying Slate Blue accessibility in dark mode | ⚪ Not Started |

---

## ✅ Ongoing status tracking
Current Focus: **Phase 1 (The Multi-Role Foundation)**
Next Step: Building `lib/core/role/app_role.dart` and the `RoleProvider`.
