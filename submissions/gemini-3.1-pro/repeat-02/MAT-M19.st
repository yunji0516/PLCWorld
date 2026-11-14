PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    Y21 : BOOL;
    Y22 : BOOL;
    X20 : BOOL;
    X21 : BOOL;
    X22 : BOOL;
    X23 : BOOL;
    D20 : INT;
    D21 : INT;
    D22 : INT;
    D23 : INT;
    D24 : INT;
    D25 : INT;
    D26 : INT;

    state : INT := 0;
    start_edge : R_TRIG;
    m1 : DINT;
    m2 : DINT;
    m3 : DINT;
    m4 : DINT;
    diff1 : DINT;
    diff2 : DINT;
    diff3 : DINT;
    t0 : INT;
    t1 : INT;
    t2 : INT;
    t3 : INT;
    target : INT;
    expected_d26 : INT := 0;
END_VAR

start_edge(CLK := X10);

CASE state OF
    0:
        IF start_edge.Q THEN
            m1 := DINT(D20);
            m2 := DINT(D21);
            m3 := DINT(D22);
            m4 := DINT(D23);

            diff1 := ABS( (m1 + m2) - (m3 + m4) );
            diff2 := ABS( (m1 + m3) - (m2 + m4) );
            diff3 := ABS( (m1 + m4) - (m2 + m3) );

            IF diff1 <= 1 THEN
                t0 := 0; t1 := 0; t2 := 1; t3 := 1;
            ELSIF diff2 <= 1 THEN
                t0 := 0; t1 := 1; t2 := 0; t3 := 1;
            ELSE
                t0 := 0; t1 := 1; t2 := 1; t3 := 0;
            END_IF;
            
            expected_d26 := 0;
            state := 1;
        END_IF;

    1:
        IF expected_d26 = 4 THEN
            state := 5;
        ELSIF expected_d26 = 0 THEN
            target := t0;
            state := 2;
        ELSIF expected_d26 = 1 THEN
            target := t1;
            state := 2;
        ELSIF expected_d26 = 2 THEN
            target := t2;
            state := 2;
        ELSIF expected_d26 = 3 THEN
            target := t3;
            state := 2;
        END_IF;

    2:
        IF target = 0 THEN
            Y20 := TRUE;
            Y21 := FALSE;
        ELSE
            Y20 := FALSE;
            Y21 := TRUE;
        END_IF;
        state := 3;

    3:
        IF X21 THEN
            Y20 := FALSE;
            Y21 := FALSE;
            expected_d26 := expected_d26 + 1;
            state := 4;
        END_IF;

    4:
        IF X20 AND D26 >= expected_d26 THEN
            state := 1;
        END_IF;

    5:
        Y22 := TRUE;
        IF X23 THEN
            Y22 := FALSE;
            state := 6;
        END_IF;

    6:
        Y2 := TRUE;

END_CASE;

END_PROGRAM