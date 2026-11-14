PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y20 : BOOL;
    Y21 : BOOL;
    Y22 : BOOL;
    Y23 : BOOL;
    Y24 : BOOL;
    Y25 : BOOL;
    Y26 : BOOL;
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
    Y2 : BOOL;
    
    step : INT := 0;
    start_edge : R_TRIG;
    align_timer : TON;
END_VAR

start_edge(CLK := X10);
align_timer(IN := (step = 1), PT := T#500ms);

CASE step OF
    0:
        IF start_edge.Q AND D10 = 1 THEN
            step := 1;
        END_IF;

    1: // Align workpiece on source support
        Y25 := TRUE;
        Y26 := TRUE;
        IF X31 AND X32 AND align_timer.Q THEN
            step := 2;
        END_IF;

    2: // Retract alignment fingers
        Y25 := FALSE;
        Y26 := FALSE;
        IF X29 THEN
            step := 3;
        END_IF;

    3: // Lower head
        Y24 := TRUE;
        IF X22 THEN
            Y24 := FALSE;
            step := 4;
        END_IF;

    4: // Wait axis stop
        IF X28 THEN
            step := 5;
        END_IF;

    5: // Grip workpiece
        Y20 := TRUE;
        IF X24 THEN
            step := 6;
        END_IF;

    6: // Raise head
        Y23 := TRUE;
        IF X23 THEN
            Y23 := FALSE;
            step := 7;
        END_IF;

    7: // Wait axis stop
        IF X28 THEN
            step := 8;
        END_IF;

    8: // Advance to receiver
        Y21 := TRUE;
        IF X21 THEN
            Y21 := FALSE;
            step := 9;
        END_IF;

    9: // Wait axis stop
        IF X28 THEN
            step := 10;
        END_IF;

    10: // Lower head at receiver
        Y24 := TRUE;
        IF X22 THEN
            Y24 := FALSE;
            step := 11;
        END_IF;

    11: // Wait axis stop
        IF X28 THEN
            step := 12;
        END_IF;

    12: // Release workpiece
        Y20 := FALSE;
        IF X25 THEN
            step := 13;
        END_IF;

    13: // Raise empty head
        Y23 := TRUE;
        IF X23 THEN
            Y23 := FALSE;
            step := 14;
        END_IF;

    14: // Wait axis stop
        IF X28 THEN
            step := 15;
        END_IF;

    15: // Return to source
        Y22 := TRUE;
        IF X20 THEN
            Y22 := FALSE;
            step := 16;
        END_IF;

    16: // Wait axis stop
        IF X28 THEN
            step := 17;
        END_IF;

    17: // Done
        Y2 := TRUE;
END_CASE;

END_PROGRAM