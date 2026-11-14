PROGRAM Main
VAR
    X0 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    D101 : DINT;
    D102 : DINT;
    D103 : DINT;
    X34 : BOOL;
    X35 : BOOL;
    D90 : DINT;
    D20 : DINT;
    D21 : DINT;
    Y20 : BOOL;
    D24 : DINT;
    D25 : DINT;
    Y21 : BOOL;
    Y30 : BOOL;
    Y2 : BOOL;

    state : DINT := 0;
    edge_X34 : R_TRIG;
END_VAR

edge_X34(CLK := X34);

CASE state OF
    0:
        IF X0 THEN
            state := 1;
        END_IF;

    1:
        (* Move A towards 150 mm at 20% speed (100 mm/s) to safely cross the reference sensor *)
        D20 := 15000;
        D21 := 200;
        Y20 := TRUE;

        IF edge_X34.Q THEN
            (* Disable axis to brake immediately at 3000 mm/s^2, stopping within ~1.7 mm *)
            Y20 := FALSE;
            state := 2;
        END_IF;

    2:
        Y20 := FALSE;
        (* Wait for A to fully stop (speed <= 1 mm/s) *)
        IF ABS(D11) <= 100 THEN
            (* Latch current stopped position as target and hold *)
            D20 := D10;
            D21 := 1000;
            Y20 := TRUE;
            Y30 := TRUE; (* Send configuration request edge *)
            state := 3;
        END_IF;

    3:
        Y20 := TRUE;
        Y30 := TRUE;
        IF X35 THEN
            state := 4;
        END_IF;

    4:
        (* Target A = Origin + (Index * Pitch) *)
        D20 := D90 + (D102 * D101) / 100;
        D21 := 1000;
        Y20 := TRUE;
        Y30 := FALSE;
        
        (* Wait for A to arrive at shelf position *)
        IF ABS(D10 - D20) <= 20 AND ABS(D11) <= 100 THEN
            state := 5;
        END_IF;

    5:
        D24 := D103;
        D25 := 1000;
        Y21 := TRUE;
        Y20 := TRUE;
        Y30 := FALSE;
        
        (* Wait for B to reach extended approach *)
        IF ABS(D12 - D24) <= 20 AND ABS(D13) <= 100 THEN
            state := 6;
        END_IF;

    6:
        D24 := 0;
        D25 := 1000;
        Y21 := TRUE;
        Y20 := TRUE;
        Y30 := FALSE;
        
        (* Wait for B to retract completely to 0 *)
        IF ABS(D12) <= 20 AND ABS(D13) <= 100 THEN
            state := 7;
        END_IF;

    7:
        Y2 := TRUE;
        Y20 := TRUE;
        Y21 := TRUE;
        Y30 := FALSE;

END_CASE;

END_PROGRAM