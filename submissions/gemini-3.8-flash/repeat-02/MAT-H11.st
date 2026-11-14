### Method Overview

The controller operates as a supervisory state machine executing the required sequence across all 4 products. It executes a safe serial schedule per the specification ("Safe serial, interleaved and fixed-priority schedules are allowed whenever all task-specific requirements are satisfied").

Key operational phases per workpiece:
1. **Tool Management**: Verify current `D8` (`tool_id`) against `target_type` (derived from `D10` / product sequence). If a tool exchange is needed:
   - If a tool is held (`D8 <> 0`), set `D200 := D8`, pulse `tool_dock` until `X2A` (`tool_at_rack`), pulse `tool_unlock` until tool is unlatched (`NOT X2B`), pulse `tool_return` to vacate the head.
   - Set `D200 := target_type`, pulse `tool_dock` until `X2A`, pulse `tool_lock` until latched (`X2B`), pulse `tool_return` to return the head to safe height.
2. **Fixture A Width Adjustment & Admission**:
   - Drive `D201` (`a_width`) to the product width (160 mm for type 1, 120 mm for type 2) and assert `Y23` (`adjust_a`) until `X28` (`source_fixture_ready`) is TRUE.
   - When `X10` (`source_ready`), pulse `Y10` (`admit`) to transfer the leading product to Jig A.
3. **Face A Operation**:
   - Wait until `X14` (`a_present`), `X13` (`head_clear`), and `X2C` (`a_fixture_ready`).
   - Request `Y11` (`work_a`) and wait for `X15` (`a_done`).
4. **Transfer to Inversion Cradle**:
   - Ensure cradle is at 0° (`NOT X1A`). If flipped, rotate empty cradle back (`Y15`).
   - Pulse `Y12` (`to_cradle`) to hand off to cradle with head holding corner.
   - Pulse `Y13` (`cradle_lock`) to secure vacuum (wait for `X18`).
   - Pulse `Y14` (`head_release`) to release corner grip, then wait for `X13` (`head_clear`).
   - Pulse `Y15` (`rotate`) to invert cradle 0° $\rightarrow$ 180° (wait for `X1A`).
   - Pulse `Y16` (`head_grip`) to secure corner fingers on product ends.
   - Pulse `Y17` (`cradle_unlock`) to retract pad 60 mm (wait for `NOT X18` and `X19` `cradle_clear`).
5. **Transfer to Fixture B & Clamping**:
   - Prepare B fixture width via `D202` (`b_width`) and `Y24` (`adjust_b`) until set.
   - Pulse `Y18` (`to_b`) to transfer product to B jig.
   - Once seated and transfer head clears (`X27`), close corner clamp with `Y1D` (`b_clamp`) until `X23` (`b_clamped`), open upper support with `Y1E` (`b_keeper_open`) until `X25` (`b_keeper_clear`).
6. **Face B Operation**:
   - Verify conditions: `X1C` (`b_present`), `D5 = 2` (exposed face B), `X22` (`b_request_ready`), `X26` (`b_face_clear`), `X2D` (`b_fixture_ready`).
   - Assert `Y19` (`work_b`) until `X1D` (`b_done`).
7. **Release and Exit Handshake**:
   - Retract corner clamp (`b_clamp := FALSE`) and reset upper keeper (`b_keeper_open := FALSE`).
   - Pulse `Y1A` (`release`) to hand over to exit.
   - Upon `X20` (`exit_received`), assert `Y1B` (`ack_exit`) until `X1F` (`exit_clear`).
   - Increment completed product count. Return cradle to 0° if more products remain.
8. **Completion**:
   - When all 4 products are finished (`prod_count = 4`), assert `Y1C` (`complete`) and maintain for $\ge 500\text{ ms}$.

```pascal
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

    step : INT := 0;
    prod_count : INT := 0;
    target_type : INT := 1;
    target_w : INT := 160;

    t_delay : TON;
    t_pulse : TON;
    t_comp : TON;

    pulse_active : BOOL := FALSE;
    pulse_done : BOOL := FALSE;
END_VAR

IF NOT X0 AND step = 0 THEN
    RETURN;
END_IF;

CASE step OF
    0:
        IF X0 THEN
            prod_count := 0;
            step := 10;
        END_IF;

    (* Step 10: Determine required tool and fixture dimensions *)
    10:
        IF prod_count >= 4 THEN
            step := 900;
        ELSE
            IF D10 > 0 THEN
                target_type := D10;
            ELSE
                IF (prod_count MOD 2) = 0 THEN
                    target_type := 1;
                ELSE
                    target_type := 2;
                END_IF;
            END_IF;

            IF target_type = 1 THEN
                target_w := 160;
            ELSE
                target_w := 120;
            END_IF;

            D201 := target_w;
            D202 := target_w;
            step := 20;
        END_IF;

    (* Step 20: Tool verification and exchange *)
    20:
        IF NOT X11 AND NOT X29 THEN
            IF D8 = target_type THEN
                step := 100;
            ELSIF D8 <> 0 THEN
                D200 := D8;
                Y1F := TRUE;
                step := 30;
            ELSE
                D200 := target_type;
                Y1F := TRUE;
                step := 50;
            END_IF;
        END_IF;

    (* Step 30: Dock current tool to rack *)
    30:
        IF X2A AND NOT X29 THEN
            Y1F := FALSE;
            Y20 := TRUE;
            step := 40;
        END_IF;

    (* Step 40: Unlock and return head from rack *)
    40:
        IF NOT X2B AND NOT X29 THEN
            Y20 := FALSE;
            Y22 := TRUE;
            step := 45;
        END_IF;

    45:
        IF NOT X2A AND NOT X29 THEN
            Y22 := FALSE;
            step := 20;
        END_IF;

    (* Step 50: Dock empty head to new tool slot *)
    50:
        IF X2A AND NOT X29 THEN
            Y1F := FALSE;
            Y21 := TRUE;
            step := 60;
        END_IF;

    (* Step 60: Lock new tool and return to origin *)
    60:
        IF X2B AND NOT X29 THEN
            Y21 := FALSE;
            Y22 := TRUE;
            step := 70;
        END_IF;

    70:
        IF NOT X2A AND NOT X29 THEN
            Y22 := FALSE;
            step := 100;
        END_IF;

    (* Step 100: Ensure cradle is at 0 degrees *)
    100:
        IF X1A AND NOT X1B THEN
            Y15 := TRUE;
            step := 105;
        ELSE
            step := 110;
        END_IF;

    105:
        IF NOT X1A AND NOT X1B THEN
            Y15 := FALSE;
            step := 110;
        END_IF;

    (* Step 110: Adjust A fixture width *)
    110:
        D201 := target_w;
        IF X28 THEN
            Y23 := FALSE;
            step := 120;
        ELSE
            Y23 := TRUE;
        END_IF;

    (* Step 120: Admit workpiece to Jig A *)
    120:
        IF X10 AND NOT X11 THEN
            Y10 := TRUE;
            step := 130;
        END_IF;

    130:
        IF X11 OR X14 THEN
            Y10 := FALSE;
            step := 140;
        END_IF;

    (* Step 140: Work A on Jig A *)
    140:
        IF X14 AND X13 AND X2C AND NOT X11 THEN
            Y11 := TRUE;
            step := 150;
        END_IF;

    150:
        IF X15 THEN
            Y11 := FALSE;
            step := 200;
        END_IF;

    (* Step 200: Transfer from Jig A to Inversion Cradle *)
    200:
        IF NOT X11 AND NOT X1B THEN
            Y12 := TRUE;
            step := 210;
        END_IF;

    210:
        IF X17 THEN
            Y12 := FALSE;
            Y13 := TRUE;
            step := 220;
        END_IF;

    (* Step 220: Secure vacuum pad on cradle *)
    220:
        IF X18 THEN
            Y13 := FALSE;
            Y14 := TRUE;
            step := 230;
        END_IF;

    (* Step 230: Head release and clear before rotation *)
    230:
        IF X13 AND NOT X12 THEN
            Y14 := FALSE;
            Y15 := TRUE;
            step := 240;
        END_IF;

    (* Step 240: Invert cradle 0 -> 180 *)
    240:
        IF X1A AND NOT X1B THEN
            Y15 := FALSE;
            Y16 := TRUE;
            step := 250;
        END_IF;

    (* Step 250: Grip opposing corners with head *)
    250:
        IF X12 AND NOT X11 THEN
            Y16 := FALSE;
            Y17 := TRUE;
            step := 260;
        END_IF;

    (* Step 260: Retract cradle vacuum pad *)
    260:
        IF X19 AND NOT X18 THEN
            Y17 := FALSE;
            step := 300;
        END_IF;

    (* Step 300: Adjust B fixture width *)
    300:
        D202 := target_w;
        Y24 := TRUE;
        step := 310;

    310:
        IF NOT X11 THEN
            Y24 := FALSE;
            Y18 := TRUE;
            step := 320;
        END_IF;

    (* Step 320: Transfer to B jig *)
    320:
        IF X1C AND X27 THEN
            Y18 := FALSE;
            Y1D := TRUE;
            step := 330;
        END_IF;

    (* Step 330: Clamp B corner and open upper keeper *)
    330:
        IF X23 THEN
            Y1E := TRUE;
            step := 340;
        END_IF;

    340:
        IF X25 THEN
            step := 400;
        END_IF;

    (* Step 400: Execute Work B *)
    400:
        IF X1C AND X22 AND X26 AND X2D AND (D5 = 2) AND NOT X1E THEN
            Y19 := TRUE;
            step := 410;
        END_IF;

    410:
        IF X1D THEN
            Y19 := FALSE;
            Y1D := FALSE;
            Y1E := FALSE;
            step := 500;
        END_IF;

    (* Step 500: Release from Jig B to exit *)
    500:
        IF X24 AND NOT X11 THEN
            Y1A := TRUE;
            step := 510;
        END_IF;

    510:
        IF X20 THEN
            Y1A := FALSE;
            Y1B := TRUE;
            step := 520;
        END_IF;

    (* Step 520: Acknowledge exit reception *)
    520:
        IF X1F THEN
            Y1B := FALSE;
            prod_count := prod_count + 1;
            step := 10;
        END_IF;

    (* Step 900: Completion hold *)
    900:
        Y1C := TRUE;
END_CASE;

t_comp(IN := Y1C, PT := T#550ms);

END_PROGRAM
```