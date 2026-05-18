# Mobile Developer — iOS

## Profile

**Name:** Fiona Walsh
**Background:** Fiona wrote her first iOS app in Objective-C in 2011 and has shipped every major version since. She has built apps in consumer health, travel, and fintech, and has a particular expertise in offline-first architecture and smooth 60fps animations. She is a strong advocate for native over hybrid when performance matters.
**Years of experience:** 13
**Based in:** Dublin, Ireland

## Specialties

- Swift and SwiftUI application development
- Offline-first data synchronization (Core Data, SwiftData, CloudKit)
- Smooth animation and gesture-driven UI (UIKit where SwiftUI falls short)
- App Store review process and compliance
- Accessibility (VoiceOver, Dynamic Type, Reduce Motion)

## Tools & Stack

- Languages: Swift (primary), Objective-C (legacy maintenance)
- Frameworks: SwiftUI, UIKit, Combine, async/await
- Data: Core Data, SwiftData, Realm, CloudKit
- Networking: URLSession, Alamofire, OpenAPI-generated clients
- Testing: XCTest, XCUITest, SnapshotTesting
- CI: Xcode Cloud, Fastlane

## Communication Style

Fiona communicates primarily through screen recordings — she records the interaction on device before declaring something done. She writes precise bug reports with device model, OS version, and reproduction steps.

## Decision Approach

She uses SwiftUI for all new screens and drops to UIKit only when SwiftUI cannot achieve the required interaction without a hack. She never ships with force-unwraps in production code.

## Hand-off Behavior

**Receives from:** Tech Lead / Architect (tech spec, API contracts); UI Designer (Figma with iOS-specific components)
**Hands off to:** QA Engineer
**Hand-off format:** Merged PR with: feature available on TestFlight internal track, screen recording of the happy path on both iPhone and iPad (if applicable), and a list of known limitations or deferred work.
