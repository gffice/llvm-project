; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -passes=loop-distribute -enable-loop-distribute \
; RUN:   -verify-loop-info -verify-dom-info -S < %s | FileCheck %s

; Derived from crash-in-memcheck-generation.ll

; Make sure the loop is distributed even with a convergent
; op. LoopAccessAnalysis says that runtime checks are necessary, but
; none are cross partition, so none are truly needed.

define void @f(ptr %a, ptr %b, ptr noalias %c, ptr noalias %d, ptr noalias %e) #1 {
; CHECK-LABEL: @f(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[ENTRY_SPLIT_LDIST1:%.*]]
; CHECK:       entry.split.ldist1:
; CHECK-NEXT:    br label [[FOR_BODY_LDIST1:%.*]]
; CHECK:       for.body.ldist1:
; CHECK-NEXT:    [[IND_LDIST1:%.*]] = phi i64 [ 0, [[ENTRY_SPLIT_LDIST1]] ], [ [[ADD_LDIST1:%.*]], [[FOR_BODY_LDIST1]] ]
; CHECK-NEXT:    [[ARRAYIDXA_LDIST1:%.*]] = getelementptr inbounds i32, ptr [[A:%.*]], i64 [[IND_LDIST1]]
; CHECK-NEXT:    [[LOADA_LDIST1:%.*]] = load i32, ptr [[ARRAYIDXA_LDIST1]], align 4
; CHECK-NEXT:    [[ARRAYIDXB_LDIST1:%.*]] = getelementptr inbounds i32, ptr [[B:%.*]], i64 [[IND_LDIST1]]
; CHECK-NEXT:    [[LOADB_LDIST1:%.*]] = load i32, ptr [[ARRAYIDXB_LDIST1]], align 4
; CHECK-NEXT:    [[MULA_LDIST1:%.*]] = mul i32 [[LOADB_LDIST1]], [[LOADA_LDIST1]]
; CHECK-NEXT:    [[ADD_LDIST1]] = add nuw nsw i64 [[IND_LDIST1]], 1
; CHECK-NEXT:    [[ARRAYIDXA_PLUS_4_LDIST1:%.*]] = getelementptr inbounds i32, ptr [[A]], i64 [[ADD_LDIST1]]
; CHECK-NEXT:    store i32 [[MULA_LDIST1]], ptr [[ARRAYIDXA_PLUS_4_LDIST1]], align 4
; CHECK-NEXT:    [[EXITCOND_LDIST1:%.*]] = icmp eq i64 [[ADD_LDIST1]], 20
; CHECK-NEXT:    br i1 [[EXITCOND_LDIST1]], label [[ENTRY_SPLIT:%.*]], label [[FOR_BODY_LDIST1]]
; CHECK:       entry.split:
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[IND:%.*]] = phi i64 [ 0, [[ENTRY_SPLIT]] ], [ [[ADD:%.*]], [[FOR_BODY]] ]
; CHECK-NEXT:    [[ADD]] = add nuw nsw i64 [[IND]], 1
; CHECK-NEXT:    [[ARRAYIDXD:%.*]] = getelementptr inbounds i32, ptr [[D:%.*]], i64 [[IND]]
; CHECK-NEXT:    [[LOADD:%.*]] = load i32, ptr [[ARRAYIDXD]], align 4
; CHECK-NEXT:    [[CONVERGENTD:%.*]] = call i32 @llvm.convergent(i32 [[LOADD]])
; CHECK-NEXT:    [[ARRAYIDXE:%.*]] = getelementptr inbounds i32, ptr [[E:%.*]], i64 [[IND]]
; CHECK-NEXT:    [[LOADE:%.*]] = load i32, ptr [[ARRAYIDXE]], align 4
; CHECK-NEXT:    [[MULC:%.*]] = mul i32 [[CONVERGENTD]], [[LOADE]]
; CHECK-NEXT:    [[ARRAYIDXC:%.*]] = getelementptr inbounds i32, ptr [[C:%.*]], i64 [[IND]]
; CHECK-NEXT:    store i32 [[MULC]], ptr [[ARRAYIDXC]], align 4
; CHECK-NEXT:    [[EXITCOND:%.*]] = icmp eq i64 [[ADD]], 20
; CHECK-NEXT:    br i1 [[EXITCOND]], label [[FOR_END:%.*]], label [[FOR_BODY]]
; CHECK:       for.end:
; CHECK-NEXT:    ret void
;
entry:
  br label %for.body

for.body:                                         ; preds = %for.body, %entry
  %ind = phi i64 [ 0, %entry ], [ %add, %for.body ]

  %arrayidxA = getelementptr inbounds i32, ptr %a, i64 %ind
  %loadA = load i32, ptr %arrayidxA, align 4

  %arrayidxB = getelementptr inbounds i32, ptr %b, i64 %ind
  %loadB = load i32, ptr %arrayidxB, align 4

  %mulA = mul i32 %loadB, %loadA

  %add = add nuw nsw i64 %ind, 1
  %arrayidxA_plus_4 = getelementptr inbounds i32, ptr %a, i64 %add
  store i32 %mulA, ptr %arrayidxA_plus_4, align 4

  %arrayidxD = getelementptr inbounds i32, ptr %d, i64 %ind
  %loadD = load i32, ptr %arrayidxD, align 4
  %convergentD = call i32 @llvm.convergent(i32 %loadD)

  %arrayidxE = getelementptr inbounds i32, ptr %e, i64 %ind
  %loadE = load i32, ptr %arrayidxE, align 4

  %mulC = mul i32 %convergentD, %loadE

  %arrayidxC = getelementptr inbounds i32, ptr %c, i64 %ind
  store i32 %mulC, ptr %arrayidxC, align 4

  %exitcond = icmp eq i64 %add, 20
  br i1 %exitcond, label %for.end, label %for.body

for.end:                                          ; preds = %for.body
  ret void
}

declare i32 @llvm.convergent(i32) #0

attributes #0 = { nounwind readnone convergent }
attributes #1 = { nounwind convergent }
