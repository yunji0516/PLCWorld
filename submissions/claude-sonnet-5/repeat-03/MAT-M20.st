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
    D20 : INT;

    (* internal *)
    startReq   : R_TRIG;
    requestAcc : BOOL := FALSE;
    state      : INT := 0;
END_VAR

(* Detect the single rising-edge start request *)
startReq(CLK := X10);

IF startReq.Q AND NOT requestAcc THEN
    requestAcc := TRUE;
    (* D10 request value accepted; only value 1 defined for this task *)
    state := 1;
END_IF;

CASE state OF

0:
    (* Idle: no actuator commands before Start is accepted *)
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
    Y23 := FALSE;

1:
    (* Raise bridge fully before crossing the gap; keep pusher idle *)
    Y20 := TRUE;
    Y21 := FALSE;
    Y22 := FALSE;
    Y23 := FALSE;
    IF X20 THEN
        state := 2;
    END_IF;

2:
    (* Bridge stays raised (continuous support), push board across *)
    Y20 := TRUE;
    Y21 := FALSE;
    Y22 := TRUE;
    Y23 := FALSE;
    IF X25 AND (D20 >= 699) THEN
        (* whole board received and within 1 mm of +700 endpoint *)
        state := 3;
    END_IF;

3:
    (* Board fully on receiving support: safe to lower bridge and retract pusher *)
    Y20 := FALSE;
    Y21 := TRUE;
    Y22 := FALSE;
    Y23 := TRUE;
    IF X21 AND X22 THEN
        state := 4;
    END_IF;

4:
    (* Terminal state: all actuator outputs OFF, completion claimed and held *)
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
    Y23 := FALSE;
    Y2  := TRUE;

ELSE
    (* Should not occur; force safe idle state *)
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
    Y23 := FALSE;
    state := 0;

END_CASE;

END_PROGRAM