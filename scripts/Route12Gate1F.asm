Route12Gate1F_Script:
    call Route12Gate1F_CheckLapras
    call EnableAutoTextBoxDrawing
    ret

Route12Gate1F_CheckLapras:
    ld a, [wStatusFlags4]   ; Cargar el estado del evento
    bit BIT_GOT_LAPRAS, a   ; ¿Ya recibió Lapras?
    ret nz                  ; Si ya lo tiene, salir

    ld hl, Route12Gate1F_GiveLaprasText
    call PrintText          ; Mostrar el mensaje inicial

    lb bc, LAPRAS, 15       ; Especificar Lapras nivel 15
    call GivePokemon        ; Intentar dar el Pokémon
    jr nc, .storage_full    ; Si el equipo y cajas están llenos, avisar

    ld a, [wAddedToParty]   ; ¿Se agregó a la caja o al equipo?
    and a
    call z, WaitForTextScrollButtonPress
    call EnableAutoTextBoxDrawing
    ld hl, Route12Gate1F_LaprasDescriptionText
    call PrintText          ; Mostrar información del Lapras

    ; Marcar el evento como completado SOLO si lo recibió correctamente
    ld hl, wStatusFlags4
    set BIT_GOT_LAPRAS, [hl]
    ret

.storage_full:
    ld hl, Route12Gate1F_NoSpaceForLaprasText
    call PrintText
    ret

Route12Gate1F_GiveLaprasText:
    text "¡Te entrego un Lapras!"
    line "Es un Pokémon fuerte."
    done

Route12Gate1F_LaprasDescriptionText:
    text "Lapras es muy noble."
    line "Cudalo bien."
    done

Route12Gate1F_NoSpaceForLaprasText:
    text "No tienes espacio"
    line "para Lapras."
    done
