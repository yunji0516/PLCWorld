PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    X20 : BOOL;
    X21 : BOOL;
    X22 : BOOL;
    (* Add internal variables here. *)
    started   : BOOL := FALSE;
    completed : BOOL := FALSE;
    r_trig1   : R_TRIG;
END_VAR

(* Implement the control logic here. *)

r_trig1(CLK := X10);

// Start the release sequence only on a rising edge of X10, and only once.
IF r_trig1.Q AND NOT started AND D10 = 1 THEN
    started := TRUE;
END_IF;

// Grip command: hold closed until Start, then open (release) and never reacquire.
IF started THEN
    Y20 := FALSE;
ELSE
    Y20 := TRUE;
END_IF;

// Completion latch: product released, no longer held, and received by support.
IF (NOT completed) AND started AND X21 AND X22 AND (NOT X20) THEN
    completed := TRUE;
END_IF;

// Completion claim, retained once achieved.
IF completed THEN
    Y2 := TRUE;
ELSE
    Y2 := FALSE;
END_IF;

END_PROGRAM