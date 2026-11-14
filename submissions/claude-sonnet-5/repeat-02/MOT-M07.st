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
    D102 : DINT;
    D103 : DINT;
    D104 : DINT;
    D20 : DINT;
    D21 : DINT;
    Y20 : BOOL;
    D24 : DINT;
    D25 : DINT;
    Y21 : BOOL;
    D28 : DINT;
    D29 : DINT;
    Y22 : BOOL;
    Y2 : BOOL;

    (* internal *)
    started    : BOOL := FALSE;
    completed  : BOOL := FALSE;
    state      : INT := 1;
    safeB      : DINT := 11000; (* 110.00 mm raw, > 100mm clearance threshold *)
    posTol     : DINT := 20;    (* 0.2 mm * 100 *)
    velTol     : DINT := 100;   (* 1 mm/s * 100 *)

    port1_done : BOOL := FALSE;
    port2_done : BOOL := FALSE;

    arrivedA   : BOOL;
    arrivedB   : BOOL;
    arrivedC   : BOOL;
END_VAR

IF NOT started THEN
    (* Not yet permitted to enable axes; may prepare targets/rates while disabled *)
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
    D21 := 1000;
    D25 := 1000;
    D29 := 1000;
    D20 := 0;
    D24 := 0;
    D28 := 0;
    Y2  := FALSE;

    IF X0 THEN
        started := TRUE;
        state   := 1;
    END_IF;

ELSE
    (* Axes enabled once start has been requested *)
    Y20 := TRUE;
    Y21 := TRUE;
    Y22 := TRUE;
    D21 := 1000;
    D25 := 1000;
    D29 := 1000;

    CASE state OF

        1: (* Raise B to safe clearance height, A/C stay at home *)
            D20 := 0;
            D24 := safeB;
            D28 := 0;

            arrivedB := (ABS(D12 - D24) <= posTol) AND (ABS(D13) <= velTol);

            IF arrivedB THEN
                state := 2;
            END_IF;

        2: (* Move laterally / forward-back to port 1 alignment, at safe height *)
            D20 := D101;
            D24 := safeB;
            D28 := 0;

            arrivedA := (ABS(D10 - D20) <= posTol) AND (ABS(D11) <= velTol);
            arrivedC := (ABS(D14 - D28) <= posTol) AND (ABS(D15) <= velTol);

            IF arrivedA AND arrivedC THEN
                state := 3;
            END_IF;

        3: (* Descend into port 1 opening *)
            D20 := D101;
            D24 := 0;
            D28 := 0;

            arrivedA := (ABS(D10 - D20) <= posTol) AND (ABS(D11) <= velTol);
            arrivedB := (ABS(D12 - D24) <= posTol) AND (ABS(D13) <= velTol);
            arrivedC := (ABS(D14 - D28) <= posTol) AND (ABS(D15) <= velTol);

            IF arrivedA AND arrivedB AND arrivedC THEN
                port1_done := TRUE;
                state := 4;
            END_IF;

        4: (* Raise back to safe height after port 1 *)
            D20 := D101;
            D24 := safeB;
            D28 := 0;

            arrivedB := (ABS(D12 - D24) <= posTol) AND (ABS(D13) <= velTol);

            IF arrivedB THEN
                state := 5;
            END_IF;

        5: (* Move to port 2 alignment at safe height *)
            D20 := D102;
            D24 := safeB;
            D28 := D104;

            arrivedA := (ABS(D10 - D20) <= posTol) AND (ABS(D11) <= velTol);
            arrivedC := (ABS(D14 - D28) <= posTol) AND (ABS(D15) <= velTol);

            IF arrivedA AND arrivedC THEN
                state := 6;
            END_IF;

        6: (* Descend into port 2 opening *)
            D20 := D102;
            D24 := D103;
            D28 := D104;

            arrivedA := (ABS(D10 - D20) <= posTol) AND (ABS(D11) <= velTol);
            arrivedB := (ABS(D12 - D24) <= posTol) AND (ABS(D13) <= velTol);
            arrivedC := (ABS(D14 - D28) <= posTol) AND (ABS(D15) <= velTol);

            IF arrivedA AND arrivedB AND arrivedC THEN
                port2_done := TRUE;
                state := 7;
            END_IF;

        7: (* Raise back to safe height after port 2 *)
            D20 := D102;
            D24 := safeB;
            D28 := D104;

            arrivedB := (ABS(D12 - D24) <= posTol) AND (ABS(D13) <= velTol);

            IF arrivedB THEN
                state := 8;
            END_IF;

        8: (* Move to home XZ alignment at safe height *)
            D20 := 0;
            D24 := safeB;
            D28 := 0;

            arrivedA := (ABS(D10 - D20) <= posTol) AND (ABS(D11) <= velTol);
            arrivedC := (ABS(D14 - D28) <= posTol) AND (ABS(D15) <= velTol);

            IF arrivedA AND arrivedC THEN
                state := 9;
            END_IF;

        9: (* Descend to final home *)
            D20 := 0;
            D24 := 0;
            D28 := 0;

            arrivedA := (ABS(D10 - D20) <= posTol) AND (ABS(D11) <= velTol);
            arrivedB := (ABS(D12 - D24) <= posTol) AND (ABS(D13) <= velTol);
            arrivedC := (ABS(D14 - D28) <= posTol) AND (ABS(D15) <= velTol);

            IF arrivedA AND arrivedB AND arrivedC THEN
                completed := TRUE;
                state := 10;
            END_IF;

        10: (* Hold final home position and maintain completion *)
            D20 := 0;
            D24 := 0;
            D28 := 0;

        ELSE
            (* should not occur, hold last commanded targets *)
            ;
    END_CASE;

    Y2 := completed;
END_IF;

END_PROGRAM