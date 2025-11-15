# Implementation Plan: Voice Entry Listing

**Branch**: `001-voice-entry-listing` | **Date**: 2025-11-15 | **Spec**: [spec.md](./spec.md)

**Input**: Feature specification from `/specs/001-voice-entry-listing/spec.md`

**Note**: This template is filled in by the `/speckit.plan` command. See `.specify/templates/commands/plan.md` for the execution workflow.

## Summary

Build an iOS application that allows users to create entries by recording voice, transcribing the audio to text, storing entries using SwiftData, and automatically sending emails. The app uses native Apple frameworks (AVFoundation for audio recording, Speech framework for transcription, MessageUI for email) with Swift 6.2 concurrency patterns and Clean Architecture with MVVM.

## Technical Context

**Language/Version**: Swift 6.2 (MANDATORY)

**Primary Dependencies**: 
- SwiftUI (UI framework)
- AVFoundation (audio recording)
- Speech (speech recognition/transcription)
- MessageUI (email composition and sending)
- SwiftData (data persistence)
- Combine (reactive programming)
- Swift Testing (testing framework)

**Storage**: SwiftData framework (MANDATORY) - type-safe, declarative data modeling and persistence

**Testing**: Swift Testing framework (not XCTest) - use `@Test` macro, `@Suite` macro, `#expect` for assertions

**Target Platform**: iOS 26.0+ (MANDATORY), iPhone and iPad (MANDATORY)

**Project Type**: Mobile (iOS) - Clean Architecture with MVVM pattern

**Performance Goals**: 
- Entry list loads within 1 second (SC-001)
- Voice recording and transcription completes in under 30 seconds for recordings up to 2 minutes (SC-002)
- Email sending completes within 5 seconds under normal network conditions (SC-004)
- Resend email completes within 3 seconds (SC-006)

**Constraints**: 
- Must use native Apple frameworks only (avoid external libraries)
- Must support offline voice recording (audio can be recorded without network)
- Transcription requires network connection (Speech framework may use on-device or cloud)
- Email sending requires network connection
- Must handle microphone and email permissions gracefully
- Must work on both iPhone and iPad with adaptive layouts
- Must be accessible (VoiceOver, Dynamic Type, WCAG AA contrast)

**Scale/Scope**: 
- Single-user application
- Expected entries: hundreds to thousands per user
- Audio recordings: typically 30 seconds to 5 minutes per entry
- Two UI languages: English and French

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

### Pre-Research Gates

✅ **Swift 6.2 Concurrency (MANDATORY)**: All async operations will use `async`/`await`, structured concurrency with `Task`/`TaskGroup`, actor isolation for shared state, `@MainActor` for UI code

✅ **Clean Architecture with MVVM (MANDATORY)**: Architecture will follow Clean Architecture with MVVM - Presentation (SwiftUI views/ViewModels), Domain (entities/use cases), Data (SwiftData models/repositories)

✅ **Platform Compatibility (MANDATORY)**: App will support both iPhone and iPad with adaptive layouts using SwiftUI size classes

✅ **SwiftData Persistence (MANDATORY)**: All data persistence will use SwiftData framework with `@Model` macro

✅ **Test-Driven Development (MANDATORY)**: All features will be tested using Xcode MCP and Swift Testing framework before implementation

✅ **Accessibility Compliance (MANDATORY)**: All UI elements will have proper accessibility labels, VoiceOver support, Dynamic Type, WCAG AA contrast

✅ **Code Quality (MANDATORY)**: All code will pass SwiftLint and SwiftFormat checks, follow Swift API Design Guidelines

✅ **Localization (MANDATORY)**: All user-facing strings will use xcstrings files for English and French

### Post-Design Gates

✅ **Swift 6.2 Concurrency (MANDATORY)**: All services use `async`/`await`, `Task` for concurrent operations, `@MainActor` for UI updates

✅ **Clean Architecture with MVVM (MANDATORY)**: Architecture follows Clean Architecture - Domain (Entry entity, use cases), Data (EntryModel, repositories, services), Presentation (SwiftUI views, ViewModels, Coordinator)

✅ **Platform Compatibility (MANDATORY)**: SwiftUI views use adaptive layouts, size classes, responsive design for iPhone and iPad

✅ **SwiftData Persistence (MANDATORY)**: EntryModel uses `@Model` macro, ModelContext for operations

✅ **Test-Driven Development (MANDATORY)**: All features will be tested with Xcode MCP and Swift Testing framework

✅ **Accessibility Compliance (MANDATORY)**: All UI elements will have accessibility labels, VoiceOver support, Dynamic Type support

✅ **Code Quality (MANDATORY)**: All code will pass SwiftLint and SwiftFormat, follow Swift API Design Guidelines

✅ **Localization (MANDATORY)**: All strings will use xcstrings files for English and French

**All gates passed - design is constitution-compliant**

## Project Structure

### Documentation (this feature)

```text
specs/001-voice-entry-listing/
├── plan.md              # This file (/speckit.plan command output)
├── research.md          # Phase 0 output (/speckit.plan command)
├── data-model.md        # Phase 1 output (/speckit.plan command)
├── quickstart.md        # Phase 1 output (/speckit.plan command)
├── contracts/           # Phase 1 output (/speckit.plan command)
└── tasks.md             # Phase 2 output (/speckit.tasks command - NOT created by /speckit.plan)
```

### Source Code (repository root)

Following Clean Architecture with MVVM pattern in `Packages/` directory:

```text
Packages/
├── Domain/
│   └── VoiceEntry/
│       ├── Entities/
│       │   └── Entry.swift              # Domain entity (protocol/struct)
│       └── UseCases/
│           ├── CreateEntryUseCase.swift
│           ├── ListEntriesUseCase.swift
│           ├── TranscribeAudioUseCase.swift
│           └── SendEmailUseCase.swift
│
├── Data/
│   └── VoiceEntry/
│       ├── Models/
│       │   └── EntryModel.swift         # SwiftData @Model
│       ├── Repositories/
│       │   └── EntryRepository.swift    # Implements domain repository protocol
│       └── Services/
│           ├── AudioRecordingService.swift
│           ├── SpeechTranscriptionService.swift
│           └── EmailService.swift
│
└── Presentation/
    └── VoiceEntry/
        ├── Views/
        │   ├── EntryListView.swift
        │   ├── RecordingView.swift
        │   └── EntryDetailView.swift
        ├── ViewModels/
        │   ├── EntryListViewModel.swift
        │   ├── RecordingViewModel.swift
        │   └── EntryDetailViewModel.swift
        └── Coordinators/
            └── VoiceEntryCoordinator.swift

mainApp/
└── MonAnnonce/
    ├── App.swift                        # App entry point
    └── Resources/
        └── Localizable.xcstrings       # English and French strings

Tests/
└── VoiceEntry/
    ├── Domain/
    │   └── UseCases/
    ├── Data/
    │   └── Repositories/
    └── Presentation/
        └── ViewModels/
```

**Structure Decision**: Using Clean Architecture with MVVM pattern organized in `Packages/` directory as folders (not separate Swift Packages). Domain layer is independent, Data layer depends on Domain, Presentation layer depends on Domain. This ensures separation of concerns, testability, and maintainability while following the constitution requirements.

## Complexity Tracking

> **Fill ONLY if Constitution Check has violations that must be justified**

*No violations - all architecture decisions align with constitution requirements*
