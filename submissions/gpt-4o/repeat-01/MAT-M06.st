PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL := FALSE;
    Y20 : BOOL := FALSE;
    Y21 : BOOL := FALSE;
    Y22 : BOOL := FALSE;
    Y23 : BOOL := FALSE;
    X20 : BOOL;
    X21 : BOOL;
    X22 : BOOL;
    X23 : BOOL;
    D20 : INT;
    D21 : INT;
    (* Internal variables *)
    startRequest : BOOL := FALSE;
    targetVolumeReached : BOOL := FALSE;
    startProcessed : BOOL := FALSE;
    requestedVolume : INT := 0;
    initialPumpVolume : INT := 0;
END_VAR

(* Rising edge detection for start. *)
IF (X10 AND NOT startRequest) THEN
    startProcessed := TRUE;
    requestedVolume := D10;
    initialPumpVolume := D21;
END_IF
startRequest := X10;

(* Main control logic. *)
IF startProcessed THEN
    (* Lower the nozzle if not at the lower position. *)
    IF NOT X21 THEN
        Y20 := TRUE;     (* Command: down *)
        Y21 := FALSE;
    ELSE
        Y20 := FALSE;
    END_IF

    (* Open the valve if the nozzle is at the lower position. *)
    IF X21 AND NOT X22 THEN
        Y22 := TRUE;     (* Command: valve open *)
    END_IF

    (* Activate the pump if the valve is open. *)
    IF X22 THEN
        Y23 := TRUE;     (* Command: pump on *)
    END_IF

    (* Check for the target volume to be reached. *)
    IF (D20 >= requestedVolume - 2) AND (D20 <= requestedVolume + 2) THEN
        targetVolumeReached := TRUE;
    END_IF

    (* Once the target volume is reached, stop operations *)
    IF targetVolumeReached THEN
        Y22 := FALSE;    (* Command: valve close *)
        Y23 := FALSE;    (* Command: pump off *)

        IF X23 THEN
            Y21 := TRUE;  (* Command: move up only if valve is closed *)
            Y20 := FALSE;
        END_IF

        IF NOT Y22 AND NOT Y23 AND X20 THEN
            Y2 := TRUE;  (* Completion claim *)
        END_IF
    END_IF
END_IF

END_PROGRAM