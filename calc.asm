%include "../stdlib.asm"

section .text
	global _start

_start:
	print msg_enter_num1, len_enter_num1
  read operand1, 64
  dec rax
  mov byte [rsi+rax], 0 ; null terminate user input
  mov r8, rax ; save size for later use
  print msg_enter_num2, len_enter_num2
  read operand2, 64
  dec rax
  mov byte [rsi+rax], 0 ; null terminate user input
  mov r9, rax ; save size for later use
  print msg_enter_operation, len_enter_operation
  read operator, 1

  mov rdi, operand1
  call atoi ; convert to int
  mov r14, rax ; store the return value

  mov rdi, operand2
  call atoi
  mov r15, rax

  cmp byte [operator], '+'
  je addition
  cmp byte [operator], '-'
  je subtraction
  cmp byte [operator], '*'
  je multiplication
  cmp byte [operator], '/'
  je division
  cmp byte [operator], '^'
  je power
  
  print error_wrong_op, len_error_wrong_op
  exit 54

  addition:
    add r14, r15 
    jmp exit_point

  subtraction:
    sub r14, r15
    jmp exit_point

  multiplication:
    mov rax, r14
    imul r15
    mov r14, rax
    jmp exit_point

  division:
    mov rax, r14
    cqo
    idiv r15
    mov r14, rax
    jmp exit_point

  power:
    mov rdi, r14
    mov rsi, r15
    call pow
    mov r14, rax
    jmp exit_point
  
  exit_point:
    mov rdi, r14
    mov rsi, result
    call itoa

    mov rdi, result
    call strlen
    mov rdx, rax

    print result_msg, len_result_msg
    print result, rdx

    exit 0

section .data
	msg_enter_num1 db "Enter first operand: ", 0
	len_enter_num1 equ $-msg_enter_num1
  msg_enter_num2 db "Enter second operand: ", 0
  len_enter_num2 equ $-msg_enter_num2
  msg_enter_operation db "Enter the operation: ", 0
  len_enter_operation equ $-msg_enter_operation
  error_wrong_op db "Error: unsupported operation!"
  len_error_wrong_op equ $-error_wrong_op
  result_msg db "The result is: ", 0
  len_result_msg equ $-result_msg
section .bss
	operand1 resb 64
  operand2 resb 64
  operator resb 1
  result resb 64
