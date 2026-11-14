PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL := FALSE;
    Y20 : BOOL := FALSE;
    Y21 : BOOL := FALSE;
    X20 : BOOL;
    X21 : BOOL;
    D20 : INT;
    D21 : INT;
    (* Add internal variables here. *)
    started : BOOL := FALSE;
    prev_X10 : BOOL := FALSE;
    targetVolume : INT;
    timer : TON;
    resultHeld : BOOL := FALSE;
    holdCounter : INT := 0;
END_VAR

(* Implement the control logic here. *)
timer(IN := FALSE, PT := T#10MS);

IF NOT started THEN
    IF X10 AND NOT prev_X10 THEN
        targetVolume := D10;
        started := TRUE;
        resultHeld := FALSE;
        holdCounter := 0;
    END_IF;
ELSE
    IF NOT resultHeld THEN
        IF D20 >= targetVolume AND D20 <= targetVolume + 2 THEN
            Y21 := FALSE;
            Y20 := FALSE;
            IF X21 THEN
                Y2 := TRUE;
                resultHeld := TRUE;
            ELSE
                Y2 := FALSE;
            END_IF;
        ELSE
            IF NOT X20 THEN
                Y20 := TRUE;
                timer(IN := TRUE);
            ELSE
                timer(IN := FALSE);
                IF timer.Q THEN
                    Y21 := TRUE;
                END_IF;
            END_IF;
            
            IF D20 > targetVolume + 2 THEN
                Y21 := FALSE;
                Y20 := FALSE;
                started := FALSE;
                Y2 := FALSE;
            END_IF;
        END_IF;
    ELSE
        IF holdCounter < 50 THEN
            holdCounter := holdCounter + 1;
        ELSE
            started := FALSE;
            Y2 := FALSE;
        END_IF;
    END_IF;
END_IF;

prev_X10 := X10;

END_PROGRAM