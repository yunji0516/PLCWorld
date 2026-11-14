PROGRAM Main
VAR
    X0 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    D14 : DINT;
    D15 : DINT;
    D101 : DINT;
    X34 : BOOL;
    X35 : BOOL;
    D90 : DINT;
    D20 : DINT;
    D21 : DINT;
    Y20 : BOOL;
    D24 : DINT;
    D25 : DINT;
    Y21 : BOOL;
    D28 : DINT;
    D29 : DINT;
    Y22 : BOOL;
    Y30 : BOOL;
    Y2 : BOOL;

    (* internal state *)
    started        : BOOL := FALSE;
    state          : INT := 0;
    b_retracted_ok : BOOL := FALSE;
    c_raised_ok    : BOOL := FALSE;
    fresh_crossing : BOOL := FALSE;
    stop_ok        : BOOL := FALSE;
    configured_issued : BOOL := FALSE;
    edge_latched   : DINT := 0;
    search_target  : DINT := 0;
    final_target   : DINT := 0;
    pos_tol        : DINT := 20;   (* 0.2 mm * 100 *)
    speed_tol      : DINT := 100;  (* 1 mm/s * 100 *)
    x34_trig       : R_TRIG;
END_VAR

(* latch the start request once seen *)
IF X0 THEN
    started := TRUE;
END_IF;

x34_trig(CLK := X34);

CASE state OF

    0: (* INIT - wait for start, no enable allowed yet *)
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y30 := FALSE;
        Y2  := FALSE;
        D20 := 0;
        D21 := 0;
        D24 := 0;
        D25 := 500;
        D28 := 0;
        D29 := 500;
        IF started THEN
            state := 1;
        END_IF;

    1: (* RETRACT_B - avoid upper jaw before raising C *)
        Y21 := TRUE;
        D24 := 0;
        D25 := 500;
        Y22 := FALSE;
        Y20 := FALSE;
        Y30 := FALSE;
        Y2  := FALSE;
        IF ABS(D12 - 0) <= pos_tol AND ABS(D13) <= speed_tol THEN
            b_retracted_ok := TRUE;
            state := 2;
        END_IF;

    2: (* RAISE_C - lift head above guard *)
        Y21 := TRUE;
        D24 := 0;
        D25 := 500;
        Y22 := TRUE;
        D28 := 10000; (* 100 mm *)
        D29 := 500;
        Y20 := FALSE;
        Y30 := FALSE;
        Y2  := FALSE;
        IF ABS(D14 - 10000) <= pos_tol AND ABS(D15) <= speed_tol THEN
            c_raised_ok := TRUE;
            IF D10 <= 9000 THEN
                search_target := 16000; (* move toward 160 mm *)
            ELSE
                search_target := 2000;  (* move toward 20 mm *)
            END_IF;
            state := 3;
        END_IF;

    3: (* SEARCH_A - slow scan across reference sensor band *)
        Y21 := TRUE;
        D24 := 0;
        D25 := 500;
        Y22 := TRUE;
        D28 := 10000;
        D29 := 500;
        Y20 := TRUE;
        D20 := search_target;
        D21 := 100; (* slow, controlled stopping distance *)
        Y30 := FALSE;
        Y2  := FALSE;
        IF x34_trig.Q AND b_retracted_ok AND c_raised_ok THEN
            edge_latched := D10;
            fresh_crossing := TRUE;
            D20 := edge_latched;
            state := 4;
        END_IF;

    4: (* STOPPING - settle within 10mm after the edge *)
        Y21 := TRUE;
        D24 := 0;
        D25 := 500;
        Y22 := TRUE;
        D28 := 10000;
        D29 := 500;
        Y20 := TRUE;
        D20 := edge_latched;
        D21 := 100;
        Y30 := FALSE;
        Y2  := FALSE;
        IF ABS(D10 - edge_latched) <= pos_tol AND ABS(D11) <= speed_tol THEN
            stop_ok := TRUE;
            state := 5;
        END_IF;

    5: (* WAIT_CONFIGURED - issue configuration edge, wait for ack *)
        Y21 := TRUE;
        D24 := 0;
        D25 := 500;
        Y22 := TRUE;
        D28 := 10000;
        D29 := 500;
        Y20 := TRUE;
        D20 := edge_latched;
        D21 := 100;
        Y2  := FALSE;
        IF b_retracted_ok AND c_raised_ok AND fresh_crossing AND stop_ok THEN
            Y30 := TRUE;
            configured_issued := TRUE;
        ELSE
            Y30 := FALSE;
        END_IF;
        IF configured_issued AND X35 THEN
            final_target := D90 + D101;
            state := 6;
        END_IF;

    6: (* FINAL_MOVE - go to registered origin + park offset *)
        Y21 := TRUE;
        D24 := 0;
        D25 := 500;
        Y22 := TRUE;
        D28 := 10000;
        D29 := 500;
        Y20 := TRUE;
        D20 := final_target;
        D21 := 500;
        Y30 := TRUE;
        Y2  := FALSE;
        IF ABS(D10 - final_target) <= pos_tol AND ABS(D11) <= speed_tol
           AND ABS(D12 - 0) <= pos_tol AND ABS(D13) <= speed_tol
           AND ABS(D14 - 10000) <= pos_tol AND ABS(D15) <= speed_tol THEN
            state := 7;
        END_IF;

    7: (* DONE - hold position and completion *)
        Y21 := TRUE;
        D24 := 0;
        D25 := 500;
        Y22 := TRUE;
        D28 := 10000;
        D29 := 500;
        Y20 := TRUE;
        D20 := final_target;
        D21 := 500;
        Y30 := TRUE;
        Y2  := TRUE;

    ELSE
        ;
END_CASE;

END_PROGRAM