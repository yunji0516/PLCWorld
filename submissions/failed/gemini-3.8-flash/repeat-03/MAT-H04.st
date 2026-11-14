).
35: WAIT_POUCH_LOADED
    Wait for X11 (pouch_loaded) AND NOT X12 (pouch_busy).
    Record `curr_pouch_id := D0;`
    Go to 40 (TRANSFER_AND_OPEN).

40: TRANSFER_AND_OPEN
    Pulse Y15 (transfer_pouch) := TRUE.
    Set Y12 (vacuum_left) := TRUE.
    Set Y13 (vacuum_right) := TRUE.
    Go to 45 (WAIT_DOCK_AND_OPEN).
45: WAIT_DOCK_AND_OPEN
    Set Y14 (open) := TRUE.
    Check pouch docking and open:
    If X13 (pouch_docked) AND X1A (left_held) AND X1B (right_held) AND X1C (aperture_open) AND NOT X12 (pouch_busy):
        Go to 50 (WAIT_CONTENT_AVAIL).

50: WAIT_CONTENT_AVAIL
    Check if content with ID = curr_pouch_id is available in D4:
    `(SHR(D4, curr_pouch_id - 1) AND 1) = 1` AND NOT X14 (content_busy) AND D2 = 0.
    If yes:
        D200 := curr_pouch_id;
        Pulse Y11 (accept_content) := TRUE;
        Go to 55 (WAIT_CONTENT_LOADED).
55: WAIT_CONTENT_LOADED
    Wait for NOT X14 (content_busy) AND X15 (content_ready) AND D2 = curr_pouch_id.
    Go to 60 (ALIGN_CONTENT).

60: ALIGN_CONTENT
    Set Y1D (align_side) := TRUE.
    Set Y1E (align_front) := TRUE.
    Wait for X24 (content_aligned) AND align_timer >= 400 ms.
    Set Y1D := FALSE.
    Set Y1E := FALSE.
    Go to 65 (WAIT_ALIGN_CLEAR).
65: WAIT_ALIGN_CLEAR
    Wait for X25 (align_tools_clear).
    Go to 70 (INSERT_CONTENT).

70: INSERT_CONTENT
    Check all safety conditions:
    - X13 (pouch_docked)
    - X1A (left_held) AND X1B (right_held) AND X1C (aperture_open)
    - D5 >= D6 + 4 (clearance)
    - D0 = curr_pouch_id AND D2 = curr_pouch_id
    - X24 (content_aligned) AND X25 (align_tools_clear)
    - X17 (insert_home)
    Set Y16 (insert) := TRUE.
    Wait for X19 (contained) AND X18 (insert_end).
    Set Y16 := FALSE.
    Go to 75 (RETRACT_PUSHER).

75: RETRACT_PUSHER
    Set Y17 (retract) := TRUE.
    Wait for X17 (insert_home) AND NOT X16 (insert_busy).
    Set Y17 := FALSE.
    Go to 80 (RELEASE_PACKAGE).

80: RELEASE_PACKAGE
    Check release conditions:
    - X19 (contained)
    - X17 (insert_home)
    - NOT X14 (content_busy)
    - X1D (exit_clear)
    Pulse Y18 (release) := TRUE.
    Set Y14 (open) := FALSE.
    Go to 85 (WAIT_EXIT_RECEIVED).

85: WAIT_EXIT_RECEIVED
    Wait for X1E (exit_received).
    Set Y12 (vacuum_left) := FALSE.
    Set Y13 (vacuum_right) := FALSE.
    Pulse Y19 (ack_exit) := TRUE.
    Go to 90 (WAIT_EXIT_CLEAR).

90: WAIT_EXIT_CLEAR
    Wait for NOT X1E (exit_received).
    pkg_count := pkg_count + 1;
    If pkg_count >= 4 OR X1F (all_done) THEN
        Go to 95 (RETURN_SHUTTLE_FINAL);
    ELSE
        Go to 92 (RETURN_SHUTTLE);
    END_IF;

92: RETURN_SHUTTLE
    If X13 (pouch_docked) AND NOT X12 (pouch_busy) THEN
        Pulse Y15 (transfer_pouch) := TRUE;
    END_IF;
    Wait for NOT X13 (pouch_docked) AND NOT X12 (pouch_busy).
    Go to 10 (CHECK_POUCH).

95: RETURN_SHUTTLE_FINAL
    If X13 (pouch_docked) AND NOT X12 (pouch_busy) THEN
        Pulse Y15 (transfer_pouch) := TRUE;
    END_IF;
    Wait for NOT X13 (pouch_docked) AND NOT X12 (pouch_busy).
    Go to 100 (COMPLETE_STATE).

100: COMPLETE_STATE
    Turn OFF all actuators.
    Set Y1A (complete) := TRUE.

---
Wait! Let's examine State 92 and 95:
Look at:
```st
    If X13 (pouch_docked) AND NOT X1