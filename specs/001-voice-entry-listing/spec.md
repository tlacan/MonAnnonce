# Feature Specification: Voice Entry Listing

**Feature Branch**: `001-voice-entry-listing`  
**Created**: 2025-11-15  
**Status**: Draft  
**Input**: User description: "Build an iOS application which make a Listing of Entries for me. I may create a new entry by making a new voice record. The voice record will be transcripted to the app, It will fill an Entity object. Then it will send a new mail to a hardcoded gmail address. A resend email button is available if needed afterwards on an entity."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - View List of Entries (Priority: P1)

As a user, I want to view a list of all my entries so that I can see what I've recorded previously.

**Why this priority**: This is the foundation of the app - without the ability to view entries, the app has no value. This story can be independently tested with test data and provides immediate value by displaying existing entries.

**Independent Test**: Can be fully tested by displaying a list of pre-populated test entries. The user can verify that entries are displayed correctly, sorted appropriately, and show key information. This delivers value by allowing users to see their recorded entries.

**Acceptance Scenarios**:

1. **Given** the app has no entries, **When** the user opens the app, **Then** an empty state message is displayed indicating no entries exist
2. **Given** the app has one or more entries, **When** the user opens the app, **Then** all entries are displayed in a list with their transcription text and creation date
3. **Given** the app has multiple entries, **When** the user views the list, **Then** entries are sorted by creation date (newest first)
4. **Given** an entry exists, **When** the user views the list, **Then** each entry displays its transcription text, creation timestamp, and email status

---

### User Story 2 - Create Entry via Voice Recording (Priority: P2)

As a user, I want to create a new entry by recording my voice so that I can quickly capture information without typing.

**Why this priority**: This is the core functionality for creating entries. While it depends on P1 for displaying the new entry, it can be independently tested by verifying that a new entry appears in the list after recording. This story delivers the primary value proposition of voice-based entry creation.

**Independent Test**: Can be fully tested by recording a voice message, verifying transcription occurs, and confirming a new entry appears in the list with the transcribed text. This delivers value by enabling users to create entries through voice input.

**Acceptance Scenarios**:

1. **Given** the user is on the entry list screen, **When** the user taps the record button, **Then** the voice recording interface is presented
2. **Given** the recording interface is active, **When** the user speaks, **Then** the app records the audio
3. **Given** the user has recorded audio, **When** the user stops the recording, **Then** the app transcribes the audio to text
4. **Given** the transcription is complete, **When** the transcription succeeds, **Then** a new Entry entity is created with the transcribed text and current timestamp
5. **Given** a new entry is created, **When** the user returns to the list, **Then** the new entry appears in the list with the transcribed text
6. **Given** the transcription fails, **When** an error occurs, **Then** an error message is displayed and no entry is created

---

### User Story 3 - Send Email on Entry Creation (Priority: P3)

As a user, I want the app to automatically send an email when I create a new entry so that the transcribed content is shared via email.

**Why this priority**: This adds the email functionality that completes the entry creation flow. It builds on P2 but can be independently tested by verifying email sending after entry creation. This delivers value by automatically sharing entries via email.

**Independent Test**: Can be fully tested by creating a new entry and verifying that an email is sent to the hardcoded Gmail address with the transcribed text. This delivers value by ensuring entries are automatically shared via email.

**Acceptance Scenarios**:

1. **Given** a new entry is successfully created from voice transcription, **When** the entry is saved, **Then** an email is automatically sent to the hardcoded Gmail address
2. **Given** an email is being sent, **When** the email contains the transcribed text, **Then** the email subject and body include the entry content
3. **Given** an email is sent successfully, **When** the entry is displayed, **Then** the entry shows an email sent status indicator
4. **Given** email sending fails, **When** an error occurs, **Then** an error message is displayed and the entry is still created but marked as email not sent

---

### User Story 4 - Resend Email for Existing Entry (Priority: P4)

As a user, I want to resend an email for an existing entry so that I can share it again if needed or if the initial send failed.

**Why this priority**: This provides additional functionality for managing entries. It can work independently with any existing entry and delivers value by allowing users to resend emails when needed.

**Independent Test**: Can be fully tested by selecting an existing entry and tapping the resend email button, then verifying that an email is sent. This delivers value by enabling users to resend emails for any entry.

**Acceptance Scenarios**:

1. **Given** an entry exists in the list, **When** the user views the entry details, **Then** a resend email button is available
2. **Given** the user taps the resend email button, **When** the button is tapped, **Then** an email is sent to the hardcoded Gmail address with the entry's transcribed text
3. **Given** the email is sent successfully, **When** the resend completes, **Then** a success message is displayed and the entry's email status is updated
4. **Given** email sending fails, **When** an error occurs during resend, **Then** an error message is displayed and the entry's email status remains unchanged

---

### Edge Cases

- What happens when the device has no microphone permission?
- How does the system handle very long voice recordings (e.g., > 5 minutes)?
- What happens when transcription service is unavailable or network connection is lost?
- How does the system handle transcription of multiple languages or unclear speech?
- What happens when the hardcoded Gmail address is invalid or unreachable?
- How does the system handle email sending when the device has no internet connection?
- What happens when the user denies email sending permissions?
- How does the system handle rapid successive voice recordings?
- What happens when the app is backgrounded during voice recording?
- How does the system handle corrupted or invalid audio files?

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: System MUST display a list of all entries sorted by creation date (newest first)
- **FR-002**: System MUST allow users to initiate voice recording from the entry list screen
- **FR-003**: System MUST record audio from the device microphone when recording is active
- **FR-004**: System MUST transcribe recorded audio to text using speech recognition
- **FR-005**: System MUST create an Entry entity with transcribed text and creation timestamp when transcription succeeds
- **FR-006**: System MUST persist entries using SwiftData framework
- **FR-007**: System MUST automatically send an email to a hardcoded Gmail address when a new entry is created
- **FR-008**: System MUST include the transcribed text in the email body
- **FR-009**: System MUST display email status (sent/not sent) for each entry
- **FR-010**: System MUST provide a resend email button for each entry
- **FR-011**: System MUST send an email when the resend button is tapped
- **FR-012**: System MUST handle and display errors for transcription failures
- **FR-013**: System MUST handle and display errors for email sending failures
- **FR-014**: System MUST request microphone permission before allowing voice recording
- **FR-015**: System MUST display an empty state when no entries exist
- **FR-016**: System MUST support both iPhone and iPad screen sizes and orientations
- **FR-017**: System MUST be accessible with VoiceOver support and proper accessibility labels
- **FR-018**: System MUST localize all user-facing strings in English and French using xcstrings files

### Key Entities *(include if feature involves data)*

- **Entry**: Represents a voice-recorded entry in the system
  - **Attributes**: 
    - `id`: Unique identifier (UUID)
    - `transcribedText`: The text transcribed from the voice recording (String)
    - `creationDate`: Timestamp when the entry was created (Date)
    - `emailSent`: Boolean indicating whether email was successfully sent
    - `lastEmailSentDate`: Optional timestamp of the last successful email send (Date?)
    - `audioRecordingURL`: Optional URL/path to the saved audio file (URL?)
  - **Relationships**: None (standalone entity)
  - **Business Rules**: 
    - Entry must have transcribed text before it can be considered complete
    - Entry creation date is set automatically when entity is created
    - Email status is updated when email is sent or fails

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Users can view the list of entries within 1 second of app launch (performance metric)
- **SC-002**: Users can complete voice recording and transcription in under 30 seconds for recordings up to 2 minutes (user experience metric)
- **SC-003**: Transcription accuracy is sufficient for users to understand and use the transcribed text (qualitative - 90% of transcriptions should be readable and meaningful)
- **SC-004**: Email sending completes within 5 seconds of entry creation under normal network conditions (performance metric)
- **SC-005**: 95% of successfully transcribed entries result in successfully sent emails (reliability metric)
- **SC-006**: Users can resend emails for existing entries within 3 seconds of tapping the resend button (user experience metric)
- **SC-007**: The app handles errors gracefully - no crashes when transcription or email sending fails (reliability metric)
- **SC-008**: The app works correctly on both iPhone and iPad devices with proper layout adaptation (compatibility metric)
- **SC-009**: All user-facing text is properly localized in both English and French (completeness metric)
