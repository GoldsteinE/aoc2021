.intel_syntax noprefix

.include "constants.s"
.include "strings.s"

.section .data
printn_buf: .ds.b 64

.section .text

.macro exit code
	mov rax, SYS_EXIT
	mov rdi, \code
	syscall
.endm

.macro trysyscall
	syscall
	test rax, rax
	js trysyscall_die
.endm

# type: () -> !
.global trysyscall_die
trysyscall_die:
	mov rdi, rax
	neg rdi
	mov rax, SYS_EXIT
	syscall

# type: (int fd, char* buf, int n) -> void
.global fputsn
fputsn:
	mov rax, SYS_WRITE
	trysyscall
	cmp rax, rdx
	je .Lfputsn.end
	sub rdx, rax
	add rsi, rax
	jmp fputsn
.Lfputsn.end:
	ret

# type: (char* buf, int n) -> void
.global putsn
putsn:
	mov rdx, rsi
	mov rsi, rdi
	mov rdi, STDOUT
	jmp fputsn

# type: (int fd) -> void
.global fputnl
fputnl:
	mov rsi, offset newline
	mov rdx, 1
	jmp fputsn

# type: () -> void
.global putnl
putnl:
	mov rdi, STDOUT
	jmp fputnl

# type: (char* buf) -> (bool newline, int num)
# First return value is true if eof isn't reached yet
.global readline
readline:
	mov rbx, rdi
	mov rsi, rdi
	# r10 is newline
	mov r10, 10
	mov rdi, STDIN
.Lreadline.loop:
	mov rax, SYS_READ
	mov rdx, 1
	trysyscall
	test rax, rax
	jz .Lreadline.end
	mov r8b, [rsi]
	cmp r8b, r10b
	je .Lreadline.end
	inc rsi
	jmp .Lreadline.loop
.Lreadline.end:
	sub rsi, rbx
	mov rbx, rsi
	ret
