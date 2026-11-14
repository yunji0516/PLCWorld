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
    X22 : BOOL;
    X23 : BOOL;
    X24 : BOOL;
    X25 : BOOL;
    X26 : BOOL;
    X27 : BOOL;
    X28 : BOOL;
    X29 : BOOL;
    X30 : BOOL;
    X31 : BOOL;
    X32 : BOOL;
    Y10 : BOOL;
    Y11 : BOOL;
    Y12 : BOOL;
    Y13 : BOOL;
    Y14 : BOOL;
    Y15 : BOOL;
    Y16 : BOOL;
    Y17 : BOOL;
    Y18 : BOOL;
    Y19 : BOOL;
    Y20 : BOOL;
    Y21 : BOOL;
    Y22 : BOOL;
    D0 : INT;
    D1 : INT;
    D2 : INT;
    D3 : INT;
    D4 : INT;
    D5 : INT;
    D6 : INT;
    D7 : INT;
    D8 : INT;
    D9 : INT;
    D10 : INT;
    D11 : INT;
    D12 : INT;
    D13 : INT;
    X1A : BOOL;
    X1B : BOOL;
    X1C : BOOL;
    X1D : BOOL;
    X1E : BOOL;
    X1F : BOOL;
    X2A : BOOL;
    X2B : BOOL;
    X2C : BOOL;
    X2D : BOOL;
    X2E : BOOL;
    X2F : BOOL;
    Y1A : BOOL;
    Y1B : BOOL;
    Y1C : BOOL;
    Y1D : BOOL;
    Y1E : BOOL;
    Y1F : BOOL;

    swap_edge : R_TRIG;
    cap_a_edge : R_TRIG;
    cap_b_edge : R_TRIG;
    valve_timer_a : TON;
    valve_timer_b : TON;
    capper_timer : TON;

    started : BOOL;
    complete_flag : BOOL;

    line_a_state : INT;
    line_b_state : INT;
    capper_state : INT;
    refill_state : INT;
    swap_state : INT;

    a_fill_started : BOOL;
    a_valve_cmd : BOOL;
    a_pump_cmd : BOOL;
    b_fill_started : BOOL;
    b_valve_cmd : BOOL;
    b_pump_cmd : BOOL;

    refill_req : BOOL;
    swap_req : BOOL;
    capper_req_a : BOOL;
    capper_req_b : BOOL;

    a_done_internal : BOOL;
    b_done_internal : BOOL;

    scan_count : DINT;
END_VAR

CONST
    LINE_STATE_IDLE : INT := 0;
    LINE_STATE_FEED : INT := 1;
    LINE_STATE_CLAMP : INT := 2;
    LINE_STATE_DOWN : INT := 3;
    LINE_STATE_FILL : INT := 4;
    LINE_STATE_UP : INT := 5;
    LINE_STATE_OUT : INT := 6;
    LINE_STATE_WAIT_CAP : INT := 7;
    LINE_STATE_RELEASE : INT := 8;
    LINE_STATE_DONE : INT := 9;

    CAPPER_IDLE : INT := 0;
    CAPPER_MOVING_A : INT := 1;
    CAPPER_CAP_A : INT := 2;
    CAPPER_MOVING_B : INT := 3;
    CAPPER_CAP_B : INT := 4;

    REFILL_IDLE : INT := 0;
    REFILL_ACTIVE : INT := 1;

    SWAP_IDLE : INT := 0;
    SWAP_REQ : INT := 1;
END_CONST

(* Edge detection *)
swap_edge(CLK := X30);
cap_a_edge(CLK := Y12);
cap_b_edge(CLK := Y13);

valve_timer_a(IN := a_valve_cmd, PT := T#150ms);
valve_timer_b(IN := b_valve_cmd, PT := T#150ms);

scan_count := scan_count + 1;

(* Initialize on start *)
IF NOT started AND X0 THEN
    started := TRUE;
    line_a_state := LINE_STATE_IDLE;
    line_b_state := LINE_STATE_IDLE;
    capper_state := CAPPER_IDLE;
    refill_state := REFILL_IDLE;
    swap_state := SWAP_IDLE;
    complete_flag := FALSE;
    a_done_internal := FALSE;
    b_done_internal := FALSE;
END_IF;

(* === REFILL MANAGEMENT === *)

(* Check if swap is needed - batch empty and batch_ready is off *)
IF D1 <= 0 AND NOT X2F AND swap_state = SWAP_IDLE AND refill_state = REFILL_IDLE THEN
    swap_req := TRUE;
    swap_state := SWAP_REQ;
END_IF;

(* Execute swap *)
IF swap_state = SWAP_REQ AND NOT X30 THEN
    Y11 := TRUE;
    swap_state := SWAP_REQ;
ELSIF swap_edge.Q OR (swap_state = SWAP_REQ AND X30) THEN
    Y11 := FALSE;
    swap_state := SWAP_IDLE;
    swap_req := FALSE;
END_IF;

(* Refill control - only when batch is ready and no swap happening *)
refill_req := FALSE;
IF X2F AND swap_state = SWAP_IDLE AND refill_state = REFILL_IDLE AND D0 < 120 THEN
    refill_req := TRUE;
    refill_state := REFILL_ACTIVE;
END_IF;

IF refill_state = REFILL_ACTIVE AND D0 >= 160 THEN
    refill_state := REFILL_IDLE;
END_IF;

IF refill_state = REFILL_ACTIVE AND (NOT X2F OR swap_state <> SWAP_IDLE) THEN
    refill_state := REFILL_IDLE;
END_IF;

Y10 := (refill_state = REFILL_ACTIVE);

(* === LINE A CONTROL === *)

CASE line_a_state OF
    LINE_STATE_IDLE:
        Y14 := FALSE;
        Y15 := FALSE;
        Y16 := FALSE;
        Y19 := FALSE;
        Y1A := FALSE;
        a_valve_cmd := FALSE;
        a_pump_cmd := FALSE;
        Y17 := FALSE;
        Y18 := FALSE;
        Y12 := FALSE;
        
        (* Request feed when source available and station empty *)
        IF X11 AND X18 AND NOT X10 THEN
            line_a_state := LINE_STATE_FEED;
        END_IF;

    LINE_STATE_FEED:
        Y14 := TRUE;
        Y15 := FALSE;
        Y16 := FALSE;
        Y19 := FALSE;
        Y1A := FALSE;
        a_valve_cmd := FALSE;
        a_pump_cmd := FALSE;
        Y17 := FALSE;
        Y18 := FALSE;
        Y12 := FALSE;
        
        (* Move to clamp when container present at station *)
        IF X10 THEN
            line_a_state := LINE_STATE_CLAMP;
        END_IF;
        (* Timeout safety - if no container after feed, abort *)
        IF NOT X11 THEN
            line_a_state := LINE_STATE_IDLE;
        END_IF;

    LINE_STATE_CLAMP:
        Y14 := FALSE;
        Y15 := TRUE;
        Y16 := FALSE;
        Y19 := FALSE;
        Y1A := FALSE;
        a_valve_cmd := FALSE;
        a_pump_cmd := FALSE;
        Y17 := FALSE;
        Y18 := FALSE;
        Y12 := FALSE;
        
        (* Wait for clamp confirmation *)
        IF X14 THEN
            line_a_state := LINE_STATE_DOWN;
        END_IF;

    LINE_STATE_DOWN:
        Y14 := FALSE;
        Y15 := TRUE;
        Y16 := TRUE;
        Y19 := FALSE;
        Y1A := FALSE;
        a_valve_cmd := FALSE;
        a_pump_cmd := FALSE;
        Y17 := FALSE;
        Y18 := FALSE;
        Y12 := FALSE;
        
        (* Wait for nozzle down confirmation *)
        IF X13 THEN
            line_a_state := LINE_STATE_FILL;
        END_IF;

    LINE_STATE_FILL:
        Y14 := FALSE;
        Y15 := TRUE;
        Y16 := TRUE;
        Y19 := FALSE;
        Y1A := FALSE;
        Y17 := a_valve_cmd;
        Y18 := a_pump_cmd;
        Y12 := FALSE;
        
        IF NOT a_fill_started THEN
            a_fill_started := TRUE;
            a_valve_cmd := TRUE;
        END_IF;
        
        (* Start pump after valve confirmed open (0.15s delay) *)
        IF a_valve_cmd AND valve_timer_a.Q THEN
            a_pump_cmd := TRUE;
        END_IF;
        
        (* Stop filling when goal reached (with hose delay compensation) *)
        (* hose delay means fluid continues flowing after pump stops *)
        (* We stop pump when received >= goal - margin for hose discharge *)
        IF a_pump_cmd AND D4 >= D5 - 15 THEN
            a_valve_cmd := FALSE;
            a_pump_cmd := FALSE;
            a_fill_started := FALSE;
            line_a_state := LINE_STATE_UP;
        END_IF;
        
        (* Safety: stop if tank gets too low *)
        IF D0 < 10 AND a_pump_cmd THEN
            a_valve_cmd := FALSE;
            a_pump_cmd := FALSE;
        END_IF;

    LINE_STATE_UP:
        Y14 := FALSE;
        Y15 := TRUE;
        Y16 := FALSE;
        Y19 := FALSE;
        Y1A := FALSE;
        a_valve_cmd := FALSE;
        a_pump_cmd := FALSE;
        Y17 := FALSE;
        Y18 := FALSE;
        Y12 := FALSE;
        
        (* Wait for nozzle up confirmation *)
        IF X12 THEN
            line_a_state := LINE_STATE_OUT;
        END_IF;

    LINE_STATE_OUT:
        Y14 := FALSE;
        Y15 := FALSE;
        Y16 := FALSE;
        Y19 := TRUE;
        Y1A := FALSE;
        a_valve_cmd := FALSE;
        a_pump_cmd := FALSE;
        Y17 := FALSE;
        Y18 := FALSE;
        Y12 := FALSE;
        
        (* Wait for valve closed and nozzle up and clamp released (via out) *)
        IF X17 AND X12 AND NOT X14 THEN
            line_a_state := LINE_STATE_WAIT_CAP;
        END_IF;

    LINE_STATE_WAIT_CAP:
        Y14 := FALSE;
        Y15 := FALSE;
        Y16 := FALSE;
        Y19 := FALSE;
        Y1A := FALSE;
        a_valve_cmd := FALSE;
        a_pump_cmd := FALSE;
        Y17 := FALSE;
        Y18 := FALSE;
        Y12 := FALSE;
        
        (* Wait for container at capping position *)
        IF X1A THEN
            (* Request capping - check capper availability *)
            IF capper_state = CAPPER_IDLE OR capper_state = CAPPER_CAP_A OR capper_state = CAPPER_CAP_B THEN
                IF (capper_state = CAPPER_IDLE AND NOT X2C) OR (capper_state = CAPPER_IDLE AND NOT X2D AND NOT X2E) THEN
                    Y12 := TRUE;
                    capper_state := CAPPER_MOVING_A;
                END_IF;
            END_IF;
            (* Also check if capper is already at A or can service A *)
            IF X2D AND X1A AND NOT X1B AND NOT X2C THEN
                Y12 := TRUE;
                capper_state := CAPPER_CAP_A;
            END_IF;
        END_IF;
        
        (* Move to release when capped *)
        IF X1B THEN
            line_a_state := LINE_STATE_RELEASE;
            Y12 := FALSE;
        END_IF;

    LINE_STATE_RELEASE:
        Y14 := FALSE;
        Y15 := FALSE;
        Y16 := FALSE;
        Y19 := FALSE;
        Y1A := FALSE;
        a_valve_cmd := FALSE;
        a_pump_cmd := FALSE;
        Y17 := FALSE;
        Y18 := FALSE;
        Y12 := FALSE;
        
        (* Wait for exit clear before releasing *)
        IF X1C THEN
            Y1A := TRUE;
        END_IF;
        
        (* When done signal received, move to done state *)
        IF X1D THEN
            line_a_state := LINE_STATE_DONE;
            Y1A := FALSE;
            a_done_internal := TRUE;
        END_IF;
        (* Safety - release only when exit is clear and container is capped *)
        IF NOT X1C THEN
            Y1A := FALSE;
        END_IF;

    LINE_STATE_DONE:
        Y14 := FALSE;
        Y15 := FALSE;
        Y16 := FALSE;
        Y19 := FALSE;
        Y1A := FALSE;
        a_valve_cmd := FALSE;
        a_pump_cmd := FALSE;
        Y17 := FALSE;
        Y18 := FALSE;
        Y12 := FALSE;
END_CASE;

(* === LINE B CONTROL === *)

CASE line_b_state OF
    LINE_STATE_IDLE:
        Y1B := FALSE;
        Y1C := FALSE;
        Y1D := FALSE;
        Y20 := FALSE;
        Y21 := FALSE;
        b_valve_cmd := FALSE;
        b_pump_cmd := FALSE;
        Y1E := FALSE;
        Y1F := FALSE;
        Y13 := FALSE;
        
        (* Request feed when source available and station empty *)
        IF X1F AND X26 AND NOT X1E THEN
            line_b_state := LINE_STATE_FEED;
        END_IF;

    LINE_STATE_FEED:
        Y1B := TRUE;
        Y1C := FALSE;
        Y1D := FALSE;
        Y20 := FALSE;
        Y21 := FALSE;
        b_valve_cmd := FALSE;
        b_pump_cmd := FALSE;
        Y1E := FALSE;
        Y1F := FALSE;
        Y13 := FALSE;
        
        (* Move to clamp when container present at station *)
        IF X1E THEN
            line_b_state := LINE_STATE_CLAMP;
        END_IF;
        
        IF NOT X1F THEN
            line_b_state := LINE_STATE_IDLE;
        END_IF;

    LINE_STATE_CLAMP:
        Y1B := FALSE;
        Y1C := TRUE;
        Y1D := FALSE;
        Y20 := FALSE;
        Y21 := FALSE;
        b_valve_cmd := FALSE;
        b_pump_cmd := FALSE;
        Y1E := FALSE;
        Y1F := FALSE;
        Y13 := FALSE;
        
        IF X22 THEN
            line_b_state := LINE_STATE_DOWN;
        END_IF;

    LINE_STATE_DOWN:
        Y1B := FALSE;
        Y1C := TRUE;
        Y1D := TRUE;
        Y20 := FALSE;
        Y21 := FALSE;
        b_valve_cmd := FALSE;
        b_pump_cmd := FALSE;
        Y1E := FALSE;
        Y1F := FALSE;
        Y13 := FALSE;
        
        IF X21 THEN
            line_b_state := LINE_STATE_FILL;
        END_IF;

    LINE_STATE_FILL:
        Y1B := FALSE;
        Y1C := TRUE;
        Y1D := TRUE;
        Y20 := FALSE;
        Y21 := FALSE;
        Y1E := b_valve_cmd;
        Y1F := b_pump_cmd;
        Y13 := FALSE;
        
        IF NOT b_fill_started THEN
            b_fill_started := TRUE;
            b_valve_cmd := TRUE;
        END_IF;
        
        IF b_valve_cmd AND valve_timer_b.Q THEN
            b_pump_cmd := TRUE;
        END_IF;
        
        IF b_pump_cmd AND D9 >= D10 - 15 THEN
            b_valve_cmd := FALSE;
            b_pump_cmd := FALSE;
            b_fill_started := FALSE;
            line_b_state := LINE_STATE_UP;
        END_IF;
        
        IF D0 < 10 AND b_pump_cmd THEN
            b_valve_cmd := FALSE;
            b_pump_cmd := FALSE;
        END_IF;

    LINE_STATE_UP:
        Y1B := FALSE;
        Y1C := TRUE;
        Y1D := FALSE;
        Y20 := FALSE;
        Y21 := FALSE;
        b_valve_cmd := FALSE;
        b_pump_cmd := FALSE;
        Y1E := FALSE;
        Y1F := FALSE;
        Y13 := FALSE;
        
        IF X20 THEN
            line_b_state := LINE_STATE_OUT;
        END_IF;

    LINE_STATE_OUT:
        Y1B := FALSE;
        Y1C := FALSE;
        Y1D := FALSE;
        Y20 := TRUE;
        Y21 := FALSE;
        b_valve_cmd := FALSE;
        b_pump_cmd := FALSE;
        Y1E := FALSE;
        Y1F := FALSE;
        Y13 := FALSE;
        
        IF X25 AND X20 AND NOT X22 THEN
            line_b_state := LINE_STATE_WAIT_CAP;
        END_IF;

    LINE_STATE_WAIT_CAP:
        Y1B := FALSE;
        Y1C := FALSE;
        Y1D := FALSE;
        Y20 := FALSE;
        Y21 := FALSE;
        b_valve_cmd := FALSE;
        b_pump_cmd := FALSE;
        Y1E := FALSE;
        Y1F := FALSE;
        Y13 := FALSE;
        
        IF X28 THEN
            (* Check if capper can service B *)
            IF (capper_state = CAPPER_IDLE AND NOT X2C) OR X2E THEN
                IF X28 AND NOT X29 AND NOT X2C THEN
                    Y13 := TRUE;
                    capper_state := CAPPER_MOVING_B;
                END_IF;
            END_IF;
            IF X2E AND X28 AND NOT X29 AND NOT X2C THEN
                Y13 := TRUE;
                capper_state := CAPPER_CAP_B;
            END_IF;
        END_IF;
        
        IF X29 THEN
            line_b_state := LINE_STATE_RELEASE;
            Y13 := FALSE;
        END_IF;

    LINE_STATE_RELEASE:
        Y1B := FALSE;
        Y1C := FALSE;
        Y1D := FALSE;
        Y20 := FALSE;
        Y21 := FALSE;
        b_valve_cmd := FALSE;
        b_pump_cmd := FALSE;
        Y1E := FALSE;
        Y1F := FALSE;
        Y13 := FALSE;
        
        IF X2A THEN
            Y21 := TRUE;
        END_IF;
        
        IF X2B THEN
            line_b_state := LINE_STATE_DONE;
            Y21 := FALSE;
            b_done_internal := TRUE;
        END_IF;
        
        IF NOT X2A THEN
            Y21 := FALSE;
        END_IF;

    LINE_STATE_DONE:
        Y1B := FALSE;
        Y1C := FALSE;
        Y1D := FALSE;
        Y20 := FALSE;
        Y21 := FALSE;
        b_valve_cmd := FALSE;
        b_pump_cmd := FALSE;
        Y1E := FALSE;
        Y1F := FALSE;
        Y13 := FALSE;
END_CASE;

(* === CAPPER STATE MANAGEMENT === *)

CASE capper_state OF
    CAPPER_IDLE:
        Y12 := FALSE;
        Y13 := FALSE;
        
        (* Check if either line needs capping *)
        IF line_a_state = LINE_STATE_WAIT_CAP AND X1A AND NOT X1B THEN
            Y12 := TRUE;
            capper_state := CAPPER_MOVING_A;
        ELSIF line_b_state = LINE_STATE_WAIT_CAP AND X28 AND NOT X29 THEN
            Y13 := TRUE;
            capper_state := CAPPER_MOVING_B;
        END_IF;

    CAPPER_MOVING_A:
        Y12 := TRUE;
        Y13 := FALSE;
        
        IF X2D AND NOT X2C THEN
            capper_state := CAPPER_CAP_A;
        END_IF;
        
        (* If already capped or no container, return to idle *)
        IF X1B OR (NOT X1A AND NOT X2C) THEN
            capper_state := CAPPER_IDLE;
            Y12 := FALSE;
        END_IF;

    CAPPER_CAP_A:
        Y12 := TRUE;
        Y13 := FALSE;
        
        IF X1B OR NOT X2C THEN
            capper_state := CAPPER_IDLE;
            Y12 := FALSE;
        END_IF;

    CAPPER_MOVING_B:
        Y12 := FALSE;
        Y13 := TRUE;
        
        IF X2E AND NOT X2C THEN
            capper_state := CAPPER_CAP_B;
        END_IF;
        
        IF X29 OR (NOT X28 AND NOT X2C) THEN
            capper_state := CAPPER_IDLE;
            Y13 := FALSE;
        END_IF;

    CAPPER_CAP_B:
        Y12 := FALSE;
        Y13 := TRUE;
        
        IF X29 OR NOT X2C THEN
            capper_state := CAPPER_IDLE;
            Y13 := FALSE;
        END_IF;
END_CASE;

(* === COMPLETION CHECK === *)

IF a_done_internal AND b_done_internal AND D3 >= 6 THEN
    complete_flag := TRUE;
END_IF;

Y22 := complete_flag;

END_PROGRAM