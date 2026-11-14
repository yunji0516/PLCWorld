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

    (* Internal *)
    step : INT := 0;
    started : BOOL := FALSE;
    startTrig : R_TRIG;

    POS_TOL : DINT := 20;   (* 0.2 mm * 100 *)
    VEL_TOL : DINT := 100;  (* 1 mm/s * 100 *)
    A_OPEN  : DINT := 5000; (* 50 mm raw, > 27.5mm clearance minimum *)
    B_OPEN  : DINT := 5000;
    D_DOCK  : DINT := 7000; (* 70 mm raw *)
END_VAR

startTrig(CLK := X0);
IF startTrig.Q THEN
    started := TRUE;
    IF step = 0 THEN
        step := 1;
    END_IF;
END_IF;

IF NOT started THEN
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
    Y23 := FALSE;
    Y24 := FALSE;
    D20 := 0; D21 := 0;
    D24 := 0; D25 := 0;
    D28 := 0; D29 := 0;
    D32 := 0; D33 := 0;
    D36 := 0; D37 := 0;
    Y2 := FALSE;
ELSE
    CASE step OF
        0:
            (* not reached normally, safety default *)
            ;

        1: (* Open A/B plates to clear the transfer jig path *)
            Y20 := TRUE;
            Y21 := TRUE;
            D20 := A_OPEN; D21 := 1000;
            D24 := B_OPEN; D25 := 1000;

            IF (ABS(D10 - A_OPEN) <= POS_TOL) AND (ABS(D11) <= VEL_TOL) AND
               (ABS(D12 - B_OPEN) <= POS_TOL) AND (ABS(D13) <= VEL_TOL) THEN
                step := 2;
            END_IF;

        2: (* Move C transfer jig to requested target *)
            Y22 := TRUE;
            D28 := D101; D29 := 1000;

            IF (ABS(D14 - D101) <= POS_TOL) AND (ABS(D15) <= VEL_TOL) THEN
                step := 3;
            END_IF;

        3: (* Dock D lower support at 70 *)
            Y23 := TRUE;
            D32 := D_DOCK; D33 := 1000;

            IF (ABS(D16 - D_DOCK) <= POS_TOL) AND (ABS(D17) <= VEL_TOL) THEN
                step := 4;
            END_IF;

        4: (* Lower E upper tool to requested stroke *)
            Y24 := TRUE;
            D36 := D102; D37 := 1000;

            IF (ABS(D18 - D102) <= POS_TOL) AND (ABS(D19) <= VEL_TOL) THEN
                step := 5;
            END_IF;

        5: (* Retract E to 0, while holding C and D fixed (E > 167.5 window) *)
            D36 := 0; D37 := 1000;

            IF (ABS(D18 - 0) <= POS_TOL) AND (ABS(D19) <= VEL_TOL) THEN
                step := 6;
            END_IF;

        6: (* Retract transfer jig C back to 0, E already retracted *)
            D28 := 0; D29 := 1000;

            IF (ABS(D14 - 0) <= POS_TOL) AND (ABS(D15) <= VEL_TOL) THEN
                step := 7;
            END_IF;

        7: (* Lower docking support D back to 0 *)
            D32 := 0; D33 := 1000;

            IF (ABS(D16 - 0) <= POS_TOL) AND (ABS(D17) <= VEL_TOL) THEN
                step := 8;
            END_IF;

        8: (* Close A/B plates back to 0 *)
            D20 := 0; D21 := 1000;
            D24 := 0; D25 := 1000;

            IF (ABS(D10 - 0) <= POS_TOL) AND (ABS(D11) <= VEL_TOL) AND
               (ABS(D12 - 0) <= POS_TOL) AND (ABS(D13) <= VEL_TOL) THEN
                step := 9;
            END_IF;

        9: (* All axes at 0 : assert and maintain completion *)
            Y2 := TRUE;

        ELSE
            ;
    END_CASE;
END_IF;

END_PROGRAM