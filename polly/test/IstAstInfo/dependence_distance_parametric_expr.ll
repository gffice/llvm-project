; RUN: opt %loadPolly -polly-print-ast -polly-ast-detect-parallel -disable-output < %s | FileCheck %s
; RUN: opt %loadPolly -print-polyhedral-info -polly-check-parallel -disable-output < %s | FileCheck %s -check-prefix=PINFO
;
;        void f(int *A, int N, int c, int v) {
; CHECK:   #pragma minimal dependence distance: 1
; PINFO:   for.cond: Loop is not parallel.
;          for (int j = 0; j < N; j++)
; CHECK:      #pragma minimal dependence distance: max(-c - v, c + v)
; PINFO-NEXT: for.cond1: Loop is not parallel.
;             for (int i = 0; i < N; i++)
;               A[i + c + v] = A[i] + 1;
;        }
;
target datalayout = "e-m:e-p:32:32-i64:64-v128:64:128-n32-S64"

define void @f(ptr %A, i32 %N, i32 %c, i32 %v) {
entry:
  br label %for.cond

for.cond:                                         ; preds = %for.inc7, %entry
  %j.0 = phi i32 [ 0, %entry ], [ %inc8, %for.inc7 ]
  %cmp = icmp slt i32 %j.0, %N
  br i1 %cmp, label %for.body, label %for.end9

for.body:                                         ; preds = %for.cond
  br label %for.cond1

for.cond1:                                        ; preds = %for.inc, %for.body
  %i.0 = phi i32 [ 0, %for.body ], [ %inc, %for.inc ]
  %exitcond = icmp ne i32 %i.0, %N
  br i1 %exitcond, label %for.body3, label %for.end

for.body3:                                        ; preds = %for.cond1
  %arrayidx = getelementptr inbounds i32, ptr %A, i32 %i.0
  %tmp = load i32, ptr %arrayidx, align 4
  %add = add nsw i32 %tmp, 1
  %add4 = add nsw i32 %i.0, %c
  %add5 = add nsw i32 %add4, %v
  %arrayidx6 = getelementptr inbounds i32, ptr %A, i32 %add5
  store i32 %add, ptr %arrayidx6, align 4
  br label %for.inc

for.inc:                                          ; preds = %for.body3
  %inc = add nsw i32 %i.0, 1
  br label %for.cond1

for.end:                                          ; preds = %for.cond1
  br label %for.inc7

for.inc7:                                         ; preds = %for.end
  %inc8 = add nsw i32 %j.0, 1
  br label %for.cond

for.end9:                                         ; preds = %for.cond
  ret void
}
