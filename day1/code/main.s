.include "stdlib.s"

.section .data

# 16 bytes is more than enough for storing string representations of our numbers
buffer: .fill 16
# Pointers to int64 should be 8-aligned
.balign 8
window: .fill 24  # 3 values, 8 bytes each
window_size: .fill 8

.section .text

# type: (int value) -> void (clobbers only rdi)
# Push a new value into the global `window`, discarding oldest
.global slide
slide:
	# How values move between the register and array elements:
	# rdi ||  0  |  1  |  2 
	# --- || --- | --- | ---
	#  a  ||  x  |  y  |  z
	xchg rdi, [window + 16]
	#  z  ||  x  |  y  |  a
	xchg rdi, [window + 8]
	#  y  ||  x  |  z  |  a
	xchg rdi, [window]
	#  x  ||  y  |  z  |  a
	ret

# type: (int count [range: 1-3]) -> int (clobbers only rdi)
# Sum last `count` elements from the global `window`
.global sum
sum:
	# We always want the last element
	mov rax, [window + 16]
	# If (count - 1) > 0, we also want the middle element
	dec rdi
	jz .Lsum_end
	add rax, [window + 8]
	# If (count - 2) > 0, we also want the first element
	dec rdi
	jz .Lsum_end
	add rax, [window]
	# There are only three elements, so no need to do any further checks
.Lsum_end:
	ret

.global _start
_start:
	# Choosing the part
	# Binary is called with one argument to select part two
	# Loading argc
	mov r15, [rsp]
	# Now r15 == 1 for part 1 and r15 == 2 for part 2
	# Doing some arithmetic magic:
	# 1 -> 2 | 2 -> 4
	shl r15, 1
	# 2 -> 1 | 4 -> 3
	dec r15
	# Now r15 is the window size: 1 for part 1 and 3 for part 2
	# We'll store it in memory to avoid using a register
	mov [window_size], r15
	# We'll store count of the processed elements in r14
	xor r14, r14
	# And the answer will be in r15
	xor r15, r15
.L_start.loop:
	# Read one line from STDIN
	mov rdi, offset buffer
	call readline
	# If input is empty, exit loop
	test rbx, rbx
	jz .L_start.loop_end
	# Remember EOF flag
	mov r12, rax
	# Convert line from STDIN to a number
	mov rdi, offset buffer
	mov rsi, rbx
	call stoi
	# Push resulting number into the sliding `window`
	mov rdi, rax
	call slide
	# Calculate the sum of the last `[window_size]` elems of the sliding window
	mov rdi, [window_size]
	call sum
	# Increment count of processed elements
	inc r14
	# If window was filled before this iteration
	mov rbx, [window_size]
	cmp r14, rbx
	jle .L_start.after_check
	# Compare the current value of the window with the previous value
	cmp rax, r13
	jle .L_start.after_check
	# And increment the answer if it's greater
	inc r15
.L_start.after_check:
	# Remember the current window sum
	mov r13, rax
	# If not EOF, jump to the beginning of the loop
	test r12, r12
	jnz .L_start.loop
.L_start.loop_end:
	# Convert answer to a string
	mov rdi, r15
	mov rsi, offset buffer
	call itos
	# And print it to STDOUT
	mov rdi, offset buffer
	mov rsi, rax
	call putsn
	call putnl
	exit 0
