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
    edge_detected : BOOL := FALSE;
    edge_pos : DINT := 0;
    target_A : DINT := 0;
    target_B : DINT := 0;
    pulse_cnt : INT := 0;
    complete_timer : TON;
END_VAR

IF step = 0 THEN
    IF X0 THEN
        step := 10;
    END_IF;
END_IF;

CASE step OF
    10:
        (* Move axis A upwards slowly to detect the fresh reference sensor edge *)
        (* Sensor mark is in range [60, 90] mm -> [6000, 9000] *)
        D20 := 9500;
        D21 := 100; (* 10% rate for gentle search and quick stopping within 10mm *)
        Y20 := TRUE;

        (* Check for fresh OFF->ON edge of X34 *)
        IF X34 AND NOT prev_X34 THEN
            edge_detected := TRUE;
            edge_pos := D10;
            (* Target a stop position within 10 mm (1000 units) of the edge, e.g. edge_pos + 4 mm *)
            D20 := edge_pos + 400;
            step := 20;
        END_IF;

    20:
        (* Stop within 10 mm after edge *)
        IF ABS(D10 - D20) <= 20 AND ABS(D11) <= 100 THEN
            (* Stopped within capture window, send Y30 rising edge *)
            Y30 := TRUE;
            pulse_cnt := 0;
            step := 30;
        END_IF;

    30:
        (* Hold Y30 until configured X35 confirms or registration completes *)
        pulse_cnt := pulse_cnt + 1;
        IF X35 OR pulse_cnt >= 5 THEN
            Y30 := FALSE;
            (* Calculate target position for requested shelf *)
            (* Formula: A = D90 + index * pitch *)
            (* request_index and request_pitch are scaled by 100 *)
            target_A := D90 + (D102 * D101) / 100;
            D20 := target_A;
            D21 := 600;
            step := 40;
        END_IF;

    40:
        (* Move axis A to shelf position *)
        IF ABS(D10 - target_A) <= 20 AND ABS(D11) <= 100 THEN
            (* Reached target shelf height, now extend axis B *)
            target_B := D103; (* reach scaled by 100 *)
            D24 := target_B;
            D25 := 600;
            Y21 := TRUE;
            step := 50;
        END_IF;

    50:
        (* Approach lateral axis B to reach *)
        IF ABS(D12 - target_B) <= 20 AND ABS(D13) <= 100 THEN
            (* Reached reach position, now retract axis B to 0 *)
            target_B := 0;
            D24 := 0;
            D25 := 600;
            step := 60;
        END_IF;

    60:
        (* Retract axis B to 0 *)
        IF ABS(D12) <= 20 AND ABS(D13) <= 100 THEN
            step := 70;
        END_IF;

    70:
        (* Completed sequence, assert Y2 *)
        Y2 := TRUE;
END_CASE;

prev_X34 := X34;

complete_timer(IN := (step = 70), PT := T#100ms);

END_PROGRAM