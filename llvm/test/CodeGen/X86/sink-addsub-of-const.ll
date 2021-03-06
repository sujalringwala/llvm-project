; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686-unknown-unknown -mattr=+slow-lea,+slow-3ops-lea,+sse,+sse2   | FileCheck %s --check-prefixes=ALL,X32
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+slow-lea,+slow-3ops-lea,+sse,+sse2 | FileCheck %s --check-prefixes=ALL,X64

; Scalar tests. Trying to avoid LEA here, so the output is actually readable..

define i32 @sink_add_of_const_to_add(i32 %a, i32 %b, i32 %c) {
; X32-LABEL: sink_add_of_const_to_add:
; X32:       # %bb.0:
; X32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X32-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X32-NEXT:    addl {{[0-9]+}}(%esp), %ecx
; X32-NEXT:    addl %ecx, %eax
; X32-NEXT:    addl $32, %eax
; X32-NEXT:    retl
;
; X64-LABEL: sink_add_of_const_to_add:
; X64:       # %bb.0:
; X64-NEXT:    # kill: def $edx killed $edx def $rdx
; X64-NEXT:    # kill: def $edi killed $edi def $rdi
; X64-NEXT:    addl %esi, %edi
; X64-NEXT:    leal 32(%rdx,%rdi), %eax
; X64-NEXT:    retq
  %t0 = add i32 %a, %b
  %t1 = add i32 %t0, 32
  %r = add i32 %t1, %c
  ret i32 %r
}
define i32 @sink_sub_of_const_to_add(i32 %a, i32 %b, i32 %c) {
; X32-LABEL: sink_sub_of_const_to_add:
; X32:       # %bb.0:
; X32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X32-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X32-NEXT:    addl {{[0-9]+}}(%esp), %ecx
; X32-NEXT:    addl %ecx, %eax
; X32-NEXT:    addl $-32, %eax
; X32-NEXT:    retl
;
; X64-LABEL: sink_sub_of_const_to_add:
; X64:       # %bb.0:
; X64-NEXT:    # kill: def $edx killed $edx def $rdx
; X64-NEXT:    # kill: def $edi killed $edi def $rdi
; X64-NEXT:    addl %esi, %edi
; X64-NEXT:    leal -32(%rdx,%rdi), %eax
; X64-NEXT:    retq
  %t0 = add i32 %a, %b
  %t1 = sub i32 %t0, 32
  %r = add i32 %t1, %c
  ret i32 %r
}

define i32 @sink_add_of_const_to_sub(i32 %a, i32 %b, i32 %c) {
; X32-LABEL: sink_add_of_const_to_sub:
; X32:       # %bb.0:
; X32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X32-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X32-NEXT:    addl %ecx, %eax
; X32-NEXT:    addl $32, %eax
; X32-NEXT:    subl {{[0-9]+}}(%esp), %eax
; X32-NEXT:    retl
;
; X64-LABEL: sink_add_of_const_to_sub:
; X64:       # %bb.0:
; X64-NEXT:    # kill: def $esi killed $esi def $rsi
; X64-NEXT:    # kill: def $edi killed $edi def $rdi
; X64-NEXT:    leal 32(%rdi,%rsi), %eax
; X64-NEXT:    subl %edx, %eax
; X64-NEXT:    retq
  %t0 = add i32 %a, %b
  %t1 = add i32 %t0, 32
  %r = sub i32 %t1, %c
  ret i32 %r
}
define i32 @sink_sub_of_const_to_sub2(i32 %a, i32 %b, i32 %c) {
; X32-LABEL: sink_sub_of_const_to_sub2:
; X32:       # %bb.0:
; X32-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X32-NEXT:    addl {{[0-9]+}}(%esp), %ecx
; X32-NEXT:    movl $32, %eax
; X32-NEXT:    subl %ecx, %eax
; X32-NEXT:    addl {{[0-9]+}}(%esp), %eax
; X32-NEXT:    retl
;
; X64-LABEL: sink_sub_of_const_to_sub2:
; X64:       # %bb.0:
; X64-NEXT:    addl %esi, %edi
; X64-NEXT:    movl $32, %eax
; X64-NEXT:    subl %edi, %eax
; X64-NEXT:    addl %edx, %eax
; X64-NEXT:    retq
  %t0 = add i32 %a, %b
  %t1 = sub i32 %t0, 32
  %r = sub i32 %c, %t1
  ret i32 %r
}

define i32 @sink_add_of_const_to_sub2(i32 %a, i32 %b, i32 %c) {
; X32-LABEL: sink_add_of_const_to_sub2:
; X32:       # %bb.0:
; X32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X32-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X32-NEXT:    movl {{[0-9]+}}(%esp), %edx
; X32-NEXT:    addl %edx, %ecx
; X32-NEXT:    addl $32, %ecx
; X32-NEXT:    subl %ecx, %eax
; X32-NEXT:    retl
;
; X64-LABEL: sink_add_of_const_to_sub2:
; X64:       # %bb.0:
; X64-NEXT:    movl %edx, %eax
; X64-NEXT:    # kill: def $esi killed $esi def $rsi
; X64-NEXT:    # kill: def $edi killed $edi def $rdi
; X64-NEXT:    leal 32(%rdi,%rsi), %ecx
; X64-NEXT:    subl %ecx, %eax
; X64-NEXT:    retq
  %t0 = add i32 %a, %b
  %t1 = add i32 %t0, 32
  %r = sub i32 %c, %t1
  ret i32 %r
}
define i32 @sink_sub_of_const_to_sub(i32 %a, i32 %b, i32 %c) {
; X32-LABEL: sink_sub_of_const_to_sub:
; X32:       # %bb.0:
; X32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X32-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X32-NEXT:    addl %ecx, %eax
; X32-NEXT:    addl $-32, %eax
; X32-NEXT:    subl {{[0-9]+}}(%esp), %eax
; X32-NEXT:    retl
;
; X64-LABEL: sink_sub_of_const_to_sub:
; X64:       # %bb.0:
; X64-NEXT:    # kill: def $esi killed $esi def $rsi
; X64-NEXT:    # kill: def $edi killed $edi def $rdi
; X64-NEXT:    leal -32(%rdi,%rsi), %eax
; X64-NEXT:    subl %edx, %eax
; X64-NEXT:    retq
  %t0 = add i32 %a, %b
  %t1 = sub i32 %t0, 32
  %r = sub i32 %t1, %c
  ret i32 %r
}

; Basic vector tests. Here it is easier to see where the constant operand is.

define <4 x i32> @vec_sink_add_of_const_to_add(<4 x i32> %a, <4 x i32> %b, <4 x i32> %c) {
; X32-LABEL: vec_sink_add_of_const_to_add:
; X32:       # %bb.0:
; X32-NEXT:    paddd %xmm2, %xmm1
; X32-NEXT:    paddd %xmm1, %xmm0
; X32-NEXT:    paddd {{\.LCPI.*}}, %xmm0
; X32-NEXT:    retl
;
; X64-LABEL: vec_sink_add_of_const_to_add:
; X64:       # %bb.0:
; X64-NEXT:    paddd %xmm2, %xmm1
; X64-NEXT:    paddd %xmm1, %xmm0
; X64-NEXT:    paddd {{.*}}(%rip), %xmm0
; X64-NEXT:    retq
  %t0 = add <4 x i32> %a, %b
  %t1 = add <4 x i32> %t0, <i32 31, i32 undef, i32 33, i32 66>
  %r = add <4 x i32> %t1, %c
  ret <4 x i32> %r
}
define <4 x i32> @vec_sink_sub_of_const_to_add(<4 x i32> %a, <4 x i32> %b, <4 x i32> %c) {
; X32-LABEL: vec_sink_sub_of_const_to_add:
; X32:       # %bb.0:
; X32-NEXT:    paddd %xmm1, %xmm0
; X32-NEXT:    psubd {{\.LCPI.*}}, %xmm0
; X32-NEXT:    paddd %xmm2, %xmm0
; X32-NEXT:    retl
;
; X64-LABEL: vec_sink_sub_of_const_to_add:
; X64:       # %bb.0:
; X64-NEXT:    paddd %xmm1, %xmm0
; X64-NEXT:    psubd {{.*}}(%rip), %xmm0
; X64-NEXT:    paddd %xmm2, %xmm0
; X64-NEXT:    retq
  %t0 = add <4 x i32> %a, %b
  %t1 = sub <4 x i32> %t0, <i32 12, i32 undef, i32 44, i32 32>
  %r = add <4 x i32> %t1, %c
  ret <4 x i32> %r
}

define <4 x i32> @vec_sink_add_of_const_to_sub(<4 x i32> %a, <4 x i32> %b, <4 x i32> %c) {
; X32-LABEL: vec_sink_add_of_const_to_sub:
; X32:       # %bb.0:
; X32-NEXT:    paddd %xmm1, %xmm0
; X32-NEXT:    paddd {{\.LCPI.*}}, %xmm0
; X32-NEXT:    psubd %xmm2, %xmm0
; X32-NEXT:    retl
;
; X64-LABEL: vec_sink_add_of_const_to_sub:
; X64:       # %bb.0:
; X64-NEXT:    paddd %xmm1, %xmm0
; X64-NEXT:    paddd {{.*}}(%rip), %xmm0
; X64-NEXT:    psubd %xmm2, %xmm0
; X64-NEXT:    retq
  %t0 = add <4 x i32> %a, %b
  %t1 = add <4 x i32> %t0, <i32 86, i32 undef, i32 65, i32 47>
  %r = sub <4 x i32> %t1, %c
  ret <4 x i32> %r
}
define <4 x i32> @vec_sink_sub_of_const_to_sub2(<4 x i32> %a, <4 x i32> %b, <4 x i32> %c) {
; ALL-LABEL: vec_sink_sub_of_const_to_sub2:
; ALL:       # %bb.0:
; ALL-NEXT:    paddd %xmm1, %xmm0
; ALL-NEXT:    movdqa {{.*#+}} xmm1 = <93,u,45,81>
; ALL-NEXT:    psubd %xmm0, %xmm1
; ALL-NEXT:    paddd %xmm2, %xmm1
; ALL-NEXT:    movdqa %xmm1, %xmm0
; ALL-NEXT:    ret{{[l|q]}}
  %t0 = add <4 x i32> %a, %b
  %t1 = sub <4 x i32> %t0, <i32 93, i32 undef, i32 45, i32 81>
  %r = sub <4 x i32> %c, %t1
  ret <4 x i32> %r
}

define <4 x i32> @vec_sink_add_of_const_to_sub2(<4 x i32> %a, <4 x i32> %b, <4 x i32> %c) {
; X32-LABEL: vec_sink_add_of_const_to_sub2:
; X32:       # %bb.0:
; X32-NEXT:    paddd %xmm1, %xmm0
; X32-NEXT:    paddd {{\.LCPI.*}}, %xmm0
; X32-NEXT:    psubd %xmm0, %xmm2
; X32-NEXT:    movdqa %xmm2, %xmm0
; X32-NEXT:    retl
;
; X64-LABEL: vec_sink_add_of_const_to_sub2:
; X64:       # %bb.0:
; X64-NEXT:    paddd %xmm1, %xmm0
; X64-NEXT:    paddd {{.*}}(%rip), %xmm0
; X64-NEXT:    psubd %xmm0, %xmm2
; X64-NEXT:    movdqa %xmm2, %xmm0
; X64-NEXT:    retq
  %t0 = add <4 x i32> %a, %b
  %t1 = add <4 x i32> %t0, <i32 51, i32 undef, i32 61, i32 92>
  %r = sub <4 x i32> %c, %t1
  ret <4 x i32> %r
}
define <4 x i32> @vec_sink_sub_of_const_to_sub(<4 x i32> %a, <4 x i32> %b, <4 x i32> %c) {
; X32-LABEL: vec_sink_sub_of_const_to_sub:
; X32:       # %bb.0:
; X32-NEXT:    paddd %xmm1, %xmm0
; X32-NEXT:    psubd {{\.LCPI.*}}, %xmm0
; X32-NEXT:    psubd %xmm2, %xmm0
; X32-NEXT:    retl
;
; X64-LABEL: vec_sink_sub_of_const_to_sub:
; X64:       # %bb.0:
; X64-NEXT:    paddd %xmm1, %xmm0
; X64-NEXT:    psubd {{.*}}(%rip), %xmm0
; X64-NEXT:    psubd %xmm2, %xmm0
; X64-NEXT:    retq
  %t0 = add <4 x i32> %a, %b
  %t1 = sub <4 x i32> %t0, <i32 49, i32 undef, i32 45, i32 21>
  %r = sub <4 x i32> %t1, %c
  ret <4 x i32> %r
}
