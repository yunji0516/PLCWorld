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
    X34 : BOOL;
    X35 : BOOL;
    X36 : BOOL;
    X37 : BOOL;
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
    D100 : INT := 0;
    D101 : INT := 0;
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
    (* Internal variables *)
    robot_state : INT := 0; (* 0 - idle, 1 - working *)
    workpiece_count : INT := 0;
    measure_edge : R_TRIG;
    move_edge : R_TRIG;
    inspection_edge : R_TRIG;
    cycle_edge : R_TRIG;
    reject_slot : INT;
END_VAR

(* Rising edge detection for commands *)
measure_edge(CLK := X0 AND NOT X13); (* Only measure if holding a workpiece *)
move_edge(CLK := NOT X10);
inspection_edge(CLK := NOT X15);
cycle_edge(CLK := NOT X20);

(* Control logic for handling workpieces *)
IF X0 THEN
    CASE robot_state OF
        0: (* Idle state *)
            IF NOT X10 AND NOT X13 THEN
                (* Check for source place *)
                IF workpiece_count < 2 THEN
                    (* Move to source A for A-order workpieces *)
                    D100 := 1; (* source_a *)
                    IF (move_edge.Q) THEN
                        D101 := D101 + 1;
                        robot_state := 1; (* Change to working state *)
                    END_IF
                ELSE
                    (* Move to source B for B-order workpieces *)
                    D100 := 2; (* source_b *)
                    IF (move_edge.Q) THEN
                        D101 := D101 + 1;
                        robot_state := 1; (* Change to working state *)
                    END_IF
                END_IF
            END_IF;
        1: (* Working state *)
            IF D0 = D100 AND NOT X10 THEN
                (* Execute grip close command at source *)
                IF NOT X13 THEN
                    Y10 := TRUE; (* Grip close *)
                    Y11 := FALSE;
                    IF X12 THEN
                        Y10 := FALSE; (* After closed *)
                        robot_state := 0; (* Back to Idle *)
                    END_IF
                END_IF
            END_IF;
    END_CASE;
END_IF;

(* Measurement command logic *)
IF X13 AND measure_edge.Q THEN
    Y12 := TRUE; (* Start measurement *)
    IF NOT X15 THEN
        Y12 := FALSE; (* End measurement *)
        IF D4 >= 5800 AND D4 <= 6200 AND D5 >= 5800 AND D5 <= 6200 THEN
            D100 := 7; (* normal outfeed *)
        ELSE
            (* Find an empty reject pocket *)
            IF NOT X34 THEN reject_slot := 8;
            ELSIF NOT X35 THEN reject_slot := 9;
            ELSIF NOT X36 THEN reject_slot := 10;
            ELSE reject_slot := 11;
            END_IF;
            D100 := reject_slot;
        END_IF;
        IF X1A THEN
            D100 := D100; (* Move to outfeed or reject pocket *)
            IF (move_edge.Q) THEN
                D101 := D101 + 1;
                workpiece_count := workpiece_count + 1;
            END_IF
        END_IF
    END_IF
END_IF;

(* Final completion check *)
IF workpiece_count = 4 AND D1B THEN
    Y14 := TRUE; (* Task is complete *)
END_IF;

END_PROGRAM