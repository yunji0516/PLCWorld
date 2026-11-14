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
    X24 : BOOL;
    D20 : INT;
    D21 : INT;

    state : INT := 0;
    x10_prev : BOOL := FALSE;
END_VAR

(* Detect rising edge on start request to begin the operation *)
IF X10 AND NOT x10_prev AND state = 0 AND D10 = 1 THEN
    state := 1;
END_IF;
x10_prev := X10;

CASE state OF
    0:
        (* Initial idle state *)
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y2 := FALSE;

    1:
        (* Load product into the launch nest *)
        Y20 := FALSE;
        Y21 := FALSE;
        
        (* Do not advance supply finger if launch pusher is away from home *)
        IF X20 THEN
            Y22 := TRUE;
        ELSE
            Y22 := FALSE;
        END_IF;
        
        (* Wait until full placement is reported *)
        IF X23 THEN
            state := 2;
        END_IF;

    2:
        (* Withdraw the supply finger *)
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        
        (* Wait until supply finger is fully returned home *)
        IF X24 THEN
            state := 3;
        END_IF;

    3:
        (* Wait for firing window *)
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        
        (* The launch pusher takes exactly 1.0 s to extend.
           D21 is speed in mm/s, so the pocket will travel exactly D21 mm in 1.0 s.
           Fire when remaining arc distance D20 is just equal to or slightly less than D21.
           The lower bound D21 - 30 prevents firing if the window was already missed. *)
        IF D20 <= D21 AND D20 >= (D21 - 30) THEN
            state := 4;
        END_IF;

    4:
        (* Fire launch pusher *)
        Y20 := TRUE;
        Y21 := FALSE;
        Y22 := FALSE;
        
        (* Wait for pusher to reach full extension *)
        IF X21 THEN
            state := 5;
        END_IF;

    5:
        (* Retract launch pusher *)
        Y20 := FALSE;
        Y21 := TRUE;
        Y22 := FALSE;
        
        (* Wait for pusher to return home *)
        IF X20 THEN
            state := 6;
        END_IF;

    6:
        (* Operation complete, hold completion claim *)
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y2 := TRUE;
END_CASE;

END_PROGRAM