PROGRAM Main
VAR
    X10 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    D14 : DINT;
    D15 : DINT;
    D16 : DINT;
    X11 : BOOL;
    X12 : BOOL;
    D20 : DINT;
    D21 : DINT;
    Y20 : BOOL;
    Y21 : BOOL;
    Y22 : BOOL;
    Y2 : BOOL;

    (* Internal state *)
    state       : INT := 0;
    origin_u    : DINT := 0;
    park_target : DINT := 0;

    settle_timer : TON;
    hold_timer   : TON;

    good      : BOOL;
    pos_err   : DINT;
    spd_err   : DINT;
    target_mod : DINT;
    current_mod : DINT;
    diff      : DINT;
    ratio_ok  : BOOL;
END_VAR

CASE state OF

0: // IDLE - wait for request, validate ratio, pulse GearIn
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
    D20 := 0;
    IF X10 THEN
        ratio_ok := (D15 >= 500) AND (D15 <= 2500);
        IF ratio_ok THEN
            D20 := D15;      // ratio command latched while gear_in edge is active
            Y20 := TRUE;     // rising-edge pulse for GearIn
            state := 1;
        END_IF;
    END_IF;

1: // ENGAGING - clear pulse, wait for stable InGear feedback (30 ms)
    Y20 := FALSE;
    D20 := D15;
    settle_timer(IN := (X11 AND X12), PT := T#30ms);
    IF settle_timer.Q THEN
        origin_u := D10;      // capture master origin at established InGear
        state := 2;
    END_IF;

2: // SYNCING - hold coupling, wait for required span of master rotation
    D20 := D15;
    IF X11 AND X12 THEN
        IF (D10 - origin_u) >= D14 THEN
            Y21 := TRUE;      // rising-edge pulse for GearOut
            state := 3;
        END_IF;
    END_IF;

3: // DISENGAGING - clear pulse, wait for coupling to actually release
    Y21 := FALSE;
    D20 := 0;
    IF NOT X12 THEN
        // compute nearest forward absolute target matching Park angle modulo 360 deg
        target_mod := D13;
        WHILE target_mod < 0 DO
            target_mod := target_mod + 36000;
        END_WHILE;
        WHILE target_mod >= 36000 DO
            target_mod := target_mod - 36000;
        END_WHILE;

        current_mod := D11;
        WHILE current_mod < 0 DO
            current_mod := current_mod + 36000;
        END_WHILE;
        WHILE current_mod >= 36000 DO
            current_mod := current_mod - 36000;
        END_WHILE;

        diff := target_mod - current_mod;
        IF diff < 0 THEN
            diff := diff + 36000;
        END_IF;

        park_target := D11 + diff;
        D21 := park_target;
        Y22 := TRUE;          // independent positioning command
        state := 4;
    END_IF;

4: // PARKING / HOLDING - wait for stable arrival within tolerance for 100 ms
    D20 := 0;
    Y22 := TRUE;
    D21 := park_target;
    pos_err := ABS(D11 - park_target);
    spd_err := ABS(D12);
    good := (pos_err <= 20) AND (spd_err <= 100);
    hold_timer(IN := good, PT := T#100ms);
    IF hold_timer.Q THEN
        Y2 := TRUE;
        state := 5;
    END_IF;

5: // DONE - retain completion and maintain result
    D20 := 0;
    Y22 := TRUE;
    D21 := park_target;
    Y2 := TRUE;

ELSE
    state := 0;

END_CASE;

END_PROGRAM