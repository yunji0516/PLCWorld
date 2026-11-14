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

    (* internal *)
    startTrig : R_TRIG;
    started   : BOOL := FALSE;
    state     : INT := 0;   (* 0=idle,1=advancing,2=retracting,3=done/verify *)
    done      : BOOL := FALSE;
END_VAR

(* Detect the single Start rising edge *)
startTrig(CLK := X10);

IF startTrig.Q AND (D10 = 1) THEN
    started := TRUE;
END_IF;

CASE state OF

0: (* Idle: outputs off, wait for start *)
    Y20 := FALSE;
    Y21 := FALSE;
    Y2  := FALSE;
    IF started THEN
        state := 1;
    END_IF;

1: (* Advance both alignment fingers toward datum faces *)
    Y20 := TRUE;
    Y21 := TRUE;
    IF X20 AND X21 THEN
        state := 2;
    END_IF;

2: (* Datums reached: retract both fingers *)
    Y20 := FALSE;
    Y21 := FALSE;
    IF X22 THEN
        state := 3;
    END_IF;

3: (* Retracted: verify datum errors, fingers clear, outputs off *)
    Y20 := FALSE;
    Y21 := FALSE;
    IF NOT done THEN
        IF X20 AND X21 AND X22 THEN
            done := TRUE;
        END_IF;
    END_IF;
    Y2 := done;

ELSE
    Y20 := FALSE;
    Y21 := FALSE;
    Y2  := done;

END_CASE;

END_PROGRAM