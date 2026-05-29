# Implementation Plan — Luna Leftovers & Role-Based AI Garden

This plan details the steps required to complete the leftover stubs in the Luna application and implement the Garden tab with the companion AI chat feature for the **Him (💙)** role, matching the functionality in the **Her (🌸)** role.

---

## User Review Required

> [!IMPORTANT]
> **Unified Navigation Symmetry (6 Tabs for Him)**
> To support the `Garden` tab along with Him's specific screens (`Care Dashboard`, `From Her` inbox, and `Us` shared space), we propose shifting Him's bottom navigation bar from 5 tabs to **6 tabs**:
> `[Home] [Her (Care)] [Garden] [From Her] [Us] [Me]`
> This guarantees full functional parity with Her's layout and matches our architectural requirements perfectly.

---

## Proposed Changes

### 🧑‍🤝‍🧑 Core Shared / Navigation Component

#### [MODIFY] [home_screen.dart](file:///d:/flutter_projects/her/lib/features/home/presentation/home_screen.dart)
*   Update `HomeScreen` to render **6 navigation tabs** for Him when the role is `AppRole.him`.
*   Map index `2` to the `/garden` route, index `3` to `/from-her`, index `4` to `/us`, and index `5` to `/profile`.
*   Add a new `BottomNavigationBarItem` with a `spa_outlined` / `spa` (garden) icon and label `'Garden'` to Him's navigation bar.

#### [MODIFY] [app_router.dart](file:///d:/flutter_projects/her/lib/core/router/app_router.dart)
*   **De-stub Us route**: Replace the blank `Scaffold` builder for `/us` with `const RelationshipScreen()`.
*   **De-stub Her Care Dashboard**: Replace the blank `Scaffold` builder for `/him/care` with `const CareDashboard()`.
*   **De-stub From Her route**: Replace the blank `Scaffold` builder for `/from-her` with `const FromHerScreen()`.

---

### 🌿 Garden & AI Companion Component

#### [MODIFY] [mood_garden_screen.dart](file:///d:/flutter_projects/her/lib/features/mood_garden/presentation/mood_garden_screen.dart)
*   Add dynamic data loading based on `AppRole`:
    *   If the user is `her`, watch the local `dashboardProvider`.
    *   If the user is `him`, watch `partnerProfileProvider` and `partnerCycleEntriesProvider` to retrieve her status.
*   Compute cycle day and phase for Him using `CycleCalculator.calculate(partnerEntries)`.
*   Update HUD top text to say `"Her Garden 🌿"` and `"Blooming in response to her daily checks."` when Him is logged in.
*   Keep the beautiful full-bleed custom-painter canvas (`GardenCanvas`) rendering her active state.
*   Ensure the "Open Companion Chat" button points to `/companion` as usual.

#### [MODIFY] [companion_screen.dart](file:///d:/flutter_projects/her/lib/features/mood_garden/presentation/companion_screen.dart)
*   Identify the user's role using `authProvider`.
*   **Role-Aware Summary Prompt (`@summarize`)**:
    *   If `isHim` is true, change the `@summarize` trigger to query `partnerCycleEntriesProvider` and `partnerProfileProvider` to write a specialized support and care recommendation prompt (e.g. *"Provide an actionable summary of my partner's cycle day and how I can best support her"*).
    *   If `isHer` is true, preserve the existing self-summary behavior.
*   Customize empty placeholder text:
    *   For Him: *"A peaceful chat room where you can get immediate, loving suggestions on how to care for her today."*

---

### 💙 Him Specific Dashboard & Inbox

#### [MODIFY] [him_home_tab.dart](file:///d:/flutter_projects/her/lib/features/home/presentation/him_home_tab.dart)
*   De-mock static follicular variables:
    *   Watch `partnerProfileProvider` and `partnerCycleEntriesProvider` to compute her live cycle statistics.
    *   Update `_buildHerMoodCard` to display her actual current phase name and cycle day (e.g., `"Menstrual · Day 3"`).
    *   Update `_buildCareTipCard` to dynamically load and display a real care description from `CycleCalculator.getSupportTips(phase)` or a caring suggestion based on her logged phase.
*   De-mock "Days Together":
    *   Watch her couple relationship stream and calculate the exact elapsed days since their custom anniversary date, syncing in real-time.

#### [NEW] [from_her_screen.dart](file:///d:/flutter_projects/her/lib/features/from_him/presentation/from_her_screen.dart)
*   Implement a gorgeous, customized **From Her (FromHerScreen)** companion page:
    *   Render using a sleek slate-blue and silver-wax aesthetic.
    *   Display custom envelopes Her role leaves for Him.
    *   Integrate memories, playlists, and love letters composed by Her for Him.
    *   Include a virtual hug or interactive appreciation button to send sparks back to Her device!

---

## Verification Plan

### Automated / Manual Verification
1.  **Tab Verification**: Verify that logging in as Him renders all 6 tabs correctly: Home, Her Care, Garden, From Her, Us, and Me/Profile.
2.  **State Calculations**: Verify that when logging in as Him, the Home tab, Care Dashboard, and Garden canvas correctly pull Her active period logs, calculating cycle stats identically.
3.  **Chat Parity**: Test the Luna Companion chat `@summarize` command as both Her and Him to verify that Him receives guidance on her cycle while She receives self-care advice.
