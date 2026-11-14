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
    Y20 : BOOL;
    Y21 : BOOL;
    Y22 : BOOL;
    Y23 : BOOL;
    Y24 : BOOL;
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
    D200 : INT;
    D201 : INT;
    D202 : INT;
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
    Y1A : BOOL;
    Y1B : BOOL;
    Y1C : BOOL;
    Y1D : BOOL;
    Y1E : BOOL;
    Y1F : BOOL;
    (* Internal variables *)
    st_main : INT := 0;
    st_toolx : INT := 0;
    prev_st_main : INT := -1;
    cur_prod : INT := 0;
    exit_ack_count : INT := 0;
    a_prepared : BOOL := FALSE;
    b_prepared : BOOL := FALSE;
    cradle_init_done : BOOL := FALSE;
    prod_a_done : ARRAY[1..4] OF BOOL := [FALSE, FALSE, FALSE, FALSE];
    prod_b_done : ARRAY[1..4] OF BOOL := [FALSE, FALSE, FALSE, FALSE];
    prod_exit_done : ARRAY[1..4] OF BOOL := [FALSE, FALSE, FALSE, FALSE];
    b_clamp_timer : TON;
    start_edge : R_TRIG;
    admit_edge : R_TRIG;
    cradle_lock_edge : R_TRIG;
    rotate_edge : R_TRIG;
    head_grip_edge : R_TRIG;
    tool_dock_edge : R_TRIG;
    tool_lock_edge : R_TRIG;
    tool_unlock_edge : R_TRIG;
    source_ready_edge : R_TRIG;
    a_done_edge : R_TRIG;
    cradle_flipped_edge : R_TRIG;
    b_done_edge : R_TRIG;
    exit_received_edge : R_TRIG;
    b_transfer_clear_edge : R_TRIG;
    b_request_edge : R_TRIG;
    head_busy_last : BOOL := FALSE;
    head_held_last : BOOL := FALSE;
    head_clear_last : BOOL := FALSE;
    a_present_last : BOOL := FALSE;
    a_done_last : BOOL := FALSE;
    a_busy_last : BOOL := FALSE;
    cradle_present_last : BOOL := FALSE;
    cradle_locked_last : BOOL := FALSE;
    b_present_last : BOOL := FALSE;
    b_done_last : BOOL := FALSE;
    b_busy_last : BOOL := FALSE;
    exit_received_last : BOOL := FALSE;
    source_ready_last : BOOL := FALSE;
    b_request_ready_last : BOOL := FALSE;
    tool_at_rack_last : BOOL := FALSE;
    tool_latched_last : BOOL := FALSE;
    tool_busy_last_val : BOOL := FALSE;
    b_transfer_clear_last : BOOL := FALSE;
    cradle_flipped_last : BOOL := FALSE;
    source_fixture_ready_last : BOOL := FALSE;
    a_fixture_ready_last : BOOL := FALSE;
    b_fixture_ready_last : BOOL := FALSE;
    product_width : ARRAY[1..4] OF INT := [160, 120, 160, 120];
    product_type : ARRAY[1..4] OF INT := [1, 2, 1, 2];
    a_width_target : INT := 160;
    b_width_target : INT := 160;
    completed : BOOL := FALSE;
    complete_timer : TON;
END_VAR

(* Edge detection *)
start_edge(CLK := X0);
source_ready_edge(CLK := X10);
head_busy_last := X11;
head_held_last := X12;
head_clear_last := X13;
a_present_last := X14;
a_done_last := X15;
a_busy_last := X16;
cradle_present_last := X17;
cradle_locked_last := X18;
cradle_flipped_last := X1A;
b_present_last := X1C;
b_done_last := X1D;
b_busy_last := X1E;
exit_received_last := X20;
b_request_ready_last := X22;
b_transfer_clear_last := X27;
source_fixture_ready_last := X28;
tool_busy_last_val := X29;
tool_at_rack_last := X2A;
tool_latched_last := X2B;
a_fixture_ready_last := X2C;
b_fixture_ready_last := X2D;

(* Main state machine *)
CASE st_main OF
    0: (* Idle - waiting for start *)
        IF start_edge.Q THEN
            st_main := 1;
        END_IF;

    1: (* Prepare A fixture and head tool for current product *)
        IF cur_prod = 0 THEN
            cur_prod := 1;
        END_IF;
        a_width_target := product_width[cur_prod];
        b_width_target := product_width[cur_prod];
        a_prepared := FALSE;
        b_prepared := FALSE;
        cradle_init_done := FALSE;
        st_main := 2;

    2: (* Adjust A fixture to product width, prepare head tool *)
        D201 := a_width_target;
        Y23 := TRUE;
        (* Tool setup: ensure correct tool is on head *)
        IF D8 <> product_type[cur_prod] THEN
            st_main := 30;
            st_toolx := 10;
        ELSE
            a_prepared := TRUE;
            st_main := 3;
        END_IF;

    30: (* Tool exchange sub-sequence - moving head to rack *)
        st_toolx := 10;
        D200 := product_type[cur_prod];
        Y1F := TRUE; (* tool_dock - move head to rack slot *)
        IF X2A THEN
            st_toolx := 11;
            Y1F := FALSE;
        END_IF;
        (* If tool exchange is done, return to main *)
        IF st_toolx = 15 THEN
            st_toolx := 0;
            st_main := 2;
        END_IF;

    3: (* Wait for source fixture ready, then admit *)
        Y23 := FALSE;
        D201 := a_width_target;
        IF X28 AND X10 THEN
            Y10 := TRUE; (* admit - transfer product to A jig *)
            st_main := 4;
        END_IF;

    4: (* Product admitted, waiting for head to clear after admit *)
        Y10 := FALSE;
        IF X13 THEN (* head_clear - head returned from admit *)
            st_main := 5;
        END_IF;

    5: (* Wait for product present in A jig, then start A work *)
        IF X14 AND NOT X16 THEN (* a_present and a_busy not active yet *)
            Y11 := TRUE; (* work_a *)
            st_main := 6;
        END_IF;

    6: (* A operation in progress *)
        Y11 := TRUE;
        IF X15 THEN (* a_done *)
            Y11 := FALSE;
            prod_a_done[cur_prod] := TRUE;
            st_main := 7;
        END_IF;

    7: (* Transfer completed A product to cradle *)
        Y12 := TRUE; (* to_cradle *)
        st_main := 8;

    8: (* Waiting for head to clear after to_cradle transfer *)
        Y12 := FALSE;
        IF X13 THEN
            st_main := 9;
        END_IF;

    9: (* Lock cradle - pads make contact and secure vacuum *)
        Y13 := TRUE; (* cradle_lock *)
        st_main := 10;

    10: (* Wait for cradle_locked, then head_release *)
        Y13 := FALSE;
        IF X18 THEN
            Y14 := TRUE; (* head_release *)
            st_main := 11;
        END_IF;

    11: (* Rotate cradle - wait for head to clear after release *)
        Y14 := FALSE;
        IF X13 THEN
            Y15 := TRUE; (* rotate - invert 0 to 180 *)
            st_main := 12;
        END_IF;

    12: (* Wait for rotation complete *)
        Y15 := FALSE;
        IF X1A THEN (* cradle_flipped *)
            st_main := 13;
        END_IF;

    13: (* Head grips from opposing corner *)
        Y16 := TRUE; (* head_grip *)
        st_main := 14;

    14: (* Wait for head_held, then unlock cradle *)
        Y16 := FALSE;
        IF X12 THEN
            Y17 := TRUE; (* cradle_unlock - retract pads *)
            st_main := 15;
        END_IF;

    15: (* Transfer to B fixture *)
        Y17 := FALSE;
        IF X13 THEN
            Y18 := TRUE; (* to_b *)
            st_main := 16;
        END_IF;

    16: (* Wait for head to clear after to_b *)
        Y18 := FALSE;
        IF X13 THEN
            st_main := 17;
        END_IF;

    17: (* Adjust B fixture width, wait for b_transfer_clear *)
        D202 := product_width[cur_prod];
        Y24 := TRUE;
        IF X27 THEN
            st_main := 18;
        END_IF;

    18: (* Clamp B fixture after transfer clear *)
        Y24 := FALSE;
        D202 := product_width[cur_prod];
        Y1D := TRUE; (* b_clamp - close Z corner clamp 300ms after product arrival *)
        b_clamp_timer(IN := TRUE, PT := T#300ms);
        st_main := 19;

    19: (* Wait for b_clamp timing and b_keeper_open *)
        Y1D := TRUE;
        IF b_clamp_timer.Q THEN
            Y1E := TRUE; (* b_keeper_open - retract upper support 80mm *)
            b_clamp_timer(IN := FALSE);
            st_main := 20;
        END_IF;

    20: (* Prepare B work - wait for conditions *)
        Y1D := FALSE;
        Y1E := FALSE;
        D202 := product_width[cur_prod];
        Y24 := TRUE;
        IF X2D AND X1C AND X22 AND X23 AND X25 AND X26 AND D8 = product_type[cur_prod] THEN
            Y19 := TRUE; (* work_b *)
            st_main := 21;
        END_IF;

    21: (* B operation in progress *)
        Y19 := TRUE;
        IF X1D THEN (* b_done *)
            Y19 := FALSE;
            prod_b_done[cur_prod] := TRUE;
            st_main := 22;
        END_IF;

    22: (* Release product to exit *)
        Y1A := TRUE; (* release *)
        st_main := 23;

    23: (* Wait for exit_received, then ack *)
        Y1A := FALSE;
        IF X20 THEN
            Y1B := TRUE; (* ack_exit *)
            st_main := 24;
        END_IF;

    24: (* Wait for ack confirmation *)
        Y1B := FALSE;
        prod_exit_done[cur_prod] := TRUE;
        exit_ack_count := exit_ack_count + 1;
        st_main := 25;

    25: (* Check if all products done *)
        IF cur_prod >= 4 THEN
            st_main := 50;
        ELSE
            cur_prod := cur_prod + 1;
            st_main := 1;
        END_IF;

    50: (* Final: return cradle to 0, ensure head away from rack *)
        IF cradle_init_done = FALSE THEN
            cradle_init_done := TRUE;
        END_IF;
        st_main := 51;

    51: (* Check completion conditions *)
        IF exit_ack_count >= 4 AND D8 = 0 AND NOT X11 AND X1F THEN
            st_main := 60;
        END_IF;

    60: (* Complete - maintain for 0.5s then declare *)
        completed := TRUE;
        complete_timer(IN := TRUE, PT := T#500ms);
        IF complete_timer.Q THEN
            st_main := 61;
        END_IF;

    61: (* Maintain complete state *)
        completed := TRUE;
END_CASE;

(* Tool exchange sub-states *)
IF st_main >= 30 AND st_main <= 39 THEN
    CASE st_toolx OF
        10: (* Move head to rack - already initiated *)
            D200 := product_type[cur_prod];
            Y1F := TRUE;
            IF X2A THEN
                Y1F := FALSE;
                st_toolx := 11;
            END_IF;
        11: (* At rack, unlock old tool if present *)
            IF D8 <> 0 THEN
                Y20 := TRUE;
                IF NOT X2B THEN
                    Y20 := FALSE;
                    st_toolx := 12;
                END_IF;
            ELSE
                st_toolx := 12;
            END_IF;
        12: (* Select new tool, lock it *)
            Y20 := FALSE;
            D200 := product_type[cur_prod];
            Y21 := TRUE;
            IF X2B THEN
                Y21 := FALSE;
                st_toolx := 13;
            END_IF;
        13: (* Return head from rack *)
            Y21 := FALSE;
            Y22 := TRUE;
            IF X13 THEN
                Y22 := FALSE;
                st_toolx := 15;
            END_IF;
        15: (* Tool exchange complete *)
            Y22 := FALSE;
            Y21 := FALSE;
            Y20 := FALSE;
            Y1F := FALSE;
            D200 := 0;
            st_toolx := 0;
            st_main := 2;
    END_CASE;
END_IF;

(* Reset tool exchange outputs when not in tool exchange *)
IF st_main < 30 OR st_main > 39 THEN
    Y1F := FALSE;
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
    D200 := 0;
END_IF;

(* Completion output *)
IF completed THEN
    Y1C := TRUE;
ELSE
    Y1C := FALSE;
END_IF;

(* Safety: ensure no tool release when product held *)
IF X12 AND Y20 THEN
    Y20 := FALSE;
END_IF;

(* Safety: ensure no tool lock without rack *)
IF NOT X2A AND Y21 THEN
    Y21 := FALSE;
END_IF;

END_PROGRAM