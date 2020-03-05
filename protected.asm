section .data
msg1 db 10,"Processor is in Real Mode"
msg1len:equ $-msg1

msg2 db 10,"Processor is in Protected Mode"
msg2len:equ $-msg2

msg3 db 10,"GDT Contents are::"
msg3len:equ $-msg3

msg4 db 10,"LDT Contents are::"
msg4len:equ $-msg4

msg5 db 10,"IDT Contents are::"
msg5len:equ $-msg5

msg6 db 10,"Task Register Contents are::"
msg6len: equ $-msg6

msg7 db 10,"Machine Status Word:"
msg7len:equ $-msg7

msg8 db ":"
msg8len:equ $-msg8

nwline db 10

section .bss
gdt resd 1
    resw 1
ldt resw 1
idt resd 1
    resw 1
tr  resw 1

cro_data resd 2
msw resd 1
disp_buff resb 04

%macro disp 2
mov eax,04
mov ebx,01
mov ecx,%1
mov edx,%2
int 80h
%endmacro

section .text
global _start
_start:
   smsw eax        

   mov [cro_data],eax

   bt eax,1         
   jc prmode
   disp msg1,msg1len
   jmp nxt1

 prmode:    disp msg2,msg2len

 nxt1:    
      sgdt [gdt]
      sldt [ldt]
      sidt [idt]
      str[tr]

      disp msg3,msg3len

      mov bx,[gdt+4]
      call disp_num

      mov bx,[gdt+2]
      call disp_num

      disp msg8,1

      mov bx,[gdt]
      call disp_num

      disp msg4,msg4len
      mov bx,[ldt]
      call disp_num

      disp msg5,msg5len

      mov bx,[idt+4]
      call disp_num

      mov bx,[idt+2]
      call disp_num

      disp msg8,1

      mov bx,[idt]
      call disp_num

      disp msg6,msg6len

      mov bx,[tr]
      call disp_num

      disp msg7,msg7len

      mov bx,[cro_data+2]
      call disp_num

      mov bx,[cro_data]
      call disp_num

      disp nwline,1
 exit:    
      mov eax,01
      mov ebx,00
      int 80h

 disp_num:
      mov esi,disp_buff    
      mov ecx,04        

 up1:
     rol bx,4        
     mov dl,bl        
     and dl,0fh        
     add dl,30h         
     cmp dl,39h        
     jbe skip1        
     add dl,07h        
 skip1:
     mov [esi],dl        
     inc esi            
     loop up1        


 disp disp_buff,4    
 ret
