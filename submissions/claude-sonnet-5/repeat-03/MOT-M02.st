PROGRAM Main
VAR
    X0 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    D14 : DINT;
    D15 : DINT;
    X1 : BOOL;
    X2 : BOOL;
    X3 : BOOL;
    X4 : BOOL;
    X5 : BOOL;
    D90 : DINT;
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
    Y30 : BOOL;
    Y31 : BOOL;
    Y2 : BOOL;

    (* Internal state *)
    state : INT := 0;
    full_rate : DINT := 1000;
END_VAR

CASE state OF

0: (* IDLE - wait for start, keep everything OFF/disabled *)
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
    Y30 := FALSE;
    Y31 := FALSE;
    D20 := 0;
    D21 := full_rate;
    D24 := 0;
    D25 := full_rate;
    D28 := 0;
    D29 := full_rate;

    IF X0 THEN
        state := 1;
    END_IF;

1: (* MOVE A/B TO REQUESTED DOCK *)
    Y20 := TRUE;
    Y21 := TRUE;
    Y22 := FALSE;
    Y30 := FALSE;
    Y31 := FALSE;

    D20 := D101;
    D21 := full_rate;
    D24 := D101;
    D25 := full_rate;

    IF X4 THEN
        state := 2;
    END_IF;

2: (* ENGAGE LATCH - beam locked, hold dock target *)
    Y20 := TRUE;
    Y21 := TRUE;
    Y30 := TRUE;
    Y31 := FALSE;

    D20 := D101;
    D21 := full_rate;
    D24 := D101;
    D25 := full_rate;

    IF X2 THEN
        state := 3;
    END_IF;

3: (* MOVE ENTIRE CART TO PARK ON FIXED RAIL *)
    Y20 := TRUE;
    Y21 := TRUE;
    Y22 := TRUE;
    Y30 := TRUE;
    Y31 := FALSE;

    D20 := D101;
    D21 := full_rate;
    D24 := D101;
    D25 := full_rate;
    D28 := D102;
    D29 := full_rate;

    IF (ABS(D14 - D102) <= 20) AND (ABS(D15) <= 100) THEN
        state := 4;
    END_IF;

4: (* RELEASE LATCH - cart parked on fixed side, safe to release *)
    Y20 := TRUE;
    Y21 := TRUE;
    Y22 := FALSE;
    Y30 := FALSE;
    Y31 := TRUE;

    D28 := D102;
    D29 := full_rate;

    IF X1 THEN
        state := 5;
    END_IF;

5: (* RETURN EMPTY BEAM TO ORIGIN, CART STAYS PARKED *)
    Y20 := TRUE;
    Y21 := TRUE;
    Y22 := FALSE;
    Y30 := FALSE;
    Y31 := FALSE;

    D20 := 0;
    D21 := full_rate;
    D24 := 0;
    D25 := full_rate;

    IF (ABS(D10) <= 20) AND (ABS(D11) <= 100) AND
       (ABS(D12) <= 20) AND (ABS(D13) <= 100) THEN
        state := 6;
    END_IF;

6: (* DONE - hold completion, actuators off (except result) *)
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
    Y30 := FALSE;
    Y31 := FALSE;
    Y2 := TRUE;

ELSE
    state := 0;

END_CASE;

END_PROGRAM