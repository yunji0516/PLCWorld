PROGRAM Main
VAR
    X10 : BOOL;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    D14 : DINT;
    X11 : BOOL;
    X12 : BOOL;
    D20 : DINT;
    D21 : DINT;
    Y20 : BOOL;
    Y21 : BOOL;
    Y2 : BOOL;
    
    requestReceived : BOOL := FALSE;
    forkInserted : BOOL := FALSE;
    aligning : BOOL := FALSE;
    
    timerAlignment : TON;
    timerCompletion : TON;
END_VAR

(* Check if request is active, and set up the initial conditions. *)
IF X10 THEN
    requestReceived := TRUE;
END_IF

(* Process the alignment and fork insertion only if there is a request. *)
IF requestReceived THEN
    (* Determine if alignment is needed. *)
    IF NOT aligning THEN
        aligning := TRUE;
        Y20 := TRUE; (* Movement reference following active. *)
    END_IF
    
    (* Synchronize carrier with external reference axis U. *)
    D20 := DINT(D13);  (* Set reference position equal to U's current position. *)
    D21 := D14;        (* Set reference speed equal to U's current speed. *)
    
    (* Check alignment criteria. *)
    IF ABS(D11 - D13) <= 20 AND ABS(D12 - D14) <= 100 THEN
        (* Alignment achieved, begin fork insertion. *)
        Y21 := TRUE;
        IF X11 THEN
            forkInserted := TRUE;
            aligning := FALSE;
            requestReceived := FALSE; (* Reset request handling after insertion and alignment. *)
            
            (* Start completion timer once fork inserted and synchronized. *)
            timerCompletion(IN := TRUE, PT := T#30ms);

            IF timerCompletion.Q THEN
                Y2 := TRUE; (* Set task completion retention. *)
            ELSE
                Y2 := FALSE;
            END_IF
        END_IF
    ELSE
        (* Reset fork inserted state if alignment criteria are no longer met. *)
        IF forkInserted THEN
            Y21 := FALSE;
            forkInserted := FALSE;
        END_IF
    END_IF
ELSE
    (* Ensure outputs are cleared when no request is active. *)
    Y20 := FALSE; (* Movement reference following not active. *)
    Y21 := FALSE; (* Fork insertion not active. *)
    Y2 := FALSE;  (* Task completion not active. *)
    forkInserted := FALSE;
END_IF

(* Reset completion timer and outputs if no request or after fulfillment. *)
IF NOT requestReceived OR (timerCompletion.Q AND Y2) THEN
    requestReceived := FALSE;
    aligning := FALSE;
    Y20 := FALSE;
    Y21 := FALSE;
    Y2 := FALSE;
    forkInserted := FALSE;
    timerAlignment(IN := FALSE);
    timerCompletion(IN := FALSE);
END_IF

END_PROGRAM