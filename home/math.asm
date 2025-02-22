EXPORT Modulus
; function to do multiplication
; all values are big endian
; INPUT
; FF96-FF98 =  multiplicand
; FF99 = multiplier
; OUTPUT
; FF95-FF98 = product
Multiply::
	push hl
	push bc
	callfar _Multiply
	pop bc
	pop hl
	ret

; function to do division
; all values are big endian
; INPUT
; FF95-FF98 = dividend
; FF99 = divisor
; b = number of bytes in the dividend (starting from FF95)
; OUTPUT
; FF95-FF98 = quotient
; FF99 = remainder
Divide::
	push hl
	push de
	push bc
	homecall _Divide
	pop bc
	pop de
	pop hl
	ret

Modulus:
    ld h, 0
    ld l, a   ; Cargar el dividendo en HL
.mod_loop
    sub b     ; Restar divisor (b) al dividendo (a)
    jr c, .done  ; Si resultado es negativo, hemos terminado
    inc h     ; Contador de divisiones completas
    jr .mod_loop
.done
    add b     ; Revertimos la última resta que fue demasiado
    ld a, l   ; El residuo queda en 'a'
    ret

; Divide el valor en A por 10 y devuelve el cociente en A
DivideBy10:
    ld c, 10         ; Cargamos el divisor (10)
    call Divide      ; Llamamos a la función de división del juego
    ld a, l          ; Guardamos el cociente (resultado de A / 10)
    ret
