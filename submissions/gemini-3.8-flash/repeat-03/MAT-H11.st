An implementation of the control program in IEC 61131-3 Structured Text for **MAT-H11**:

```iecst
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
    step : INT := 0;
    target_tool : INT := 0;
    target_width : INT := 0;
    products_completed : INT := 0;

    ton_timer : TON;
    timer_in : BOOL := FALSE;
    timer_pt : TIME := T#0ms;

    complete_timer : TON;
    complete_latched : BOOL := FALSE;
END_VAR

(* Reset command pulses at beginning of scan *)
Y10 := FALSE; (* admit *)
Y11 := FALSE; (* work_a *)
Y12 := FALSE; (* to_cradle *)
Y13 := FALSE; (* cradle_lock *)
Y14 := FALSE; (* head_release *)
Y15 := FALSE; (* rotate *)
Y16 := FALSE; (* head_grip *)
Y17 := FALSE; (* cradle_unlock *)
Y18 := FALSE; (* to_b *)
Y19 := FALSE; (* work_b *)
Y20 := FALSE; (* tool_unlock *)
Y21 := FALSE; (* tool_lock *)
Y22 := FALSE; (* tool_return *)
Y23 := FALSE; (* adjust_a *)
Y24 := FALSE; (* adjust_b *)
Y1A := FALSE; (* release *)
Y1B := FALSE; (* ack_exit *)
Y1F := FALSE; (* tool_dock *)

(* Execute main sequencer if system started *)
IF X0 OR (step > 0) THEN
    CASE step OF
        0: (* Wait for system start *)
            IF X0 THEN
                step := 1;
            END_IF;

        1: (* Check if all 4 products are finished *)
            IF (products_completed >= 4) OR X21 THEN
                step := 90; (* Go to completion *)
            ELSE
                step := 2;
            END_IF;

        2: (* Inspect source workpiece requirements *)
            IF X10 THEN
                IF D10 = 2 THEN
                    target_tool := 2;
                    target_width := 120;
                ELSE
                    target_tool := 1;
                    target_width := 160;
                END_IF;
                D200 := target_tool;
                D201 := target_width;
                step := 3;
            END_IF;

        3: (* Check tool requirement *)
            IF NOT X11 AND NOT X29 THEN
                IF D8 = target_tool THEN
                    step := 10; (* Correct tool already mounted *)
                ELSIF D8 = 0 THEN
                    (* Empty head: dock directly to target slot *)
                    D200 := target_tool;
                    Y1F := TRUE;
                    step := 6;
                ELSE
                    (* Different tool mounted: must return it first *)
                    D200 := D8;
                    Y1F := TRUE;
                    step := 4;
                END_IF;
            END_IF;

        4: (* Wait for old tool at rack slot *)
            IF X2A AND NOT X29 AND NOT X11 THEN
                Y20 := TRUE; (* tool_unlock *)
                step := 5;
            END_IF;

        5: (* Wait for unlatched old tool, then dock to target tool *)
            IF NOT X2B AND NOT X29 THEN
                D200 := target_tool;
                Y1F := TRUE;
                step := 6;
            END_IF;

        6: (* Wait for head at target tool rack slot *)
            IF X2A AND NOT X29 AND NOT X11 THEN
                Y21 := TRUE; (* tool_lock *)
                step := 7;
            END_IF;

        7: (* Wait for target tool locked, return head *)
            IF X2B AND NOT X29 THEN
                Y22 := TRUE; (* tool_return *)
                step := 8;
            END_IF;

        8: (* Wait for head returned to origin and clear *)
            IF NOT X29 AND NOT X11 AND X13 AND NOT X2A THEN
                step := 10;
            END_IF;

        10: (* Return cradle to 0 deg before receiving workpiece *)
            IF X1A AND NOT X1B AND NOT X17 THEN
                Y15 := TRUE; (* rotate cradle back to 0 deg *)
                step := 11;
            ELSIF NOT X1A AND NOT X1B THEN
                step := 12;
            END_IF;

        11: (* Wait for cradle returned to 0 deg *)
            IF NOT X1A AND NOT X1B THEN
                step := 12;
            END_IF;

        12: (* Prepare A fixture width to match source workpiece *)
            D201 := target_width;
            IF NOT X28 THEN
                Y23 := TRUE; (* adjust_a *)
            ELSE
                step := 13;
            END_IF;

        13: (* Transfer workpiece from source to A fixture *)
            IF X28 AND X10 AND NOT X11 AND X13 THEN
                Y10 := TRUE; (* admit *)
                step := 14;
            END_IF;

        14: (* Wait for transfer to A to complete and head to clear *)
            IF X14 AND NOT X11 AND X13 AND NOT X12 THEN
                step := 15;
            END_IF;

        15: (* Request work_a when A fixture is ready *)
            IF X2C AND NOT X16 AND NOT X15 THEN
                Y11 := TRUE; (* work_a *)
                step := 16;
            ELSIF X15 THEN
                step := 17;
            END_IF;

        16: (* Wait for A-side operation to complete *)
            IF X15 AND NOT X16 THEN
                step := 17;
            END_IF;

        17: (* Transfer completed product from A to cradle *)
            IF NOT X11 AND NOT X1B AND NOT X17 THEN
                Y12 := TRUE; (* to_cradle *)
                step := 18;
            END_IF;

        18: (* Wait for cradle_present *)
            IF X17 AND NOT X11 THEN
                Y13 := TRUE; (* cradle_lock *)
                step := 19;
            END_IF;

        19: (* Secure vacuum on cradle bottom pad (0.25 s) *)
            IF X18 THEN
                timer_in := TRUE;
                timer_pt := T#260ms;
                IF ton_timer.Q THEN
                    timer_in := FALSE;
                    Y14 := TRUE; (* head_release *)
                    step := 20;
                END_IF;
            ELSE
                timer_in := FALSE;
            END_IF;

        20: (* Wait for head release and upward retreat *)
            IF NOT X12 AND X13 AND NOT X11 THEN
                Y15 := TRUE; (* rotate cradle *)
                step := 21;
            END_IF;

        21: (* Wait for cradle inversion to finish *)
            IF X1A AND NOT X1B THEN
                Y16 := TRUE; (* head_grip opposing corner fingers *)
                step := 22;
            END_IF;

        22: (* Wait for corner grip established *)
            IF X12 AND NOT X11 THEN
                Y17 := TRUE; (* cradle_unlock *)
                step := 23;
            END_IF;

        23: (* Wait for cradle unlocked and cleared *)
            IF NOT X18 AND X19 THEN
                step := 24;
            END_IF;

        24: (* Prepare B fixture width before transfer *)
            D202 := target_width;
            IF NOT X1C THEN
                Y24 := TRUE; (* adjust_b level *)
                timer_in := TRUE;
                timer_pt := T#100ms;
                IF ton_timer.Q THEN
                    timer_in := FALSE;
                    step := 25;
                END_IF;
            ELSE
                step := 25;
            END_IF;

        25: (* Transfer product to B jig *)
            IF X19 AND NOT X11 AND NOT X1C THEN
                Y18 := TRUE; (* to_b *)
                step := 26;
            END_IF;

        26: (* Wait for B arrival, upper support closes 300 ms after arrival *)
            IF X1C THEN
                timer_in := TRUE;
                timer_pt := T#310ms;
                IF ton_timer.Q THEN
                    timer_in := FALSE;
                    Y14 := TRUE; (* head_release after contact *)
                    step := 27;
                END_IF;
            ELSE
                timer_in := FALSE;
            END_IF;

        27: (* Wait for head vacated from B *)
            IF NOT X12 AND X13 AND NOT X11 AND X27 THEN
                step := 28;
            END_IF;

        28: (* Close Z corner clamp on B (300 ms) *)
            Y1D := TRUE; (* b_clamp *)
            IF X23 THEN
                step := 29;
            END_IF;

        29: (* Retract upper support sideways 80 mm *)
            Y1D := TRUE; (* retain clamp *)
            Y1E := TRUE; (* b_keeper_open *)
            IF X25 THEN
                step := 30;
            END_IF;

        30: (* Verify all conditions and start work_b *)
            Y1D := TRUE; (* retain clamp *)
            Y1E := TRUE; (* retain keeper open *)
            IF X2D AND X22 AND X26 AND NOT X1E AND NOT X1D THEN
                Y19 := TRUE; (* work_b *)
                step := 31;
            ELSIF X1D THEN
                step := 32;
            END_IF;

        31: (* Wait for B-side operation completion *)
            Y1D := TRUE; (* retain clamp *)
            Y1E := TRUE; (* retain keeper open *)
            IF X1D AND NOT X1E THEN
                step := 32;
            END_IF;

        32: (* Open clamp before release *)
            Y1E := TRUE; (* retain keeper open *)
            IF X24 THEN
                step := 33;
            END_IF;

        33: (* Release product to exit *)
            IF X1F AND NOT X11 THEN
                Y1A := TRUE; (* release *)
                step := 34;
            END_IF;

        34: (* Acknowledge exit receipt *)
            IF X20 THEN
                Y1B := TRUE; (* ack_exit *)
                step := 35;
            END_IF;

        35: (* Wait for exit cleared, product cycle complete *)
            IF NOT X20 THEN
                products_completed := products_completed + 1;
                step := 1; (* Next product *)
            ELSE
                Y1B := TRUE;
            END_IF;

        90: (* All products finished, maintain complete *)
            complete_latched := TRUE;
    END_CASE;
END_IF;

(* Timer instance update *)
ton_timer(IN := timer_in, PT := timer_pt);

(* Maintain complete output for at least 0.5 s *)
complete_timer(IN := complete_latched, PT := T#500ms);
IF complete_latched THEN
    Y1C := TRUE;
END_IF;

END_PROGRAM
```