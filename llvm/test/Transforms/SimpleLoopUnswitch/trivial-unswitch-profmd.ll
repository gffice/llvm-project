; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
;       then metadata checks MDn were added manually.
; RUN: opt -passes='loop(simple-loop-unswitch),verify<loops>' -S < %s | FileCheck %s
; RUN: opt -verify-memoryssa -passes='loop-mssa(simple-loop-unswitch),verify<loops>' -S < %s | FileCheck %s

declare void @some_func()

; Test for a trivially unswitchable switch with non-default case exiting.
define i32 @test2(ptr %var, i32 %cond1, i32 %cond2) {
; CHECK-LABEL: @test2(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    switch i32 [[COND2:%.*]], label [[ENTRY_SPLIT:%.*]] [
; CHECK-NEXT:    i32 2, label [[LOOP_EXIT2:%.*]]
; CHECK-NEXT:    ], !prof ![[MD0:[0-9]+]]
; CHECK:       entry.split:
; CHECK-NEXT:    br label [[LOOP_BEGIN:%.*]]
; CHECK:       loop_begin:
; CHECK-NEXT:    [[VAR_VAL:%.*]] = load i32, ptr [[VAR:%.*]]
; CHECK-NEXT:    switch i32 [[COND2]], label [[LOOP2:%.*]] [
; CHECK-NEXT:    i32 0, label [[LOOP0:%.*]]
; CHECK-NEXT:    i32 1, label [[LOOP1:%.*]]
; CHECK-NEXT:    ], !prof ![[MD1:[0-9]+]]
; CHECK:       loop0:
; CHECK-NEXT:    call void @some_func()
; CHECK-NEXT:    br label [[LOOP_LATCH:%.*]]
; CHECK:       loop1:
; CHECK-NEXT:    call void @some_func()
; CHECK-NEXT:    br label [[LOOP_LATCH]]
; CHECK:       loop2:
; CHECK-NEXT:    call void @some_func()
; CHECK-NEXT:    br label [[LOOP_LATCH]]
; CHECK:       loop_latch:
; CHECK-NEXT:    br label [[LOOP_BEGIN]]
; CHECK:       loop_exit1:
; CHECK-NEXT:    ret i32 0
; CHECK:       loop_exit2:
; CHECK-NEXT:    ret i32 0
; CHECK:       loop_exit3:
; CHECK-NEXT:    ret i32 0
;
entry:
  br label %loop_begin

loop_begin:
  %var_val = load i32, ptr %var
  switch i32 %cond2, label %loop2 [
  i32 0, label %loop0
  i32 1, label %loop1
  i32 2, label %loop_exit2
  ], !prof !{!"branch_weights", i32 99, i32 100, i32 101, i32 102}

loop0:
  call void @some_func()
  br label %loop_latch

loop1:
  call void @some_func()
  br label %loop_latch

loop2:
  call void @some_func()
  br label %loop_latch

loop_latch:
  br label %loop_begin

loop_exit1:
  ret i32 0

loop_exit2:
  ret i32 0

loop_exit3:
  ret i32 0
}

; Test for a trivially unswitchable switch with only the default case exiting.
define i32 @test3(ptr %var, i32 %cond1, i32 %cond2) {
; CHECK-LABEL: @test3(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    switch i32 [[COND2:%.*]], label [[LOOP_EXIT2:%.*]] [
; CHECK-NEXT:    i32 0, label [[ENTRY_SPLIT:%.*]]
; CHECK-NEXT:    i32 1, label [[ENTRY_SPLIT]]
; CHECK-NEXT:    i32 2, label [[ENTRY_SPLIT]]
; CHECK-NEXT:    ], !prof ![[MD2:[0-9]+]]
; CHECK:       entry.split:
; CHECK-NEXT:    br label [[LOOP_BEGIN:%.*]]
; CHECK:       loop_begin:
; CHECK-NEXT:    [[VAR_VAL:%.*]] = load i32, ptr [[VAR:%.*]]
; CHECK-NEXT:    switch i32 [[COND2]], label [[LOOP2:%.*]] [
; CHECK-NEXT:    i32 0, label [[LOOP0:%.*]]
; CHECK-NEXT:    i32 1, label [[LOOP1:%.*]]
; CHECK-NEXT:    ], !prof ![[MD3:[0-9]+]]
; CHECK:       loop0:
; CHECK-NEXT:    call void @some_func()
; CHECK-NEXT:    br label [[LOOP_LATCH:%.*]]
; CHECK:       loop1:
; CHECK-NEXT:    call void @some_func()
; CHECK-NEXT:    br label [[LOOP_LATCH]]
; CHECK:       loop2:
; CHECK-NEXT:    call void @some_func()
; CHECK-NEXT:    br label [[LOOP_LATCH]]
; CHECK:       loop_latch:
; CHECK-NEXT:    br label [[LOOP_BEGIN]]
; CHECK:       loop_exit1:
; CHECK-NEXT:    ret i32 0
; CHECK:       loop_exit2:
; CHECK-NEXT:    ret i32 0
; CHECK:       loop_exit3:
; CHECK-NEXT:    ret i32 0
;
entry:
  br label %loop_begin

loop_begin:
  %var_val = load i32, ptr %var
  switch i32 %cond2, label %loop_exit2 [
  i32 0, label %loop0
  i32 1, label %loop1
  i32 2, label %loop2
  ], !prof !{!"branch_weights", i32 99, i32 100, i32 101, i32 102}

loop0:
  call void @some_func()
  br label %loop_latch

loop1:
  call void @some_func()
  br label %loop_latch

loop2:
  call void @some_func()
  br label %loop_latch

loop_latch:
  br label %loop_begin

loop_exit1:
  ret i32 0

loop_exit2:
  ret i32 0

loop_exit3:
  ret i32 0
}

; Test for a trivially unswitchable switch with multiple exiting cases and
; multiple looping cases.
define i32 @test4(ptr %var, i32 %cond1, i32 %cond2) {
; CHECK-LABEL: @test4(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    switch i32 [[COND2:%.*]], label [[LOOP_EXIT2:%.*]] [
; CHECK-NEXT:    i32 13, label [[LOOP_EXIT1:%.*]]
; CHECK-NEXT:    i32 42, label [[LOOP_EXIT3:%.*]]
; CHECK-NEXT:    i32 0, label [[ENTRY_SPLIT:%.*]]
; CHECK-NEXT:    i32 1, label [[ENTRY_SPLIT]]
; CHECK-NEXT:    i32 2, label [[ENTRY_SPLIT]]
; CHECK-NEXT:    ], !prof ![[MD4:[0-9]+]]
; CHECK:       entry.split:
; CHECK-NEXT:    br label [[LOOP_BEGIN:%.*]]
; CHECK:       loop_begin:
; CHECK-NEXT:    [[VAR_VAL:%.*]] = load i32, ptr [[VAR:%.*]]
; CHECK-NEXT:    switch i32 [[COND2]], label [[LOOP2:%.*]] [
; CHECK-NEXT:    i32 0, label [[LOOP0:%.*]]
; CHECK-NEXT:    i32 1, label [[LOOP1:%.*]]
; CHECK-NEXT:    ], !prof ![[MD3:[0-9]+]]
; CHECK:       loop0:
; CHECK-NEXT:    call void @some_func()
; CHECK-NEXT:    br label [[LOOP_LATCH:%.*]]
; CHECK:       loop1:
; CHECK-NEXT:    call void @some_func()
; CHECK-NEXT:    br label [[LOOP_LATCH]]
; CHECK:       loop2:
; CHECK-NEXT:    call void @some_func()
; CHECK-NEXT:    br label [[LOOP_LATCH]]
; CHECK:       loop_latch:
; CHECK-NEXT:    br label [[LOOP_BEGIN]]
; CHECK:       loop_exit1:
; CHECK-NEXT:    ret i32 0
; CHECK:       loop_exit2:
; CHECK-NEXT:    ret i32 0
; CHECK:       loop_exit3:
; CHECK-NEXT:    ret i32 0
;
entry:
  br label %loop_begin

loop_begin:
  %var_val = load i32, ptr %var
  switch i32 %cond2, label %loop_exit2 [
  i32 0, label %loop0
  i32 1, label %loop1
  i32 13, label %loop_exit1
  i32 2, label %loop2
  i32 42, label %loop_exit3
  ], !prof !{!"branch_weights", i32 99, i32 100, i32 101, i32 113, i32 102, i32 142}

loop0:
  call void @some_func()
  br label %loop_latch

loop1:
  call void @some_func()
  br label %loop_latch

loop2:
  call void @some_func()
  br label %loop_latch

loop_latch:
  br label %loop_begin

loop_exit1:
  ret i32 0

loop_exit2:
  ret i32 0

loop_exit3:
  ret i32 0
}

; CHECK: ![[MD0]] = !{!"branch_weights", i32 300, i32 102}
; CHECK: ![[MD1]] = !{!"branch_weights", i32 99, i32 100, i32 101}
; CHECK: ![[MD2]] = !{!"branch_weights", i32 99, i32 100, i32 101, i32 102}
; CHECK: ![[MD3]] = !{!"branch_weights", i32 102, i32 100, i32 101}
; CHECK: ![[MD4]] = !{!"branch_weights", i32 99, i32 113, i32 142, i32 100, i32 101, i32 102}
