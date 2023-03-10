; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt %loadexampleirtransforms -passes=tut-simplifycfg -tut-simplifycfg-version=v1 < %s -S -verify-dom-info | FileCheck %s
; RUN: opt %loadexampleirtransforms -passes=tut-simplifycfg -tut-simplifycfg-version=v2 < %s -S -verify-dom-info | FileCheck %s
; RUN: opt %loadexampleirtransforms -passes=tut-simplifycfg -tut-simplifycfg-version=v3 < %s -S -verify-dom-info | FileCheck %s

define void @test() {
; CHECK-LABEL: @test(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    switch i32 undef, label [[SW_DEFAULT23:%.*]] [
; CHECK-NEXT:    i32 129, label [[SW_BB:%.*]]
; CHECK-NEXT:    i32 215, label [[SW_BB1:%.*]]
; CHECK-NEXT:    i32 117, label [[SW_BB1]]
; CHECK-NEXT:    i32 207, label [[SW_BB1]]
; CHECK-NEXT:    i32 158, label [[SW_BB1]]
; CHECK-NEXT:    i32 94, label [[SW_BB1]]
; CHECK-NEXT:    i32 219, label [[SW_BB1]]
; CHECK-NEXT:    i32 88, label [[SW_BB1]]
; CHECK-NEXT:    i32 168, label [[SW_BB1]]
; CHECK-NEXT:    i32 295, label [[SW_BB1]]
; CHECK-NEXT:    i32 294, label [[SW_BB1]]
; CHECK-NEXT:    i32 296, label [[SW_BB1]]
; CHECK-NEXT:    i32 67, label [[SW_BB1]]
; CHECK-NEXT:    i32 293, label [[SW_BB1]]
; CHECK-NEXT:    i32 382, label [[SW_BB1]]
; CHECK-NEXT:    i32 335, label [[SW_BB1]]
; CHECK-NEXT:    i32 393, label [[SW_BB1]]
; CHECK-NEXT:    i32 415, label [[SW_BB1]]
; CHECK-NEXT:    i32 400, label [[SW_BB1]]
; CHECK-NEXT:    i32 383, label [[SW_BB1]]
; CHECK-NEXT:    i32 421, label [[SW_BB1]]
; CHECK-NEXT:    i32 422, label [[SW_BB1]]
; CHECK-NEXT:    i32 302, label [[SW_BB1]]
; CHECK-NEXT:    i32 303, label [[SW_BB1]]
; CHECK-NEXT:    i32 304, label [[SW_BB1]]
; CHECK-NEXT:    i32 420, label [[SW_BB1]]
; CHECK-NEXT:    i32 401, label [[SW_EPILOG24:%.*]]
; CHECK-NEXT:    i32 53, label [[SW_BB12:%.*]]
; CHECK-NEXT:    i32 44, label [[SW_BB12]]
; CHECK-NEXT:    ]
; CHECK:       sw.bb:
; CHECK-NEXT:    unreachable
; CHECK:       sw.bb1:
; CHECK-NEXT:    br label [[SW_EPILOG24]]
; CHECK:       sw.bb12:
; CHECK-NEXT:    switch i32 undef, label [[SW_DEFAULT:%.*]] [
; CHECK-NEXT:    i32 47, label [[SW_BB13:%.*]]
; CHECK-NEXT:    i32 8, label [[SW_BB13]]
; CHECK-NEXT:    ]
; CHECK:       sw.bb13:
; CHECK-NEXT:    unreachable
; CHECK:       sw.default:
; CHECK-NEXT:    unreachable
; CHECK:       sw.default23:
; CHECK-NEXT:    unreachable
; CHECK:       sw.epilog24:
; CHECK-NEXT:    [[PREVIOUS_3:%.*]] = phi i32 [ undef, [[SW_BB1]] ], [ 401, [[ENTRY:%.*]] ]
; CHECK-NEXT:    unreachable
;
entry:
  br label %while.body

while.body:                                       ; preds = %entry
  switch i32 undef, label %sw.default23 [
  i32 129, label %sw.bb
  i32 215, label %sw.bb1
  i32 117, label %sw.bb1
  i32 207, label %sw.bb1
  i32 158, label %sw.bb1
  i32 94, label %sw.bb1
  i32 219, label %sw.bb1
  i32 88, label %sw.bb1
  i32 168, label %sw.bb1
  i32 295, label %sw.bb1
  i32 294, label %sw.bb1
  i32 296, label %sw.bb1
  i32 67, label %sw.bb1
  i32 293, label %sw.bb1
  i32 382, label %sw.bb1
  i32 335, label %sw.bb1
  i32 393, label %sw.bb1
  i32 415, label %sw.bb1
  i32 400, label %sw.bb1
  i32 383, label %sw.bb1
  i32 421, label %sw.bb1
  i32 422, label %sw.bb1
  i32 302, label %sw.bb1
  i32 303, label %sw.bb1
  i32 304, label %sw.bb1
  i32 420, label %sw.bb1
  i32 401, label %sw.epilog24
  i32 53, label %sw.bb12
  i32 44, label %sw.bb12
  ]

sw.bb:                                            ; preds = %while.body
  unreachable

sw.bb1:                                           ; preds = %while.body, %while.body, %while.body, %while.body, %while.body, %while.body, %while.body, %while.body, %while.body, %while.body, %while.body, %while.body, %while.body, %while.body, %while.body, %while.body, %while.body, %while.body, %while.body, %while.body, %while.body, %while.body, %while.body, %while.body, %while.body
  br i1 false, label %land.lhs.true, label %sw.epilog24

land.lhs.true:                                    ; preds = %sw.bb1
  br label %sw.epilog24

sw.bb12:                                          ; preds = %while.body, %while.body
  switch i32 undef, label %sw.default [
  i32 47, label %sw.bb13
  i32 8, label %sw.bb13
  ]

sw.bb13:                                          ; preds = %sw.bb12, %sw.bb12
  unreachable

sw.default:                                       ; preds = %sw.bb12
  unreachable

sw.default23:                                     ; preds = %while.body
  unreachable

sw.epilog24:                                      ; preds = %land.lhs.true, %sw.bb1, %while.body
  %Previous.3 = phi i32 [ undef, %land.lhs.true ], [ undef, %sw.bb1 ], [ 401, %while.body ]
  unreachable
}
