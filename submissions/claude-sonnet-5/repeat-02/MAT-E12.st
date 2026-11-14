PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    D20 : INT;
    D21 : INT;

    (* internal state *)
    startEdge : R_TRIG;
    running   : BOOL := FALSE;   (* pump commanded active *)
    completed : BOOL := FALSE;   (* completion latched *)
    startedOnce : BOOL := FALSE; (* prevents re-trigger on later edges *)
END_VAR

(* Detect the single rising edge of the start request *)
startEdge(CLK := X10);

IF startEdge.Q AND NOT startedOnce AND NOT completed THEN
    (* Only initiate the requested operation after Start, and only if the
       requested outlet material matches the specification (ID2). *)
    IF D10 = 2 THEN
        running := TRUE;
        startedOnce := TRUE;
    END_IF
END_IF

(* Stop the pump as soon as the outlet observation confirms the transition
   to the new material (old residue fully displaced), limiting any
   additional new-material carryover to at most one scan's worth
   (0.1 mL at 10 mL/s over a 10 ms scan, well under the 1 mL cap). *)
IF running AND (D20 = 2) THEN
    running := FALSE;
    completed := TRUE;
END_IF

(* Drive the pump actuator only while actively running and not yet
   completed. Once completed, the pump remains OFF permanently. *)
Y20 := running AND NOT completed;

(* Latch and hold the completion claim once the physical conditions are
   satisfied; never clear it afterward. *)
IF completed THEN
    Y2 := TRUE;
END_IF

END_PROGRAM