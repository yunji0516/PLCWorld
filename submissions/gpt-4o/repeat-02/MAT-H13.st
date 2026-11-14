PROGRAM Main
VAR
    X0 : BOOL;
    X10 : BOOL;
    X11 : BOOL;
    X12 : BOOL;
    X13 : BOOL;
    X14 : BOOL;
    X15 : BOOL;
    X16 : BOOL;
    X17 : BOOL;
    X18 : BOOL;
    X19 : BOOL;
    X20 : BOOL;
    X21 : BOOL;
    X22 : BOOL;
    X23 : BOOL;
    X24 : BOOL;
    X25 : BOOL;
    X26 : BOOL;
    X27 : BOOL;
    X28 : BOOL;
    X29 : BOOL;
    X30 : BOOL;
    X31 : BOOL;
    X32 : BOOL;
    X33 : BOOL;
    Y10 : BOOL := FALSE;
    Y11 : BOOL := FALSE;
    Y12 : BOOL := FALSE;
    Y13 : BOOL := FALSE;
    Y14 : BOOL := FALSE;
    Y15 : BOOL := FALSE;
    Y16 : BOOL := FALSE;
    Y17 : BOOL := FALSE;
    Y18 : BOOL := FALSE;
    Y19 : BOOL := FALSE;
    Y20 : BOOL := FALSE;
    Y21 : BOOL := FALSE;
    Y22 : BOOL := FALSE;
    Y23 : BOOL := FALSE;
    Y24 : BOOL := FALSE;
    D0 : INT;
    D1 : INT;
    D2 : INT;
    D3 : INT;
    D4 : INT;
    D5 : INT;
    D6 : INT;
    D7 : INT;
    D8 : INT;
    D9 : INT;
    D10 : INT;
    D11 : INT;
    D200 : INT := 0;
    X1A : BOOL;
    X1B : BOOL;
    X1C : BOOL;
    X1D : BOOL;
    X1E : BOOL;
    X1F : BOOL;
    X2A : BOOL;
    X2B : BOOL;
    X2C : BOOL;
    X2D : BOOL;
    X2E : BOOL;
    X2F : BOOL;
    Y1A : BOOL := FALSE;
    Y1B : BOOL := FALSE;
    Y1C : BOOL := FALSE;
    Y1D : BOOL := FALSE;
    Y1E : BOOL := FALSE;
    Y1F : BOOL := FALSE;

    timer1 : TON;
    edge_grip : R_TRIG;
    edge_wrap : R_TRIG;
    edge_tape : R_TRIG;
    edge_form_align : R_TRIG;

    forming : BOOL := FALSE;
    wrapping : BOOL := FALSE;
    transferring : BOOL := FALSE;
    tape_applying : BOOL := FALSE;

    current_form_count : INT := 0;
    targeted_forms : INT;
    ready_to_wrap : BOOL := FALSE;

END_VAR

// Rising edge detection for grip command
edge_grip(CLK := X10 AND NOT Y10);
IF edge_grip.Q THEN
    Y10 := TRUE;
END_IF

// Rising edge detection for wrapping
edge_wrap(CLK := X13 AND X18 AND X19 AND NOT Y16);
IF edge_wrap.Q THEN
    ready_to_wrap := TRUE;
END_IF

// Rising edge detection for tape preparation
edge_tape(CLK := X6);
IF edge_tape.Q THEN
    Y18 := TRUE;
END_IF

// Rising edge detection for form alignment
edge_form_align(CLK := X25 AND X29 AND NOT Y1F);
IF edge_form_align.Q THEN
    Y1F := TRUE;
END_IF

// Forming Process
IF X0 AND X32 AND current_form_count < D10 THEN
    Y1C := TRUE; // unit_feed
    IF X28 THEN
        Y1D := TRUE; // form_stop
    END_IF
    current_form_count := current_form_count + 1;
    IF current_form_count = D10 THEN
        forming := TRUE;
    END_IF
ELSE
    Y1C := FALSE;
END_IF

// Wrapping Process
IF ready_to_wrap AND X19 AND X1B AND X18 THEN
    Y16 := TRUE;
    timer1(IN := TRUE, PT := T#300ms);
    IF timer1.Q THEN
        wrapping := TRUE;
        ready_to_wrap := FALSE;
        timer1(IN := FALSE);
    END_IF
ELSE
    Y16 := FALSE;
END_IF

// Transfer Process
IF X12 AND NOT transferring THEN
    Y13 := TRUE; // to_source
    transferring := TRUE;
ELSIF X13 THEN
    IF NOT transferring AND X15 THEN
        Y14 := TRUE; // to_wrap
    END_IF
ELSIF X14 THEN
    Y15 := TRUE; // to_exit
    transferring := FALSE;
END_IF

// Tape Application
IF X20 AND NOT tape_applying THEN
    IF D5 = D0 THEN
        Y19 := TRUE; // apply_tape
        tape_applying := TRUE;
    END_IF
END_IF

// Reset form alignment
IF Y1F THEN
    Y1F := FALSE;
END_IF

// Complete Condition
IF forming AND wrapped AND transferring THEN
    Y1B := TRUE;
    forming := FALSE;
    wrapping := FALSE;
    transferring := FALSE;
    tape_applying := FALSE;
    current_form_count := 0;
END_IF

END_PROGRAM