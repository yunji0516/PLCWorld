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
    state : INT := 0;
    startReq : R_TRIG;
    reqData : INT := 0;
    raiseDoneThreshold : INT := 500;   (* safe center pos to lower bridge, keeps unsupported <=150mm *)
    finalThreshold : INT := 699;       (* within 1mm of +700 endpoint *)
END_VAR

startReq(CLK := X10);

IF startReq.Q AND state = 0 THEN
    reqData := D10;
    state := 1;
END_IF;

CASE state OF

    0: (* IDLE - no commands before start accepted *)
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        Y2  := FALSE;

    1: (* RAISING bridge before any push, board sits fully supported on source *)
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        Y20 := TRUE;
        IF X20 THEN
            Y20 := FALSE;
            state := 2;
        END_IF;

    2: (* PUSHING1 - bridge fully raised gives full support -1100..1100 *)
        Y20 := FALSE;
        Y21 := FALSE;
        Y23 := FALSE;
        IF D20 >= raiseDoneThreshold THEN
            Y22 := FALSE;
            state := 3;
        ELSE
            Y22 := TRUE;
        END_IF;

    3: (* LOWERING bridge - board stationary at safe center (>=500) *)
        Y20 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        Y21 := TRUE;
        IF X21 THEN
            Y21 := FALSE;
            state := 4;
        END_IF;

    4: (* PUSHING2 - bridge lowered, safe zone since unsupported width = 650-c <=150 for c>=500, decreasing further *)
        Y20 := FALSE;
        Y21 := FALSE;
        Y23 := FALSE;
        IF (D20 >= finalThreshold) AND X25 THEN
            Y22 := FALSE;
            state := 5;
        ELSE
            Y22 := TRUE;
        END_IF;

    5: (* RETRACTING pusher home, board stays put (retract does not pull board back) *)
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := TRUE;
        IF X22 THEN
            Y23 := FALSE;
            state := 6;
        END_IF;

    6: (* DONE - all actuator outputs off, maintain completion claim *)
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        IF X25 AND (D20 >= finalThreshold) AND X21 AND X22 THEN
            Y2 := TRUE;
        END_IF;

    ELSE
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;

END_CASE;

END_PROGRAM