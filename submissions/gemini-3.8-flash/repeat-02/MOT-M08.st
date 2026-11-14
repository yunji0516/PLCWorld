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

    step : INT := 0;
    prev_X34 : BOOL := FALSE;
    latched_edge_pos : DINT := 0;
    target_shelf_pos : DINT := 0;
    pulse_sent : BOOL := FALSE;
END_VAR

IF step = 0 THEN
    Y20 := FALSE;
    Y21 := FALSE;
    Y30 := FALSE;
    Y2 := FALSE;
    prev_X34 := X34;
    IF X0 THEN
        step := 10;
    END_IF;

ELSIF step = 10 THEN
    (* Move axis A slowly to find the fresh rising edge of X34 *)
    Y20 := TRUE;
    D20 := 9500; (* 95 mm, sensor mark is 60..90 mm *)
    D21 := 60;   (* 30 mm/s slow scan to stop promptly *)
    Y21 := FALSE;
    D24 := 0;
    D25 := 0;

    (* Detect fresh OFF->ON transition of X34 *)
    IF (NOT prev_X34) AND X34 THEN
        latched_edge_pos := D10;
        step := 20;
    END_IF;

ELSIF step = 20 THEN
    (* Stop immediately within 10 mm of edge *)
    Y20 := TRUE;
    D20 := D10; (* Set target to current position to halt *)
    D21 := 1000;

    (* Check if stopped within 10 mm (1000 scaled units) after edge *)
    IF (ABS(D11) <= 100) AND (D10 - latched_edge_pos <= 1000) THEN
        step := 30;
    END_IF;

ELSIF step = 30 THEN
    (* Axis A stopped, send Y30 rising edge to configure reference *)
    Y20 := TRUE;
    D20 := D10;
    D21 := 1000;
    Y30 := TRUE;
    step := 40;

ELSIF step = 40 THEN
    (* Maintain Y30 or wait for X35 confirmation *)
    Y30 := TRUE;
    IF X35 THEN
        Y30 := FALSE;
        (* Calculate target shelf position: A = D90 + index * pitch *)
        (* D102 is index * 100, D101 is pitch * 100 *)
        target_shelf_pos := D90 + ((D102 / 100) * D101);
        step := 50;
    END_IF;

ELSIF step = 50 THEN
    (* Move axis A to target shelf position *)
    Y20 := TRUE;
    D20 := target_shelf_pos;
    D21 := 1000;
    Y21 := FALSE;

    (* Check arrival at shelf: position within 0.2 mm (20 units), speed <= 1 mm/s (100 units) *)
    IF (ABS(D10 - target_shelf_pos) <= 20) AND (ABS(D11) <= 100) THEN
        step := 60;
    END_IF;

ELSIF step = 60 THEN
    (* Extend lateral approach axis B to request_reach (D103) *)
    Y20 := TRUE;
    D20 := target_shelf_pos;
    D21 := 1000;
    Y21 := TRUE;
    D24 := D103;
    D25 := 1000;

    (* Check arrival of B at reach *)
    IF (ABS(D12 - D103) <= 20) AND (ABS(D13) <= 100) THEN
        step := 70;
    END_IF;

ELSIF step = 70 THEN
    (* Retract lateral approach axis B to 0 *)
    Y20 := TRUE;
    D20 := target_shelf_pos;
    D21 := 1000;
    Y21 := TRUE;
    D24 := 0;
    D25 := 1000;

    (* Check arrival of B at 0 *)
    IF (ABS(D12) <= 20) AND (ABS(D13) <= 100) THEN
        step := 80;
    END_IF;

ELSIF step = 80 THEN
    (* Approach and retraction complete; assert Y2 and hold state *)
    Y20 := TRUE;
    D20 := target_shelf_pos;
    D21 := 1000;
    Y21 := TRUE;
    D24 := 0;
    D25 := 1000;
    Y30 := FALSE;
    Y2 := TRUE;
END_IF;

prev_X34 := X34;

END_PROGRAM