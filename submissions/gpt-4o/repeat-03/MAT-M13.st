PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL := FALSE;
    Y20 : BOOL := FALSE;
    Y21 : BOOL := FALSE;
    Y22 : BOOL := FALSE;
    Y23 : BOOL := TRUE; // Starts retracted
    X20 : BOOL;
    X21 : BOOL;
    X22 : BOOL;
    X23 : BOOL;
    D20 : INT;
    D21 : INT;
    (* Internal Variables *)
    requestedId : INT := 0;
    startEdge : R_TRIG;
    state : INT := 0;
END_VAR

(* Implement the control logic here. *)

startEdge(CLK := X10);

CASE state OF
    0: (* Wait for start request *)
        IF startEdge.Q THEN
            requestedId := D10;
            state := 1;
        END_IF

    1: (* Align to ejector position (station 2) *)
        IF (D21 = 0 OR D21 = 1) THEN
            Y20 := TRUE; // CW
            Y21 := FALSE;
        ELSIF (D21 = 3) THEN
            Y21 := TRUE; // CCW
            Y20 := FALSE;
        ELSE
            Y20 := FALSE;
            Y21 := FALSE;
            IF X20 THEN
                state := 2;
            END_IF
        END_IF
        
    2: (* Verify ID at ejector station *)
        IF (D21 = 2) THEN
            IF D20 = requestedId THEN
                Y22 := TRUE; // Push
                Y23 := FALSE;
                state := 3;
            ELSE
                state := 1; // Not matching, return to alignment phase
            END_IF
        END_IF

    3: (* Eject item and retract *)
        IF X23 THEN
            Y22 := FALSE;
            Y23 := TRUE; // Retract
            IF X21 THEN
                state := 4;
            END_IF
        END_IF

    4: (* Completion claim *)
        Y2 := TRUE;
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
END_CASE

END_PROGRAM