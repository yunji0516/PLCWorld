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
    X33 : BOOL;
    X34 : BOOL;
    X35 : BOOL;
    X36 : BOOL;
    X37 : BOOL;
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
    D100 : INT;
    D101 : INT;
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
    step : INT;
    current_kind : INT;
    a_finished : INT;
    b_finished : INT;
    delivered_count : INT;
    current_token : INT;
    dest_target : INT;
    accepted_before : INT;
    good_part : BOOL;
    reject_used_0 : BOOL;
    reject_used_1 : BOOL;
    reject_used_2 : BOOL;
    reject_used_3 : BOOL;
    move_ready : BOOL;
    accepted_now : BOOL;
    at_destination : BOOL;
    pocket_occupied : BOOL;
END_VAR

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
Y1A := FALSE;
Y1B := FALSE;
Y1C := FALSE;
Y1D := FALSE;
Y1E := FALSE;

move_ready := (NOT X10) AND (D1 = D101);
accepted_now := FALSE;
at_destination := FALSE;
pocket_occupied := FALSE;

CASE step OF
0:
    D100 := 0;
    IF X0 THEN
        a_finished := 0;
        b_finished := 0;
        delivered_count := 0;
        current_kind := 0;
        current_token := 0;
        dest_target := 0;
        accepted_before := D6;
        good_part := FALSE;
        reject_used_0 := FALSE;
        reject_used_1 := FALSE;
        reject_used_2 := FALSE;
        reject_used_3 := FALSE;
        step := 5;
    END_IF;

5:
    IF (a_finished >= 2) AND (b_finished >= 2) AND (delivered_count >= 4) THEN
        step := 800;
    ELSIF a_finished < 2 THEN
        current_kind := 1;
        step := 10;
    ELSE
        current_kind := 2;
        step := 10;
    END_IF;

10:
    IF NOT X13 THEN
        IF NOT X11 THEN
            IF NOT X10 THEN
                Y11 := TRUE;
            END_IF;
        ELSE
            IF current_kind = 1 THEN
                IF move_ready AND (D7 <> 0) THEN
                    IF D0 = 1 THEN
                        step := 12;
                    ELSE
                        D100 := 1;
                        D101 := D101 + 1;
                        step := 11;
                    END_IF;
                END_IF;
            ELSE
                IF move_ready AND (D9 <> 0) THEN
                    IF D0 = 2 THEN
                        step := 12;
                    ELSE
                        D100 := 2;
                        D101 := D101 + 1;
                        step := 11;
                    END_IF;
                END_IF;
            END_IF;
        END_IF;
    END_IF;

11:
    IF move_ready THEN
        IF ((current_kind = 1) AND (D0 = 1)) OR ((current_kind = 2) AND (D0 = 2)) THEN
            step := 12;
        END_IF;
    END_IF;

12:
    IF NOT X10 THEN
        IF NOT X13 THEN
            Y10 := TRUE;
        ELSIF X12 THEN
            current_token := D2;
            step := 13;
        END_IF;
    END_IF;

13:
    IF current_kind = 1 THEN
        IF X13 AND X21 AND X23 AND X26 AND X1E AND (NOT X20) THEN
            IF move_ready THEN
                IF D0 = 3 THEN
                    step := 15;
                ELSE
                    D100 := 3;
                    D101 := D101 + 1;
                    step := 14;
                END_IF;
            END_IF;
        END_IF;
    ELSE
        IF X13 AND X2C AND X2E AND X31 AND X29 AND (NOT X2B) THEN
            IF move_ready THEN
                IF D0 = 4 THEN
                    step := 15;
                ELSE
                    D100 := 4;
                    D101 := D101 + 1;
                    step := 14;
                END_IF;
            END_IF;
        END_IF;
    END_IF;

14:
    IF move_ready THEN
        IF ((current_kind = 1) AND (D0 = 3)) OR ((current_kind = 2) AND (D0 = 4)) THEN
            step := 15;
        END_IF;
    END_IF;

15:
    IF NOT X10 THEN
        IF X13 THEN
            Y11 := TRUE;
        ELSE
            IF X11 THEN
                IF ((current_kind = 1) AND X27) OR ((current_kind = 2) AND X32) THEN
                    step := 16;
                ELSE
                    Y11 := TRUE;
                END_IF;
            END_IF;
        END_IF;
    END_IF;

16:
    IF move_ready THEN
        IF D0 = 0 THEN
            step := 17;
        ELSE
            D100 := 0;
            D101 := D101 + 1;
            step := 160;
        END_IF;
    END_IF;

160:
    IF move_ready AND (D0 = 0) THEN
        step := 17;
    END_IF;

17:
    IF current_kind = 1 THEN
        IF X25 AND (D0 <> 3) AND (NOT X20) THEN
            IF NOT X24 THEN
                Y17 := TRUE;
            END_IF;
            IF X24 AND (NOT X22) THEN
                Y16 := TRUE;
            END_IF;
            IF X24 AND X22 AND X27 AND X1D THEN
                step := 18;
            END_IF;
        END_IF;
    ELSE
        IF X30 AND (D0 <> 4) AND (NOT X2B) THEN
            IF NOT X2F THEN
                Y1C := TRUE;
            END_IF;
            IF X2F AND (NOT X2D) THEN
                Y1B := TRUE;
            END_IF;
            IF X2F AND X2D AND X32 AND X28 THEN
                step := 18;
            END_IF;
        END_IF;
    END_IF;

18:
    IF current_kind = 1 THEN
        IF X27 AND (NOT X20) AND X22 AND X24 AND X25 THEN
            Y17 := TRUE;
            Y19 := TRUE;
            step := 19;
        END_IF;
    ELSE
        IF X32 AND (NOT X2B) AND X2D AND X2F AND X30 THEN
            Y1C := TRUE;
            Y1E := TRUE;
            step := 19;
        END_IF;
    END_IF;

19:
    IF current_kind = 1 THEN
        Y17 := TRUE;
        IF (NOT X20) AND X1F AND X27 THEN
            step := 20;
        END_IF;
    ELSE
        Y1C := TRUE;
        IF (NOT X2B) AND X2A AND X32 THEN
            step := 20;
        END_IF;
    END_IF;

20:
    IF current_kind = 1 THEN
        IF NOT X20 THEN
            IF NOT X21 THEN
                Y15 := TRUE;
            END_IF;
            IF X21 AND (NOT X23) THEN
                Y18 := TRUE;
            END_IF;
            IF X21 AND X23 AND X26 AND X1F AND X27 THEN
                step := 21;
            END_IF;
        END_IF;
    ELSE
        IF NOT X2B THEN
            IF NOT X2C THEN
                Y1A := TRUE;
            END_IF;
            IF X2C AND (NOT X2E) THEN
                Y1D := TRUE;
            END_IF;
            IF X2C AND X2E AND X31 AND X2A AND X32 THEN
                step := 21;
            END_IF;
        END_IF;
    END_IF;

21:
    IF current_kind = 1 THEN
        IF X21 AND X23 AND X26 AND X1F AND X27 THEN
            IF move_ready THEN
                IF D0 = 3 THEN
                    step := 23;
                ELSE
                    D100 := 3;
                    D101 := D101 + 1;
                    step := 22;
                END_IF;
            END_IF;
        END_IF;
    ELSE
        IF X2C AND X2E AND X31 AND X2A AND X32 THEN
            IF move_ready THEN
                IF D0 = 4 THEN
                    step := 23;
                ELSE
                    D100 := 4;
                    D101 := D101 + 1;
                    step := 22;
                END_IF;
            END_IF;
        END_IF;
    END_IF;

22:
    IF move_ready THEN
        IF ((current_kind = 1) AND (D0 = 3)) OR ((current_kind = 2) AND (D0 = 4)) THEN
            step := 23;
        END_IF;
    END_IF;

23:
    IF NOT X10 THEN
        IF NOT X13 THEN
            Y10 := TRUE;
        ELSIF X12 THEN
            current_token := D2;
            step := 24;
        END_IF;
    END_IF;

24:
    IF X13 AND (NOT X14) AND X1C AND (NOT X15) THEN
        IF move_ready THEN
            IF D0 = 5 THEN
                step := 26;
            ELSE
                D100 := 5;
                D101 := D101 + 1;
                step := 25;
            END_IF;
        END_IF;
    END_IF;

25:
    IF move_ready AND (D0 = 5) THEN
        step := 26;
    END_IF;

26:
    IF NOT X10 THEN
        IF X13 THEN
            Y11 := TRUE;
        ELSE
            IF X11 AND X14 THEN
                step := 27;
            ELSE
                Y11 := TRUE;
            END_IF;
        END_IF;
    END_IF;

27:
    IF move_ready THEN
        IF D0 = 0 THEN
            step := 28;
        ELSE
            D100 := 0;
            D101 := D101 + 1;
            step := 270;
        END_IF;
    END_IF;

270:
    IF move_ready AND (D0 = 0) THEN
        step := 28;
    END_IF;

28:
    IF X14 AND (NOT X15) AND X17 AND (D0 <> 5) AND (D11 = current_token) THEN
        Y12 := TRUE;
        step := 29;
    END_IF;

29:
    IF X16 AND (NOT X15) AND (D3 = current_token) AND (D11 = current_token) THEN
        good_part := (D4 >= 5800) AND (D4 <= 6200) AND (D5 >= 5800) AND (D5 <= 6200);
        step := 30;
    END_IF;

30:
    IF X14 AND (NOT X15) THEN
        IF move_ready THEN
            IF D0 = 5 THEN
                step := 32;
            ELSE
                D100 := 5;
                D101 := D101 + 1;
                step := 31;
            END_IF;
        END_IF;
    END_IF;

31:
    IF move_ready AND (D0 = 5) THEN
        step := 32;
    END_IF;

32:
    IF NOT X10 THEN
        IF NOT X13 THEN
            Y10 := TRUE;
        ELSIF X12 THEN
            current_token := D2;
            step := 33;
        END_IF;
    END_IF;

33:
    dest_target := 0;
    IF good_part THEN
        IF X1A THEN
            dest_target := 7;
        END_IF;
    ELSE
        IF (NOT X34) AND (NOT reject_used_0) THEN
            dest_target := 8;
        ELSIF (NOT X35) AND (NOT reject_used_1) THEN
            dest_target := 9;
        ELSIF (NOT X36) AND (NOT reject_used_2) THEN
            dest_target := 10;
        ELSIF (NOT X37) AND (NOT reject_used_3) THEN
            dest_target := 11;
        END_IF;
    END_IF;

    IF dest_target <> 0 THEN
        IF move_ready THEN
            IF good_part THEN
                accepted_before := D6;
            END_IF;
            IF D0 = dest_target THEN
                step := 35;
            ELSE
                D100 := dest_target;
                D101 := D101 + 1;
                step := 34;
            END_IF;
        END_IF;
    END_IF;

34:
    IF move_ready AND (D0 = dest_target) THEN
        step := 35;
    END_IF;

35:
    IF NOT X10 THEN
        IF X13 THEN
            Y11 := TRUE;
        ELSE
            IF X11 THEN
                IF good_part THEN
                    IF move_ready THEN
                        IF D0 = 0 THEN
                            step := 36;
                        ELSE
                            D100 := 0;
                            D101 := D101 + 1;
                            step := 36;
                        END_IF;
                    END_IF;
                ELSE
                    IF dest_target = 8 THEN
                        pocket_occupied := X34;
                    ELSIF dest_target = 9 THEN
                        pocket_occupied := X35;
                    ELSIF dest_target = 10 THEN
                        pocket_occupied := X36;
                    ELSIF dest_target = 11 THEN
                        pocket_occupied := X37;
                    ELSE
                        pocket_occupied := FALSE;
                    END_IF;

                    IF pocket_occupied THEN
                        IF dest_target = 8 THEN
                            reject_used_0 := TRUE;
                        ELSIF dest_target = 9 THEN
                            reject_used_1 := TRUE;
                        ELSIF dest_target = 10 THEN
                            reject_used_2 := TRUE;
                        ELSIF dest_target = 11 THEN
                            reject_used_3 := TRUE;
                        END_IF;

                        IF move_ready THEN
                            IF D0 = 0 THEN
                                step := 37;
                            ELSE
                                D100 := 0;
                                D101 := D101 + 1;
                                step := 37;
                            END_IF;
                        END_IF;
                    END_IF;
                END_IF;
            ELSE
                Y11 := TRUE;
            END_IF;
        END_IF;
    END_IF;

36:
    accepted_now := (D6 > accepted_before) OR X1B;
    IF NOT accepted_now THEN
        Y13 := TRUE;
    END_IF;

    IF accepted_now AND move_ready AND (D0 = 0) THEN
        IF current_kind = 1 THEN
            a_finished := a_finished + 1;
        ELSE
            b_finished := b_finished + 1;
        END_IF;
        delivered_count := delivered_count + 1;
        step := 5;
    END_IF;

37:
    IF move_ready AND (D0 = 0) THEN
        IF current_kind = 1 THEN
            a_finished := a_finished + 1;
        ELSE
            b_finished := b_finished + 1;
        END_IF;
        delivered_count := delivered_count + 1;
        step := 5;
    END_IF;

800:
    IF move_ready THEN
        IF D0 = 0 THEN
            step := 810;
        ELSE
            D100 := 0;
            D101 := D101 + 1;
            step := 805;
        END_IF;
    END_IF;

805:
    IF move_ready AND (D0 = 0) THEN
        step := 810;
    END_IF;

810:
    IF (NOT X13) AND X11 AND (NOT X10) AND (NOT X20) AND (NOT X2B) AND (NOT X15) AND X1B THEN
        step := 900;
    ELSE
        IF (NOT X13) AND (NOT X11) AND (NOT X10) THEN
            Y11 := TRUE;
        END_IF;
    END_IF;

900:
    Y14 := TRUE;

ELSE
    step := 0;
END_CASE;

END_PROGRAM