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
    D200 : INT;
    X1A : BOOL;
    X1B : BOOL;
    X1C : BOOL;
    X1D : BOOL;
    X1E : BOOL;
    X1F : BOOL;
    Y1A : BOOL;
    Y1B : BOOL;
    Y1C : BOOL;
    Y1D : BOOL;
    Y1E : BOOL;

    prev_accept_p : BOOL;
    prev_pouch_ready : BOOL;
    prev_exit_received : BOOL;
    prev_content_ready : BOOL;
    prev_sheet_single : BOOL;
    prev_double_sheet : BOOL;

    content_sel : INT;
    ack_count : INT;

    sep_done_flag : BOOL;
    sep_start_flag : BOOL;
    sep_count : INT;
    need_sep : BOOL;

    accept_p : BOOL;
    accept_c : BOOL;
    prev_accept_c : BOOL;
    vac_left : BOOL;
    vac_right : BOOL;
    open_p : BOOL;
    insert_p : BOOL;
    retract_p : BOOL;
    release_p : BOOL;
    ack_exit_p : BOOL;
    comp_p : BOOL;
    sep_hold_p : BOOL;
    sep_separate_p : BOOL;
    align_side_p : BOOL;
    align_front_p : BOOL;

    comp_timer : TON;

    state : INT := 0;
END_VAR

prev_accept_p := accept_p;
prev_pouch_ready := pouch_ready;
prev_exit_received := exit_received;
prev_content_ready := content_ready;
prev_sheet_single := sheet_single;
prev_double_sheet := double_sheet;

CASE state OF
    0:
        IF X0 THEN
            state := 1;
        END_IF;

    1:
        IF available_mask > 0 THEN
            IF DINT(available_mask) AND DINT#1 > 0 THEN
                content_sel := 1;
            ELSIF DINT(available_mask) AND DINT#2 > 0 THEN
                content_sel := 2;
            ELSIF DINT(available_mask) AND DINT#4 > 0 THEN
                content_sel := 3;
            ELSIF DINT(available_mask) AND DINT#8 > 0 THEN
                content_sel := 4;
            END_IF;

            accept_c := TRUE;
            state := 2;
        END_IF;

    2:
        IF accept_c AND NOT prev_accept_c AND content_ready THEN
            accept_c := FALSE;
            state := 3;
        END_IF;

    3:
        align_side_p := TRUE;
        align_front_p := TRUE;

        IF content_aligned THEN
            align_side_p := FALSE;
            align_front_p := FALSE;
            state := 4;
        END_IF;

    4:
        sep_done_flag := FALSE;

        IF need_sep AND NOT sep_done_flag AND NOT accept_p THEN
            IF double_sheet AND NOT prev_double_sheet AND NOT separator_busy THEN
                sep_hold_p := TRUE;
                sep_separate_p := TRUE;
                sep_start_flag := TRUE;
            END_IF;
        END_IF;

        IF sep_start_flag THEN
            IF sheet_single AND NOT separator_busy AND sep_hold_p THEN
                sep_hold_p := FALSE;
                sep_separate_p := FALSE;
                sep_start_flag := FALSE;
                sep_done_flag := TRUE;
                sep_count := sep_count + 1;
            END_IF;
        END_IF;

        need_sep := (sep_count < 2);

        IF NOT need_sep OR sep_done_flag THEN
            state := 5;
        END_IF;

    5:
        accept_p := FALSE;

        IF pouch_ready AND NOT prev_pouch_ready THEN
            accept_p := TRUE;
            state := 6;
        END_IF;

    6:
        vac_left := TRUE;
        vac_right := TRUE;
        open_p := TRUE;

        IF aperture_open THEN
            open_p := FALSE;
            state := 7;
        END_IF;

    7:
        IF pouch_docked THEN
            vac_left := FALSE;
            vac_right := FALSE;
            state := 8;
        END_IF;

    8:
        IF align_tools_clear THEN
            state := 9;
        END_IF;

    9:
        IF content_ready AND content_aligned AND align_tools_clear AND aperture_open THEN
            insert_p := TRUE;
            state := 10;
        END_IF;

    10:
        IF contained THEN
            insert_p := FALSE;
            retract_p := TRUE;
            state := 11;
        END_IF;

    11:
        IF insert_home THEN
            retract_p := FALSE;
            state := 12;
        END_IF;

    12:
        IF contained THEN
            release_p := TRUE;
            state := 13;
        END_IF;

    13:
        IF exit_clear THEN
            release_p := FALSE;
            state := 14;
        END_IF;

    14:
        ack_exit_p := TRUE;

        IF exit_received AND NOT prev_exit_received THEN
            ack_exit_p := FALSE;
            ack_count := ack_count + 1;

            need_sep := (ack_count < 2);
            sep_done_flag := FALSE;

            IF need_sep THEN
                state := 1;
            ELSE
                state := 15;
            END_IF;
        END_IF;

    15:
        IF ack_count >= 4 THEN
            IF NOT separator_busy AND insert_home THEN
                comp_p := TRUE;
                comp_timer(IN := TRUE, PT := T#500ms);

                IF comp_timer.Q THEN
                    state := 16;
                END_IF;
            END_IF;
        ELSE
            state := 1;
        END_IF;

    16:
        comp_p := FALSE;

END_CASE;

accept_pouch := accept_p;
accept_content := accept_c;
vacuum_left := vac_left;
vacuum_right := vac_right;
open := open_p;
transfer_pouch := FALSE;
insert := insert_p;
retract := retract_p;
release := release_p;
ack_exit := ack_exit_p;
complete := comp_p;
separator_hold := sep_hold_p;
separate := sep_separate_p;
align_side := align_side_p;
align_front := align_front_p;
content_select := content_sel;

END_PROGRAM