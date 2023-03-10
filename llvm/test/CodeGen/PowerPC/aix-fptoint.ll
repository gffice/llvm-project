; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -O3 -mtriple powerpc-ibm-aix -verify-machineinstrs < %s | FileCheck --check-prefix=32BIT %s
; RUN: llc -O3 -mtriple powerpc64-ibm-aix -verify-machineinstrs < %s | FileCheck --check-prefix=64BIT %s

; Function Attrs: nounwind strictfp
define i64 @tester_s(double %d) local_unnamed_addr #0 {
; 32BIT-LABEL: tester_s:
; 32BIT:       # %bb.0: # %entry
; 32BIT-NEXT:    xscvdpsxds 0, 1
; 32BIT-NEXT:    stfd 0, -8(1)
; 32BIT-NEXT:    lwz 3, -8(1)
; 32BIT-NEXT:    lwz 4, -4(1)
; 32BIT-NEXT:    blr
;
; 64BIT-LABEL: tester_s:
; 64BIT:       # %bb.0: # %entry
; 64BIT-NEXT:    xscvdpsxds 0, 1
; 64BIT-NEXT:    stfd 0, -8(1)
; 64BIT-NEXT:    ld 3, -8(1)
; 64BIT-NEXT:    blr
entry:
  %conv = tail call i64 @llvm.experimental.constrained.fptosi.i64.f64(double %d, metadata !"fpexcept.ignore") #2
  ret i64 %conv
}

; Function Attrs: nounwind strictfp
define i64 @tester_u(double %d) local_unnamed_addr #0 {
; 32BIT-LABEL: tester_u:
; 32BIT:       # %bb.0: # %entry
; 32BIT-NEXT:    xscvdpuxds 0, 1
; 32BIT-NEXT:    stfd 0, -8(1)
; 32BIT-NEXT:    lwz 3, -8(1)
; 32BIT-NEXT:    lwz 4, -4(1)
; 32BIT-NEXT:    blr
;
; 64BIT-LABEL: tester_u:
; 64BIT:       # %bb.0: # %entry
; 64BIT-NEXT:    xscvdpuxds 0, 1
; 64BIT-NEXT:    stfd 0, -8(1)
; 64BIT-NEXT:    ld 3, -8(1)
; 64BIT-NEXT:    blr
entry:
  %conv = tail call i64 @llvm.experimental.constrained.fptoui.i64.f64(double %d, metadata !"fpexcept.ignore") #2
  ret i64 %conv
}

; Function Attrs: nounwind
declare i64 @llvm.experimental.constrained.fptosi.i64.f64(double, metadata) #1
declare i64 @llvm.experimental.constrained.fptoui.i64.f64(double, metadata) #1

attributes #0 = { nounwind strictfp "target-cpu"="pwr7" }
attributes #1 = { nounwind }


