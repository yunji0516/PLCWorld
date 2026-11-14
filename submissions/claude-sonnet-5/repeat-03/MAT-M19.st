PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    Y21 : BOOL;
    Y22 : BOOL;
    X20 : BOOL;
    X21 : BOOL;
    X22 : BOOL;
    X23 : BOOL;
    D20 : INT;
    D21 : INT;
    D22 : INT;
    D23 : INT;
    D24 : INT;
    D25 : INT;
    D26 : INT;

    (* internal *)
    startTrig   : R_TRIG;
    accepted    : BOOL := FALSE;
    doneLatched : BOOL := FALSE;
    state       : INT := 0;   (* 0=idle,1=ready-to-place,2=wait-end,3=wait-home-return,5=depart,6=check-done *)
    itemIdx     : INT := 1;
    side1       : INT;
    side2       : INT;
    side3       : INT;
    side4       : INT;
    current_side: INT;
    diffA       : INT;
    diffB       : INT;
    diffC       : INT;
END_VAR

startTrig(CLK := X10);

IF startTrig.Q AND NOT accepted THEN
    accepted := TRUE;

    (* determine the balanced 2-and-2 partition among the three possible pairings *)
    diffA := ABS((D20 + D21) - (D22 + D23)); (* {1,2} | {3,4} *)
    diffB := ABS((D20 + D22) - (D21 + D23)); (* {1,3} | {2,4} *)
    diffC := ABS((D20 + D23) - (D21 + D22)); (* {1,4} | {2,3} *)

    IF (diffA <= diffB) AND (diffA <= diffC) THEN
        side1 := 1; side2 := 1; side3 := 2; side4 := 2;
    ELSIF (diffB <= diffA) AND (diffB <= diffC) THEN
        side1 := 1; side2 := 2; side3 := 1; side4 := 2;
    ELSE
        side1 := 1; side2 := 2; side3 := 2; side4 := 1;
    END_IF;

    itemIdx := 1;
    state := 1;
END_IF;

IF accepted THEN
    CASE state OF

        1: (* ready to place next item, must be at home to latch side/item *)
            IF itemIdx > 4 THEN
                state := 5;
            ELSIF X20 THEN
                CASE itemIdx OF
                    1: current_side := side1;
                    2: current_side := side2;
                    3: current_side := side3;
                    4: current_side := side4;
                ELSE
                    current_side := 0;
                END_CASE;

                IF current_side = 1 THEN
                    Y20 := TRUE;
                    Y21 := FALSE;
                ELSE
                    Y20 := FALSE;
                    Y21 := TRUE;
                END_IF;
                state := 2;
            END_IF;

        2: (* wait until outward end reached *)
            IF X21 THEN
                Y20 := FALSE;
                Y21 := FALSE;
                state := 3;
            END_IF;

        3: (* command off; wait for automatic return to home *)
            IF X20 THEN
                itemIdx := itemIdx + 1;
                state := 1;
            END_IF;

        5: (* depart the loaded receiver *)
            Y22 := TRUE;
            IF X23 THEN
                Y22 := FALSE;
                state := 6;
            END_IF;

        6: (* verify terminal conditions and latch completion *)
            IF NOT doneLatched THEN
                IF X23 AND X20 AND (NOT Y20) AND (NOT Y21) AND (NOT Y22)
                   AND (ABS(D24 - D25) <= 1) AND (itemIdx > 4) THEN
                    Y2 := TRUE;
                    doneLatched := TRUE;
                END_IF;
            END_IF;

    ELSE
        ;
    END_CASE;
END_IF;

(* maintain the completion claim and terminal physical result for the rest of the run *)
IF doneLatched THEN
    Y2 := TRUE;
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
END_IF;

END_PROGRAM