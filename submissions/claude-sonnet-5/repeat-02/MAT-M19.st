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
    startReq   : R_TRIG;
    accepted   : BOOL := FALSE;
    state      : INT := 0;
    itemIdx    : INT := 0;
    leftSide   : ARRAY[1..4] OF BOOL;
    diff1      : INT;
    diff2      : INT;
    diff3      : INT;
END_VAR

startReq(CLK := X10);

IF NOT accepted THEN
    (* No actuator operation before Start is accepted *)
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;

    IF startReq.Q THEN
        accepted := TRUE;

        (* Evaluate the three possible 2-and-2 partitions by mass balance *)
        diff1 := ABS((D20 + D21) - (D22 + D23)); (* {1,2} vs {3,4} *)
        diff2 := ABS((D20 + D22) - (D21 + D23)); (* {1,3} vs {2,4} *)
        diff3 := ABS((D20 + D23) - (D21 + D22)); (* {1,4} vs {2,3} *)

        IF (diff1 <= diff2) AND (diff1 <= diff3) THEN
            leftSide[1] := TRUE;
            leftSide[2] := TRUE;
            leftSide[3] := FALSE;
            leftSide[4] := FALSE;
        ELSIF (diff2 <= diff1) AND (diff2 <= diff3) THEN
            leftSide[1] := TRUE;
            leftSide[2] := FALSE;
            leftSide[3] := TRUE;
            leftSide[4] := FALSE;
        ELSE
            leftSide[1] := TRUE;
            leftSide[2] := FALSE;
            leftSide[3] := FALSE;
            leftSide[4] := TRUE;
        END_IF;

        itemIdx := 1;
        state   := 10;
    END_IF;

ELSE
    CASE state OF

        10: (* ready to command next item; module must be home *)
            IF X20 THEN
                IF leftSide[itemIdx] THEN
                    Y20 := TRUE;
                    Y21 := FALSE;
                ELSE
                    Y21 := TRUE;
                    Y20 := FALSE;
                END_IF;
                state := 20;
            END_IF;

        20: (* wait for outward end reached *)
            IF X21 THEN
                Y20 := FALSE;
                Y21 := FALSE;
                state := 30;
            END_IF;

        30: (* wait for return home before next item / depart *)
            IF X20 THEN
                IF itemIdx < 4 THEN
                    itemIdx := itemIdx + 1;
                    state := 10;
                ELSE
                    state := 40;
                END_IF;
            END_IF;

        40: (* command depart; hold until fully departed *)
            Y22 := TRUE;
            IF X23 THEN
                state := 50;
            END_IF;

        50: (* release depart command and verify terminal state *)
            Y22 := FALSE;
            IF (D26 >= 4) AND (ABS(D24 - D25) <= 1) AND X23 AND X20 THEN
                Y2 := TRUE;
                state := 60;
            END_IF;

        60: (* maintain terminal result for remainder of the run *)
            Y20 := FALSE;
            Y21 := FALSE;
            Y22 := FALSE;
            Y2  := TRUE;

        ELSE
            (* defensive: keep actuators off *)
            Y20 := FALSE;
            Y21 := FALSE;
            Y22 := FALSE;
    END_CASE;
END_IF;

END_PROGRAM