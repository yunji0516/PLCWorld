PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    Y21 : BOOL;
    Y22 : BOOL;
    Y23 : BOOL;
    Y24 : BOOL;
    Y25 : BOOL;
    X20 : BOOL;
    X21 : BOOL;
    X22 : BOOL;
    X23 : BOOL;
    X24 : BOOL;
    X25 : BOOL;
    X26 : BOOL;
    D20 : INT;
    D21 : INT;

    (* internal *)
    step      : INT := 0;
    startEdge : R_TRIG;
    recipe    : INT := 0;
END_VAR

(* detect the single accepted start request *)
startEdge(CLK := X10);

CASE step OF

    0: (* idle - no actuator commands before Start is accepted *)
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        Y24 := FALSE;
        Y25 := FALSE;
        IF startEdge.Q THEN
            recipe := D10;
            step := 1;
        END_IF;

    1: (* grip both vacuum sides *)
        Y20 := TRUE;
        Y21 := TRUE;
        IF X20 AND X21 THEN
            step := 2;
        END_IF;

    2: (* open the opening axis to full mechanical open with gap>=160 *)
        Y22 := TRUE;
        IF X22 THEN
            Y22 := FALSE; (* axis OFF holds position at full open *)
            step := 3;
        END_IF;

    3: (* insert the content until it seats; opening stays maintained open *)
        Y24 := TRUE;
        IF X25 THEN
            Y24 := FALSE;
            step := 4;
        END_IF;

    4: (* retract insertion tool to home; opening still held open, sides still held *)
        Y25 := TRUE;
        IF X23 THEN
            Y25 := FALSE;
            step := 5;
        END_IF;

    5: (* tool has cleared - release both vacuum sides *)
        Y20 := FALSE;
        Y21 := FALSE;
        IF X26 THEN
            step := 6;
        END_IF;

    6: (* terminal state: claim completion and hold actuators OFF *)
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        Y24 := FALSE;
        Y25 := FALSE;
        Y2  := TRUE;

    ELSE
        step := 0;

END_CASE;

END_PROGRAM