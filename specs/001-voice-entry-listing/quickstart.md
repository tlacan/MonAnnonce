# Quickstart Guide: Voice Entry Listing

**Feature**: Voice Entry Listing  
**Date**: 2025-11-15  
**Purpose**: Manual testing scenarios and validation steps

## Prerequisites

- iOS 26.0+ device or simulator
- Microphone access (for physical device)
- Network connection (for transcription and email)
- Email account configured on device (for email sending)

## Test Scenarios

### Scenario 1: View Empty Entry List (User Story 1 - P1)

**Objective**: Verify empty state is displayed when no entries exist

**Steps**:
1. Launch the app
2. Verify empty state message is displayed
3. Verify message is localized (test in English and French)

**Expected Result**: 
- Empty state message: "No entries yet. Tap the record button to create your first entry."
- Message is properly localized

**Success Criteria**: SC-001 (list loads within 1 second)

---

### Scenario 2: Create Entry via Voice Recording (User Story 2 - P2)

**Objective**: Verify voice recording and transcription workflow

**Steps**:
1. Launch the app
2. Tap the record button
3. Grant microphone permission if prompted
4. Speak for 10-30 seconds (e.g., "This is a test voice entry for the MonAnnonce app")
5. Stop the recording
6. Wait for transcription to complete
7. Verify new entry appears in the list with transcribed text

**Expected Result**:
- Recording interface is presented
- Audio is recorded successfully
- Transcription completes within 30 seconds (SC-002)
- New entry appears in list with correct transcribed text
- Entry shows creation date and email status (not sent yet)

**Success Criteria**: SC-002 (transcription completes in under 30 seconds), SC-003 (transcription is readable)

---

### Scenario 3: Automatic Email on Entry Creation (User Story 3 - P3)

**Objective**: Verify email is sent automatically when entry is created

**Steps**:
1. Complete Scenario 2 (create entry via voice recording)
2. After entry is created, verify email composer is presented
3. Verify email is pre-filled with:
   - Recipient: Hardcoded Gmail address
   - Subject: "Voice Entry - [Creation Date]"
   - Body: Transcribed text
4. Send the email (or verify automatic sending if implemented)
5. Verify entry's email status is updated to "sent"

**Expected Result**:
- Email composer is presented automatically after entry creation
- Email is pre-filled correctly
- Email sending completes within 5 seconds (SC-004)
- Entry's email status indicator shows "sent"

**Success Criteria**: SC-004 (email completes within 5 seconds), SC-005 (95% success rate)

---

### Scenario 4: Resend Email for Existing Entry (User Story 4 - P4)

**Objective**: Verify resend email functionality

**Steps**:
1. View entry list with at least one existing entry
2. Tap on an entry to view details (or tap resend button if available in list)
3. Tap "Resend Email" button
4. Verify email composer is presented with entry's transcribed text
5. Send the email
6. Verify success message is displayed
7. Verify entry's email status is updated

**Expected Result**:
- Resend button is available for entries
- Email composer is presented with correct content
- Email sending completes within 3 seconds (SC-006)
- Success message is displayed
- Entry's email status is updated

**Success Criteria**: SC-006 (resend completes within 3 seconds)

---

### Scenario 5: Error Handling - Microphone Permission Denied

**Objective**: Verify graceful handling of denied microphone permission

**Steps**:
1. Launch the app
2. Tap record button
3. Deny microphone permission when prompted
4. Verify error message is displayed
5. Verify user is guided to Settings to enable permission

**Expected Result**:
- Clear error message explaining permission is required
- Guidance on how to enable permission in Settings
- App does not crash

**Success Criteria**: SC-007 (no crashes on errors)

---

### Scenario 6: Error Handling - Transcription Failure

**Objective**: Verify graceful handling of transcription failures

**Steps**:
1. Create entry via voice recording
2. Simulate transcription failure (network issue or invalid audio)
3. Verify error message is displayed
4. Verify entry is not created
5. Verify user can retry recording

**Expected Result**:
- Clear error message explaining transcription failed
- Entry is not created
- User can retry recording
- App does not crash

**Success Criteria**: SC-007 (no crashes on errors)

---

### Scenario 7: Error Handling - Email Sending Failure

**Objective**: Verify graceful handling of email sending failures

**Steps**:
1. Create entry via voice recording
2. Simulate email sending failure (no network or email not configured)
3. Verify error message is displayed
4. Verify entry is still created but marked as email not sent
5. Verify user can resend email later

**Expected Result**:
- Clear error message explaining email sending failed
- Entry is created with `emailSent = false`
- User can resend email using resend button
- App does not crash

**Success Criteria**: SC-007 (no crashes on errors)

---

### Scenario 8: Platform Compatibility - iPhone

**Objective**: Verify app works correctly on iPhone

**Steps**:
1. Run app on iPhone simulator or device
2. Test all scenarios above
3. Verify layout adapts correctly to iPhone screen size
4. Verify all UI elements are accessible and properly sized

**Expected Result**:
- App works correctly on iPhone
- Layout is appropriate for iPhone screen
- All features are accessible

**Success Criteria**: SC-008 (works on iPhone and iPad)

---

### Scenario 9: Platform Compatibility - iPad

**Objective**: Verify app works correctly on iPad

**Steps**:
1. Run app on iPad simulator or device
2. Test all scenarios above
3. Verify layout adapts correctly to iPad screen size
4. Verify all UI elements are accessible and properly sized
5. Test in both portrait and landscape orientations

**Expected Result**:
- App works correctly on iPad
- Layout is appropriate for iPad screen
- Layout adapts to orientation changes
- All features are accessible

**Success Criteria**: SC-008 (works on iPhone and iPad)

---

### Scenario 10: Accessibility - VoiceOver

**Objective**: Verify VoiceOver support

**Steps**:
1. Enable VoiceOver in Settings
2. Launch the app
3. Navigate through all screens using VoiceOver
4. Verify all UI elements have proper accessibility labels
5. Verify logical reading order

**Expected Result**:
- All UI elements are accessible via VoiceOver
- Proper accessibility labels are provided
- Logical reading order is maintained
- All actions can be performed using VoiceOver

**Success Criteria**: Accessibility compliance (constitution requirement)

---

### Scenario 11: Accessibility - Dynamic Type

**Objective**: Verify Dynamic Type support

**Steps**:
1. Change text size in Settings (Accessibility > Display & Text Size > Larger Text)
2. Launch the app
3. Verify all text scales appropriately
4. Verify layout adapts to larger text sizes
5. Verify no text is cut off or overlapping

**Expected Result**:
- All text scales with Dynamic Type settings
- Layout adapts to larger text sizes
- No text is cut off or overlapping

**Success Criteria**: Accessibility compliance (constitution requirement)

---

### Scenario 12: Localization - English

**Objective**: Verify English localization

**Steps**:
1. Set device language to English
2. Launch the app
3. Verify all user-facing strings are in English
4. Test all scenarios above

**Expected Result**:
- All strings are properly localized in English
- No hardcoded strings visible

**Success Criteria**: SC-009 (properly localized)

---

### Scenario 13: Localization - French

**Objective**: Verify French localization

**Steps**:
1. Set device language to French
2. Launch the app
3. Verify all user-facing strings are in French
4. Test all scenarios above

**Expected Result**:
- All strings are properly localized in French
- No hardcoded strings visible

**Success Criteria**: SC-009 (properly localized)

---

## Performance Validation

- **Entry List Load**: Should complete within 1 second (SC-001)
- **Transcription**: Should complete within 30 seconds for 2-minute recordings (SC-002)
- **Email Sending**: Should complete within 5 seconds (SC-004)
- **Resend Email**: Should complete within 3 seconds (SC-006)

## Edge Cases to Test

1. Very long recordings (> 5 minutes)
2. Rapid successive recordings
3. App backgrounded during recording
4. Network connection lost during transcription
5. Network connection lost during email sending
6. Multiple languages in transcription
7. Unclear speech or background noise
8. Corrupted audio files
9. Device storage full
10. Email account not configured

## Notes

- All tests should be performed on both iPhone and iPad simulators/devices
- Test with both English and French device languages
- Test with VoiceOver and Dynamic Type enabled
- Verify SwiftLint compliance for all code
- Verify Swift 6.2 concurrency patterns are used correctly
- Verify Clean Architecture layers are properly separated

