; RUN: opt %loadPolly -polly-stmt-granularity=bb -polly-flatten-schedule -polly-delicm-overapproximate-writes=true -polly-delicm-compute-known=true -polly-print-delicm -disable-output < %s | FileCheck %s
; RUN: opt %loadPolly -polly-stmt-granularity=bb -polly-flatten-schedule -polly-delicm-partial-writes=true -polly-delicm-compute-known=true -polly-print-delicm -disable-output < %s | FileCheck -check-prefix=PARTIAL %s
;
;    void func(double *A) {
;      for (int j = 0; j < 2; j += 1) { /* outer */
;        double phi = 0.0;
;        for (int i = 0; i < 4; i += 1) { /* reduction */
;          phi += 4.2;
;          A[j] = phi;
;        }
;      }
;    }
;
define void @func(ptr noalias nonnull %A) {
entry:
  br label %outer.preheader

outer.preheader:
  br label %outer.for

outer.for:
  %j = phi i32 [0, %outer.preheader], [%j.inc, %outer.inc]
  %j.cmp = icmp slt i32 %j, 2
  br i1 %j.cmp, label %reduction.preheader, label %outer.exit


    reduction.preheader:
      br label %reduction.for

    reduction.for:
      %i = phi i32 [0, %reduction.preheader], [%i.inc, %reduction.inc]
      %phi = phi double [0.0, %reduction.preheader], [%add, %reduction.inc]
      br label %body



        body:
          %add = fadd double %phi, 4.2
          %A_idx = getelementptr inbounds double, ptr %A, i32 %j
          store double %add, ptr %A_idx
          br label %reduction.inc



    reduction.inc:
      %i.inc = add nuw nsw i32 %i, 1
      %i.cmp = icmp slt i32 %i.inc, 4
      br i1 %i.cmp, label %reduction.for, label %reduction.exit

    reduction.exit:
      br label %outer.inc



outer.inc:
  %j.inc = add nuw nsw i32 %j, 1
  br label %outer.for

outer.exit:
  br label %return

return:
  ret void
}


; CHECK:      After accesses {
; CHECK-NEXT:    Stmt_reduction_preheader
; CHECK-NEXT:            MustWriteAccess :=  [Reduction Type: NONE] [Scalar: 1]
; CHECK-NEXT:                 { Stmt_reduction_preheader[i0] -> MemRef_phi__phi[] };
; CHECK-NEXT:            new: { Stmt_reduction_preheader[i0] -> MemRef_A[i0] };
; CHECK-NEXT:     Stmt_reduction_for
; CHECK-NEXT:             ReadAccess :=       [Reduction Type: NONE] [Scalar: 1]
; CHECK-NEXT:                 { Stmt_reduction_for[i0, i1] -> MemRef_phi__phi[] };
; CHECK-NEXT:            new: { Stmt_reduction_for[i0, i1] -> MemRef_A[i0] };
; CHECK-NEXT:             MustWriteAccess :=  [Reduction Type: NONE] [Scalar: 1]
; CHECK-NEXT:                 { Stmt_reduction_for[i0, i1] -> MemRef_phi[] };
; CHECK-NEXT:            new: { Stmt_reduction_for[i0, i1] -> MemRef_A[i0] };
; CHECK-NEXT:     Stmt_body
; CHECK-NEXT:             MustWriteAccess :=  [Reduction Type: NONE] [Scalar: 1]
; CHECK-NEXT:                 { Stmt_body[i0, i1] -> MemRef_add[] };
; CHECK-NEXT:            new: { Stmt_body[i0, i1] -> MemRef_A[i0] };
; CHECK-NEXT:             ReadAccess :=       [Reduction Type: NONE] [Scalar: 1]
; CHECK-NEXT:                 { Stmt_body[i0, i1] -> MemRef_phi[] };
; CHECK-NEXT:            new: { Stmt_body[i0, i1] -> MemRef_A[i0] : 3i1 <= 21 - 13i0; Stmt_body[1, 3] -> MemRef_A[1] };
; CHECK-NEXT:             MustWriteAccess :=  [Reduction Type: NONE] [Scalar: 0]
; CHECK-NEXT:                 { Stmt_body[i0, i1] -> MemRef_A[i0] };
; CHECK-NEXT:     Stmt_reduction_inc
; CHECK-NEXT:             ReadAccess :=       [Reduction Type: NONE] [Scalar: 1]
; CHECK-NEXT:                 { Stmt_reduction_inc[i0, i1] -> MemRef_add[] };
; CHECK-NEXT:            new: { Stmt_reduction_inc[i0, i1] -> MemRef_A[i0] : 3i1 <= 21 - 13i0; Stmt_reduction_inc[1, 3] -> MemRef_A[1] };
; CHECK-NEXT:             MustWriteAccess :=  [Reduction Type: NONE] [Scalar: 1]
; CHECK-NEXT:                 { Stmt_reduction_inc[i0, i1] -> MemRef_phi__phi[] };
; CHECK-NEXT:            new: { Stmt_reduction_inc[i0, i1] -> MemRef_A[i0] };
; CHECK-NEXT: }


; PARTIAL:      After accesses {
; PARTIAL-NEXT:     Stmt_reduction_preheader
; PARTIAL-NEXT:             MustWriteAccess :=  [Reduction Type: NONE] [Scalar: 1]
; PARTIAL-NEXT:                 { Stmt_reduction_preheader[i0] -> MemRef_phi__phi[] };
; PARTIAL-NEXT:            new: { Stmt_reduction_preheader[i0] -> MemRef_A[i0] };
; PARTIAL-NEXT:     Stmt_reduction_for
; PARTIAL-NEXT:             ReadAccess :=       [Reduction Type: NONE] [Scalar: 1]
; PARTIAL-NEXT:                 { Stmt_reduction_for[i0, i1] -> MemRef_phi__phi[] };
; PARTIAL-NEXT:            new: { Stmt_reduction_for[i0, i1] -> MemRef_A[i0] };
; PARTIAL-NEXT:             MustWriteAccess :=  [Reduction Type: NONE] [Scalar: 1]
; PARTIAL-NEXT:                 { Stmt_reduction_for[i0, i1] -> MemRef_phi[] };
; PARTIAL-NEXT:            new: { Stmt_reduction_for[i0, i1] -> MemRef_A[i0] };
; PARTIAL-NEXT:     Stmt_body
; PARTIAL-NEXT:             MustWriteAccess :=  [Reduction Type: NONE] [Scalar: 1]
; PARTIAL-NEXT:                 { Stmt_body[i0, i1] -> MemRef_add[] };
; PARTIAL-NEXT:            new: { Stmt_body[i0, i1] -> MemRef_A[i0] };
; PARTIAL-NEXT:             ReadAccess :=       [Reduction Type: NONE] [Scalar: 1]
; PARTIAL-NEXT:                 { Stmt_body[i0, i1] -> MemRef_phi[] };
; PARTIAL-NEXT:            new: { Stmt_body[i0, i1] -> MemRef_A[i0] : 3i1 <= 21 - 13i0; Stmt_body[1, 3] -> MemRef_A[1] };
; PARTIAL-NEXT:             MustWriteAccess :=  [Reduction Type: NONE] [Scalar: 0]
; PARTIAL-NEXT:                 { Stmt_body[i0, i1] -> MemRef_A[i0] };
; PARTIAL-NEXT:     Stmt_reduction_inc
; PARTIAL-NEXT:             ReadAccess :=       [Reduction Type: NONE] [Scalar: 1]
; PARTIAL-NEXT:                 { Stmt_reduction_inc[i0, i1] -> MemRef_add[] };
; PARTIAL-NEXT:            new: { Stmt_reduction_inc[i0, i1] -> MemRef_A[i0] : 3i1 <= 21 - 13i0; Stmt_reduction_inc[1, 3] -> MemRef_A[1] };
; PARTIAL-NEXT:             MustWriteAccess :=  [Reduction Type: NONE] [Scalar: 1]
; PARTIAL-NEXT:                 { Stmt_reduction_inc[i0, i1] -> MemRef_phi__phi[] };
; PARTIAL-NEXT:            new: { Stmt_reduction_inc[i0, i1] -> MemRef_A[i0] : i1 <= 2 };
; PARTIAL-NEXT: }
