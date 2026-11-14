PROGRAM Main
VAR
    X10 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    Y20 : BOOL;
    D20 : DINT;
    Y2 : BOOL;

    edge_X10 : R_TRIG;

    req_accepted : BOOL;
    scan_count : INT;
    stable_scans : INT;
    completion_scan : INT;
END_VAR

edge_X10(CLK := X10);

scan_count := scan_count + 1;

IF edge_X10.Q AND NOT req_accepted THEN
    req_accepted := TRUE;
END_IF;

IF req_accepted THEN
    Y20 := TRUE;

    D20 := D10;

    IF ABS(D11 - D10) <= 20 AND ABS(D12) <= 100 THEN
        stable_scans := stable_scans + 1;
        IF stable_scans >= 3 THEN
            IF completion_scan = 0 THEN
                completion_scan := scan_count;
            END_IF;
        END_IF;
    ELSE
        stable_scans := 0;
    END_IF;

    IF completion_scan > 0 AND (scan_count - completion_scan) >= 10 THEN
        Y2 := TRUE;
    END_IF;
END_IF;

END_PROGRAM