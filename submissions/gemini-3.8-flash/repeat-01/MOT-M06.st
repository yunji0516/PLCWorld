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
    D18 : DINT;
    D19 : DINT;
    D101 : DINT;
    D102 : DINT;
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
    D36 : DINT;
    D37 : DINT;
    Y24 : BOOL;
    Y2 : BOOL;

    step : INT := 0;
    target_c : DINT := 0;
    target_e : DINT := 0;
END_VAR

CASE step OF
    0:
        Y20 := FALSE;
        D20 := 0;
        D21 := 0;
        Y21 := FALSE;
        D24 := 0;
        D25 := 0;
        Y22 := FALSE;
        D28 := 0;
        D29 := 0;
        Y23 := FALSE;
        D32 := 0;
        D33 := 0;
        Y24 := FALSE;
        D36 := 0;
        D37 := 0;
        Y2 := FALSE;

        IF X0 THEN
            target_c := D101;
            target_e := D102;
            step := 10;
        END_IF;

    10:
        (* Open A and B vertical opening plates *)
        Y20 := TRUE;
        D20 := 10000;
        D21 := 1000;
        Y21 := TRUE;
        D24 := 10000;
        D25 := 1000;

        IF ABS(D10 - 10000) <= 20 AND ABS(D11) <= 100 AND
           ABS(D12 - 10000) <= 20 AND ABS(D13) <= 100 THEN
            step := 20;
        END_IF;

    20:
        (* Move C transfer jig to target *)
        Y22 := TRUE;
        D28 := target_c;
        D29 := 1000;

        IF ABS(D14 - target_c) <= 20 AND ABS(D15) <= 100 THEN
            step := 30;
        END_IF;

    30:
        (* Dock D lower support under jig at 70 *)
        Y23 := TRUE;
        D32 := 7000;
        D33 := 1000;

        IF ABS(D16 - 7000) <= 20 AND ABS(D17) <= 100 THEN
            step := 40;
        END_IF;

    40:
        (* Lower E upper tool to stroke *)
        Y24 := TRUE;
        D36 := target_e;
        D37 := 1000;

        IF ABS(D18 - target_e) <= 20 AND ABS(D19) <= 100 THEN
            step := 50;
        END_IF;

    50:
        (* Retract E upper tool to 0 *)
        D36 := 0;
        D37 := 1000;

        IF ABS(D18) <= 20 AND ABS(D19) <= 100 THEN
            step := 60;
        END_IF;

    60:
        (* Lower D docking support to 0 *)
        D32 := 0;
        D33 := 1000;

        IF ABS(D16) <= 20 AND ABS(D17) <= 100 THEN
            step := 70;
        END_IF;

    70:
        (* Retract C transfer jig to 0 *)
        D28 := 0;
        D29 := 1000;

        IF ABS(D14) <= 20 AND ABS(D15) <= 100 THEN
            step := 80;
        END_IF;

    80:
        (* Close A and B vertical opening plates to 0 *)
        D20 := 0;
        D21 := 1000;
        D24 := 0;
        D25 := 1000;

        IF ABS(D10) <= 20 AND ABS(D11) <= 100 AND
           ABS(D12) <= 20 AND ABS(D13) <= 100 THEN
            step := 90;
        END_IF;

    90:
        (* Cycle complete, maintain all axes at 0 *)
        Y2 := TRUE;
END_CASE;

END_PROGRAM