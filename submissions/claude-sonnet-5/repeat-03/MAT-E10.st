PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    X20 : BOOL;
    D20 : INT;

    (* internal variables *)
    startEdge   : R_TRIG;
    started     : BOOL;
    violation   : BOOL;
    completed   : BOOL;
    scanCount   : DINT;
    lowThresh   : INT := 300;   (* turn unwind ON when buffer at/below this *)
    highThresh  : INT := 600;   (* turn unwind OFF when buffer at/above this *)
END_VAR

(* scan counter, mainly for internal bookkeeping *)
scanCount := scanCount + 1;

(* detect rising edge of Start request *)
startEdge(CLK := X10);
IF startEdge.Q THEN
    started := TRUE;
END_IF;

(* Safety: never initiate before Start *)
IF NOT started THEN
    Y20 := FALSE;
ELSE
    (* Feedback / hysteresis control of unwind based on buffer reading *)
    IF X20 THEN
        (* withdrawal ended: unwind must be OFF *)
        Y20 := FALSE;
    ELSIF D20 <= lowThresh THEN
        Y20 := TRUE;
    ELSIF D20 >= highThresh THEN
        Y20 := FALSE;
    END_IF;
    (* if buffer is between thresholds, retain previous Y20 state (hysteresis) *)
END_IF;

(* Monitor band compliance throughout withdrawal, until completion is claimed *)
IF started AND NOT completed THEN
    IF (D20 < 200) OR (D20 > 700) THEN
        violation := TRUE;
    END_IF;
END_IF;

(* Completion check: withdrawal ended, unwind OFF, no band violation observed *)
IF started AND X20 AND (NOT Y20) AND (NOT violation) AND (NOT completed) THEN
    completed := TRUE;
END_IF;

(* Latch completion result and hold Y2 through remaining execution budget *)
IF completed THEN
    Y2 := TRUE;
ELSE
    Y2 := FALSE;
END_IF;

END_PROGRAM