PROGRAM Main
VAR
    X10 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    Y20 : BOOL;
    D20 : DINT;
    Y2 : BOOL;
    
    state : INT := 0;
    pos : REAL := 0.0;
    vel : REAL := 0.0;
    target : REAL := 0.0;
    dist : REAL := 0.0;
    dir : REAL := 1.0;
    v_lin : REAL := 0.0;
    v_sqrt : REAL := 0.0;
    v_req : REAL := 0.0;
    v_target : REAL := 0.0;
    actual_pos : REAL := 0.0;
    actual_vel : REAL := 0.0;
    err : REAL := 0.0;
    abs_vel : REAL := 0.0;
    
    hold_timer : TON;
END_VAR

IF NOT X10 THEN
    state := 0;
    Y20 := FALSE;
    Y2 := FALSE;
    D20 := D11;
    hold_timer(IN := FALSE, PT := T#30ms);
ELSE
    Y20 := TRUE;
    
    IF state = 0 THEN
        state := 1;
        pos := REAL(D11) / 100.0;
        vel := REAL(D12) / 100.0;
    END_IF;
    
    target := REAL(D10) / 100.0;
    
    dist := target - pos;
    IF dist < 0.0 THEN
        dir := -1.0;
        dist := -dist;
    ELSE
        dir := 1.0;
    END_IF;
    
    IF dist < 0.0001 THEN
        pos := target;
        vel := 0.0;
        dist := 0.0;
    END_IF;
    
    v_lin := 30.0 * dist;
    v_sqrt := SQRT(2400.0 * dist);
    
    v_req := v_lin;
    IF v_sqrt < v_req THEN
        v_req := v_sqrt;
    END_IF;
    
    IF v_req > 220.0 THEN
        v_req := 220.0;
    END_IF;
    
    v_target := dir * v_req;
    
    IF v_target > vel + 15.0 THEN
        vel := vel + 15.0;
    ELSIF v_target < vel - 15.0 THEN
        vel := vel - 15.0;
    ELSE
        vel := v_target;
    END_IF;
    
    pos := pos + vel * 0.01;
    
    D20 := DINT(pos * 100.0);
    
    IF D20 > 200000 THEN
        D20 := 200000;
    ELSIF D20 < -200000 THEN
        D20 := -200000;
    END_IF;
    
    actual_pos := REAL(D11) / 100.0;
    actual_vel := REAL(D12) / 100.0;
    
    err := actual_pos - target;
    IF err < 0.0 THEN 
        err := -err; 
    END_IF;
    
    abs_vel := actual_vel;
    IF abs_vel < 0.0 THEN 
        abs_vel := -abs_vel; 
    END_IF;
    
    IF err <= 0.2 AND abs_vel <= 1.0 THEN
        hold_timer(IN := TRUE, PT := T#30ms);
    ELSE
        hold_timer(IN := FALSE, PT := T#30ms);
    END_IF;
    
    IF hold_timer.Q THEN
        Y2 := TRUE;
    END_IF;
END_IF;

END_PROGRAM