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

    step : INT := 0;
    req_side : DINT;
    req_target : DINT;
    req_stroke : DINT;
    start_edge : R_TRIG;
    compl_timer : TON;
    compl_asserted : BOOL;
END_VAR

start_edge(CLK := X0);

CASE step OF
    0: (* WAIT_START - do not enable any axis before X0 *)
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;
        D20 := 0;
        D21 := 0;
        D24 := 0;
        D25 := 0;
        D28 := 0;
        D29 := 0;
        D32 := 0;
        D33 := 0;
        Y2 := FALSE;
        compl_asserted := FALSE;

        IF start_edge.Q THEN
            req_side := D101;
            req_target := D102;
            req_stroke := D103;
            step := 1;
        END_IF;

    1: (* SET_REFERENCE - side=1 gives A=60,B=0; side=2 gives A=0,B=60 *)
        IF req_side >= 100 AND req_side < 150 THEN
            D20 := 6000;
            D24 := 0;
        ELSE
            D20 := 0;
            D24 := 6000;
        END_IF;

        D21 := 1000;
        D25 := 1000;
        Y20 := TRUE;
        Y21 := TRUE;

        IF ABS(D10 - D20) <= 20 AND ABS(D11) <= 100 AND
           ABS(D12 - D24) <= 20 AND ABS(D13) <= 100 THEN
            step := 2;
        END_IF;

    2: (* TRANSFER_C - move C to target *)
        D28 := req_target;
        D29 := 1000;
        Y22 := TRUE;

        IF ABS(D14 - D28) <= 20 AND ABS(D15) <= 100 THEN
            step := 3;
        END_IF;

    3: (* APPROACH_D - move D to stroke, C=target and reference maintained *)
        D32 := req_stroke;
        D33 := 1000;
        Y23 := TRUE;

        IF ABS(D16 - D32) <= 20 AND ABS(D17) <= 100 THEN
            step := 4;
        END_IF;

    4: (* RETRACT_D - D back to 0 *)
        D32 := 0;
        D33 := 1000;

        IF ABS(D16) <= 20 AND ABS(D17) <= 100 THEN
            Y23 := FALSE;
            step := 5;
        END_IF;

    5: (* RETRACT_C - C back to 0 *)
        D28 := 0;
        D29 := 1000;

        IF ABS(D14) <= 20 AND ABS(D15) <= 100 THEN
            Y22 := FALSE;
            step := 6;
        END_IF;

    6: (* RELEASE_REF - A and B back to 0 *)
        D20 := 0;
        D24 := 0;
        D21 := 1000;
        D25 := 1000;

        IF ABS(D10) <= 20 AND ABS(D11) <= 100 AND
           ABS(D12) <= 20 AND ABS(D13) <= 100 THEN
            Y20 := FALSE;
            Y21 := FALSE;
            step := 7;
        END_IF;

    7: (* DONE - all at 0, assert completion *)
        D20 := 0;
        D24 := 0;
        D28 := 0;
        D32 := 0;
        D21 := 0;
        D25 := 0;
        D29 := 0;
        D33 := 0;
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y23 := FALSE;

        compl_timer(IN := NOT compl_asserted, PT := T#100ms);
        IF compl_timer.Q THEN
            compl_asserted := TRUE;
        END_IF;
        Y2 := compl_asserted;

END_CASE;

END_PROGRAM