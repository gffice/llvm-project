// RUN: %clang_cc1 -triple riscv32 -emit-llvm %s -o - | FileCheck %s

// This file contains test cases that will have different output for ilp32 vs
// the other 32-bit ABIs.

#include <stddef.h>
#include <stdint.h>

struct tiny {
  uint8_t a, b, c, d;
};

struct small {
  int32_t a, *b;
};

struct small_aligned {
  int64_t a;
};

struct large {
  int32_t a, b, c, d;
};

// Scalars passed on the stack should have signext/zeroext attributes, just as
// if they were passed in registers.

// CHECK-LABEL: define{{.*}} i32 @f_scalar_stack_1(i32 noundef %a, i64 noundef %b, float noundef %c, double noundef %d, fp128 noundef %e, i8 noundef zeroext %f, i8 noundef signext %g, i8 noundef zeroext %h)
int f_scalar_stack_1(int32_t a, int64_t b, float c, double d, long double e,
                     uint8_t f, int8_t g, uint8_t h) {
  return g + h;
}

// CHECK-LABEL: define{{.*}} void @f_scalar_stack_2(ptr noalias sret(%struct.large) align 4 %agg.result, float noundef %a, i64 noundef %b, double noundef %c, fp128 noundef %d, i8 noundef zeroext %e, i8 noundef signext %f, i8 noundef zeroext %g)
struct large f_scalar_stack_2(float a, int64_t b, double c, long double d,
                              uint8_t e, int8_t f, uint8_t g) {
  return (struct large){a, e, f, g};
}

// Aggregates and >=XLen scalars passed on the stack should be lowered just as
// they would be if passed via registers.

// CHECK-LABEL: define{{.*}} void @f_scalar_stack_3(double noundef %a, i64 noundef %b, double noundef %c, i64 noundef %d, i32 noundef %e, i64 noundef %f, float noundef %g, double noundef %h, fp128 noundef %i)
void f_scalar_stack_3(double a, int64_t b, double c, int64_t d, int e,
                      int64_t f, float g, double h, long double i) {}

// CHECK-LABEL: define{{.*}} void @f_agg_stack(double noundef %a, i64 noundef %b, double noundef %c, i64 noundef %d, i32 %e.coerce, [2 x i32] %f.coerce, i64 %g.coerce, ptr noundef %h)
void f_agg_stack(double a, int64_t b, double c, int64_t d, struct tiny e,
                 struct small f, struct small_aligned g, struct large h) {}
