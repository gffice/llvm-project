; RUN: opt < %s -disable-output -passes='print<assumptions>' 2>&1 | FileCheck %s

target datalayout = "e-i64:64-f80:128-n8:16:32:64-S128"

declare void @llvm.assume(i1)
declare void @llvm.experimental.guard(i1, ...)

define void @test1(i32 %a) {
; CHECK-LABEL: Cached assumptions for function: test1
; CHECK-NEXT: icmp ne i32 %{{.*}}, 0
; CHECK-NEXT: icmp slt i32 %{{.*}}, 0
; CHECK-NEXT: icmp sgt i32 %{{.*}}, 0
; CHECK-NEXT: icmp ult i32 %{{.*}}, 0
; CHECK-NEXT: icmp ugt i32 %{{.*}}, 0

entry:
  %cond1 = icmp ne i32 %a, 0
  call void @llvm.assume(i1 %cond1)
  %cond2 = icmp slt i32 %a, 0
  call void @llvm.assume(i1 %cond2)
  %cond3 = icmp sgt i32 %a, 0
  call void @llvm.assume(i1 %cond3)
  %cond4 = icmp ult i32 %a, 0
  call void (i1, ...) @llvm.experimental.guard(i1 %cond4) [ "deopt"() ]
  %cond5 = icmp ugt i32 %a, 0
  call void (i1, ...) @llvm.experimental.guard(i1 %cond5) [ "deopt"() ]

  ret void
}
