An IEC 61131-3 Structured Text control program for the MAT-H15 specification.

```iec61131-3
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
    D5 : INT;
    D6 : INT;
    D7 : INT;
    D8 : INT;
    D9 : INT;
    D10 : INT;
    D11 : INT;
    D12 : INT;
    D13 : INT;
    D14 : INT;
    D15 : INT;
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
    X2A : BOOL;
    X2B : BOOL;
    X2C : BOOL;
    Y1A : BOOL;
    Y1B : BOOL;
    Y1C : BOOL;
    Y1D : BOOL;
    Y1E : BOOL;
    Y1F : BOOL;

    (* Internal state machines and variables *)
    head_step : INT := 0;
    fork_mode : INT := 0; (* 0: idle, 1: pallet transport, 2: bundle ship *)
    pallet_step : INT := 0;
    bundle_step : INT := 0;

    target_pallet_side : INT := 0;
    target_bundle_side : INT := 0;

    a_bundle_shipped : BOOL := FALSE;
    b_bundle_shipped : BOOL := FALSE;

    a_pallet_requested : BOOL := FALSE;
    b_pallet_requested : BOOL := FALSE;

    dest_station : INT := 0;

    complete_timer : TON;
    complete_started : BOOL := FALSE;
END_VAR

// Reset one-scan command pulses
Y10 := FALSE;
Y11 := FALSE;
Y12 := FALSE;
Y13 := FALSE;
Y14 := FALSE;
Y15 := FALSE;
Y16 := FALSE;
Y17 := FALSE;
Y18 := FALSE;
Y19 := FALSE;
Y1C := FALSE;
Y1D := FALSE;
Y1E := FALSE;
Y1F := FALSE;

// Keep support targets at base position 850 mm by default
D203 := 850;
D204 := 850;

// Order acceptance logic
IF X0 THEN
    IF X1B AND NOT X1D THEN
        Y10 := TRUE;
    END_IF;
    IF X1C AND NOT X1E THEN
        Y11 := TRUE;
    END_IF;
END_IF;

// Shared Fork Arbitration and State Machine
// fork_mode: 0=IDLE, 1=PALLET TRANSFER, 2=BUNDLE SHIPMENT
CASE fork_mode OF
    0: // Idle
        IF NOT X14 AND X18 THEN
            // Pallet transfer priority if a station is active, empty, and has available pallet
            IF X27 AND NOT X28 AND NOT a_pallet_requested AND (X1D OR X1B) THEN
                target_pallet_side := 1;
                a_pallet_requested := TRUE;
                fork_mode := 1;
                pallet_step := 1;
            ELSIF X27 AND NOT X29 AND NOT b_pallet_requested AND (X1E OR X1C) THEN
                target_pallet_side := 2;
                b_pallet_requested := TRUE;
                fork_mode := 1;
                pallet_step := 1;
            // Bundle shipment when a bundle is complete and head is not busy with it
            ELSIF NOT X12 AND (X1F OR D11 = 3) AND NOT a_bundle_shipped THEN
                target_bundle_side := 1;
                fork_mode := 2;
                bundle_step := 1;
            ELSIF NOT X12 AND (X20 OR D12 = 4) AND NOT b_bundle_shipped THEN
                target_bundle_side := 2;
                fork_mode := 2;
                bundle_step := 1;
            END_IF;
        END_IF;

    1: // Empty-Pallet Transport
        CASE pallet_step OF
            1: // Pick pallet from supply
                IF X27 THEN
                    Y1C := TRUE;
                    pallet_step := 2;
                END_IF;

            2: // Wait for fork inserted under pallet
                IF X2A THEN
                    Y1D := TRUE; // pallet_lift
                    pallet_step := 3;
                END_IF;

            3: // Wait for pallet supported
                IF X2B THEN
                    D201 := target_pallet_side;
                    Y1E := TRUE; // pallet_transfer to station
                    pallet_step := 4;
                END_IF;

            4: // Wait until empty pallet reaches station
                IF X2C THEN
                    Y1F := TRUE; // pallet_release
                    pallet_step := 5;
                END_IF;

            5: // Wait for fork to return home and station to confirm pallet seated
                IF X18 AND NOT X14 THEN
                    IF (target_pallet_side = 1 AND X28) OR (target_pallet_side = 2 AND X29) THEN
                        fork_mode := 0;
                        pallet_step := 0;
                    END_IF;
                END_IF;
        END_CASE;

    2: // Completed-Bundle Shipment
        CASE bundle_step OF
            1: // Ensure station support is at 850 mm before insertion
                IF target_bundle_side = 1 THEN
                    D203 := 850;
                    IF NOT X21 THEN
                        Y14 := TRUE;
                    ELSE
                        D201 := 1;
                        Y16 := TRUE; // fork_insert
                        bundle_step := 2;
                    END_IF;
                ELSE
                    D204 := 850;
                    IF NOT X22 THEN
                        Y15 := TRUE;
                    ELSE
                        D201 := 2;
                        Y16 := TRUE; // fork_insert
                        bundle_step := 2;
                    END_IF;
                END_IF;

            2: // Wait for fork inserted
                IF X15 THEN
                    Y17 := TRUE; // fork_lift to 870 mm
                    bundle_step := 3;
                END_IF;

            3: // Wait for fork supporting, then command original support down to 780 mm
                IF X16 THEN
                    IF target_bundle_side = 1 THEN
                        D203 := 780;
                        Y14 := TRUE;
                        IF X23 THEN
                            bundle_step := 4;
                        END_IF;
                    ELSE
                        D204 := 780;
                        Y15 := TRUE;
                        IF X24 THEN
                            bundle_step := 4;
                        END_IF;
                    END_IF;
                END_IF;

            4: // Move fork to exit
                Y18 := TRUE; // fork_transfer
                bundle_step := 5;

            5: // Wait until fork arrives at exit
                IF X17 THEN
                    Y19 := TRUE; // fork_release
                    bundle_step := 6;
                END_IF;

            6: // Restore lifting platform to 850 mm
                IF target_bundle_side = 1 THEN
                    D203 := 850;
                    Y14 := TRUE;
                    IF X21 THEN
                        bundle_step := 7;
                    END_IF;
                ELSE
                    D204 := 850;
                    Y15 := TRUE;
                    IF X22 THEN
                        bundle_step := 7;
                    END_IF;
                END_IF;

            7: // Wait for fork to return home
                IF X18 AND NOT X14 THEN
                    IF target_bundle_side = 1 THEN
                        a_bundle_shipped := TRUE;
                    ELSE
                        b_bundle_shipped := TRUE;
                    END_IF;
                    fork_mode := 0;
                    bundle_step := 0;
                END_IF;
        END_CASE;
END_CASE;

// External exit receipt acknowledge
IF X19 THEN
    Y1A := TRUE;
ELSE
    Y1A := FALSE;
END_IF;

// Head Pick & Place State Machine
CASE head_step OF
    0: // Idle - select next plate to pick
        IF NOT X12 AND NOT X13 THEN
            // Check if station A needs a plate and is ready
            IF X1D AND X28 AND X25 AND NOT X1F AND D11 < 3 THEN
                IF D7 = 1 AND X10 THEN // R sheet needed and ready
                    D200 := 1;
                    Y12 := TRUE;
                    dest_station := 1;
                    head_step := 1;
                ELSIF D7 = 2 AND X11 THEN // B sheet needed and ready
                    D200 := 2;
                    Y12 := TRUE;
                    dest_station := 1;
                    head_step := 1;
                END_IF;
            END_IF;

            // Check if station B needs a plate and is ready (if A not scheduled this scan)
            IF head_step = 0 AND X1E AND X29 AND X26 AND NOT X20 AND D12 < 4 THEN
                IF D8 = 1 AND X10 THEN // R sheet needed and ready
                    D200 := 1;
                    Y12 := TRUE;
                    dest_station := 2;
                    head_step := 1;
                ELSIF D8 = 2 AND X11 THEN // B sheet needed and ready
                    D200 := 2;
                    Y12 := TRUE;
                    dest_station := 2;
                    head_step := 1;
                END_IF;
            END_IF;
        END_IF;

    1: // Wait for pick completion
        IF NOT X12 AND X13 THEN
            head_step := 2;
        END_IF;

    2: // Place plate onto designated station
        IF NOT X12 THEN
            IF dest_station = 1 AND X25 THEN
                D201 := 1;
                D202 := D9; // Seat at measured top surface of A
                Y13 := TRUE;
                head_step := 3;
            ELSIF dest_station = 2 AND X26 THEN
                D201 := 2;
                D202 := D10; // Seat at measured top surface of B
                Y13 := TRUE;
                head_step := 3;
            END_IF;
        END_IF;

    3: // Wait for place completion
        IF NOT X12 AND NOT X13 THEN
            head_step := 0;
        END_IF;
END_CASE;

// Completion detection and hold logic
IF a_bundle_shipped AND b_bundle_shipped AND
   X18 AND NOT X14 AND
   NOT X12 AND NOT X13 AND
   fork_mode = 0 AND head_step = 0 AND
   X21 AND X22 AND NOT X19 THEN
    complete_started := TRUE;
END_IF;

complete_timer(IN := complete_started, PT := T#500ms);
IF complete_timer.Q THEN
    Y1B := TRUE;
ELSE
    Y1B := FALSE;
END_IF;

END_PROGRAM
```