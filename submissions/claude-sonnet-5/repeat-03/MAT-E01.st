PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    X20 : BOOL;

    (* Internal variables *)
    startTrig : R_TRIG;
    started   : BOOL := FALSE;
    completed : BOOL := FALSE;
END_VAR

(* Detect rising edge of Start request *)
startTrig(CLK := X10);

IF startTrig.Q THEN
    started := TRUE;
END_IF;

(* Only command the gripper closed after a valid Start has been received *)
IF started THEN
    Y20 := TRUE;
END_IF;

(* Latch completion once actual holding is observed *)
IF started AND X20 THEN
    completed := TRUE;
END_IF;

(* Maintain the completion claim once achieved, through the remaining budget *)
IF completed THEN
    Y2 := TRUE;
END_IF;

END_PROGRAM