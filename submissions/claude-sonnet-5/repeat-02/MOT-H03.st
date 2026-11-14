PROGRAM Main
VAR
    D1000 : DINT;
    D1001 : DINT;
    D1004 : DINT;
    D1005 : DINT;
    D1008 : DINT;
    D1009 : DINT;
    D1012 : DINT;
    D1013 : DINT;
    D1016 : DINT;
    D1017 : DINT;
    D1020 : DINT;
    D1021 : DINT;
    D1024 : DINT;
    D1025 : DINT;
    D1028 : DINT;
    D1029 : DINT;
    D1032 : DINT;
    D1033 : DINT;
    D100 : DINT;
    D101 : DINT;
    D102 : DINT;
    D103 : DINT;
    D104 : DINT;
    X30 : BOOL;
    X31 : BOOL;
    D120 : DINT;
    D121 : DINT;
    D122 : DINT;
    D123 : DINT;
    D124 : DINT;
    X34 : BOOL;
    X35 : BOOL;
    X51 : BOOL;
    D90 : DINT;
    D91 : DINT;
    D92 : DINT;
    X52 : BOOL;
    X53 : BOOL;
    D403 : DINT;
    D404 : DINT;
    X61 : BOOL;
    D406 : DINT;
    D407 : DINT;
    X62 : BOOL;
    D409 : DINT;
    D410 : DINT;
    X63 : BOOL;
    D412 : DINT;
    D413 : DINT;
    X64 : BOOL;
    D500 : DINT;
    D501 : DINT;
    D502 : DINT;
    D520 : DINT;
    D521 : DINT;
    D522 : DINT;
    D523 : DINT;
    D524 : DINT;
    D525 : DINT;
    D526 : DINT;
    D527 : DINT;
    X70 : BOOL;
    X71 : BOOL;
    X72 : BOOL;
    D600 : DINT;
    D601 : DINT;
    D620 : DINT;
    D621 : DINT;
    D622 : DINT;
    D623 : DINT;
    D624 : DINT;
    D625 : DINT;
    D626 : DINT;
    D627 : DINT;
    X75 : BOOL;
    X76 : BOOL;
    X77 : BOOL;
    D2000 : DINT;
    D2001 : DINT;
    D2002 : DINT;
    Y40 : BOOL;
    D2004 : DINT;
    D2005 : DINT;
    D2006 : DINT;
    Y41 : BOOL;
    D2008 : DINT;
    D2009 : DINT;
    D2010 : DINT;
    Y42 : BOOL;
    D2012 : DINT;
    D2013 : DINT;
    D2014 : DINT;
    Y43 : BOOL;
    D2016 : DINT;
    D2017 : DINT;
    D2018 : DINT;
    Y44 : BOOL;
    D2020 : DINT;
    D2021 : DINT;
    D2022 : DINT;
    Y45 : BOOL;
    D2024 : DINT;
    D2025 : DINT;
    D2026 : DINT;
    Y46 : BOOL;
    D2028 : DINT;
    D2029 : DINT;
    D2030 : DINT;
    Y47 : BOOL;
    D2032 : DINT;
    D2033 : DINT;
    D2034 : DINT;
    Y48 : BOOL;
    D300 : DINT;
    D301 : DINT;
    D302 : DINT;
    D303 : DINT;
    Y70 : BOOL;
    Y71 : BOOL;
    D700 : DINT;
    D701 : DINT;
    D702 : DINT;
    Y75 : BOOL;
    Y76 : BOOL;
    D710 : DINT;
    D711 : DINT;
    D712 : DINT;
    D80 : DINT;
    D81 : DINT;
    D82 : DINT;
    Y30 : BOOL;
    Y2 : BOOL;

    (* internal state *)
    step        : INT := 0;
    req_active  : INT := 0;
    req0_acked  : BOOL := FALSE;
    req1_acked  : BOOL := FALSE;
    cur_location : DINT;
    cur_id      : DINT;
    cur_returned : BOOL;
    cur_cancelled : BOOL;
    use_liftA   : BOOL;
    src_port_x  : DINT;
    src_port_ready : BOOL;
    seq_num     : DINT := 0;
    scan_count  : DINT := 0;
    y2_declared : BOOL := FALSE;

    a_tgt : DINT; b_tgt : DINT; c_tgt : DINT; d_tgt : DINT;
    s3_0_tgt : DINT; s3_1_tgt : DINT; s3_2_tgt : DINT;
    s4_0_tgt : DINT; s4_1_tgt : DINT;

    A_HOME : DINT := 0;
    B_HOME : DINT := 0;
    C_HOME : DINT := 15000;
    D_HOME : DINT := 15000;
    S3_0_HOME : DINT := -50000;
    S3_1_HOME : DINT := -50000;
    S3_2_HOME : DINT := 0;
    S4_0_HOME : DINT := 0;
    S4_1_HOME : DINT := 0;
    B_CONNECT : DINT := 18000;

    POS_TOL : DINT := 20;
    VEL_TOL : DINT := 100;
END_VAR

scan_count := scan_count + 1;

(* --- load current request fields --- *)
IF req_active = 0 THEN
    cur_location := D101;
    cur_id := D100;
    cur_returned := X30;
    cur_cancelled := X31;
ELSE
    cur_location := D121;
    cur_id := D120;
    cur_returned := X34;
    cur_cancelled := X35;
END_IF;

use_liftA := (cur_location = 1);

IF use_liftA THEN
    src_port_x := D403;
    src_port_ready := X61;
ELSE
    src_port_x := D406;
    src_port_ready := X62;
END_IF;

(* default: hold current targets unless overwritten below *)

(* cancellation forces jump to return phase *)
IF cur_cancelled AND step >= 1 AND step < 8 THEN
    step := 8;
END_IF;

CASE step OF

0: (* SELECT next request *)
    IF NOT req0_acked THEN
        req_active := 0;
        step := 1;
    ELSIF NOT req1_acked THEN
        req_active := 1;
        step := 1;
    ELSE
        step := 90;
    END_IF;

1: (* TO_SOURCE: align shuttle & source lift *)
    a_tgt := src_port_x;
    b_tgt := 0;
    IF use_liftA THEN
        c_tgt := D92; d_tgt := D_HOME;
    ELSE
        d_tgt := D92; c_tgt := C_HOME;
    END_IF;
    s3_0_tgt := S3_0_HOME; s3_1_tgt := S3_1_HOME; s3_2_tgt := S3_2_HOME;
    s4_0_tgt := S4_0_HOME; s4_1_tgt := S4_1_HOME;
    IF ABS(D1000 - a_tgt) <= POS_TOL AND ABS(D1001) <= VEL_TOL AND
       ((use_liftA AND ABS(D1008 - c_tgt) <= POS_TOL AND ABS(D1009) <= VEL_TOL) OR
        (NOT use_liftA AND ABS(D1012 - d_tgt) <= POS_TOL AND ABS(D1013) <= VEL_TOL)) AND
       src_port_ready THEN
        seq_num := seq_num + 1;
        D80 := 1; D81 := cur_location; D82 := seq_num;
        step := 2;
    END_IF;

2: (* CONNECT_SOURCE: insert fork *)
    b_tgt := B_CONNECT;
    IF ABS(D1004 - b_tgt) <= POS_TOL AND ABS(D1005) <= VEL_TOL THEN
        step := 3;
    END_IF;

3: (* TO_CELL3 *)
    a_tgt := D409;
    c_tgt := C_HOME; d_tgt := D_HOME;
    IF ABS(D1000 - a_tgt) <= POS_TOL AND ABS(D1001) <= VEL_TOL AND X63 THEN
        seq_num := seq_num + 1;
        D80 := 2; D81 := 3; D82 := seq_num;
        step := 4;
    END_IF;

4: (* CELL3_SYNC *)
    s3_0_tgt := D500; s3_1_tgt := D501; s3_2_tgt := D502;
    IF X72 AND X70 THEN
        step := 5;
    END_IF;

5: (* TO_CELL4 *)
    a_tgt := D412;
    s3_0_tgt := S3_0_HOME; s3_1_tgt := S3_1_HOME; s3_2_tgt := S3_2_HOME;
    IF ABS(D1000 - a_tgt) <= POS_TOL AND ABS(D1001) <= VEL_TOL AND X64 THEN
        seq_num := seq_num + 1;
        D80 := 2; D81 := 4; D82 := seq_num;
        step := 6;
    END_IF;

6: (* CELL4_SYNC *)
    s4_0_tgt := D600; s4_1_tgt := D601;
    IF X77 AND X75 THEN
        step := 8;
    END_IF;

8: (* RETURN_TO_SOURCE *)
    a_tgt := src_port_x;
    s4_0_tgt := S4_0_HOME; s4_1_tgt := S4_1_HOME;
    s3_0_tgt := S3_0_HOME; s3_1_tgt := S3_1_HOME; s3_2_tgt := S3_2_HOME;
    IF use_liftA THEN
        c_tgt := D92; d_tgt := D_HOME;
    ELSE
        d_tgt := D92; c_tgt := C_HOME;
    END_IF;
    IF ABS(D1000 - a_tgt) <= POS_TOL AND ABS(D1001) <= VEL_TOL AND
       ((use_liftA AND ABS(D1008 - c_tgt) <= POS_TOL AND ABS(D1009) <= VEL_TOL) OR
        (NOT use_liftA AND ABS(D1012 - d_tgt) <= POS_TOL AND ABS(D1013) <= VEL_TOL)) AND
       src_port_ready THEN
        seq_num := seq_num + 1;
        D80 := 1; D81 := cur_location; D82 := seq_num;
        step := 9;
    END_IF;

9: (* DISCONNECT *)
    b_tgt := 0;
    IF ABS(D1004 - b_tgt) <= POS_TOL AND ABS(D1005) <= VEL_TOL THEN
        step := 10;
    END_IF;

10: (* LIFT_DOWN_HOME *)
    IF use_liftA THEN
        c_tgt := C_HOME;
    ELSE
        d_tgt := D_HOME;
    END_IF;
    IF (use_liftA AND ABS(D1008 - C_HOME) <= POS_TOL AND ABS(D1009) <= VEL_TOL) OR
       (NOT use_liftA AND ABS(D1012 - D_HOME) <= POS_TOL AND ABS(D1013) <= VEL_TOL) THEN
        step := 11;
    END_IF;

11: (* ACK *)
    IF req_active = 0 THEN
        D300 := cur_id;
        IF cur_cancelled THEN
            D301 := 2;
        ELSE
            D301 := 1;
        END_IF;
        IF cur_returned THEN
            req0_acked := TRUE;
            step := 0;
        END_IF;
    ELSE
        D302 := cur_id;
        IF cur_cancelled THEN
            D303 := 2;
        ELSE
            D303 := 1;
        END_IF;
        IF cur_returned THEN
            req1_acked := TRUE;
            step := 0;
        END_IF;
    END_IF;

90: (* FINALIZE *)
    a_tgt := A_HOME; b_tgt := B_HOME; c_tgt := C_HOME; d_tgt := D_HOME;
    s3_0_tgt := S3_0_HOME; s3_1_tgt := S3_1_HOME; s3_2_tgt := S3_2_HOME;
    s4_0_tgt := S4_0_HOME; s4_1_tgt := S4_1_HOME;
    IF NOT y2_declared AND scan_count <= 16000 THEN
        IF ABS(D1000 - A_HOME) <= POS_TOL AND ABS(D1001) <= VEL_TOL AND
           ABS(D1004 - B_HOME) <= POS_TOL AND ABS(D1005) <= VEL_TOL AND
           ABS(D1008 - C_HOME) <= POS_TOL AND ABS(D1009) <= VEL_TOL AND
           ABS(D1012 - D_HOME) <= POS_TOL AND ABS(D1013) <= VEL_TOL AND
           ABS(D1016 - S3_0_HOME) <= POS_TOL AND ABS(D1017) <= VEL_TOL AND
           ABS(D1020 - S3_1_HOME) <= POS_TOL AND ABS(D1021) <= VEL_TOL AND
           ABS(D1024 - S3_2_HOME) <= POS_TOL AND ABS(D1025) <= VEL_TOL AND
           ABS(D1028 - S4_0_HOME) <= POS_TOL AND ABS(D1029) <= VEL_TOL AND
           ABS(D1032 - S4_1_HOME) <= POS_TOL AND ABS(D1033) <= VEL_TOL AND
           req0_acked AND req1_acked THEN
            y2_declared := TRUE;
        END_IF;
    END_IF;

ELSE
    step := 0;
END_CASE;

(* --- brake: engage while shuttle is holding, release while translating --- *)
IF step = 1 OR step = 3 OR step = 5 OR step = 8 THEN
    Y30 := FALSE;
ELSE
    Y30 := TRUE;
END_IF;

(* --- gear/configure outputs --- *)
Y70 := (step = 4);
Y71 := Y70;
D700 := 1000;
D701 := D526;
D702 := 6000;

Y75 := (step = 6);
Y76 := Y75;
D710 := 1000;
D711 := D626;
D712 := 6000;

(* --- write axis outputs --- *)
D2000 := a_tgt;  D2001 := 1000; D2002 := 0; Y40 := TRUE;
D2004 := b_tgt;  D2005 := 1000; D2006 := 0; Y41 := TRUE;
D2008 := c_tgt;  D2009 := 1000; D2010 := 0; Y42 := TRUE;
D2012 := d_tgt;  D2013 := 1000; D2014 := 0; Y43 := TRUE;
D2016 := s3_0_tgt; D2017 := 1000; D2018 := 0; Y44 := TRUE;
D2020 := s3_1_tgt; D2021 := 1000; D2022 := 0; Y45 := TRUE;
D2024 := s3_2_tgt; D2025 := 1000; D2026 := 0; Y46 := TRUE;
D2028 := s4_0_tgt; D2029 := 1000; D2030 := 0; Y47 := TRUE;
D2032 := s4_1_tgt; D2033 := 1000; D2034 := 0; Y48 := TRUE;

Y2 := y2_declared;

END_PROGRAM