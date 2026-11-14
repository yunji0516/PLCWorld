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
    started : BOOL := FALSE;
    last_x34 : BOOL := FALSE;
    sensor_edge_pos : DINT := 0;
    shelf_target : DINT := 0;
    config_timer : INT := 0;
    done_timer : INT := 0;
END_VAR

IF NOT started THEN
    IF X0 THEN
        started := TRUE;
        last_x34 := X34;
        step := 10;
    END_IF;
END_IF;

CASE step OF
    0:
        Y20 := FALSE;
        Y21 := FALSE;
        Y30 := FALSE;
        Y2 := FALSE;

    10:
        (* Creep axis A upwards to find fresh OFF->ON edge of X34 *)
        D20 := 10000; (* target 100 mm *)
        D21 := 60;    (* 30 mm/s slow creep to stop quickly *)
        Y20 := TRUE;

        IF (NOT last_x34) AND X34 THEN
            sensor_edge_pos := D10;
            (* Command stop immediately *)
            D20 := D10;
            step := 20;
        END_IF;
        last_x34 := X34;

    20:
        (* Decelerate to stop within 10 mm of edge *)
        D20 := sensor_edge_pos + 400; (* stop target 4mm after edge *)
        D21 := 100;
        Y20 := TRUE;

        IF ABS(D11) <= 100 AND ABS(D10 - D20) <= 20 THEN
            (* Stopped within 10mm of edge *)
            IF ABS(D10 - sensor_edge_pos) <= 1000 THEN
                step := 30;
                config_timer := 0;
            END_IF;
        END_IF;

    30:
        (* Send Y30 rising edge to configure reference *)
        Y30 := TRUE;
        config_timer := config_timer + 1;
        IF config_timer >= 3 AND X35 THEN
            Y30 := FALSE;
            (* Calculate target shelf position *)
            (* pitch = D101 / 100, index = D102 / 100 *)
            (* shelf_target = D90 + index * pitch = D90 + (D102 * D101) / 10000 *)
            shelf_target := D90 + (D102 * D101) / 10000;
            step := 40;
        END_IF;

    40:
        (* Move axis A to shelf target *)
        D20 := shelf_target;
        D21 := 500; (* 50% rate *)
        Y20 := TRUE;

        IF ABS(D11) <= 100 AND ABS(D10 - shelf_target) <= 20 THEN
            step := 50;
        END_IF;

    50:
        (* Approach lateral axis B to reach *)
        D24 := D103;
        D25 := 500;
        Y21 := TRUE;

        IF ABS(D13) <= 100 AND ABS(D12 - D103) <= 20 THEN
            step := 60;
        END_IF;

    60:
        (* Retract lateral axis B to 0 *)
        D24 := 0;
        D25 := 500;
        Y21 := TRUE;

        IF ABS(D13) <= 100 AND ABS(D12) <= 20 THEN
            step := 70;
            done_timer := 0;
        END_IF;

    70:
        (* Maintain completion *)
        Y2 := TRUE;
        done_timer := done_timer + 1;
END_CASE;

END_PROGRAM