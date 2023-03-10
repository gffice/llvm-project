; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S -passes=verify,iroutliner -ir-outlining-no-cost < %s | FileCheck %s

; This test checks to make sure that we outline getelementptr instructions only
; when all the operands after the first are the exact same. In this case, we
; outline from the first two functions, but not the third.

%struct.RT = type { i8, [10 x [20 x i32]], i8 }
%struct.ST = type { i32, double, %struct.RT }

define void @function1(ptr %s, i64 %t) {
; CHECK-LABEL: @function1(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[A:%.*]] = alloca i32, align 4
; CHECK-NEXT:    [[B:%.*]] = alloca i32, align 4
; CHECK-NEXT:    call void @outlined_ir_func_0(ptr [[A]], ptr [[B]], ptr [[S:%.*]], i64 [[T:%.*]])
; CHECK-NEXT:    ret void
;
entry:
  %a = alloca i32, align 4
  %b = alloca i32, align 4
  store i32 2, ptr %a, align 4
  store i32 3, ptr %b, align 4
  %0 = getelementptr inbounds %struct.ST, ptr %s, i64 %t, i32 1
  ret void
}

define void @function2(ptr %s, i64 %t) {
; CHECK-LABEL: @function2(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[A:%.*]] = alloca i32, align 4
; CHECK-NEXT:    [[B:%.*]] = alloca i32, align 4
; CHECK-NEXT:    call void @outlined_ir_func_0(ptr [[A]], ptr [[B]], ptr [[S:%.*]], i64 [[T:%.*]])
; CHECK-NEXT:    ret void
;
entry:
  %a = alloca i32, align 4
  %b = alloca i32, align 4
  store i32 2, ptr %a, align 4
  store i32 3, ptr %b, align 4
  %0 = getelementptr inbounds %struct.ST, ptr %s, i64 %t, i32 1
  ret void
}

define void @function3(ptr %s, i64 %t) {
; CHECK-LABEL: @function3(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[A:%.*]] = alloca i32, align 4
; CHECK-NEXT:    [[B:%.*]] = alloca i32, align 4
; CHECK-NEXT:    store i32 2, ptr [[A]], align 4
; CHECK-NEXT:    store i32 3, ptr [[B]], align 4
; CHECK-NEXT:    [[TMP0:%.*]] = getelementptr inbounds [[STRUCT_ST:%.*]], ptr [[S:%.*]], i64 [[T:%.*]], i32 0
; CHECK-NEXT:    ret void
;
entry:
  %a = alloca i32, align 4
  %b = alloca i32, align 4
  store i32 2, ptr %a, align 4
  store i32 3, ptr %b, align 4
  %0 = getelementptr inbounds %struct.ST, ptr %s, i64 %t, i32 0
  ret void
}

; CHECK: define internal void @outlined_ir_func_0(ptr [[ARG0:%.*]], ptr [[ARG1:%.*]], ptr [[ARG2:%.*]], i64 [[ARG3:%.*]])
; CHECK: entry_to_outline:
; CHECK-NEXT:    store i32 2, ptr [[ARG0]], align 4
; CHECK-NEXT:    store i32 3, ptr [[ARG1]], align 4
; CHECK-NEXT:    [[TMP0:%.*]] = getelementptr inbounds %struct.ST, ptr [[ARG2]], i64 [[ARG3]], i32 1
