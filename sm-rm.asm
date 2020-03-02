; Защищенный режим

cli
        mov     al,8f
        out     CMOS_PORT,al
        jmp     next1           
next1:
        mov     al,5
        out     CMOS_PORT+1,al
       
       
       
PROC    enable_a20      NEAR
        mov     al,A20_PORT
        out     STATUS_PORT,al
        mov     al,A20_ON
        out     KBD_PORT_A,al
        ret
ENDP    enable_a20



 mov     [real_ss],ss    ; запоминаем указатель стека
 mov     [real_es],es    ; для реального режима
lgdt [QWORD gdt_gdt]

  mov     ax, 1
  lmsw    ax
 
 
 
 ; реальный режим
 
 mov     ax, 0FEh        ; команда отключения
out     64h, ax


; Запоминаем содержимое указателя стека, так как после
; сброса процессора оно будет потеряно

        mov     [real_sp],sp

; Выполняем сброс процессора

        mov     al,SHUT_DOWN
        out     STATUS_PORT,al

; Ожидаем сброса процессора

wait_reset:
        hlt
        jmp     wait_reset

; ------------------------------------------------------------
; Процедура закрывает адресную линию A20
; ------------------------------------------------------------

PROC    disable_a20     NEAR
        mov     al,A20_PORT
        out     STATUS_PORT,al
        mov     al,A20_OFF
        out     KBD_PORT_A,al
        ret
ENDP    disable_a20



        mov     ax,000dh        ; разрешаем немаскируемые прерывания
        out     CMOS_PORT,al

        in      al,INT_MASK_PORT ; разрешаем маскируемые прерывания
        and     al,0
        out     INT_MASK_PORT,al
        sti
