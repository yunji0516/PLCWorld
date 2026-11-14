PROGRAM Main
VAR
    X0 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    D14 : DINT;
    D15 : DINT;
    D16 : DINT;
    D17 : DINT;
    D101 : DINT;
    D102 : DINT;
    D103 : DINT;
    D20 : DINT;
    D21 : DINT;
    Y20 : BOOL;
    D24 : DINT;
    D25 : DINT;
    Y21 : BOOL;
    D28 : DINT;
    D29 : DINT;
    Y22 : BOOL;
    D32 : DINT;
    D33 : DINT;
    Y23 : BOOL;
    Y2 : BOOL;
    
    start_edge : R_TRIG;
    
    angle_scaled : DINT;
    target_scaled : DINT;
    receive_scaled : DINT;
    
    state : DINT := 0;
    
    arrived_a : BOOL;
    arrived_b : BOOL;
    arrived_c : BOOL;
    arrived_d : BOOL;
END_VAR

(* Edge detection for start signal *)
start_edge(CLK := X0);

(* State machine *)
CASE state OF
    0: (* Wait for start *)
        IF start_edge.Q THEN
            angle_scaled := D101;
            target_scaled := D102;
            receive_scaled := D103;
            state := 1;
        END_IF;
        
    1: (* Move B to angle, keep others at 0 *)
        D24 := angle_scaled;
        D25 := 1000;
        Y21 := TRUE;
        state := 2;
        
    2: (* Move A, C, D to targets after B arrives *)
        IF arrived_b THEN
            D20 := 12000;
            D21 := 1000;
            Y20 := TRUE;
            
            D28 := target_scaled;
            D29 := 1000;
            Y22 := TRUE;
            
            D32 := receive_scaled;
            D33 := 1000;
            Y23 := TRUE;
            
            state := 3;
        END_IF;
        
    3: (* Lower A to 100 to dock on support *)
        IF arrived_a AND arrived_c AND arrived_d THEN
            D20 := 10000;
            state := 4;
        END_IF;
        
    4: (* Docking complete - assert Y2 and maintain axes at targets *)
        Y2 := TRUE;
END_CASE;

(* Arrival checks: position within 0.2 tolerance, velocity within 1 tolerance *)
arrived_a := (ABS(D10 - D20) <= 20) AND (ABS(D11) <= 100);
arrived_b := (ABS(D12 - D24) <= 20) AND (ABS(D13) <= 100);
arrived_c := (ABS(D14 - D28) <= 20) AND (ABS(D15) <= 100);
arrived_d := (ABS(D16 - D32) <= 20) AND (ABS(D17) <= 100);

END_PROGRAM