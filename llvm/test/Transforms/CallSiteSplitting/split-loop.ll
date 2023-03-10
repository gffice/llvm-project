; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S -passes=callsite-splitting,simplifycfg -simplifycfg-require-and-preserve-domtree=1 < %s | FileCheck %s

define i16 @test1() {
; CHECK-LABEL: @test1(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[SPEC_SELECT:%.*]] = select i1 undef, i16 1, i16 0
; CHECK-NEXT:    [[TOBOOL18:%.*]] = icmp ne i16 [[SPEC_SELECT]], 0
; CHECK-NEXT:    [[TMP0:%.*]] = xor i1 [[TOBOOL18]], true
; CHECK-NEXT:    call void @llvm.assume(i1 [[TMP0]])
; CHECK-NEXT:    br label [[FOR_COND12:%.*]]
; CHECK:       for.cond12:
; CHECK-NEXT:    call void @callee(i16 [[SPEC_SELECT]])
; CHECK-NEXT:    br label [[FOR_COND12]]
;
entry:
  %spec.select = select i1 undef, i16 1, i16 0
  %tobool18 = icmp ne i16 %spec.select, 0
  br i1 %tobool18, label %for.cond12.us, label %for.cond12

for.cond12.us:
  unreachable

for.cond12:
  call void @callee(i16 %spec.select)
  br label %for.cond12
}

define i16 @test2() {
; CHECK-LABEL: @test2(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[S:%.*]] = select i1 undef, i16 1, i16 0
; CHECK-NEXT:    [[TOBOOL18:%.*]] = icmp ne i16 [[S]], 0
; CHECK-NEXT:    [[TMP0:%.*]] = xor i1 [[TOBOOL18]], true
; CHECK-NEXT:    call void @llvm.assume(i1 [[TMP0]])
; CHECK-NEXT:    br label [[FOR_COND12:%.*]]
; CHECK:       for.cond12:
; CHECK-NEXT:    call void @callee(i16 [[S]])
; CHECK-NEXT:    [[ADD:%.*]] = add i16 [[S]], 10
; CHECK-NEXT:    [[ADD2:%.*]] = add i16 [[S]], 10
; CHECK-NEXT:    br label [[FOR_COND12]]
;
entry:
  %s= select i1 undef, i16 1, i16 0
  %tobool18 = icmp ne i16 %s, 0
  br i1 %tobool18, label %for.cond12.us, label %for.cond12

for.cond12.us:
  unreachable

for.cond12:
  call void @callee(i16 %s)
  %add = add i16 %s, 10
  %add2 = add i16 %s, 10
  br label %for.cond12
}

define i16 @test3(i1 %c) {
; CHECK-LABEL: @test3(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[S:%.*]] = select i1 undef, i16 1, i16 0
; CHECK-NEXT:    [[TOBOOL18:%.*]] = icmp ne i16 [[S]], 0
; CHECK-NEXT:    [[TMP0:%.*]] = xor i1 [[TOBOOL18]], true
; CHECK-NEXT:    call void @llvm.assume(i1 [[TMP0]])
; CHECK-NEXT:    br label [[FOR_COND12:%.*]]
; CHECK:       for.cond12:
; CHECK-NEXT:    call void @callee(i16 [[S]])
; CHECK-NEXT:    [[ADD:%.*]] = add i16 [[S]], 10
; CHECK-NEXT:    [[ADD2:%.*]] = add i16 [[ADD]], 10
; CHECK-NEXT:    br i1 [[C:%.*]], label [[FOR_COND12]], label [[EXIT:%.*]]
; CHECK:       exit:
; CHECK-NEXT:    ret i16 [[ADD2]]
;
entry:
  %s= select i1 undef, i16 1, i16 0
  %tobool18 = icmp ne i16 %s, 0
  br i1 %tobool18, label %for.cond12.us, label %for.cond12

for.cond12.us:
  unreachable

for.cond12:
  call void @callee(i16 %s)
  %add = add i16 %s, 10
  %add2 = add i16 %add, 10
  br i1 %c, label %for.cond12, label %exit

exit:
  ret i16 %add2
}

declare void @callee(i16 %flag)
