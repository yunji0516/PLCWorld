PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    X20 : BOOL;

    start_trig : R_TRIG;
    started    : BOOL;
    seen_on    : BOOL;
    prev_X20   : BOOL;
    done       : BOOL;
END_VAR

(* Detect the single rising edge of the start request *)
start_trig(CLK := X10);
IF start_trig.Q THEN
    started := TRUE;
END_IF;

(* Only run after Start; never initiate before it *)
IF started AND NOT done THEN
    Y20 := TRUE;

    (* Track that the photoeye has actually gone ON (leading edge reached boundary) *)
    IF X20 THEN
        seen_on := TRUE;
    END_IF;

    (* A falling edge that follows a genuine ON means the trailing edge
       has passed x=120mm. This ignores the initial unblocked (OFF) state. *)
    IF seen_on AND prev_X20 AND (NOT X20) THEN
        done := TRUE;
        Y20  := FALSE;
        Y2   := TRUE;
    END_IF;
ELSE
    IF NOT started THEN
        Y20 := FALSE;
    END_IF;
END_IF;

(* Maintain completion state and output through the remaining budget *)
IF done THEN
    Y20 := FALSE;
    Y2  := TRUE;
END_IF;

prev_X20 := X20;

END_PROGRAM