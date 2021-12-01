.section .text

# type: (char* buf, int len) -> void
.global reverse_string
reverse_string:
	add rsi, rdi
	cmp rdi, rsi
	jge .Lreverse_string.end
	dec rsi
.Lreverse_string.loop:
	mov cl, [rsi]
	mov dl, [rdi]
	mov [rdi], cl
	mov [rsi], dl
	dec rsi
	inc rdi
	cmp rdi, rsi
	jl .Lreverse_string.loop
.Lreverse_string.end:
	ret

# type: (char* buf, int len) -> int
.global stoi
stoi:
	add rsi, rdi
	xor rax, rax
	mov r9, 1
.Lstoi.loop:
	dec rsi
	xor rcx, rcx
	mov cl, [rsi]
	sub rcx, 48
	imul rcx, r9
	add rax, rcx
	imul r9, 10
	cmp rdi, rsi
	jne .Lstoi.loop
	ret

# type: (int n, char* buf) -> int
# Returns len of resulting string
.global itos
itos:
	mov rax, rdi
	mov rdi, rsi
	mov r9, 10
.Litos.loop:
	xor rdx, rdx
	div r9
	add rdx, 48
	mov [rsi], dl
	inc rsi
	test rax, rax
	jnz .Litos.loop
# End of loop
	sub rsi, rdi
	push rsi
	call reverse_string
	pop rax
	ret
