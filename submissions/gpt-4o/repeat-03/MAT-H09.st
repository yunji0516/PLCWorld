PROGRAM Main
VAR
    X0 : BOOL;
    X10 : BOOL;
    X11 : BOOL;
    X12 : BOOL;
    X13 : BOOL;
    X14 : BOOL;
    X15 : BOOL;
    X16 : BOOL;
    X17 : BOOL;
    X18 : BOOL;
    X19 : BOOL;
    X20 : BOOL;
    X21 : BOOL;
    X22 : BOOL;
    X23 : BOOL;
    X24 : BOOL;
    X25 : BOOL;
    X26 : BOOL;
    X27 : BOOL;
    X28 : BOOL;
    X29 : BOOL;
    X30 : BOOL;
    X31 : BOOL;
    X32 : BOOL;
    Y10 : BOOL;
    Y11 : BOOL;
    Y12 : BOOL;
    Y13 : BOOL;
    Y14 : BOOL;
    Y15 : BOOL;
    Y16 : BOOL;
    Y17 : BOOL;
    Y18 : BOOL;
    Y19 : BOOL;
    Y20 : BOOL;
    Y21 : BOOL;
    Y22 : BOOL;
    D0 : INT;
    D1 : INT;
    D2 : INT;
    D3 : INT;
    D4 : INT;
    D5 : INT;
    D6 : INT;
    D7 : INT;
    D8 : INT;
    D9 : INT;
    D10 : INT;
    D11 : INT;
    D12 : INT;
    D13 : INT;
    X1A : BOOL;
    X1B : BOOL;
    X1C : BOOL;
    X1D : BOOL;
    X1E : BOOL;
    X1F : BOOL;
    X2A : BOOL;
    X2B : BOOL;
    X2C : BOOL;
    X2D : BOOL;
    X2E : BOOL;
    X2F : BOOL;
    Y1A : BOOL;
    Y1B : BOOL;
    Y1C : BOOL;
    Y1D : BOOL;
    Y1E : BOOL;
    Y1F : BOOL;

    (* Add internal variables here. *)
    refill_needed : BOOL := FALSE;
    a_ready_to_fill : BOOL := FALSE;
    b_ready_to_fill : BOOL := FALSE;
    a_valve_timer : TON;
    b_valve_timer : TON;
    tank_safe : BOOL := TRUE;
    completion_detected : BOOL := FALSE;
    completed_time : TIME := T#0s;
END_VAR

(* Implement the control logic here. *)

(* Refill Logic *)
IF D0 < 1600 AND X2F AND NOT refill_needed THEN
    refill_needed := TRUE;
END_IF

(* Prevent overfilling *)
IF refill_needed AND NOT X30 AND D1 > 0 THEN
    Y10 := TRUE;  (* Start refill *)
ELSE
    Y10 := FALSE;
END_IF

(* Swap management: avoid swapping with liquid or during refill *)
IF NOT X2F AND D0 = 0 AND NOT Y10 THEN
    Y11 := TRUE;
ELSE
    Y11 := FALSE;
END_IF

(* Filling Logic for Line A *)
a_ready_to_fill := X10 AND X11 AND X12 AND NOT X18;
IF a_ready_to_fill AND X19 THEN  (* If container is present and exit not busy *)
    Y14 := TRUE;
    Y15 := TRUE;
    IF X13 AND NOT X14 THEN  (* If in down position but not clamped *)
        Y16 := TRUE;  (* Command down *)
    ELSE
        Y16 := FALSE;
    END_IF

    IF X15 THEN  (* Clamp engaged *)
        Y17 := TRUE;  (* Open valve *)
        a_valve_timer(IN := NOT X16, PT := T#150ms);
        IF a_valve_timer.Q THEN
            Y18 := D4 < D5;  (* Pump if more liquid is needed *)
        ELSE
            Y18 := FALSE;
        END_IF
    ELSE
        Y17 := FALSE;
        Y18 := FALSE;
    END_IF
ELSE
    Y14 := FALSE;
    Y15 := FALSE;
    Y16 := FALSE;
    Y17 := FALSE;
    Y18 := FALSE;
END_IF

(* Filling Logic for Line B *)
b_ready_to_fill := X1E AND X1F AND X20 AND NOT X26;
IF b_ready_to_fill AND X27 THEN  (* If container is present and exit not busy *)
    Y1B := TRUE;
    Y1C := TRUE;
    IF X21 AND NOT X22 THEN  (* If in down position but not clamped *)
        Y1D := TRUE;  (* Command down *)
    ELSE
        Y1D := FALSE;
    END_IF

    IF X23 THEN  (* Clamp engaged *)
        Y1E := TRUE;  (* Open valve *)
        b_valve_timer(IN := NOT X24, PT := T#150ms);
        IF b_valve_timer.Q THEN
            Y1F := D9 < D10;  (* Pump if more liquid is needed *)
        ELSE
            Y1F := FALSE;
        END_IF
    ELSE
        Y1E := FALSE;
        Y1F := FALSE;
    END_IF
ELSE
    Y1B := FALSE;
    Y1C := FALSE;
    Y1D := FALSE;
    Y1E := FALSE;
    Y1F := FALSE;
END_IF

(* Capping Logic *)
IF NOT X2C THEN
    IF X28 AND NOT X29 THEN  (* Condition for line A *)
        Y12 := TRUE;
    ELSE
        Y12 := FALSE;
    END_IF

    IF X29 AND NOT X28 THEN  (* Condition for line B *)
        Y13 := TRUE;
    ELSE
        Y13 := FALSE;
    END_IF
END_IF

(* Completion Logic *)
IF X10 AND X1E ANDX29 AND D3 = 6 AND NOT X30 AND X32 OR (completion_detected AND TIME_TO_REAL(NOW) - TIME_TO_REAL(completed_time) >= 0.5) THEN
    Y22 := TRUE;
    completion_detected := TRUE;
    completed_time := NOW;
ELSE
    Y22 := FALSE;
END_IF

END_PROGRAM