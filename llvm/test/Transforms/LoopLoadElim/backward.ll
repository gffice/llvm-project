; RUN: opt -passes=loop-load-elim -S < %s | FileCheck %s

; Simple st->ld forwarding derived from a lexical backward dep.
;
;   for (unsigned i = 0; i < 100; i++)
;     A[i+1] = A[i] + B[i];

target datalayout = "e-m:o-i64:64-f80:128-n8:16:32:64-S128"

define void @f(ptr noalias nocapture %A, ptr noalias nocapture readonly %B, i64 %N) {
entry:
; CHECK: %load_initial = load i32, ptr %A
  br label %for.body

for.body:                                         ; preds = %for.body, %entry
; CHECK: %store_forwarded = phi i32 [ %load_initial, %entry ], [ %add, %for.body ]
  %indvars.iv = phi i64 [ 0, %entry ], [ %indvars.iv.next, %for.body ]
  %arrayidx = getelementptr inbounds i32, ptr %A, i64 %indvars.iv
  %load = load i32, ptr %arrayidx, align 4
  %arrayidx2 = getelementptr inbounds i32, ptr %B, i64 %indvars.iv
  %load_1 = load i32, ptr %arrayidx2, align 4
; CHECK: %add = add i32 %load_1, %store_forwarded
  %add = add i32 %load_1, %load
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1
  %arrayidx_next = getelementptr inbounds i32, ptr %A, i64 %indvars.iv.next
  store i32 %add, ptr %arrayidx_next, align 4
  %exitcond = icmp eq i64 %indvars.iv.next, %N
  br i1 %exitcond, label %for.end, label %for.body

for.end:                                          ; preds = %for.body
  ret void
}
