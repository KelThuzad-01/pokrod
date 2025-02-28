Route12Gate1F_Script:
    jp EnableAutoTextBoxDrawing

Route12Gate1F_TextPointers:
    def_text_pointers
    dw_const Route12Gate1FGuardText, TEXT_ROUTE12GATE1F_GUARD

Route12Gate1FGuardText:
    text_asm
    ld a, [wStatusFlags4]   ; Cargar el estado del evento
    bit BIT_GOT_LAPRAS, a   ; ¿Ya recibió Lapras?
    jr nz, .already_have_it ; Si ya lo tiene, mostrar mensaje alternativo

.give_lapras
    ld hl, .GiveLaprasText
    call PrintText          ; Mostrar el mensaje inicial

    lb bc, GYARADOS, 15       ; Especificar Lapras nivel 15
    call GivePokemon        ; Intentar dar el Pokémon
    jr nc, .storage_full    ; Si el equipo y cajas están llenos, avisar

    ld a, [wAddedToParty]   ; ¿Se agregó a la caja o al equipo?
    and a
    call z, WaitForTextScrollButtonPress
    call EnableAutoTextBoxDrawing

    ld hl, .LaprasDescriptionText
    call PrintText          ; Mostrar información del Lapras

    ld hl, wStatusFlags4
    set BIT_GOT_LAPRAS, [hl]  ; Marcar que ya se recibió Lapras

    ; Esperar a que el jugador cierre el diálogo antes de mover el guardia
    call WaitForTextScrollButtonPress

    ; Mover al guardia un espacio hacia arriba
    ld a, HS_ROUTE12GATE1F_GUARD ; ID del guardia en el mapa
    ld [wMissableObjectIndex], a
    predef MoveObjectUp ; Llamar a la función de mover NPC

    jr .done

.already_have_it
    ld hl, .AlreadyHaveLaprasText
    call PrintText
    jr .done

.storage_full
    ld hl, .StorageFullText
    call PrintText

.done
    jp TextScriptEnd

; Definimos los textos

.GiveLaprasText
    text "Toma este Lapras."
    line "Es muy inteligente."
    done

.LaprasDescriptionText
    text "Lapras es un gran"
    line "nadador. Cuidalo!"
    done

.AlreadyHaveLaprasText
    text "Espero que estes"
    line "cuidando a Lapras."
    done

.StorageFullText
    text "No tienes espacio"
    line "para Lapras."
    done
