%macro print 2
	mov rax, 1
	mov rdi, 1
	mov rsi, %1
	mov rdx, %2
	syscall
%endmacro

%macro println 2
  print %1, %2
  print '\n', 1
%endmacro

%macro exit 1
	mov rax, 60
	mov rdi, %1
	syscall
%endmacro

%macro read 2
	mov rax, 0
	mov rdi, 0
	mov rsi, %1
	mov rdx, %2
	syscall
%endmacro

isdigit:
  sub sil, '0'
  cmp sil, 0
  jl not_a_digit
  cmp sil, 9
  jg not_a_digit
  mov rax, 1
  ret
  not_a_digit:
    mov rax, 0
    ret

numlen:
  xor rcx, rcx ; init counter
  mov rax, rdi

  count_len_loop:
    test rax, rax
    jz done_len
    inc rcx
    xor rdx, rdx
    mov rbx, 10
    idiv rbx
    jmp count_len_loop
  done_len:
    mov rax, rcx
    xor rcx, rcx
    ret

pow:
  mov rax, 1

  pow_mul:
    test rsi, rsi
    jz pow_exit
    imul rdi
    dec rsi
    jmp pow_mul
    pow_exit: ret

strlen:
  xor rcx, rcx ; initialize the counter
  strlen_start:
    mov bl, byte [rdi+rcx] ; load the character
    test bl, bl ; check if its the end of the string
    jnz increment
  mov rax, rcx
  ret
  increment:
    inc rcx ; increment the count if not the end of a string
    jmp strlen_start

atoi:
  call strlen ; get the length of the number
  mov r15, rax ; save length
  xor rcx, rcx ; initialize counter
  xor r10, r10 ; initialize the number
  xor r8, r8 ; initialize the mask
  atoi_start:
    xor rbx, rbx
    mov bl, byte [rdi+rcx] ; load the character
    inc rcx
    cmp bl, '-' ; check for negative number
    jne abs_value_atoi
    or r8, 0 ; flip the mask for negatives
    not r8
    jmp atoi_start
    abs_value_atoi:
      mov sil, bl
      call isdigit
      test rax, rax ; check if is a digit
      jne is_a_digit
      exit 75 ; exit with error if not a digit is given to atoi
      is_a_digit:
        sub bl, '0'
        mov rax, r10
        mov r11, 10
        mul r11
        mov r10, rax
        add r10, rbx
    
    cmp r15, rcx
    jne atoi_start
    xor r10, r8
    jns return_atoi
    inc r10
    return_atoi:
      mov rax, r10
      ret

itoa:
  test rdi, rdi
  jns itoa_positive
  mov byte [rsi], '-'
  inc rsi
  neg rdi

  itoa_positive:
    call numlen
    mov rcx, rax
    inc rcx
    mov byte [rsi+rcx], 0
    dec rcx
    mov byte [rsi+rcx], 0xA
    mov rax, rdi
    mov rbx, 10

    itoa_loop:
      dec rcx
      xor rdx, rdx
      div rbx
      add rdx, '0'
      mov byte [rsi+rcx], dl
      test rcx, rcx
      jnz itoa_loop
      ret
