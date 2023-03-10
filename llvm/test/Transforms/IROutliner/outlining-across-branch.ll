; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --include-generated-funcs
; RUN: opt -S -passes=verify,iroutliner -ir-outlining-no-cost < %s | FileCheck %s

; This checks that we are able to outline exactly the same branch structure
; while also outlining similar items on either side of the branch.

define void @outline_outputs1() #0 {
entry:
  %a = alloca i32, align 4
  %b = alloca i32, align 4
  %output = alloca i32, align 4
  %result = alloca i32, align 4
  %output2 = alloca i32, align 4
  %result2 = alloca i32, align 4
  store i32 2, ptr %a, align 4
  store i32 3, ptr %b, align 4
  br label %next
next:
  store i32 2, ptr %output, align 4
  store i32 3, ptr %result, align 4
  ret void
}

define void @outline_outputs2() #0 {
entry:
  %a = alloca i32, align 4
  %b = alloca i32, align 4
  %output = alloca i32, align 4
  %result = alloca i32, align 4
  %output2 = alloca i32, align 4
  %result2 = alloca i32, align 4
  store i32 2, ptr %a, align 4
  store i32 3, ptr %b, align 4
  br label %next
next:
  store i32 2, ptr %output, align 4
  store i32 3, ptr %result, align 4
  ret void
}
; CHECK-LABEL: @outline_outputs1(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[A:%.*]] = alloca i32, align 4
; CHECK-NEXT:    [[B:%.*]] = alloca i32, align 4
; CHECK-NEXT:    [[OUTPUT:%.*]] = alloca i32, align 4
; CHECK-NEXT:    [[RESULT:%.*]] = alloca i32, align 4
; CHECK-NEXT:    [[OUTPUT2:%.*]] = alloca i32, align 4
; CHECK-NEXT:    [[RESULT2:%.*]] = alloca i32, align 4
; CHECK-NEXT:    call void @outlined_ir_func_0(ptr [[A]], ptr [[B]], ptr [[OUTPUT]], ptr [[RESULT]])
; CHECK-NEXT:    ret void
;
;
; CHECK-LABEL: @outline_outputs2(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[A:%.*]] = alloca i32, align 4
; CHECK-NEXT:    [[B:%.*]] = alloca i32, align 4
; CHECK-NEXT:    [[OUTPUT:%.*]] = alloca i32, align 4
; CHECK-NEXT:    [[RESULT:%.*]] = alloca i32, align 4
; CHECK-NEXT:    [[OUTPUT2:%.*]] = alloca i32, align 4
; CHECK-NEXT:    [[RESULT2:%.*]] = alloca i32, align 4
; CHECK-NEXT:    call void @outlined_ir_func_0(ptr [[A]], ptr [[B]], ptr [[OUTPUT]], ptr [[RESULT]])
; CHECK-NEXT:    ret void
;
;
; CHECK: define internal void @outlined_ir_func_0(
; CHECK:  newFuncRoot:
; CHECK-NEXT:    br label [[ENTRY_TO_OUTLINE:%.*]]
; CHECK:       entry_to_outline:
; CHECK-NEXT:    store i32 2, ptr [[TMP0:%.*]], align 4
; CHECK-NEXT:    store i32 3, ptr [[TMP1:%.*]], align 4
; CHECK-NEXT:    br label [[NEXT:%.*]]
; CHECK:       next:
; CHECK-NEXT:    store i32 2, ptr [[TMP2:%.*]], align 4
; CHECK-NEXT:    store i32 3, ptr [[TMP3:%.*]], align 4
; CHECK-NEXT:    br label [[ENTRY_AFTER_OUTLINE_EXITSTUB:%.*]]
; CHECK:       entry_after_outline.exitStub:
; CHECK-NEXT:    ret void
;
