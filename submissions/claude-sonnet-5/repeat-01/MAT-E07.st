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
    D20 : INT;

    (* internal state machine *)
    state : INT := 0;        (* 0=IDLE,1=PUSHING,2=RETRACTING,3=DONE *)
    startReq : R_TRIG;
    completed : BOOL := FALSE;
END_VAR

(* detect start rising edge *)
startReq(CLK := X10);

CASE state OF

0: (* IDLE - wait for start *)
    Y20 := FALSE;
    Y21 := FALSE;
    IF startReq.Q AND (D10 = 1) THEN
        state := 1;
    END_IF;

1: (* PUSHING - drive plate toward receiver *)
    Y20 := TRUE;
    Y21 := FALSE;
    IF X22 THEN
        (* whole plate detected inside receiver: stop pushing, retract pusher *)
        state := 2;
    END_IF;

2: (* RETRACTING - return pusher home *)
    Y20 := FALSE;
    Y21 := TRUE;
    IF X20 THEN
        state := 3;
    END_IF;

3: (* DONE - verify completion and hold outputs off *)
    Y20 := FALSE;
    Y21 := FALSE;

ELSE
    (* defensive fallback *)
    Y20 := FALSE;
    Y21 := FALSE;
    state := 0;

END_CASE;

(* Evaluate and latch completion once the entire plate is confirmed
   within the receiver support and the pusher is home with outputs off. *)
IF (NOT completed) AND (state = 3) AND X20 AND (NOT Y20) AND (NOT Y21)
   AND X22 AND (D20 >= 650) AND (D20 <= 700) THEN
    completed := TRUE;
END_IF;

IF completed THEN
    Y2 := TRUE;
ELSE
    Y2 := FALSE;
END_IF;

END_PROGRAM