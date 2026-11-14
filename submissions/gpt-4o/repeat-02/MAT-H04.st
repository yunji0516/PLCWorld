```iec
PROGRAM Main
VAR
    X0 : BOOL; // start
    X10 : BOOL; // pouch_ready
    X11 : BOOL; // pouch_loaded
    X12 : BOOL; // pouch_busy
    X13 : BOOL; // pouch_docked
    X14 : BOOL; // content_busy
    X15 : BOOL; // content_ready
    X16 : BOOL; // insert_busy
    X17 : BOOL; // insert_home
    X18 : BOOL; // insert_end
    X19 : BOOL; // contained
    X20 : BOOL; // double_sheet
    X21 : BOOL; // separator_busy
    X22 : BOOL; // separator_held
    X23 : BOOL; // sheet_single
    X24 : BOOL; // content_aligned
    X25 : BOOL; // align_tools_clear
    Y10 : BOOL; // accept_pouch
    Y11 : BOOL; // accept_content
    Y12 : BOOL; // vacuum_left
    Y13 : BOOL; // vacuum_right
    Y14 : BOOL; // open
    Y15 : BOOL; // transfer_pouch
    Y16 : BOOL; // insert
    Y17 : BOOL; // retract
    Y18 : BOOL; // release
    Y19 : BOOL; // ack_exit
    D0 : INT; // pouch_id
    D1 : INT; // next_pouch
    D2 : INT; // content_id
    D3 : INT; // first_content
    D4 : INT; // available_mask
    D5 : INT; // aperture_mm
    D6 : INT; // content_thickness
    D7 : INT; // received
    D200 : INT; // content_select
    X1A : BOOL; // left_held
    X1B : BOOL; // right_held
    X1C : BOOL; // aperture_open
    X1D : BOOL; // exit_clear
    X1E : BOOL; // exit_received
    X1F : BOOL; // all_done
    Y1A : BOOL; // complete
    Y1B : BOOL; // separator_hold
    Y1C : BOOL; // separate
    Y1D : BOOL; // align_side
    Y1E : BOOL; // align_front

    // Internal state variables
    accept_pouch_edge : R_TRIG;
    content_selected : BOOL := FALSE;
    package_completed : BOOL := FALSE;
    complete_timer : TON;
END_VAR

// Rising edge detection for accept_pouch
accept_pouch_edge(CLK := X23 AND NOT X21 AND X10 AND NOT Y10);

// Accept pouch control logic
IF accept_pouch_edge.Q THEN
    Y10 := TRUE;
ELSE
    Y10 := FALSE;
END_IF

// Control vacuum hold and opening
IF X13 AND X20 AND NOT X21 THEN
    Y12 := X1A; // vacuum_left
    Y13 := X1B; // vacuum_right
    Y14 := TRUE; // open level
ELSE
    Y12 := FALSE;
    Y13 := FALSE;
    Y14 := FALSE;
END_IF

// Control separator and sheet handling
IF X20 AND NOT X21 AND NOT Y1B THEN
    Y1B := TRUE; // separator_hold
ELSIF X23 AND Y1B THEN
    Y1B := FALSE;
END_IF

IF X20 AND X22 AND NOT X21 AND NOT Y1C THEN
    Y1C := TRUE; // separate
ELSIF X23 AND Y1C THEN
    Y1C := FALSE;
END_IF

// Content acceptance and alignment
IF X15 AND NOT X14 AND NOT content_selected THEN
    IF (D4 AND D3) <> 0 THEN
        D200 := D3; // Select the first available content source
        Y11 := TRUE;
        content_selected := TRUE;
    END_IF
ENDIF

// Alignment logic
IF content_selected THEN
    IF NOT (X24 AND X25) THEN
        Y1D := TRUE; // align_side
        Y1E := TRUE; // align_front
    ELSE
        Y1D := FALSE;
        Y1E := FALSE;
        Y16 := TRUE; // insert
        content_selected := FALSE;
    END_IF
ELSE
    Y16 := FALSE;
END_IF

// Release and retract logic
IF X17 AND NOT X16 THEN
    Y17 := TRUE; // retract
    IF X19 THEN
        Y18 := TRUE; // release
    ELSE
        Y18 := FALSE;
    END_IF
ELSE
    Y17 := FALSE;
END_IF

// Exit and complete logic
IF X1E THEN
    Y19 := TRUE; // ack_exit
ELSE
    Y19 := FALSE;
END_IF

IF X1F AND X18 AND NOT package_completed THEN
    package_completed := TRUE;
    complete_timer(IN := TRUE, PT := T#500ms);
END_IF

IF package_completed AND complete_timer.Q THEN
    Y1A := TRUE; // complete
    complete_timer(IN := FALSE);
    package_completed := FALSE;
ELSE
    Y1A := FALSE;
END_IF

END_PROGRAM
```