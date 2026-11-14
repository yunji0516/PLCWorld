PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    Y21 : BOOL;
    X20 : BOOL;
    X21 : BOOL;
    D20 : INT;

    (* Internal variables *)
    state      : INT := 0;   // 0=IDLE,1=MOVING,2=RETURNING,3=CHECK,4=DONE
    startEdge  : R_TRIG;
    timer1     : TON;
    timer2     : TON;
    key        : INT;
    reqKey     : INT;
    match      : BOOL;
    completed  : BOOL := FALSE;
END_VAR

startEdge(CLK := X10);

CASE state OF

0: // IDLE - wait for a valid start request while at home
    Y20 := FALSE;
    Y21 := FALSE;

    IF startEdge.Q AND X20 THEN
        key    := D20;
        reqKey := D10;
        match  := (key = reqKey);

        IF match THEN
            Y20 := TRUE;
            Y21 := FALSE;
        ELSE
            Y21 := TRUE;
            Y20 := FALSE;
        END_IF;

        state := 1;
    END_IF;

1: // MOVING - hold selected output ON for 0.5 s to fully advance
    timer1(IN := TRUE, PT := T#500ms);

    IF timer1.Q THEN
        Y20 := FALSE;
        Y21 := FALSE;
        timer1(IN := FALSE, PT := T#500ms); // reset for cleanliness
        state := 2;
    END_IF;

2: // RETURNING - both outputs OFF for 0.5 s to return home
    Y20 := FALSE;
    Y21 := FALSE;

    timer2(IN := TRUE, PT := T#500ms);

    IF timer2.Q THEN
        timer2(IN := FALSE, PT := T#500ms); // reset for cleanliness
        state := 3;
    END_IF;

3: // CHECK - verify home and correct destination outcome
    Y20 := FALSE;
    Y21 := FALSE;

    IF X20 THEN
        IF match THEN
            IF X21 THEN
                Y2 := TRUE;
                completed := TRUE;
            END_IF;
        ELSE
            IF NOT X21 THEN
                Y2 := TRUE;
                completed := TRUE;
            END_IF;
        END_IF;
    END_IF;

    IF completed THEN
        state := 4;
    END_IF;

4: // DONE - hold result and completion claim, outputs remain OFF
    Y20 := FALSE;
    Y21 := FALSE;
    Y2  := TRUE;

ELSE
    Y20 := FALSE;
    Y21 := FALSE;

END_CASE

END_PROGRAM