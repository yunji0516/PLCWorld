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
    D0 : INT;
    D1 : INT;
    D2 : INT;
    D3 : INT;
    D4 : INT;
    D200 : INT;
    D201 : INT;
    X1A : BOOL;
    X1B : BOOL;
    X1C : BOOL;
    X1D : BOOL;
    X1E : BOOL;
    X1F : BOOL;
    Y1A : BOOL;

    (* State machine *)
    state : INT := 0;
    a_sent : INT := 0;
    b_sent : INT := 0;
    a_seq : INT := 1;
    b_seq : INT := 1;
    exchange_done : BOOL := FALSE;

    (* Consumption management states *)
    a_asm_state : INT := 0;
    b_asm_state : INT := 0;
    a_rel_state : INT := 0;
    b_rel_state : INT := 0;

    (* Completion *)
    comp_timer : TON;
    comp_holding : BOOL := FALSE;
    comp_locked : BOOL := FALSE;

    (* Edge detection *)
    start_edge : R_TRIG;
END_VAR

start_edge(CLK := X0);

(* Assembly A: pulse Y16 when item present, cap ready, not busy *)
CASE a_asm_state OF
    0:
        IF X1F AND X20 AND NOT X21 THEN
            Y16 := TRUE;
            a_asm_state := 1;
        END_IF;
    1:
        Y16 := FALSE;
        a_asm_state := 2;
    2:
        IF X21 OR NOT X1F THEN
            a_asm_state := 0;
        END_IF;
END_CASE;

(* Assembly B: pulse Y17 when item present, cap ready, not busy *)
CASE b_asm_state OF
    0:
        IF X25 AND X26 AND NOT X27 THEN
            Y17 := TRUE;
            b_asm_state := 1;
        END_IF;
    1:
        Y17 := FALSE;
        b_asm_state := 2;
    2:
        IF X27 OR NOT X25 THEN
            b_asm_state := 0;
        END_IF;
END_CASE;

(* Release A: pulse Y18 when done and exit clear *)
CASE a_rel_state OF
    0:
        IF X22 AND X23 THEN
            Y18 := TRUE;
            a_rel_state := 1;
        END_IF;
    1:
        Y18 := FALSE;
        a_rel_state := 2;
    2:
        IF NOT X22 OR NOT X23 THEN
            a_rel_state := 0;
        END_IF;
END_CASE;

(* Release B: pulse Y19 when done and exit clear *)
CASE b_rel_state OF
    0:
        IF X28 AND X29 THEN
            Y19 := TRUE;
            b_rel_state := 1;
        END_IF;
    1:
        Y19 := FALSE;
        b_rel_state := 2;
    2:
        IF NOT X28 OR NOT X29 THEN
            b_rel_state := 0;
        END_IF;
END_CASE;

(* Main extraction and exchange state machine *)
CASE state OF
    0: (* IDLE - wait for start *)
        Y10 := TRUE;
        Y11 := TRUE;
        Y12 := FALSE;
        Y13 := FALSE;
        Y14 := FALSE;
        Y15 := FALSE;
        IF start_edge.Q THEN
            state := 1;
        END_IF;

    1: (* PREP - close upper, wait for shuttle_home + stack_ready + upper_closed *)
        Y12 := FALSE;
        Y13 := FALSE;
        Y14 := FALSE;
        Y15 := FALSE;
        Y11 := TRUE;
        IF X12 AND X16 AND X11 THEN
            Y10 := FALSE;
            state := 2;
        END_IF;

    2: (* WAIT_SHUTTLE_LOADED - lowest item descends to shuttle *)
        Y11 := TRUE;
        Y13 := FALSE;
        Y14 := FALSE;
        Y15 := FALSE;
        IF X17 THEN
            Y12 := TRUE;
            state := 3;
        END_IF;

    3: (* EXTRACT - move forward, wait for extraction_clear *)
        Y11 := TRUE;
        Y13 := FALSE;
        Y14 := FALSE;
        Y15 := FALSE;
        IF X18 THEN
            Y12 := FALSE;
            Y10 := TRUE;
            Y11 := FALSE;
            state := 4;
        END_IF;

    4: (* RESTORE - wait for lower_closed AND upper_open *)
        Y12 := FALSE;
        Y13 := FALSE;
        Y14 := FALSE;
        Y15 := FALSE;
        IF X14 AND X13 THEN
            state := 5;
        END_IF;

    5: (* SEND - set side/request, pulse send *)
        Y12 := FALSE;
        Y14 := FALSE;
        Y15 := FALSE;
        IF a_sent < 3 THEN
            D200 := 1;
            D201 := a_seq;
            a_seq := a_seq + 1;
            a_sent := a_sent + 1;
        ELSE
            D200 := 2;
            D201 := b_seq;
            b_seq := b_seq + 1;
            b_sent := b_sent + 1;
        END_IF;
        Y13 := TRUE;
        state := 51;

    51: (* SEND_RESET - reset send pulse, decide next step *)
        Y13 := FALSE;
        Y12 := FALSE;
        Y14 := FALSE;
        Y15 := FALSE;
        IF D0 = 201 AND D1 <= 0 AND NOT exchange_done THEN
            state := 7;
        ELSIF D3 >= 3 AND D4 >= 4 AND exchange_done THEN
            state := 90;
        ELSE
            state := 1;
        END_IF;

    7: (* CHECK_SWAP - wait for swap conditions *)
        Y12 := FALSE;
        Y13 := FALSE;
        Y15 := FALSE;
        IF X18 AND X14 AND X13 AND X1A AND X16 THEN
            Y14 := TRUE;
            state := 8;
        END_IF;

    8: (* SWAP_RESET - reset swap pulse *)
        Y14 := FALSE;
        Y12 := FALSE;
        Y13 := FALSE;
        Y15 := FALSE;
        state := 9;

    9: (* WAIT_SWAP_DONE - wait for swap_busy clear and new magazine docked *)
        Y12 := FALSE;
        Y13 := FALSE;
        Y14 := FALSE;
        Y15 := FALSE;
        IF NOT X19 AND X10 THEN
            state := 11;
        END_IF;

    11: (* WAIT_RETURN_READY - at return_ready, pulse take_empty *)
        Y12 := FALSE;
        Y13 := FALSE;
        Y14 := FALSE;
        IF X1B THEN
            Y15 := TRUE;
            state := 12;
        END_IF;

    12: (* TAKE_EMPTY_RESET - reset take_empty pulse, mark exchange done *)
        Y15 := FALSE;
        exchange_done := TRUE;
        Y12 := FALSE;
        Y13 := FALSE;
        Y14 := FALSE;
        state := 1;

    90: (* COMPLETE - verify and maintain completion *)
        Y12 := FALSE;
        Y13 := FALSE;
        Y14 := FALSE;
        Y15 := FALSE;
        IF D0 = 202 AND X10 AND D1 = 1 AND X16 AND X14 AND X13 THEN
            Y1A := TRUE;
            IF NOT comp_holding THEN
                comp_holding := TRUE;
                comp_timer(IN := TRUE, PT := T#500ms);
            ELSIF comp_timer.Q THEN
                comp_locked := TRUE;
            END_IF;
        ELSE
            IF NOT comp_locked THEN
                Y1A := FALSE;
                comp_holding := FALSE;
                comp_timer(IN := FALSE);
                state := 0;
            END_IF;
        END_IF;
END_CASE;

END_PROGRAM