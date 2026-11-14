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
    started : BOOL;
    stage : INT;
    dock_req : DINT;
    park_req : DINT;
    beam_cmd : DINT;
    beam_step : DINT := 100;
    prep_pos : DINT := 52000;
    pos_tol : DINT := 10;
    vel_tol : DINT := 50;
END_VAR

IF (NOT started) AND X0 THEN
    started := TRUE;
    stage := 1;
    dock_req := D101;
    park_req := D102;
    IF dock_req < 35000 THEN
        dock_req := 35000;
    ELSIF dock_req > 45000 THEN
        dock_req := 45000;
    END_IF;
    IF park_req < 0 THEN
        park_req := 0;
    ELSIF park_req > 90000 THEN
        park_req := 90000;
    END_IF;
    beam_cmd := 0;
END_IF;

D20 := 0;
D21 := 0;
Y20 := FALSE;
D24 := 0;
D25 := 0;
Y21 := FALSE;
D28 := 10000;
D29 := 0;
Y22 := FALSE;
Y30 := FALSE;
Y31 := FALSE;

IF started THEN
    D21 := 1000;
    D25 := 1000;
    D29 := 1000;

    CASE stage OF
        1:
            IF beam_cmd < dock_req THEN
                beam_cmd := beam_cmd + beam_step;
                IF beam_cmd > dock_req THEN
                    beam_cmd := dock_req;
                END_IF;
            ELSIF beam_cmd > dock_req THEN
                beam_cmd := beam_cmd - beam_step;
                IF beam_cmd < dock_req THEN
                    beam_cmd := dock_req;
                END_IF;
            END_IF;

            D20 := beam_cmd;
            D24 := beam_cmd;
            Y20 := TRUE;
            Y21 := TRUE;

            D28 := prep_pos;
            Y22 := TRUE;

            IF (beam_cmd = dock_req) AND X4 AND (ABS(D11) <= 100) AND (ABS(D13) <= 100) THEN
                stage := 2;
            END_IF;

        2:
            D20 := dock_req;
            D24 := dock_req;
            Y20 := FALSE;
            Y21 := FALSE;

            D28 := prep_pos;
            Y22 := TRUE;

            Y30 := TRUE;
            Y31 := FALSE;

            IF X2 AND (NOT X3) AND X4 THEN
                stage := 3;
            END_IF;

        3:
            D20 := dock_req;
            D24 := dock_req;
            Y20 := FALSE;
            Y21 := FALSE;

            D28 := park_req;
            Y22 := TRUE;

            Y30 := TRUE;
            Y31 := FALSE;

            IF X2 AND (NOT X3) AND X4 AND X5 AND (ABS(D14 - park_req) <= pos_tol) AND (ABS(D15) <= vel_tol) THEN
                stage := 4;
            END_IF;

        4:
            D20 := dock_req;
            D24 := dock_req;
            Y20 := FALSE;
            Y21 := FALSE;

            D28 := park_req;
            Y22 := TRUE;

            Y30 := FALSE;
            Y31 := TRUE;

            IF X1 AND (NOT X2) AND X5 THEN
                stage := 5;
                beam_cmd := dock_req;
            END_IF;

        5:
            IF beam_cmd > 0 THEN
                beam_cmd := beam_cmd - beam_step;
                IF beam_cmd < 0 THEN
                    beam_cmd := 0;
                END_IF;
            END_IF;

            D20 := beam_cmd;
            D24 := beam_cmd;
            Y20 := TRUE;
            Y21 := TRUE;

            D28 := park_req;
            Y22 := TRUE;

            Y30 := FALSE;
            Y31 := TRUE;

            IF (beam_cmd = 0)
               AND X1
               AND X5
               AND (ABS(D10) <= pos_tol)
               AND (ABS(D11) <= vel_tol)
               AND (ABS(D12) <= pos_tol)
               AND (ABS(D13) <= vel_tol)
               AND (ABS(D14 - park_req) <= pos_tol)
               AND (ABS(D15) <= vel_tol) THEN
                stage := 6;
            END_IF;

        6:
            D20 := 0;
            D24 := 0;
            Y20 := TRUE;
            Y21 := TRUE;

            D28 := park_req;
            Y22 := TRUE;

            Y30 := FALSE;
            Y31 := TRUE;

        ELSE
            stage := 1;
    END_CASE;
END_IF;

Y2 := started AND (stage = 6);

END_PROGRAM