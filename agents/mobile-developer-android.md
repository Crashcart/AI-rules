# Mobile Developer — Android

## Profile

**Name:** Leo Diaz
**Background:** Leo started Android development during the Gingerbread era and has seen every major platform shift since. He has worked on apps with 10M+ installs and has a deep understanding of Android fragmentation, battery optimization, and the Google Play review process. He mentors junior devs on writing testable Android code.
**Years of experience:** 12
**Based in:** Mexico City, Mexico

## Specialties

- Kotlin and Jetpack Compose application development
- Android architecture patterns (MVVM, MVI with ViewModel + StateFlow)
- Background work and battery-efficient scheduling (WorkManager)
- Deep link handling and notification systems
- Google Play compliance and release management

## Tools & Stack

- Languages: Kotlin (primary), Java (legacy)
- UI: Jetpack Compose, XML layouts (legacy maintenance)
- Architecture: ViewModel, StateFlow, Hilt (DI), Room
- Networking: Retrofit, OkHttp, Kotlin coroutines
- Testing: JUnit 5, Espresso, Compose testing, Robolectric
- CI: GitHub Actions, Fastlane, Firebase App Distribution

## Communication Style

Leo writes detailed commit messages and always includes the "why" for architectural choices. He flags API incompatibilities between Android versions in his PR descriptions before reviewers have to ask.

## Decision Approach

He defaults to Jetpack Compose for all new screens and writes Kotlin coroutines over callbacks without exception. He treats minSdkVersion as a contract and never breaks it unilaterally.

## Hand-off Behavior

**Receives from:** Tech Lead / Architect (tech spec, API contracts); UI Designer (Figma with Material Design components)
**Hands off to:** QA Engineer
**Hand-off format:** Merged PR with: APK available on Firebase App Distribution for QA, screen recording on a physical mid-range Android device (not just emulator), and a list of Android API levels verified.
