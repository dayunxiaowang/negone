// NegOne - Hardware-Accelerated Hypervisor solution
//
// Copyright (c) Zero Tang, 2018-2026. All rights reserved.
//
// This file is the host interrupt handler for NegOne.
//
// This program is distributed in the hope that it will be successful, but
// without any warranty (no matter implied warranty of merchantability or
// fitness for a particular purpose, etc.).

.include "src/xpf_core/hv_host/asm_helper_x86.inc"

.global nvc_call_try_task
.seh_proc nvc_call_try_task
nvc_call_try_task:
	sub rsp,0x28
	.seh_stackalloc 0x28
	.seh_endprologue
	mov qword ptr gs:[0x0],rsp
	lea rax,[rip+end_of_try]
	mov qword ptr gs:[0x8],rax
	mov rax,rcx
	mov rcx,rdx
	call rax
	xor eax,eax
end_of_try:
	add rsp,0x28
	ret
.seh_endproc

.macro interrupt_handler_prologue_common
	// Save volatile XMM state.
	stmxcsr  dword ptr [rsp+0x80]
	movaps xmmword ptr [rsp+0x20],xmm0
	movaps xmmword ptr [rsp+0x30],xmm1
	movaps xmmword ptr [rsp+0x40],xmm2
	movaps xmmword ptr [rsp+0x50],xmm3
	movaps xmmword ptr [rsp+0x60],xmm4
	movaps xmmword ptr [rsp+0x70],xmm5
	.seh_endprologue
.endm

.macro interrupt_handler_prologue name
.global \name
.seh_proc \name
\name:
	.seh_pushframe
	sub rsp,0x108
	.seh_stackalloc 0x108
	pushaq_fast 0x88
	interrupt_handler_prologue_common
	// Load arguments
	lea rcx,[rsp+0x108]
	lea rdx,[rsp+0x88]
.endm

.macro interrupt_handler_prologue_with_code name
.global \name
.seh_proc \name
\name:
	.seh_pushframe @code
	sub rsp,0x110
	.seh_stackalloc 0x110
	pushaq_fast 0x90
	interrupt_handler_prologue_common
	// Load arguments
	lea rcx,[rsp+0x110]
	lea rdx,[rsp+0x90]
.endm

.macro interrupt_handler_epilogue_common
	// Restore volatile XMM state.
	movaps xmm0,xmmword ptr [rsp+0x20]
	movaps xmm1,xmmword ptr [rsp+0x30]
	movaps xmm2,xmmword ptr [rsp+0x40]
	movaps xmm3,xmmword ptr [rsp+0x50]
	movaps xmm4,xmmword ptr [rsp+0x60]
	movaps xmm5,xmmword ptr [rsp+0x70]
	ldmxcsr dword ptr [rsp+0x80]
.endm

.macro interrupt_handler_epilogue
	interrupt_handler_epilogue_common
	// Restore GPR state.
	popaq_fast 0x88
	add rsp,0x108
	iretq
.seh_endproc
.endm

.macro interrupt_handler_epilogue_with_code
	interrupt_handler_epilogue_common
	// Restore GPR state.
	popaq_fast 0x90
	add rsp,0x110
	iretq
.seh_endproc
.endm

.extern negone_divide_error_fault_handler
.extern negone_debug_fault_trap_handler
.extern negone_breakpoint_trap_handler
.extern negone_overflow_trap_handler
.extern negone_bound_range_fault_handler
.extern negone_invalid_opcode_fault_handler
.extern negone_device_not_available_fault_handler
.extern negone_double_fault_abort_handler
.extern negone_invalid_tss_fault_handler
.extern negone_segment_not_present_fault_handler
.extern negone_stack_fault_handler
.extern negone_general_protection_fault_handler
.extern negone_page_fault_handler
.extern negone_x87_floating_point_fault_handler
.extern negone_alignment_check_fault_handler
.extern negone_machine_check_abort_handler
.extern negone_simd_floating_point_fault_handler
.extern negone_control_protection_fault_handler

interrupt_handler_prologue negone_divide_error_fault_handler_a
	call negone_divide_error_fault_handler
interrupt_handler_epilogue

interrupt_handler_prologue negone_debug_fault_trap_handler_a
	call negone_debug_fault_trap_handler
interrupt_handler_epilogue

interrupt_handler_prologue negone_breakpoint_trap_handler_a
	call negone_breakpoint_trap_handler
interrupt_handler_epilogue

interrupt_handler_prologue negone_overflow_trap_handler_a
	call negone_overflow_trap_handler
interrupt_handler_epilogue

interrupt_handler_prologue negone_bound_range_fault_handler_a
	call negone_bound_range_fault_handler
interrupt_handler_epilogue

interrupt_handler_prologue negone_invalid_opcode_fault_handler_a
	call negone_invalid_opcode_fault_handler
interrupt_handler_epilogue

interrupt_handler_prologue negone_device_not_available_fault_handler_a
	call negone_device_not_available_fault_handler
interrupt_handler_epilogue

interrupt_handler_prologue_with_code negone_double_fault_abort_handler_a
	call negone_double_fault_abort_handler
interrupt_handler_epilogue_with_code

interrupt_handler_prologue_with_code negone_invalid_tss_fault_handler_a
	call negone_invalid_tss_fault_handler
interrupt_handler_epilogue_with_code

interrupt_handler_prologue_with_code negone_segment_not_present_fault_handler_a
	call negone_segment_not_present_fault_handler
interrupt_handler_epilogue_with_code

interrupt_handler_prologue_with_code negone_stack_fault_handler_a
	call negone_stack_fault_handler
interrupt_handler_epilogue_with_code

interrupt_handler_prologue_with_code negone_general_protection_fault_handler_a
	call negone_general_protection_fault_handler
interrupt_handler_epilogue_with_code

interrupt_handler_prologue_with_code negone_page_fault_handler_a
	call negone_page_fault_handler
interrupt_handler_epilogue_with_code

interrupt_handler_prologue negone_x87_floating_point_fault_handler_a
	call negone_x87_floating_point_fault_handler
interrupt_handler_epilogue

interrupt_handler_prologue_with_code negone_alignment_check_fault_handler_a
	call negone_alignment_check_fault_handler
interrupt_handler_epilogue_with_code

interrupt_handler_prologue negone_machine_check_abort_handler_a
	call negone_machine_check_abort_handler
interrupt_handler_epilogue

interrupt_handler_prologue negone_simd_floating_point_fault_handler_a
	call negone_simd_floating_point_fault_handler
interrupt_handler_epilogue

interrupt_handler_prologue_with_code negone_control_protection_fault_handler_a
	call negone_control_protection_fault_handler
interrupt_handler_epilogue_with_code