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
    (* Add internal variables here. *)
    state : INT := 0;      (* 0=idle,1=pushing,2=retracting,3=done *)
    start_trig : R_TRIG;
END_VAR

start_trig(CLK := X10);

CASE state OF

0: (* idle - wait for start *)
    Y20 := FALSE;
    Y21 := FALSE;
    IF start_trig.Q THEN
        state := 1;
    END_IF;

1: (* pushing forward *)
    Y20 := TRUE;
    Y21 := FALSE;
    IF X21 THEN
        state := 2;
    END_IF;

2: (* retracting home *)
    Y20 := FALSE;
    Y21 := TRUE;
    IF X20 THEN
        state := 3;
    END_IF;

3: (* pusher home, both outputs off; check receiver for completion *)
    Y20 := FALSE;
    Y21 := FALSE;
    IF X22 THEN
        Y2 := TRUE;
    END_IF;

ELSE
    Y20 := FALSE;
    Y21 := FALSE;

END_CASE;

END_PROGRAM