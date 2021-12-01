.include "stdlib.s"

.section .data
buffer: .fill 16

.section .text

.global _start
_start:
	# Reading first number into r13
	mov rdi, offset buffer
	call readline
	mov rdi, offset buffer
	mov rsi, rbx
	call stoi
	# We'll store the answer in the r12
	xor r12, r12
	# And "previous number" in the r13
	mov r13, rax
.L_start.loop:
	mov rdi, offset buffer
	call readline
	# If input is empty, exit loop
	test rbx, rbx
	jz .L_start.loop_end
	# Remember EOF flag
	mov r14, rax
	mov rdi, offset buffer
	mov rsi, rbx
	call stoi
	xor rbx, rbx
	mov rcx, 1
	cmp r13, rax
	cmovl rbx, rcx
	add r12, rbx
	mov r13, rax
	# If not EOF, jump to the beginning
	test r14, r14
	jnz .L_start.loop
.L_start.loop_end:
	mov rdi, r12
	mov rsi, offset buffer
	call itos
	mov rdi, offset buffer
	mov rsi, rax
	call putsn
	call putnl
	exit 0
