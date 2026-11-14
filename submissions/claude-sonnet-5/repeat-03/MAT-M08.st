PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    Y21 : BOOL;
    Y22 : BOOL;
    Y23 : BOOL;
    X20 : BOOL;
    X21 : BOOL;
    X22 : BOOL;
    X23 : BOOL;
    X24 : BOOL;
    X25 : BOOL;
    X26 : BOOL;
    D20 : INT;

    (* Internal state *)
    startEdge : R_TRIG;
    state     : INT := 0;   (* 0=IDLE,1=CHECK,2=MOVE,3=PUSH,4=RETRACT,5=DONECHECK,6=MAINTAIN *)
    requestAccepted : BOOL := FALSE;
END_VAR

startEdge(CLK := X10);

CASE state OF

0: (* IDLE - wait for one rising edge start request with valid token *)
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
    Y23 := FALSE;
    Y2  := FALSE;
    IF startEdge.Q AND (D10 = 1) AND (NOT requestAccepted) THEN
        requestAccepted := TRUE;
        state := 1; (* go check current slot occupancy *)
    END_IF;

1: (* CHECK - only valid when aligned *)
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
    Y23 := FALSE;
    IF X25 THEN
        IF X24 THEN
            (* current slot occupied, need to move to next slot *)
            state := 2;
        ELSE
            (* vacant slot found, insert here *)
            state := 3;
        END_IF;
    END_IF;
    (* if not aligned yet, remain here until alignment settles *)

2: (* MOVE - move rack up to next slot, only if pusher retracted *)
    Y22 := FALSE;
    Y23 := FALSE;
    IF X22 AND (NOT X23) THEN
        (* pusher fully retracted, safe to move *)
        Y21 := FALSE;
        Y20 := TRUE;
        IF X25 THEN
            (* reached next alignment window *)
            Y20 := FALSE;
            state := 1;
        END_IF;
    ELSE
        (* pusher not retracted: hold, do not move *)
        Y20 := FALSE;
        Y21 := FALSE;
    END_IF;

3: (* PUSH - insert plate into verified vacant, aligned slot *)
    Y20 := FALSE;
    Y21 := FALSE;
    Y23 := FALSE;
    IF X25 AND (NOT X24) THEN
        Y22 := TRUE;
        IF X26 OR X23 THEN
            Y22 := FALSE;
            state := 4;
        END_IF;
    ELSE
        (* safety: never push into occupied or unaligned slot *)
        Y22 := FALSE;
    END_IF;

4: (* RETRACT - withdraw pusher *)
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
    Y23 := TRUE;
    IF X22 THEN
        Y23 := FALSE;
        state := 5;
    END_IF;

5: (* DONE CHECK - verify final terminal state before claiming completion *)
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
    Y23 := FALSE;
    IF (NOT Y20) AND (NOT Y21) AND (NOT Y22) AND (NOT Y23)
       AND X22 AND (NOT X23) AND X25 AND X24 AND X26 THEN
        Y2 := TRUE;
        state := 6;
    END_IF;

6: (* MAINTAIN - hold completion and actuator OFF state for remainder of run *)
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
    Y23 := FALSE;
    Y2  := TRUE;

ELSE
    (* fallback safety: force all actuators off *)
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
    Y23 := FALSE;

END_CASE;

END_PROGRAM