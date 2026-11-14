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
    Y10 : BOOL;
    Y11 : BOOL;
    Y12 : BOOL;
    Y13 : BOOL;
    Y14 : BOOL;
    Y15 : BOOL;
    Y16 : BOOL;
    Y17 : BOOL;
    Y18 : BOOL;
    Y19 : BOOL;
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
    D100 : INT;
    D101 : INT;
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
    Y1A : BOOL;
    Y1B : BOOL;
    Y1C : BOOL;
    Y1D : BOOL;
    Y1E : BOOL;
    
    // Internal variables
    state : INT := 0;
    piece_count : INT := 0;
    reject_counter : INT := 0;
    reject_pocket : INT;
    ton_sensor : TON;
    edge_start : R_TRIG;
END_VAR

(* Implement the control logic here. *)
ton_sensor(IN := (X0 AND NOT edge_start.Q), PT := T#30s);
edge_start(CLK := X0);

CASE state OF
    0: (* Initial State - Wait for Start *)
        IF X0 THEN
            state := 1;
        END_IF

    1: (* Prepare to pick A-order workpiece *)
        IF NOT X10 AND X11 AND NOT X13 AND NOT Y10 THEN
            Y10 := TRUE; (* Close gripper *)
            state := 2;
        END_IF

    2: (* Move to Source A and pick workpiece *)
        IF D0 = 0 THEN
            D100 := 1; (* Move to Source A *)
            D101 := D1 + 1;
        ELSIF D0 = 1 AND NOT X10 THEN
            Y10 := FALSE;
            state := 3;
        END_IF

    3: (* Pick from Source A *)
        IF NOT X10 AND X13 THEN
            Y11 := TRUE; (* Open gripper *)
            state := 4;
        END_IF

    4: (* Move to Cell A *)
        IF X11 AND D0 = 1 THEN
            D100 := 3; (* Move to Cell A *)
            D101 := D1 + 1;
        ELSIF D0 = 3 AND NOT X10 THEN
            state := 5;
            Y11 := FALSE; (* Close gripper *)
        END_IF

    5: (* Drop workpiece in Cell A *)
        IF NOT X10 AND X13 THEN
            Y17 := TRUE; (* Close clamp A *)
            state := 6;
        END_IF

    6: (* Start Machining in Cell A *)
        IF X25 AND X26 AND X21 AND X24 THEN
            Y19 := TRUE; (* Start cycle A *)
            state := 7;
        END_IF

    7: (* Wait for Cell A to complete *)
        IF X1F THEN
            Y15 := TRUE; (* Open door A *)
            Y17 := FALSE; (* Release clamp A *)
            state := 8;
        END_IF

    8: (* Retrieve from Cell A and move to Inspection *)
        IF NOT X10 THEN
            if Y15 then
                D100 := 5; (* Move to Inspection *)
                D101 := D1 + 1;
            ELSIF D0 = 5 THEN
                Y15 := FALSE; 
                state := 9;
            END_IF
        END_IF

    9: (* Inspect workpiece *)
        IF NOT X15 AND NOT X10 THEN
            Y12 := TRUE; (* Measure *)
            IF X16 THEN
                Y12 := FALSE;
                state := 10;
            END_IF
        END_IF

    10: (* Determine workpiece disposition *)
        IF X16 THEN
            IF D4 >= 5800 AND D4 <= 6200 AND D5 >= 5800 AND D5 <= 6200 THEN
                Y13 := TRUE; (* Normal outfeed *)
            ELSE
                // Find an empty reject pocket
                IF NOT X34 THEN
                    reject_pocket := 8;
                ELSIF NOT X35 THEN
                    reject_pocket := 9;
                ELSIF NOT X36 THEN
                    reject_pocket := 10;
                ELSIF NOT X37 THEN
                    reject_pocket := 11;
                END_IF
                D100 := reject_pocket;
                D101 := D1 + 1;
            END_IF
            state := 11;
        END_IF

    11: (* Move to outfeed or reject pocket *)
        IF D0 = 7 OR D0 = reject_pocket AND NOT X10 THEN
            Y13 := FALSE;
            piece_count := piece_count + 1;
            IF piece_count >= 4 THEN
                Y14 := TRUE; (* All parts processed *)
                state := 0;
            ELSE
                state := 1;
            END_IF
        END_IF
END_CASE

END_PROGRAM