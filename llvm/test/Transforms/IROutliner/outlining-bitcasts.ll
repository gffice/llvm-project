; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --include-generated-funcs
; RUN: opt -S -passes=verify,iroutliner -ir-outlining-no-cost < %s | FileCheck %s

; This test ensures that an extra output is not added when there is a bitcast
; that is relocated to outside of the extraction due to a starting lifetime
; instruction outside of the extracted region.

; Additionally, we check that the newly added bitcast instruction is excluded in
; further extractions.

declare void @llvm.lifetime.start.p0(i64, ptr nocapture)
declare void @llvm.lifetime.end.p0(i64, ptr nocapture)

define void @outline_bitcast_base() {
entry:
  %a = alloca i32, align 4
  %b = alloca i32, align 4
  %c = alloca i32, align 4
  %d = alloca i32, align 4
  store i32 2, ptr %a, align 4
  store i32 3, ptr %b, align 4
  store i32 4, ptr %c, align 4
  %al = load i32, ptr %a
  %bl = load i32, ptr %b
  %cl = load i32, ptr %c
  ret void
}

define void @outline_bitcast_removed() {
entry:
  %a = alloca i32, align 4
  %b = alloca i32, align 4
  %c = alloca i32, align 4
  %d = alloca i32, align 4
  store i32 2, ptr %a, align 4
  store i32 3, ptr %b, align 4
  store i32 4, ptr %c, align 4
  %al = load i32, ptr %a
  %bl = load i32, ptr %b
  %cl = load i32, ptr %c
  call void @llvm.lifetime.start.p0(i64 -1, ptr %d)
  %am = load i32, ptr %b
  %bm = load i32, ptr %a
  %cm = load i32, ptr %c
  call void @llvm.lifetime.end.p0(i64 -1, ptr %d)
  ret void
}

; The first bitcast is moved down to lifetime start, and, since the original
; endpoint does not match the new endpoint, we cannot extract and outline the
; second bitcast and set of adds.  Outlining only occurs in this case due to
; the lack of a cost model, as denoted by the debug command line argument.

define void @outline_bitcast_base2(i32 %a, i32 %b, i32 %c) {
entry:
  %d = alloca i32, align 4
  %al = add i32 %a, %b
  %bl = add i32 %b, %a
  %cl = add i32 %b, %c
  %buffer = mul i32 %a, %b
  %am = add i32 %a, %b
  %bm = add i32 %b, %a
  %cm = add i32 %b, %c
  call void @llvm.lifetime.start.p0(i64 -1, ptr %d)
  call void @llvm.lifetime.end.p0(i64 -1, ptr %d)
  ret void
}

; CHECK-LABEL: @outline_bitcast_base(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[A:%.*]] = alloca i32, align 4
; CHECK-NEXT:    [[B:%.*]] = alloca i32, align 4
; CHECK-NEXT:    [[C:%.*]] = alloca i32, align 4
; CHECK-NEXT:    [[D:%.*]] = alloca i32, align 4
; CHECK-NEXT:    call void @outlined_ir_func_0(ptr [[A]], ptr [[B]], ptr [[C]])
; CHECK-NEXT:    ret void
;
;
; CHECK-LABEL: @outline_bitcast_removed(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[A:%.*]] = alloca i32, align 4
; CHECK-NEXT:    [[B:%.*]] = alloca i32, align 4
; CHECK-NEXT:    [[C:%.*]] = alloca i32, align 4
; CHECK-NEXT:    call void @outlined_ir_func_0(ptr [[A]], ptr [[B]], ptr [[C]])
; CHECK-NEXT:    [[AM:%.*]] = load i32, ptr [[B]], align 4
; CHECK-NEXT:    [[BM:%.*]] = load i32, ptr [[A]], align 4
; CHECK-NEXT:    [[CM:%.*]] = load i32, ptr [[C]], align 4
; CHECK-NEXT:    ret void
;
;
; CHECK-LABEL: @outline_bitcast_base2(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    call void @outlined_ir_func_1(i32 [[A:%.*]], i32 [[B:%.*]], i32 [[C:%.*]])
; CHECK-NEXT:    [[BUFFER:%.*]] = mul i32 [[A]], [[B]]
; CHECK-NEXT:    call void @outlined_ir_func_1(i32 [[A]], i32 [[B]], i32 [[C]])
; CHECK-NEXT:    ret void
;
;
; CHECK-LABEL: @outlined_ir_func_0(
; CHECK-NEXT:  newFuncRoot:
; CHECK-NEXT:    br label [[ENTRY_TO_OUTLINE:%.*]]
; CHECK:       entry_to_outline:
; CHECK-NEXT:    store i32 2, ptr [[TMP0:%.*]], align 4
; CHECK-NEXT:    store i32 3, ptr [[TMP1:%.*]], align 4
; CHECK-NEXT:    store i32 4, ptr [[TMP2:%.*]], align 4
; CHECK-NEXT:    [[AL:%.*]] = load i32, ptr [[TMP0]], align 4
; CHECK-NEXT:    [[BL:%.*]] = load i32, ptr [[TMP1]], align 4
; CHECK-NEXT:    [[CL:%.*]] = load i32, ptr [[TMP2]], align 4
; CHECK-NEXT:    br label [[ENTRY_AFTER_OUTLINE_EXITSTUB:%.*]]
; CHECK:       entry_after_outline.exitStub:
; CHECK-NEXT:    ret void
;
;
; CHECK-LABEL: @outlined_ir_func_1(
; CHECK-NEXT:  newFuncRoot:
; CHECK-NEXT:    [[D:%.*]] = alloca i32, align 4
; CHECK-NEXT:    call void @llvm.lifetime.start.p0(i64 -1, ptr [[D]])
; CHECK-NEXT:    br label [[ENTRY_TO_OUTLINE:%.*]]
; CHECK:       entry_to_outline:
; CHECK-NEXT:    [[AL:%.*]] = add i32 [[TMP0:%.*]], [[TMP1:%.*]]
; CHECK-NEXT:    [[BL:%.*]] = add i32 [[TMP1]], [[TMP0]]
; CHECK-NEXT:    [[CL:%.*]] = add i32 [[TMP1]], [[TMP2:%.*]]
; CHECK-NEXT:    call void @llvm.lifetime.end.p0(i64 -1, ptr [[D]])
; CHECK-NEXT:    br label [[ENTRY_AFTER_OUTLINE_EXITSTUB:%.*]]
; CHECK:       entry_after_outline.exitStub:
; CHECK-NEXT:    ret void
;
