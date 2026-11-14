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
    X23 : BOOL;
    D20 : INT;
    D21 : INT;

    (* Internal variables *)
    state      : INT := 0;   (* 0=idle,1=flush waste,2=switch branch,3=pump target,4=done/hold *)
    startReq   : R_TRIG;
    accepted   : BOOL := FALSE;
    reqID      : INT := 0;
    claimed    : BOOL := FALSE;
END_VAR

(* Detect single rising edge start request *)
startReq(CLK := X10);

IF startReq.Q AND NOT accepted THEN
    accepted := TRUE;
    reqID := D10;
    state := 1;
END_IF;

CASE state OF

    0:
        (* Idle: no actuator commands before acceptance *)
        Y20 := FALSE;
        Y21 := FALSE;

    1:
        (* Flush previous material to waste; branch stays at waste while pumping *)
        Y21 := FALSE;
        Y20 := TRUE;
        IF D20 = 2 THEN
            (* Previous material exhausted at outlet; stop pump before moving branch *)
            Y20 := FALSE;
            state := 2;
        END_IF;

    2:
        (* Pump is off; safe to move branch to target *)
        Y20 := FALSE;
        Y21 := TRUE;
        IF X21 THEN
            (* Branch confirmed at target *)
            state := 3;
        END_IF;

    3:
        (* Pump current material to target until source truly empty *)
        Y21 := TRUE;
        Y20 := TRUE;
        IF X22 AND (D21 = 0) THEN
            Y20 := FALSE;
            state := 4;
        END_IF;

    4:
        (* Hold terminal state: pump OFF, branch may remain at target *)
        Y20 := FALSE;
        Y21 := TRUE;

    ELSE
        Y20 := FALSE;
        Y21 := FALSE;

END_CASE;

(* Evaluate and latch completion claim *)
IF NOT claimed THEN
    IF (state = 4) AND X22 AND X23 AND (D20 = 2) AND (NOT Y20) THEN
        claimed := TRUE;
    END_IF;
END_IF;

IF claimed THEN
    Y2 := TRUE;
    (* Maintain terminal physical result: pump off, branch at target *)
    Y20 := FALSE;
    Y21 := TRUE;
ELSE
    Y2 := FALSE;
END_IF;

END_PROGRAM