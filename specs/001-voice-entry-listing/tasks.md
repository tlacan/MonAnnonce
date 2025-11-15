# Tasks: Voice Entry Listing

**Input**: Design documents from `/specs/001-voice-entry-listing/`
**Prerequisites**: plan.md (required), spec.md (required for user stories), research.md, data-model.md, contracts/

**Tests**: Tests are included as per constitution requirement (TDD is NON-NEGOTIABLE). All tests MUST be written using Swift Testing framework before implementation.

**Organization**: Tasks are grouped by user story to enable independent implementation and testing of each story.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2, US3)
- Include exact file paths in descriptions

## Path Conventions

Following Clean Architecture structure in `Packages/` directory:
- Domain layer: `Packages/Domain/VoiceEntry/`
- Data layer: `Packages/Data/VoiceEntry/`
- Presentation layer: `Packages/Presentation/VoiceEntry/`
- Main app: `mainApp/MonAnnonce/`

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Project initialization and basic structure

- [ ] T001 [P] Configure Tuist project structure with Project.swift and Tuist.swift
- [ ] T002 [P] Configure SwiftLint and SwiftFormat with project rules
- [ ] T003 [P] Create Localizable.xcstrings file in mainApp/MonAnnonce/Resources/ with English and French strings
- [ ] T004 [P] Setup Info.plist with required permissions (microphone, speech recognition, camera, photo library)
- [ ] T005 Create project structure per implementation plan in Packages/Domain/VoiceEntry/, Packages/Data/VoiceEntry/, Packages/Presentation/VoiceEntry/
---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Core infrastructure that MUST be complete before ANY user story can be implemented

**⚠️ CRITICAL**: No user story work can begin until this phase is complete

- [ ] T006 Create Entry domain entity protocol in Packages/Domain/VoiceEntry/Entities/Entry.swift with structured fields (id: String, brand: String, color: String, description: String, is_unisex: Bool, measurement_length: Double, measurement_width: Double, price: Double, size: String, status: String, title: String) and images property
- [ ] T007 Create EntryModel SwiftData model in Packages/Data/VoiceEntry/Models/EntryModel.swift with @Model macro including structured fields (id: String, brand: String, color: String, description: String, is_unisex: Bool, measurement_length: Double, measurement_width: Double, price: Double, size: String, status: String, title: String), transcribedText (for reference), and images array
- [ ] T008 Create EntryRepository protocol in Packages/Domain/VoiceEntry/Repositories/EntryRepository.swift
- [ ] T009 Create EntryRepository implementation in Packages/Data/VoiceEntry/Repositories/EntryRepository.swift
- [ ] T010 Create error types (RecordingError, TranscriptionError, EmailError, DataError, ImageError, TextExtractionError) in Packages/Domain/VoiceEntry/Errors/
- [ ] T011 Setup SwiftData ModelContainer in mainApp/MonAnnonce/App.swift with EntryModel schema
- [ ] T012 Create app entry point App.swift in mainApp/MonAnnonce/App.swift with ModelContainer injection

**Checkpoint**: Foundation ready - user story implementation can now begin in parallel

---

## Phase 3: User Story 1 - View List of Entries (Priority: P1) 🎯 MVP

**Goal**: Display a list of all entries sorted by creation date (newest first) with empty state support

**Independent Test**: Can be fully tested by displaying a list of pre-populated test entries. The user can verify that entries are displayed correctly, sorted appropriately, and show key information.

### Tests for User Story 1

> **NOTE: Write these tests FIRST, ensure they FAIL before implementation**

- [ ] T013 [P] [US1] Create test for ListEntriesUseCase in Tests/VoiceEntry/Domain/UseCases/ListEntriesUseCaseTests.swift
- [ ] T014 [P] [US1] Create test for EntryListViewModel in Tests/VoiceEntry/Presentation/ViewModels/EntryListViewModelTests.swift
- [ ] T015 [P] [US1] Create test for EntryListView preview in Tests/VoiceEntry/Presentation/Views/EntryListViewTests.swift
- [ ] T016 [P] [US1] Create test for structured entry fields display in Tests/VoiceEntry/Presentation/Views/EntryListViewTests.swift

### Implementation for User Story 1

- [ ] T017 [P] [US1] Create ListEntriesUseCase in Packages/Domain/VoiceEntry/UseCases/ListEntriesUseCase.swift
- [ ] T018 [US1] Create EntryListViewModel in Packages/Presentation/VoiceEntry/ViewModels/EntryListViewModel.swift with @MainActor
- [ ] T019 [US1] Create EntryListView in Packages/Presentation/VoiceEntry/Views/EntryListView.swift with SwiftUI Previews
- [ ] T020 [US1] Display structured entry fields (id, brand, color, description, is_unisex, measurement_length, measurement_width, price, size, status, title) in EntryListView entry items
- [ ] T021 [US1] Create VoiceEntryCoordinator in Packages/Presentation/VoiceEntry/Coordinators/VoiceEntryCoordinator.swift
- [ ] T022 [US1] Integrate EntryListView with coordinator in mainApp/MonAnnonce/App.swift
- [ ] T023 [US1] Add localization strings for entry list (empty state, date format, field labels) in mainApp/MonAnnonce/Resources/Localizable.xcstrings
- [ ] T024 [US1] Add accessibility labels and VoiceOver support to EntryListView
- [ ] T025 [US1] Ensure EntryListView adapts to iPhone and iPad screen sizes with SwiftUI size classes

**Checkpoint**: At this point, User Story 1 should be fully functional and testable independently. Users can view entries in a list with proper sorting and empty state.

---

## Phase 4: User Story 2 - Create Entry via Voice Recording (Priority: P2)

**Goal**: Allow users to create new entries by recording voice, transcribing audio to text, extracting structured data using FoundationModels, and saving as Entry entity with structured fields

**Independent Test**: Can be fully tested by recording a voice message in French (e.g., "Id: SKU-12345, Brand: Levi's, Color: blue, Description: Vintage denim jacket size M, Is unisex: true, Measurement length: 70, Measurement width: 50, Price: 45, Size: M, Status: good, Title: Vintage Levi's Jacket"), verifying transcription occurs, FoundationModels extracts structured fields, and confirming a new entry appears in the list with extracted data.

### Tests for User Story 2

> **NOTE: Write these tests FIRST, ensure they FAIL before implementation**

- [ ] T026 [P] [US2] Create test for AudioRecordingService in Tests/VoiceEntry/Data/Services/AudioRecordingServiceTests.swift
- [ ] T027 [P] [US2] Create test for SpeechTranscriptionService in Tests/VoiceEntry/Data/Services/SpeechTranscriptionServiceTests.swift
- [ ] T028 [P] [US2] Create test for FoundationModelsTextExtractionService in Tests/VoiceEntry/Data/Services/FoundationModelsTextExtractionServiceTests.swift
- [ ] T029 [P] [US2] Create test for CreateEntryUseCase in Tests/VoiceEntry/Domain/UseCases/CreateEntryUseCaseTests.swift
- [ ] T030 [P] [US2] Create test for TranscribeAudioUseCase in Tests/VoiceEntry/Domain/UseCases/TranscribeAudioUseCaseTests.swift
- [ ] T031 [P] [US2] Create test for ExtractStructuredDataUseCase in Tests/VoiceEntry/Domain/UseCases/ExtractStructuredDataUseCaseTests.swift
- [ ] T032 [P] [US2] Create test for RecordingViewModel in Tests/VoiceEntry/Presentation/ViewModels/RecordingViewModelTests.swift

### Implementation for User Story 2

- [ ] T033 [P] [US2] Create AudioRecordingService protocol in Packages/Data/VoiceEntry/Services/AudioRecordingService.swift
- [ ] T034 [P] [US2] Create AudioRecordingService implementation in Packages/Data/VoiceEntry/Services/AVFoundationAudioRecordingService.swift using AVFoundation
- [ ] T035 [P] [US2] Create SpeechTranscriptionService protocol in Packages/Data/VoiceEntry/Services/SpeechTranscriptionService.swift
- [ ] T036 [P] [US2] Create SpeechTranscriptionService implementation in Packages/Data/VoiceEntry/Services/SpeechFrameworkTranscriptionService.swift using Speech framework
- [ ] T037 [P] [US2] Create FoundationModelsTextExtractionService protocol in Packages/Data/VoiceEntry/Services/FoundationModelsTextExtractionService.swift
- [ ] T038 [P] [US2] Create FoundationModelsTextExtractionService implementation in Packages/Data/VoiceEntry/Services/AppleFoundationModelsTextExtractionService.swift using Apple FoundationModels framework
- [ ] T039 [US2] Create ExtractStructuredDataUseCase in Packages/Domain/VoiceEntry/UseCases/ExtractStructuredDataUseCase.swift to extract structured fields (id, brand, color, description, is_unisex, measurement_length, measurement_width, price, size, status, title) from transcribed text
- [ ] T040 [US2] Create CreateEntryUseCase in Packages/Domain/VoiceEntry/UseCases/CreateEntryUseCase.swift with structured fields
- [ ] T041 [US2] Create TranscribeAudioUseCase in Packages/Domain/VoiceEntry/UseCases/TranscribeAudioUseCase.swift
- [ ] T042 [US2] Create RecordingViewModel in Packages/Presentation/VoiceEntry/ViewModels/RecordingViewModel.swift with @MainActor
- [ ] T043 [US2] Create RecordingView in Packages/Presentation/VoiceEntry/Views/RecordingView.swift with SwiftUI Previews
- [ ] T044 [US2] Implement microphone permission request flow in RecordingViewModel
- [ ] T045 [US2] Implement speech recognition permission request flow in RecordingViewModel
- [ ] T046 [US2] Integrate FoundationModels text extraction into recording flow (transcribe → extract structured data → create entry)
- [ ] T047 [US2] Add recording button to EntryListView with navigation to RecordingView
- [ ] T048 [US2] Integrate recording flow with coordinator in VoiceEntryCoordinator.swift
- [ ] T049 [US2] Add error handling and display for recording/transcription/extraction failures in RecordingView
- [ ] T050 [US2] Add localization strings for recording (permissions, errors, UI, field labels) in mainApp/MonAnnonce/Resources/Localizable.xcstrings
- [ ] T051 [US2] Add accessibility labels and VoiceOver support to RecordingView
- [ ] T052 [US2] Ensure RecordingView adapts to iPhone and iPad screen sizes

**Checkpoint**: At this point, User Story 2 should be fully functional. Users can record voice, transcribe to text, extract structured data using FoundationModels (id, brand, color, description, is_unisex, measurement_length, measurement_width, price, size, status, title), and create entries with structured fields that appear in the list.

---

## Phase 5: User Story 3 - Send Email on Entry Creation (Priority: P3)

**Goal**: Automatically send email to hardcoded Gmail address when a new entry is created

**Independent Test**: Can be fully tested by creating a new entry and verifying that an email is sent to the hardcoded Gmail address with the transcribed text.

### Tests for User Story 3

> **NOTE: Write these tests FIRST, ensure they FAIL before implementation**

- [ ] T053 [P] [US3] Create test for EmailService in Tests/VoiceEntry/Data/Services/EmailServiceTests.swift
- [ ] T054 [P] [US3] Create test for SendEmailUseCase in Tests/VoiceEntry/Domain/UseCases/SendEmailUseCaseTests.swift

### Implementation for User Story 3

- [ ] T055 [P] [US3] Create EmailService protocol in Packages/Data/VoiceEntry/Services/EmailService.swift
- [ ] T056 [P] [US3] Create EmailService implementation in Packages/Data/VoiceEntry/Services/MessageUIEmailService.swift using MessageUI framework
- [ ] T057 [US3] Create SendEmailUseCase in Packages/Domain/VoiceEntry/UseCases/SendEmailUseCase.swift
- [ ] T058 [US3] Integrate email sending into CreateEntryUseCase after entry creation
- [ ] T059 [US3] Update EntryModel emailSent and lastEmailSentDate when email is sent successfully
- [ ] T060 [US3] Add email status indicator to EntryListView entry items
- [ ] T061 [US3] Update email body to include structured entry fields (id, brand, color, description, is_unisex, measurement_length, measurement_width, price, size, status, title) in addition to transcribed text
- [ ] T062 [US3] Add error handling for email sending failures (entry still created, marked as not sent)
- [ ] T063 [US3] Add localization strings for email (status, errors) in mainApp/MonAnnonce/Resources/Localizable.xcstrings
- [ ] T064 [US3] Configure hardcoded Gmail recipient address in app configuration

**Checkpoint**: At this point, User Story 3 should be fully functional. New entries automatically trigger email sending with proper status tracking.

---

## Phase 6: User Story 4 - Resend Email for Existing Entry (Priority: P4)

**Goal**: Allow users to resend email for any existing entry

**Independent Test**: Can be fully tested by selecting an existing entry and tapping the resend email button, then verifying that an email is sent.

### Tests for User Story 4

> **NOTE: Write these tests FIRST, ensure they FAIL before implementation**

- [ ] T065 [P] [US4] Create test for resend email functionality in EntryDetailViewModel in Tests/VoiceEntry/Presentation/ViewModels/EntryDetailViewModelTests.swift

### Implementation for User Story 4

- [ ] T066 [US4] Create EntryDetailViewModel in Packages/Presentation/VoiceEntry/ViewModels/EntryDetailViewModel.swift with @MainActor
- [ ] T067 [US4] Create EntryDetailView in Packages/Presentation/VoiceEntry/Views/EntryDetailView.swift with SwiftUI Previews
- [ ] T068 [US4] Display structured entry fields (id, brand, color, description, is_unisex, measurement_length, measurement_width, price, size, status, title) in EntryDetailView
- [ ] T069 [US4] Add resend email button to EntryDetailView
- [ ] T070 [US4] Implement resend email functionality in EntryDetailViewModel using SendEmailUseCase
- [ ] T071 [US4] Update EntryModel emailSent and lastEmailSentDate when resend succeeds
- [ ] T072 [US4] Add navigation from EntryListView to EntryDetailView in VoiceEntryCoordinator.swift
- [ ] T073 [US4] Add success/error messages for resend email operation
- [ ] T074 [US4] Add localization strings for entry detail and resend (UI, messages, field labels) in mainApp/MonAnnonce/Resources/Localizable.xcstrings
- [ ] T075 [US4] Add accessibility labels and VoiceOver support to EntryDetailView
- [ ] T076 [US4] Ensure EntryDetailView adapts to iPhone and iPad screen sizes

**Checkpoint**: At this point, User Story 4 should be fully functional. Users can view entry details and resend emails for any entry.

---

## Phase 7: User Story 5 - Add Images to Entry (Priority: P5)

**Goal**: Allow users to add images to entries from photo library or camera

**Independent Test**: Can be fully tested by selecting an existing entry, adding images from photo library or camera, and verifying images are saved and displayed with the entry.

### Tests for User Story 5

> **NOTE: Write these tests FIRST, ensure they FAIL before implementation**

- [ ] T077 [P] [US5] Create test for ImagePickerService in Tests/VoiceEntry/Data/Services/ImagePickerServiceTests.swift
- [ ] T078 [P] [US5] Create test for AddImageToEntryUseCase in Tests/VoiceEntry/Domain/UseCases/AddImageToEntryUseCaseTests.swift
- [ ] T079 [P] [US5] Create test for image functionality in EntryDetailViewModel in Tests/VoiceEntry/Presentation/ViewModels/EntryDetailViewModelTests.swift

### Implementation for User Story 5

- [ ] T080 [P] [US5] Create ImagePickerService protocol in Packages/Data/VoiceEntry/Services/ImagePickerService.swift
- [ ] T081 [P] [US5] Create ImagePickerService implementation in Packages/Data/VoiceEntry/Services/UIKitImagePickerService.swift using UIImagePickerController
- [ ] T082 [US5] Create AddImageToEntryUseCase in Packages/Domain/VoiceEntry/UseCases/AddImageToEntryUseCase.swift
- [ ] T083 [US5] Update EntryModel to store images array (URLs to saved image files) in Packages/Data/VoiceEntry/Models/EntryModel.swift
- [ ] T084 [US5] Implement image saving to app's document directory in ImagePickerService
- [ ] T085 [US5] Add image picker button to EntryDetailView (photo library and camera options)
- [ ] T086 [US5] Implement photo library permission request flow in EntryDetailViewModel
- [ ] T087 [US5] Implement camera permission request flow in EntryDetailViewModel
- [ ] T088 [US5] Add image display to EntryDetailView showing all images associated with entry
- [ ] T089 [US5] Add image display to EntryListView entry items (thumbnail or count indicator)
- [ ] T090 [US5] Integrate image picker with EntryDetailViewModel using ImagePickerService
- [ ] T091 [US5] Add error handling for image picker failures (permissions denied, save failures)
- [ ] T092 [US5] Add localization strings for image functionality (permissions, UI, errors) in mainApp/MonAnnonce/Resources/Localizable.xcstrings
- [ ] T093 [US5] Add accessibility labels and VoiceOver support for image picker and image display
- [ ] T094 [US5] Ensure image picker and display adapt to iPhone and iPad screen sizes
- [ ] T095 [US5] Update email service to optionally include images as attachments in Packages/Data/VoiceEntry/Services/MessageUIEmailService.swift

**Checkpoint**: At this point, User Story 5 should be fully functional. Users can add images to entries from photo library or camera, and images are displayed with entries.

---

## Phase 8: Polish & Cross-Cutting Concerns

**Purpose**: Improvements that affect multiple user stories

- [ ] T096 [P] Run SwiftLint and SwiftFormat on all code files
- [ ] T097 [P] Verify all Swift 6.2 concurrency patterns are correctly implemented (async/await, @MainActor, actors)
- [ ] T098 [P] Verify all views have SwiftUI Previews with multiple states (loading, error, success, empty)
- [ ] T099 [P] Test app on both iPhone and iPad simulators using Xcode MCP
- [ ] T100 [P] Test accessibility with VoiceOver enabled
- [ ] T101 [P] Test Dynamic Type with largest text size
- [ ] T102 [P] Verify all user-facing strings are localized in English and French
- [ ] T103 [P] Test error handling scenarios (permissions denied, network failures, transcription failures, text extraction failures, image picker failures)
- [ ] T104 [P] Verify Clean Architecture layer separation (no circular dependencies)
- [ ] T105 [P] Run quickstart.md validation scenarios
- [ ] T106 [P] Performance testing (entry list load time, transcription time, FoundationModels extraction time, email send time, image loading)
- [ ] T107 [P] Code review for constitution compliance (Swift 6.2 concurrency, Clean Architecture, accessibility, localization)
- [ ] T108 [P] Test FoundationModels text extraction with various French input formats and edge cases

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies - can start immediately
- **Foundational (Phase 2)**: Depends on Setup completion - BLOCKS all user stories
- **User Stories (Phase 3+)**: All depend on Foundational phase completion
  - User stories can then proceed in parallel (if staffed)
  - Or sequentially in priority order (P1 → P2 → P3 → P4 → P5)
- **Polish (Final Phase)**: Depends on all desired user stories being complete

### User Story Dependencies

- **User Story 1 (P1)**: Can start after Foundational (Phase 2) - No dependencies on other stories
- **User Story 2 (P2)**: Can start after Foundational (Phase 2) - Depends on US1 for displaying new entries in list
- **User Story 3 (P3)**: Can start after Foundational (Phase 2) - Depends on US2 for entry creation flow
- **User Story 4 (P4)**: Can start after Foundational (Phase 2) - Depends on US1 for entry list, can work with any existing entry
- **User Story 5 (P5)**: Can start after Foundational (Phase 2) - Depends on US4 for EntryDetailView, can work with any existing entry

### Within Each User Story

- Tests (if included) MUST be written and FAIL before implementation
- Domain layer (entities, use cases) before Data layer (repositories, services)
- Data layer before Presentation layer (ViewModels, Views)
- Services before ViewModels
- ViewModels before Views
- Core implementation before integration
- Story complete before moving to next priority

### Parallel Opportunities

- All Setup tasks marked [P] can run in parallel
- All Foundational tasks marked [P] can run in parallel (within Phase 2)
- Once Foundational phase completes, user stories can start in parallel (if team capacity allows)
- All tests for a user story marked [P] can run in parallel
- Domain use cases within a story marked [P] can run in parallel
- Data services within a story marked [P] can run in parallel
- Different user stories can be worked on in parallel by different team members (with coordination)

---

## Parallel Example: User Story 2

```bash
# Launch all tests for User Story 2 together:
Task: "Create test for AudioRecordingService in Tests/VoiceEntry/Data/Services/AudioRecordingServiceTests.swift"
Task: "Create test for SpeechTranscriptionService in Tests/VoiceEntry/Data/Services/SpeechTranscriptionServiceTests.swift"
Task: "Create test for CreateEntryUseCase in Tests/VoiceEntry/Domain/UseCases/CreateEntryUseCaseTests.swift"
Task: "Create test for TranscribeAudioUseCase in Tests/VoiceEntry/Domain/UseCases/TranscribeAudioUseCaseTests.swift"
Task: "Create test for RecordingViewModel in Tests/VoiceEntry/Presentation/ViewModels/RecordingViewModelTests.swift"

# Launch all service protocols together:
Task: "Create AudioRecordingService protocol in Packages/Data/VoiceEntry/Services/AudioRecordingService.swift"
Task: "Create SpeechTranscriptionService protocol in Packages/Data/VoiceEntry/Services/SpeechTranscriptionService.swift"

# Launch all service implementations together (after protocols):
Task: "Create AudioRecordingService implementation in Packages/Data/VoiceEntry/Services/AVFoundationAudioRecordingService.swift"
Task: "Create SpeechTranscriptionService implementation in Packages/Data/VoiceEntry/Services/SpeechFrameworkTranscriptionService.swift"
```

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1: Setup
2. Complete Phase 2: Foundational (CRITICAL - blocks all stories)
3. Complete Phase 3: User Story 1
4. **STOP and VALIDATE**: Test User Story 1 independently with test data
5. Deploy/demo if ready

### Incremental Delivery

1. Complete Setup + Foundational → Foundation ready
2. Add User Story 1 → Test independently → Deploy/Demo (MVP!)
3. Add User Story 2 → Test independently → Deploy/Demo
4. Add User Story 3 → Test independently → Deploy/Demo
5. Add User Story 4 → Test independently → Deploy/Demo
6. Each story adds value without breaking previous stories

### Parallel Team Strategy

With multiple developers:

1. Team completes Setup + Foundational together
2. Once Foundational is done:
   - Developer A: User Story 1
   - Developer B: User Story 2 (after US1 complete)
   - Developer C: User Story 3 (after US2 complete)
   - Developer D: User Story 4 (can start after US1, works with existing entries)
3. Stories complete and integrate independently

---

## Notes

- [P] tasks = different files, no dependencies
- [Story] label maps task to specific user story for traceability
- Each user story should be independently completable and testable
- Verify tests fail before implementing
- Commit after each task or logical group
- Stop at any checkpoint to validate story independently
- Avoid: vague tasks, same file conflicts, cross-story dependencies that break independence
- All code must pass SwiftLint and SwiftFormat
- All code must use Swift 6.2 concurrency patterns
- All views must have SwiftUI Previews
- All views must support iPhone and iPad
- All views must be accessible (VoiceOver, Dynamic Type)
- All strings must be localized (English and French)
- Image picker must support both photo library and camera
- Images must be saved to app's document directory with proper file management
- FoundationModels must extract structured fields (id, brand, color, description, is_unisex, measurement_length, measurement_width, price, size, status, title) from transcribed French text
- Entry entity must store both transcribedText (for reference) and structured fields (for display and email)
- Text extraction must handle various French input formats and edge cases gracefully

