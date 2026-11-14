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
    D200 : INT;
    X1A : BOOL;
    X1B : BOOL;
    X1C : BOOL;
    X1D : BOOL;
    X1E : BOOL;
    X1F : BOOL;
    X2A : BOOL;
    Y1A : BOOL;
    Y1B : BOOL;
    Y1C : BOOL;
    Y1D : BOOL;
    Y1E : BOOL;
    Y1F : BOOL;

    (* Internal state *)
    step          : DINT := 0;
    rotate_return : DINT := 0;

    needs_insert     : BOOL := TRUE;
    output_ng_flag   : BOOL := FALSE;
    rotate_ok        : BOOL := FALSE;

    body_count      : INT := 0;
    good_count      : INT := 0;
    rework_count    : INT := 0;
    reinspect_count : INT := 0;
    gen             : INT := 1;

    clamp_timer   : TON;
    return_timer  : TON;
    complete_timer: TON;
END_VAR

(* ---- default all pulse-type outputs OFF each scan ---- *)
Y10 := FALSE;
Y11 := FALSE;
Y12 := FALSE;
Y13 := FALSE;
Y14 := FALSE;
Y15 := FALSE;
Y16 := FALSE;
Y18 := FALSE;
Y19 := FALSE;
Y1B := FALSE;
Y1D := FALSE;
Y1E := FALSE;
Y1F := FALSE;
(* Y17, Y1C, Y1A are level outputs, managed explicitly *)

rotate_ok := X1B AND X2A AND (NOT X14) AND (NOT X15) AND (NOT X16) AND (NOT X17) AND (NOT X25) AND (NOT X18);

CASE step OF

(* ---------------- INIT ---------------- *)
0:
    Y17 := TRUE;
    D200 := gen;
    step := 5;

5:
    if X19 then
        step := 6;
    end_if;

6:
    if X0 then
        step := 100;
    end_if;

(* ---------------- LOAD BODY ---------------- *)
100:
    Y17 := TRUE;
    if X19 then
        step := 110;
    end_if;

110:
    if X10 and (not X14) then
        step := 111;
    end_if;

111:
    Y10 := TRUE;
    step := 112;

112:
    if X14 then
        step := 113;
    end_if;

113:
    if not X14 then
        step := 120;
    end_if;

(* ---------------- PREPARE INSERT SLOT ---------------- *)
120:
    if X12 then
        step := 121;
    end_if;

121:
    Y11 := TRUE;
    step := 122;

122:
    if X13 then
        step := 150;
    end_if;

(* ---------------- ROTATE POS0 -> POS1 ---------------- *)
150:
    if rotate_ok then
        rotate_return := 600;
        step := 500;
    end_if;

(* ---------------- GENERIC ROTATE ---------------- *)
500:
    Y17 := FALSE;
    if X1A then
        step := 501;
    end_if;

501:
    Y18 := TRUE;
    step := 502;

502:
    if X18 then
        step := 503;
    end_if;

503:
    if not X18 then
        step := 504;
    end_if;

504:
    Y17 := TRUE;
    if X19 then
        step := rotate_return;
    end_if;

(* ---------------- INSERT AT POS1 ---------------- *)
600:
    if needs_insert then
        if X13 and (not X15) then
            step := 601;
        end_if;
    else
        step := 650;
    end_if;

601:
    Y12 := TRUE;
    step := 602;

602:
    if X15 then
        step := 603;
    end_if;

603:
    if not X15 then
        step := 610;
    end_if;

610:
    if X21 then
        step := 650;
    end_if;

(* ---------------- ROTATE POS1 -> POS2 ---------------- *)
650:
    if rotate_ok then
        rotate_return := 700;
        step := 500;
    end_if;

(* ---------------- INSPECT AT POS2 ---------------- *)
700:
    if not X16 then
        step := 701;
    end_if;

701:
    Y13 := TRUE;
    D200 := gen;
    step := 702;

702:
    if X16 then
        step := 703;
    end_if;

703:
    if not X16 then
        step := 710;
    end_if;

710:
    output_ng_flag := X24;
    if (not needs_insert) then
        reinspect_count := reinspect_count + 1;
    end_if;
    step := 750;

(* ---------------- ROTATE POS2 -> POS3 ---------------- *)
750:
    if rotate_ok then
        rotate_return := 800;
        step := 500;
    end_if;

(* ---------------- DECISION AT POS3 ---------------- *)
800:
    if output_ng_flag then
        step := 900;
    else
        step := 850;
    end_if;

(* ---------------- EJECT PATH (GOOD) ---------------- *)
850:
    if X1D and (not X17) then
        step := 851;
    end_if;

851:
    Y14 := TRUE;
    step := 852;

852:
    if X17 then
        step := 853;
    end_if;

853:
    if (not X17) and X1C then
        step := 854;
    end_if;

854:
    Y15 := TRUE;
    step := 855;

855:
    if X17 then
        step := 856;
    end_if;

856:
    if (not X17) and X1B then
        step := 860;
    end_if;

860:
    if X20 and X1B and X1D and (not X1E) then
        step := 861;
    end_if;

861:
    Y16 := TRUE;
    step := 862;

862:
    if X1E then
        step := 863;
    end_if;

863:
    Y19 := TRUE;
    step := 864;

864:
    if not X1E then
        step := 870;
    end_if;

870:
    good_count  := good_count + 1;
    body_count  := body_count + 1;
    needs_insert := TRUE;
    gen := gen + 1;
    D200 := gen;
    step := 1000;

(* ---------------- REWORK PATH (NG) ---------------- *)
900:
    if X1B and X20 then
        step := 901;
    end_if;

901:
    Y1B := TRUE;
    step := 902;

902:
    if X25 then
        step := 903;
    end_if;

903:
    if not X25 then
        step := 904;
    end_if;

904:
    if X26 then
        step := 905;
    end_if;

905:
    Y1C := TRUE;
    clamp_timer(IN := FALSE, PT := T#300ms);
    step := 906;

906:
    clamp_timer(IN := FALSE, PT := T#300ms);
    if X27 then
        step := 907;
    end_if;

907:
    clamp_timer(IN := TRUE, PT := T#300ms);
    if clamp_timer.Q then
        step := 908;
    end_if;

908:
    clamp_timer(IN := FALSE, PT := T#300ms);
    Y1D := TRUE;
    step := 909;

909:
    if X28 then
        step := 910;
    end_if;

910:
    Y1E := TRUE;
    step := 911;

911:
    if X29 then
        step := 912;
    end_if;

912:
    Y1C := FALSE;
    step := 913;

913:
    if not X27 then
        step := 914;
    end_if;

914:
    if X19 and X2A then
        step := 915;
    end_if;

915:
    Y1F := TRUE;
    return_timer(IN := TRUE, PT := T#2s);
    step := 916;

916:
    return_timer(IN := TRUE, PT := T#2s);
    if return_timer.Q then
        step := 920;
    end_if;

920:
    return_timer(IN := FALSE, PT := T#2s);
    gen := gen + 1;
    D200 := gen;
    needs_insert := FALSE;
    rework_count := rework_count + 1;
    step := 150;

(* ---------------- LOOP CONTROL ---------------- *)
1000:
    if body_count < 6 then
        step := 100;
    else
        step := 2000;
    end_if;

(* ---------------- COMPLETION ---------------- *)
2000:
    if (good_count >= 6) and (rework_count >= 2) and (reinspect_count >= 2)
       and (not X14) and (not X15) and (not X16) and (not X17) and (not X25)
       and (not X18) and X19 and X1B and X2A then
        Y1A := TRUE;
        complete_timer(IN := TRUE, PT := T#500ms);
        step := 2010;
    end_if;

2010:
    Y1A := TRUE;
    Y17 := TRUE;
    complete_timer(IN := TRUE, PT := T#500ms);
    (* remain in completed / maintenance state *)

ELSE
    step := 2000;

END_CASE;

END_PROGRAM