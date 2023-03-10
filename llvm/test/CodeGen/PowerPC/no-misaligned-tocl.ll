; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mcpu=pwr8 -mtriple=powerpc64le-unknown-unknown \
; RUN:   -ppc-asm-full-reg-names -verify-machineinstrs < %s | FileCheck %s
%0 = type <{ [7 x i8], i32, float, float, double, double, ppc_fp128 }>

@var = external dso_local unnamed_addr global %0, align 16
@ans = external dso_local unnamed_addr global i32, align 4

define dso_local signext i32 @main() #0 {
; CHECK-LABEL: main:
; CHECK:       # %bb.0: # %bb
; CHECK-NEXT:    addis r3, r2, var@toc@ha
; CHECK-NEXT:    lis r4, 0
; CHECK-NEXT:    lwa r3, var@toc@l+7(r3)
; CHECK-NEXT:    ori r4, r4, 50000
; CHECK-NEXT:    sub r3, r3, r4
; CHECK-NEXT:    addis r4, r2, ans@toc@ha
; CHECK-NEXT:    rldicl r3, r3, 1, 63
; CHECK-NEXT:    stw r3, ans@toc@l(r4)
bb:
  %i = load i32, ptr getelementptr inbounds (%0, ptr @var, i64 0, i32 1), align 4
  %i1 = icmp slt i32 %i, 50000
  %i2 = zext i1 %i1 to i32
  store i32 %i2, ptr @ans, align 4
  unreachable
}
