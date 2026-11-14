PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    Y21 : BOOL;
    X20 : BOOL;
    X21 : BOOL;
    X22 : BOOL;
    X23 : BOOL;
    X24 : BOOL;
    X25 : BOOL;

    state : INT := 0;
    start_edge : R_TRIG;
    phase_val : INT := 0;
    prev_phase : INT := 0;
    cumulative_phase : INT := 0;
    diff : INT := 0;
    net_count : INT := 0;
    wait_return : BOOL := FALSE;
END_VAR

(* Process Start Request *)
start_edge(CLK := X10);

(* Quadrature Decoding of Photoeyes A (X20) and B (X21) *)
IF NOT X20 AND NOT X21 THEN
    phase_val := 0;
ELSIF X20 AND NOT X21 THEN
    phase_val := 1;
ELSIF X20 AND X21 THEN
    phase_val := 2;
ELSIF NOT X20 AND X21 THEN
    phase_val := 3;
END_IF;

IF phase_val <> prev_phase THEN
    diff := phase_val - prev_phase;
    
    (* Increment cumulative phase on valid forward progression *)
    IF diff = 1 OR diff = -3 THEN
        cumulative_phase := cumulative_phase + 1;
    (* Decrement cumulative phase on valid reverse progression *)
    ELSIF diff = -1 OR diff = 3 THEN
        cumulative_phase := cumulative_phase - 1;
    END_IF;
    
    prev_phase := phase_val;
END_IF;

(* 1 complete passage = 4 phase steps. Integer division guarantees stability during partial entries. *)
IF cumulative_phase >= 0 THEN
    net_count := cumulative_phase / 4;
ELSE
    net_count := 0;
END_IF;

(* 
   If a disturbance is pending (X22) and the first product has fully cleared B (cumulative_phase >= 4),
   stop upstream feed to prevent admitting a second product. The receiver rollers will carry the first 
   product to the full-return trigger at x=360 mm, where it will reverse. 
*)
IF X22 AND (cumulative_phase >= 4) THEN
    wait_return := TRUE;
END_IF;
IF NOT X22 THEN
    wait_return := FALSE;
END_IF;

(* State Machine Control *)
CASE state OF
    0: (* Wait for Start *)
        IF start_edge.Q THEN
            state := 1;
        END_IF;
        
    1: (* Accumulate Required Batch *)
        (* Dispatch only when target count is met, the transfer module is empty, tray is settled, and no external returns are pending *)
        IF (net_count = D10) AND X23 AND X24 AND NOT X22 THEN
            state := 2;
        END_IF;
        
    2: (* Dispatching Tray *)
        IF X25 THEN
            state := 3;
        END_IF;
        
    3: (* Completion Hold *)
        ; (* Hold terminal state to maintain Y2 claim *)
END_CASE;

(* Actuator Commands *)
Y20 := (state = 1) AND (net_count < D10) AND NOT wait_return;
Y21 := (state = 2);
Y2  := (state = 3);

END_PROGRAM