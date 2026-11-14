PROGRAM Main
VAR
    X0 : BOOL;
    X10 : BOOL;
    X11 : BOOL;
    X12 : BOOL;
    X13 : BOOL;
    X14 : BOOL;
    X15 : BOOL;
    X16 : BOOL;
    X17 : BOOL;
    X18 : BOOL;
    X19 : BOOL;
    X20 : BOOL;
    X21 : BOOL;
    Y10 : BOOL;
    Y11 : BOOL;
    Y12 : BOOL;
    Y13 : BOOL;
    Y14 : BOOL;
    Y15 : BOOL;
    Y16 : BOOL;
    Y17 : BOOL;
    Y18 : BOOL;
    D0 : INT;
    D1 : INT;
    D2 : INT;
    D3 : INT;
    D4 : INT;
    D5 : INT;
    D6 : INT;
    D7 : INT;
    D200 : INT;
    D201 : INT;
    D202 : INT;
    D203 : INT;
    D204 : INT;
    X1A : BOOL;
    X1B : BOOL;
    X1C : BOOL;
    X1D : BOOL;
    X1E : BOOL;
    X1F : BOOL;
    
    (* Internal variables *)
    running : BOOL := FALSE;
    
    pre_step : INT := 0;
    post_step : INT := 0;
    
    pre_seq_req : INT := 1;
    post_seq_req : INT := 1;
    
    tare_mass : ARRAY[0..100] OF INT;
    tare_mass_idx : INT;
    current_tare : INT;
    net_mass : INT;
    route_req : INT;
    
    lane1_occupied : BOOL := FALSE;
    lane2_occupied : BOOL := FALSE;
    loading_lane : INT := 0;
    
    pre_timer : TON;
    post_timer : TON;
END_VAR

IF X0 THEN
    running := TRUE;
END_IF

pre_timer(IN := (pre_step = 4), PT := T#2s);
post_timer(IN := (post_step = 4), PT := T#2s);

(* Inbound Pre-Scale State Machine *)
CASE pre_step OF
0:
    IF running AND X10 AND NOT X11 AND X1F THEN
        Y10 := TRUE;
        pre_step := 1;
    END_IF
1:
    IF X11 THEN
        Y10 := FALSE;
        pre_step := 2;
    END_IF
2:
    Y17 := TRUE;
    IF X1E THEN
        pre_seq_req := pre_seq_req + 1;
        pre_step := 3;
    END_IF
3:
    IF NOT X12 THEN
        D202 := pre_seq_req;
        Y11 := TRUE;
        pre_step := 4;
    END_IF
4:
    IF D4 = pre_seq_req THEN
        tare_mass_idx := LIMIT(0, D0, 100);
        tare_mass[tare_mass_idx] := D2;
        Y11 := FALSE;
        pre_step := 5;
    ELSIF pre_timer.Q THEN
        Y11 := FALSE;
        pre_step := 3;
    END_IF
5:
    Y17 := FALSE;
    IF X1F THEN
        pre_step := 6;
    END_IF
6:
    IF X17 AND NOT lane1_occupied THEN
        D200 := 1;
        Y12 := TRUE;
        lane1_occupied := TRUE;
        pre_step := 7;
    ELSIF X19 AND NOT lane2_occupied THEN
        D200 := 2;
        Y12 := TRUE;
        lane2_occupied := TRUE;
        pre_step := 7;
    END_IF
7:
    IF NOT X11 THEN
        Y12 := FALSE;
        D200 := 0;
        pre_step := 0;
    END_IF
END_CASE

(* Finished Post-Scale State Machine *)
CASE post_step OF
0:
    IF X21 AND NOT X13 THEN
        IF X18 AND lane1_occupied THEN
            loading_lane := 1;
            D201 := 1;
            Y13 := TRUE;
            post_step := 1;
        ELSIF X1A AND lane2_occupied THEN
            loading_lane := 2;
            D201 := 2;
            Y13 := TRUE;
            post_step := 1;
        END_IF
    END_IF
1:
    IF X13 THEN
        Y13 := FALSE;
        D201 := 0;
        IF loading_lane = 1 THEN
            lane1_occupied := FALSE;
        ELSIF loading_lane = 2 THEN
            lane2_occupied := FALSE;
        END_IF
        post_step := 2;
    END_IF
2:
    Y18 := TRUE;
    IF X20 THEN
        post_seq_req := post_seq_req + 1;
        post_step := 3;
    END_IF
3:
    IF NOT X14 THEN
        D203 := post_seq_req;
        Y14 := TRUE;
        post_step := 4;
    END_IF
4:
    IF D5 = post_seq_req THEN
        tare_mass_idx := LIMIT(0, D1, 100);
        current_tare := tare_mass[tare_mass_idx];
        net_mass := D3 - current_tare;
        IF net_mass >= 95 AND net_mass <= 105 THEN
            route_req := 1;
        ELSE
            route_req := 2;
        END_IF
        Y14 := FALSE;
        post_step := 5;
    ELSIF post_timer.Q THEN
        Y14 := FALSE;
        post_step := 3;
    END_IF
5:
    Y18 := FALSE;
    IF X21 THEN
        post_step := 6;
    END_IF
6:
    IF route_req = 1 AND X1B THEN
        D204 := 1;
        Y15 := TRUE;
        post_step := 7;
    ELSIF route_req = 2 AND X1C THEN
        D204 := 2;
        Y15 := TRUE;
        post_step := 7;
    END_IF
7:
    IF NOT X13 THEN
        Y15 := FALSE;
        D204 := 0;
        post_step := 0;
    END_IF
END_CASE

(* Completion logic *)
IF X1D AND NOT X11 AND NOT X13 AND X17 AND X19 AND NOT lane1_occupied AND NOT lane2_occupied AND (pre_step = 0) AND (post_step = 0) THEN
    Y16 := TRUE;
END_IF

END_PROGRAM