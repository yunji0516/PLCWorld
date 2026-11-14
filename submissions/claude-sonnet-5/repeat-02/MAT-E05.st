PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    Y21 : BOOL;
    X20 : BOOL;
    X21 : BOOL;
    X22 : BOOL;

    (* Internal variables *)
    start_edge : R_TRIG;
    state      : INT := 0;   (* 0=idle,1=advancing,2=retracting,3=done/checking *)
    completed  : BOOL := FALSE;
END_VAR

(* Edge detect the start request *)
start_edge(CLK := X10);

CASE state OF

    0: (* IDLE - wait for a valid start request *)
        IF start_edge.Q AND (D10 = 1) THEN
            Y20 := TRUE;
            Y21 := TRUE;
            state := 1;
        END_IF;

    1: (* ADVANCING - fingers pushing plate to datum faces *)
        Y20 := TRUE;
        Y21 := TRUE;
        IF X20 AND X21 THEN
            (* both datum faces reached, begin retraction *)
            Y20 := FALSE;
            Y21 := FALSE;
            state := 2;
        END_IF;

    2: (* RETRACTING - fingers withdrawing, plate held by nest *)
        Y20 := FALSE;
        Y21 := FALSE;
        IF X22 THEN
            state := 3;
        END_IF;

    3: (* DONE / CHECKING - verify completion conditions and hold result *)
        Y20 := FALSE;
        Y21 := FALSE;
        IF NOT completed THEN
            IF X20 AND X21 AND X22 AND (NOT Y20) AND (NOT Y21) THEN
                Y2 := TRUE;
                completed := TRUE;
            END_IF;
        END_IF;

    ELSE
        (* should not occur; force safe idle-off state *)
        Y20 := FALSE;
        Y21 := FALSE;
        state := 0;

END_CASE;

(* Once completion is claimed, retain it and keep outputs OFF for the rest of the run *)
IF completed THEN
    Y2  := TRUE;
    Y20 := FALSE;
    Y21 := FALSE;
END_IF;

END_PROGRAM