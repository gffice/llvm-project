; RUN: not llvm-as -opaque-pointers=0 -disable-output %s 2>&1 | FileCheck %s
; CHECK: ptr type is only supported in -opaque-pointers mode
define void @f(i32*) {
	%a = alloca ptr
	ret void
}
