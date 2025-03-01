Route12Gate1F_Script:
    call EnableAutoTextBoxDrawing
    ret

Route12Gate1F_TextPointers:
    def_text_pointers
    dw_const Route12Gate1FPokeBall, TEXT_ROUTE12GATE1F_POKEBALL

Route12Gate1F_ObjectEvents:
    def_object_events
    object_event 6, 3, SPRITE_POKE_BALL, STAY, NONE, TEXT_ROUTE12GATE1F_POKEBALL, EVENT_GOT_LAPRAS

Route12Gate1FPokeBall:
    text_asm
    CheckEvent EVENT_GOT_LAPRAS
    jp nz, TextScriptEnd  ; Si ya lo recogimos, salir

    ld hl, LaprasItemText
    call PrintText         ; Mostrar texto inicial

    lb bc, LAPRAS, 15
    call GivePokemon
    jr nc, .storage_full   ; Si el equipo está lleno, avisar

    call WaitForTextScrollButtonPress
    call EnableAutoTextBoxDrawing
    farcall DisplayNamingScreen  ; Mostrar la pantalla de mote

    ld hl, LaprasDescriptionText
    call PrintText         ; Mostrar descripción del Pokémon

    SetEvent EVENT_GOT_LAPRAS  ; Marcar el evento como completado
    RemoveObject EVENT_GOT_LAPRAS  ; Eliminar la Poké Ball del mapa
    jp TextScriptEnd

.storage_full
    ld hl, StorageFullText
    call PrintText
    jp TextScriptEnd

LaprasItemText:
    text "Encontraste una Poké Ball."
    line "¡Tiene un Lapras dentro!"
    done

LaprasDescriptionText:
    text "Lapras es un gran"
    line "nadador. ¡Cuídalo!"
    done

StorageFullText:
    text "No tienes espacio"
    line "para Lapras."
    done
