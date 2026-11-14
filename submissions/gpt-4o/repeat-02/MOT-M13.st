PROGRAM Main
VAR
    X0 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    D14 : DINT;
    D15 : DINT;
    D16 : DINT;
    D17 : DINT;
    D101 : DINT;
    D102 : DINT;
    D103 : DINT;
    D20 : DINT;
    D21 : DINT;
    Y20 : BOOL;
    D24 : DINT;
    D25 : DINT;
    Y21 : BOOL;
    D28 : DINT;
    D29 : DINT;
    Y22 : BOOL;
    D32 : DINT;
    D33 : DINT;
    Y23 : BOOL;
    Y2 : BOOL;

    state : INT := 0;
    timer : TON;
    a_ready : BOOL;
    b_ready : BOOL;
    c_ready : BOOL;
    d_ready : BOOL;
    a_docked : BOOL;

END_VAR

(* Initialize Outputs *)
D20 := 0;
D21 := 0;
Y20 := FALSE;
D24 := 0;
D25 := 0;
Y21 := FALSE;
D28 := 0;
D29 := 0;
Y22 := FALSE;
D32 := 0;
D33 := 0;
Y23 := FALSE;
Y2 := FALSE;

(* Main State Machine *)
CASE state OF
    0:
        (* Wait for Start *)
        IF X0 THEN
            (* Prepare Targets *)
            D20 := 120 * 100; // A = 120
            D24 := D101; // Request Angle
            D28 := D102 * 100; // Request Target
            D32 := D103 * 100; // Request Receive
            a_ready := FALSE;
            b_ready := FALSE;
            c_ready := FALSE;
            d_ready := FALSE;
            state := 1;
        END_IF
    1: 
        (* Move A to 120 and align B *)
        Y20 := TRUE;
        Y21 := TRUE;
        D21 := 1000;
        D25 := 1000;
        IF ABS(D10 - D20) <= 20 AND ABS(D11) <= 100 THEN
            a_ready := TRUE;
        END_IF
        IF ABS(D12 - D24) <= 20 AND ABS(D13) <= 100 THEN
            b_ready := TRUE;
        END_IF
        IF a_ready AND b_ready THEN
            state := 2;
        END_IF
    2:
        (* Move C to Target and D to Receive *)
        Y22 := TRUE;
        Y23 := TRUE;
        D29 := 1000;
        D33 := 1000;
        IF ABS(D14 - D28) <= 20 AND ABS(D15) <= 100 THEN
            c_ready := TRUE;
        END_IF
        IF (ABS(D16 - D32) <= 20 AND ABS(D17) <= 100) AND ((D14 < D28 - 4000) OR (D10 >= 11500)) THEN
            d_ready := TRUE;
        END_IF
        IF c_ready AND d_ready THEN
            state := 3;
            a_docked := FALSE;
        END_IF
    3:
        (* Dock at Support and wait *)
        D20 := 100 * 100; // A = 100 for docking
        D21 := 1000;
        IF ABS(D10 - D20) <= 20 AND ABS(D11) <= 100 THEN
            state := 4;
        END_IF
    4:
        (* Docked: Prepare Departure *)
        a_docked := TRUE;
        D20 := 120 * 100; // Lift A to leave the support
        D28 := 0; // Retrieve C
        IF a_docked THEN
            Y2 := TRUE; // Completion
            state := 5;
            timer(IN := TRUE, PT := T#100ms);
        END_IF
    5:
        (* Hold Completion for 100ms *)
        IF timer.Q THEN
            Y2 := FALSE;
            timer(IN := FALSE);
            state := 6;
        END_IF
    6:
        (* Reset All Axes to 0 *)
        D20 := 0;
        D24 := 0;
        D28 := 0;
        D32 := 0;
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        IF ABS(D10) <= 20 AND ABS(D11) <= 100 AND
           ABS(D12) <= 20 AND ABS(D13) <= 100 AND
           ABS(D14) <= 20 AND ABS(D15) <= 100 AND
           ABS(D16) <= 20 AND ABS(D17) <= 100 THEN
            state := 0; // Ready for next cycle
        END_IF
END_CASE

END_PROGRAM