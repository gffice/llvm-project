// Test host codegen.
// RUN: %clang_cc1 -no-opaque-pointers -verify -fopenmp -x c++ -triple powerpc64le-unknown-unknown -fopenmp-targets=powerpc64le-ibm-linux-gnu -emit-llvm %s -o - | FileCheck %s --check-prefix CHECK --check-prefix CHECK-64
// RUN: %clang_cc1 -no-opaque-pointers -fopenmp -x c++ -std=c++11 -triple powerpc64le-unknown-unknown -fopenmp-targets=powerpc64le-ibm-linux-gnu -emit-pch -o %t %s
// RUN: %clang_cc1 -no-opaque-pointers -fopenmp -x c++ -triple powerpc64le-unknown-unknown -fopenmp-targets=powerpc64le-ibm-linux-gnu -std=c++11 -include-pch %t -verify %s -emit-llvm -o - | FileCheck %s --check-prefix CHECK --check-prefix CHECK-64
// RUN: %clang_cc1 -no-opaque-pointers -verify -fopenmp -x c++ -triple i386-unknown-unknown -fopenmp-targets=i386-pc-linux-gnu -emit-llvm %s -o - | FileCheck %s --check-prefix CHECK --check-prefix CHECK-32
// RUN: %clang_cc1 -no-opaque-pointers -fopenmp -x c++ -std=c++11 -triple i386-unknown-unknown -fopenmp-targets=i386-pc-linux-gnu -emit-pch -o %t %s
// RUN: %clang_cc1 -no-opaque-pointers -fopenmp -x c++ -triple i386-unknown-unknown -fopenmp-targets=i386-pc-linux-gnu -std=c++11 -include-pch %t -verify %s -emit-llvm -o - | FileCheck %s --check-prefix CHECK --check-prefix CHECK-32

// RUN: %clang_cc1 -no-opaque-pointers -verify -fopenmp-simd -x c++ -triple powerpc64le-unknown-unknown -fopenmp-targets=powerpc64le-ibm-linux-gnu -emit-llvm %s -o - | FileCheck --check-prefix SIMD-ONLY0 %s
// RUN: %clang_cc1 -no-opaque-pointers -fopenmp-simd -x c++ -std=c++11 -triple powerpc64le-unknown-unknown -fopenmp-targets=powerpc64le-ibm-linux-gnu -emit-pch -o %t %s
// RUN: %clang_cc1 -no-opaque-pointers -fopenmp-simd -x c++ -triple powerpc64le-unknown-unknown -fopenmp-targets=powerpc64le-ibm-linux-gnu -std=c++11 -include-pch %t -verify %s -emit-llvm -o - | FileCheck --check-prefix SIMD-ONLY0 %s
// RUN: %clang_cc1 -no-opaque-pointers -verify -fopenmp-simd -x c++ -triple i386-unknown-unknown -fopenmp-targets=i386-pc-linux-gnu -emit-llvm %s -o - | FileCheck --check-prefix SIMD-ONLY0 %s
// RUN: %clang_cc1 -no-opaque-pointers -fopenmp-simd -x c++ -std=c++11 -triple i386-unknown-unknown -fopenmp-targets=i386-pc-linux-gnu -emit-pch -o %t %s
// RUN: %clang_cc1 -no-opaque-pointers -fopenmp-simd -x c++ -triple i386-unknown-unknown -fopenmp-targets=i386-pc-linux-gnu -std=c++11 -include-pch %t -verify %s -emit-llvm -o - | FileCheck --check-prefix SIMD-ONLY0 %s
// SIMD-ONLY0-NOT: {{__kmpc|__tgt}}

// Test target codegen - host bc file has to be created first.
// RUN: %clang_cc1 -no-opaque-pointers -verify -fopenmp -x c++ -triple powerpc64le-unknown-unknown -fopenmp-targets=powerpc64le-ibm-linux-gnu -emit-llvm-bc %s -o %t-ppc-host.bc
// RUN: %clang_cc1 -no-opaque-pointers -verify -fopenmp -x c++ -triple powerpc64le-unknown-unknown -fopenmp-targets=powerpc64le-ibm-linux-gnu -emit-llvm %s -fopenmp-is-device -fopenmp-host-ir-file-path %t-ppc-host.bc -o - | FileCheck %s --check-prefix TCHECK --check-prefix TCHECK-64
// RUN: %clang_cc1 -no-opaque-pointers -fopenmp -x c++ -std=c++11 -triple powerpc64le-unknown-unknown -fopenmp-targets=powerpc64le-ibm-linux-gnu -emit-pch -fopenmp-is-device -fopenmp-host-ir-file-path %t-ppc-host.bc -o %t %s
// RUN: %clang_cc1 -no-opaque-pointers -fopenmp -x c++ -triple powerpc64le-unknown-unknown -fopenmp-targets=powerpc64le-ibm-linux-gnu -std=c++11 -fopenmp-is-device -fopenmp-host-ir-file-path %t-ppc-host.bc -include-pch %t -verify %s -emit-llvm -o - | FileCheck %s --check-prefix TCHECK --check-prefix TCHECK-64
// RUN: %clang_cc1 -no-opaque-pointers -verify -fopenmp -x c++ -triple i386-unknown-unknown -fopenmp-targets=i386-pc-linux-gnu -emit-llvm-bc %s -o %t-x86-host.bc
// RUN: %clang_cc1 -no-opaque-pointers -verify -fopenmp -x c++ -triple i386-unknown-unknown -fopenmp-targets=i386-pc-linux-gnu -emit-llvm %s -fopenmp-is-device -fopenmp-host-ir-file-path %t-x86-host.bc -o - | FileCheck %s --check-prefix TCHECK --check-prefix TCHECK-32
// RUN: %clang_cc1 -no-opaque-pointers -fopenmp -x c++ -std=c++11 -triple i386-unknown-unknown -fopenmp-targets=i386-pc-linux-gnu -emit-pch -fopenmp-is-device -fopenmp-host-ir-file-path %t-x86-host.bc -o %t %s
// RUN: %clang_cc1 -no-opaque-pointers -fopenmp -x c++ -triple i386-unknown-unknown -fopenmp-targets=i386-pc-linux-gnu -std=c++11 -fopenmp-is-device -fopenmp-host-ir-file-path %t-x86-host.bc -include-pch %t -verify %s -emit-llvm -o - | FileCheck %s --check-prefix TCHECK --check-prefix TCHECK-32

// RUN: %clang_cc1 -no-opaque-pointers -verify -fopenmp-simd -x c++ -triple powerpc64le-unknown-unknown -fopenmp-targets=powerpc64le-ibm-linux-gnu -emit-llvm-bc %s -o %t-ppc-host.bc
// RUN: %clang_cc1 -no-opaque-pointers -verify -fopenmp-simd -x c++ -triple powerpc64le-unknown-unknown -fopenmp-targets=powerpc64le-ibm-linux-gnu -emit-llvm %s -fopenmp-is-device -fopenmp-host-ir-file-path %t-ppc-host.bc -o - | FileCheck --check-prefix SIMD-ONLY1 %s
// RUN: %clang_cc1 -no-opaque-pointers -fopenmp-simd -x c++ -std=c++11 -triple powerpc64le-unknown-unknown -fopenmp-targets=powerpc64le-ibm-linux-gnu -emit-pch -fopenmp-is-device -fopenmp-host-ir-file-path %t-ppc-host.bc -o %t %s
// RUN: %clang_cc1 -no-opaque-pointers -fopenmp-simd -x c++ -triple powerpc64le-unknown-unknown -fopenmp-targets=powerpc64le-ibm-linux-gnu -std=c++11 -fopenmp-is-device -fopenmp-host-ir-file-path %t-ppc-host.bc -include-pch %t -verify %s -emit-llvm -o - | FileCheck --check-prefix SIMD-ONLY1 %s
// RUN: %clang_cc1 -no-opaque-pointers -verify -fopenmp-simd -x c++ -triple i386-unknown-unknown -fopenmp-targets=i386-pc-linux-gnu -emit-llvm-bc %s -o %t-x86-host.bc
// RUN: %clang_cc1 -no-opaque-pointers -verify -fopenmp-simd -x c++ -triple i386-unknown-unknown -fopenmp-targets=i386-pc-linux-gnu -emit-llvm %s -fopenmp-is-device -fopenmp-host-ir-file-path %t-x86-host.bc -o - | FileCheck --check-prefix SIMD-ONLY1 %s
// RUN: %clang_cc1 -no-opaque-pointers -fopenmp-simd -x c++ -std=c++11 -triple i386-unknown-unknown -fopenmp-targets=i386-pc-linux-gnu -emit-pch -fopenmp-is-device -fopenmp-host-ir-file-path %t-x86-host.bc -o %t %s
// RUN: %clang_cc1 -no-opaque-pointers -fopenmp-simd -x c++ -triple i386-unknown-unknown -fopenmp-targets=i386-pc-linux-gnu -std=c++11 -fopenmp-is-device -fopenmp-host-ir-file-path %t-x86-host.bc -include-pch %t -verify %s -emit-llvm -o - | FileCheck --check-prefix SIMD-ONLY1 %s
// SIMD-ONLY1-NOT: {{__kmpc|__tgt}}

// expected-no-diagnostics
#ifndef HEADER
#define HEADER

// CHECK-DAG: [[TT:%.+]] = type { i64, i8 }
// CHECK-DAG: [[ENTTY:%.+]] = type { i8*, i8*, i[[SZ:32|64]], i32, i32 }

// TCHECK: [[ENTTY:%.+]] = type { i8*, i8*, i{{32|64}}, i32, i32 }

// CHECK-DAG: [[SIZET:@.+]] = private unnamed_addr constant [3 x i64] [i64 0, i64 4, i64 {{16|12}}]
// CHECK-DAG: [[MAPT:@.+]] = private unnamed_addr constant [3 x i64] [i64 544, i64 800, i64 3]
// CHECK-DAG: @{{.*}} = weak constant i8 0

// TCHECK: @{{.+}} = weak constant [[ENTTY]]
// TCHECK: @{{.+}} = {{.*}}constant [[ENTTY]]
// TCHECK-NOT: @{{.+}} = weak constant [[ENTTY]]

// Check target registration is registered as a Ctor.
// CHECK: appending global [1 x { i32, void ()*, i8* }] [{ i32, void ()*, i8* } { i32 0, void ()* @.omp_offloading.requires_reg, i8* null }]


template<typename tx, typename ty>
struct TT{
  tx X;
  ty Y;
};

#pragma omp declare mapper(id                     \
                           : TT <long long, char> \
                               s) map(s.X, s.Y)
int global;
extern int global;

// CHECK: define {{.*}}[[FOO:@.+]](
int foo(int n) {
  int a = 0;
  short aa = 0;
  float b[10];
  float bn[n];
  double c[5][10];
  double cn[5][n];
  TT<long long, char> d;
  static long *plocal;

// CHECK:       [[ADD:%.+]] = add nsw i32
// CHECK:       store i32 [[ADD]], i32* [[DEVICE_CAP:%.+]],
// CHECK:       [[GEP:%.+]] = getelementptr inbounds %{{.+}}, %{{.+}}* %{{.+}}, i32 0, i32 0
// CHECK:       [[DEV:%.+]] = load i32, i32* [[DEVICE_CAP]],
// CHECK:       store i32 [[DEV]], i32* [[GEP]],
// CHECK:       [[TASK:%.+]] = call i8* @__kmpc_omp_task_alloc(%struct.ident_t* @1, i32 [[GTID:%.+]], i32 1, i[[SZ]] {{20|40}}, i[[SZ]] 4, i32 (i32, i8*)* bitcast (i32 (i32, %{{.+}}*)* [[TASK_ENTRY0:@.+]] to i32 (i32, i8*)*))
// CHECK:       [[BC_TASK:%.+]] = bitcast i8* [[TASK]] to [[TASK_TY0:%.+]]*
// CHECK:       getelementptr %struct.kmp_depend_info, %struct.kmp_depend_info* [[DEP_START:%.+]], i[[SZ]] 1
// CHECK:       getelementptr %struct.kmp_depend_info, %struct.kmp_depend_info* [[DEP_START]], i[[SZ]] 2
// CHECK:       getelementptr %struct.kmp_depend_info, %struct.kmp_depend_info* [[DEP_START]], i[[SZ]] 3
// CHECK:       [[DEP:%.+]] = bitcast %struct.kmp_depend_info* [[DEP_START]] to i8*
// CHECK:       call void @__kmpc_omp_taskwait_deps_51(%struct.ident_t* @1, i32 [[GTID]], i32 4, i8* [[DEP]], i32 0, i8* null, i32 0)
// CHECK:       call void @__kmpc_omp_task_begin_if0(%struct.ident_t* @1, i32 [[GTID]], i8* [[TASK]])
// CHECK:       call i32 [[TASK_ENTRY0]](i32 [[GTID]], [[TASK_TY0]]* [[BC_TASK]])
// CHECK:       call void @__kmpc_omp_task_complete_if0(%struct.ident_t* @1, i32 [[GTID]], i8* [[TASK]])
#pragma omp target device(global + a) depend(in                   \
                                             : global) depend(out \
                                                              : a, b, cn[4])
  {
  }

  // CHECK:       [[ADD:%.+]] = add nsw i32
  // CHECK:       store i32 [[ADD]], i32* [[DEVICE_CAP:%.+]],

  // CHECK:       [[BOOL:%.+]] = icmp ne i32 %{{.+}}, 0
  // CHECK:       br i1 [[BOOL]], label %[[THEN:.+]], label %[[ELSE:.+]]
  // CHECK:       [[THEN]]:
  // CHECK-DAG:   [[BPADDR0:%.+]] = getelementptr inbounds [3 x i8*], [3 x i8*]* [[BP:%.+]], i32 0, i32 0
  // CHECK-DAG:   [[PADDR0:%.+]] = getelementptr inbounds [3 x i8*], [3 x i8*]* [[P:%.+]], i32 0, i32 0
  // CHECK-DAG:   [[MADDR0:%.+]] = getelementptr inbounds [3 x i8*], [3 x i8*]* [[M:%.+]], i[[SZ]] 0, i[[SZ]] 0
  // CHECK-DAG:   [[CBPADDR0:%.+]] = bitcast i8** [[BPADDR0]] to i[[SZ]]**
  // CHECK-DAG:   [[CPADDR0:%.+]] = bitcast i8** [[PADDR0]] to i[[SZ]]**
  // CHECK-DAG:   store i[[SZ]]* [[BP0:%[^,]+]], i[[SZ]]** [[CBPADDR0]]
  // CHECK-DAG:   store i[[SZ]]* [[BP0]], i[[SZ]]** [[CPADDR0]]
  // CHECK-DAG:   store i8* null, i8** [[MADDR0]],

  // CHECK-DAG:   [[BPADDR1:%.+]] = getelementptr inbounds [3 x i8*], [3 x i8*]* [[BP]], i32 0, i32 1
  // CHECK-DAG:   [[PADDR1:%.+]] = getelementptr inbounds [3 x i8*], [3 x i8*]* [[P]], i32 0, i32 1
  // CHECK-DAG:   [[MADDR1:%.+]] = getelementptr inbounds [3 x i8*], [3 x i8*]* [[M]], i[[SZ]] 0, i[[SZ]] 1
  // CHECK-DAG:   [[CBPADDR1:%.+]] = bitcast i8** [[BPADDR1]] to i[[SZ]]*
  // CHECK-DAG:   [[CPADDR1:%.+]] = bitcast i8** [[PADDR1]] to i[[SZ]]*
  // CHECK-DAG:   store i[[SZ]] [[BP1:%[^,]+]], i[[SZ]]* [[CBPADDR1]]
  // CHECK-DAG:   store i[[SZ]] [[BP1]], i[[SZ]]* [[CPADDR1]]
  // CHECK-DAG:   store i8* null, i8** [[MADDR1]],

  // CHECK-DAG:   [[BPADDR2:%.+]] = getelementptr inbounds [3 x i8*], [3 x i8*]* [[BP]], i32 0, i32 2
  // CHECK-DAG:   [[PADDR2:%.+]] = getelementptr inbounds [3 x i8*], [3 x i8*]* [[P]], i32 0, i32 2
  // CHECK-DAG:   [[MADDR2:%.+]] = getelementptr inbounds [3 x i8*], [3 x i8*]* [[M]], i[[SZ]] 0, i[[SZ]] 2
  // CHECK-DAG:   [[CBPADDR2:%.+]] = bitcast i8** [[BPADDR2]] to [[STRUCT_TT:%.+]]**
  // CHECK-DAG:   [[CPADDR2:%.+]] = bitcast i8** [[PADDR2]] to [[STRUCT_TT]]**
  // CHECK-DAG:   store [[STRUCT_TT]]* [[D_ADDR:%.+]], [[STRUCT_TT]]** [[CBPADDR2]]
  // CHECK-DAG:   store [[STRUCT_TT]]* [[D_ADDR]], [[STRUCT_TT]]** [[CPADDR2]]
  // CHECK-DAG:   store i8* bitcast (void (i8*, i8*, i8*, i64, i64, i8*)* [[MAPPER_ID:@.+]] to i8*), i8** [[MADDR2]],

  // CHECK-DAG:   [[BP_START:%.+]] = getelementptr inbounds [3 x i8*], [3 x i8*]* [[BP]], i32 0, i32 0
  // CHECK-DAG:   [[P_START:%.+]] = getelementptr inbounds [3 x i8*], [3 x i8*]* [[P]], i32 0, i32 0
  // CHECK-DAG:   [[M_START:%.+]] = bitcast [3 x i8*]* [[M]] to i8**
  // CHECK:       [[GEP:%.+]] = getelementptr inbounds %{{.+}}, %{{.+}}* %{{.+}}, i32 0, i32 2
  // CHECK:       [[DEV:%.+]] = load i32, i32* [[DEVICE_CAP]],
  // CHECK:       store i32 [[DEV]], i32* [[GEP]],
  // CHECK:       [[DEV1:%.+]] = load i32, i32* [[DEVICE_CAP]],
  // CHECK:       [[DEV2:%.+]] = sext i32 [[DEV1]] to i64

  // CHECK:       [[TASK:%.+]] = call i8* @__kmpc_omp_target_task_alloc(%struct.ident_t* @{{.*}}, i32 [[GTID]], i32 1, i[[SZ]] {{152|88}}, i[[SZ]] {{16|12}}, i32 (i32, i8*)* bitcast (i32 (i32, %{{.+}}*)* [[TASK_ENTRY1_:@.+]] to i32 (i32, i8*)*), i64 [[DEV2]])
  // CHECK:       [[BC_TASK:%.+]] = bitcast i8* [[TASK]] to [[TASK_TY1_:%.+]]*
  // CHECK:       [[BASE:%.+]] = getelementptr inbounds [[TASK_TY1_]], [[TASK_TY1_]]* [[BC_TASK]], i32 0, i32 1
  // CHECK-64:    [[BP_BASE:%.+]] = getelementptr inbounds [[PRIVS_TY:%.+]], [[PRIVS_TY:%.+]]* [[BASE]], i32 0, i32 1
  // CHECK-64:    [[BP_CAST:%.+]] = bitcast [3 x i8*]* [[BP_BASE]] to i8*
  // CHECK-64:    [[BP_SRC:%.+]] = bitcast i8** [[BP_START]] to i8*
  // CHECK-64:    call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 8 [[BP_CAST]], i8* align 8 [[BP_SRC]], i64 24, i1 false)
  // CHECK-64:    [[P_BASE:%.+]] = getelementptr inbounds [[PRIVS_TY]], [[PRIVS_TY]]* [[BASE]], i32 0, i32 2
  // CHECK-64:    [[P_CAST:%.+]] = bitcast [3 x i8*]* [[P_BASE]] to i8*
  // CHECK-64:    [[P_SRC:%.+]] = bitcast i8** [[P_START]] to i8*
  // CHECK-64:    call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 8 [[P_CAST]], i8* align 8 [[P_SRC]], i64 24, i1 false)
  // CHECK-64:    [[SZ_BASE:%.+]] = getelementptr inbounds [[PRIVS_TY]], [[PRIVS_TY]]* [[BASE]], i32 0, i32 3
  // CHECK-64:    [[SZ_CAST:%.+]] = bitcast [3 x i64]* [[SZ_BASE]] to i8*
  // CHECK-64:    call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 8 [[SZ_CAST]], i8* align 8 bitcast ([3 x i64]* [[SIZET]] to i8*), i64 24, i1 false)
  // CHECK-64:    [[M_BASE:%.+]] = getelementptr inbounds [[PRIVS_TY]], [[PRIVS_TY]]* [[BASE]], i32 0, i32 4
  // CHECK-64:    [[M_CAST:%.+]] = bitcast [3 x i8*]* [[M_BASE]] to i8*
  // CHECK-64:    [[M_SRC:%.+]] = bitcast i8** [[M_START]] to i8*
  // CHECK-64:    call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 8 [[M_CAST]], i8* align 8 [[M_SRC]], i64 24, i1 false)
  // CHECK-32:    [[SZ_BASE:%.+]] = getelementptr inbounds [[PRIVS_TY:%.+]], [[PRIVS_TY:%.+]]* [[BASE]], i32 0, i32 0
  // CHECK-32:    [[SZ_CAST:%.+]] = bitcast [3 x i64]* [[SZ_BASE]] to i8*
  // CHECK-32:    call void @llvm.memcpy.p0i8.p0i8.i32(i8* align 4 [[SZ_CAST]], i8* align 4 bitcast ([3 x i64]* [[SIZET]] to i8*), i32 24, i1 false)
  // CHECK-32:    [[BP_BASE:%.+]] = getelementptr inbounds [[PRIVS_TY]], [[PRIVS_TY]]* [[BASE]], i32 0, i32 3
  // CHECK-32:    [[BP_CAST:%.+]] = bitcast [3 x i8*]* [[BP_BASE]] to i8*
  // CHECK-32:    [[BP_SRC:%.+]] = bitcast i8** [[BP_START]] to i8*
  // CHECK-32:    call void @llvm.memcpy.p0i8.p0i8.i32(i8* align 4 [[BP_CAST]], i8* align 4 [[BP_SRC]], i32 12, i1 false)
  // CHECK-32:    [[P_BASE:%.+]] = getelementptr inbounds [[PRIVS_TY]], [[PRIVS_TY]]* [[BASE]], i32 0, i32 4
  // CHECK-32:    [[P_CAST:%.+]] = bitcast [3 x i8*]* [[P_BASE]] to i8*
  // CHECK-32:    [[P_SRC:%.+]] = bitcast i8** [[P_START]] to i8*
  // CHECK-32:    call void @llvm.memcpy.p0i8.p0i8.i32(i8* align 4 [[P_CAST]], i8* align 4 [[P_SRC]], i32 12, i1 false)
  // CHECK-32:    [[M_BASE:%.+]] = getelementptr inbounds [[PRIVS_TY]], [[PRIVS_TY]]* [[BASE]], i32 0, i32 5
  // CHECK-32:    [[M_CAST:%.+]] = bitcast [3 x i8*]* [[M_BASE]] to i8*
  // CHECK-32:    [[M_SRC:%.+]] = bitcast i8** [[M_START]] to i8*
  // CHECK-32:    call void @llvm.memcpy.p0i8.p0i8.i32(i8* align 4 [[M_CAST]], i8* align 4 [[M_SRC]], i32 12, i1 false)
  // CHECK:       getelementptr %struct.kmp_depend_info, %struct.kmp_depend_info* [[DEP_START:%.+]], i[[SZ]] 1
  // CHECK:       getelementptr %struct.kmp_depend_info, %struct.kmp_depend_info* [[DEP_START]], i[[SZ]] 2
  // CHECK:       [[DEP:%.+]] = bitcast %struct.kmp_depend_info* [[DEP_START]] to i8*
  // CHECK:       call i32 @__kmpc_omp_task_with_deps(%struct.ident_t* @1, i32 [[GTID]], i8* [[TASK]], i32 3, i8* [[DEP]], i32 0, i8* null)
  // CHECK:       br label %[[EXIT:.+]]

  // CHECK:       [[ELSE]]:
  // CHECK-NOT:   getelementptr inbounds [2 x i8*], [2 x i8*]*
  // CHECK:       [[GEP:%.+]] = getelementptr inbounds %{{.+}}, %{{.+}}* %{{.+}}, i32 0, i32 2
  // CHECK:       [[DEV:%.+]] = load i32, i32* [[DEVICE_CAP]],
  // CHECK:       store i32 [[DEV]], i32* [[GEP]],
  // CHECK:       [[DEV1:%.+]] = load i32, i32* [[DEVICE_CAP]],
  // CHECK:       [[DEV2:%.+]] = sext i32 [[DEV1]] to i64

  // CHECK:       [[TASK:%.+]] = call i8* @__kmpc_omp_target_task_alloc(%struct.ident_t* @1, i32 [[GTID]], i32 1, i[[SZ]] {{56|28}}, i[[SZ]] {{16|12}}, i32 (i32, i8*)* bitcast (i32 (i32, %{{.+}}*)* [[TASK_ENTRY1__:@.+]] to i32 (i32, i8*)*), i64 [[DEV2]])
  // CHECK:       [[BC_TASK:%.+]] = bitcast i8* [[TASK]] to [[TASK_TY1__:%.+]]*
  // CHECK:       getelementptr %struct.kmp_depend_info, %struct.kmp_depend_info* [[DEP_START:%.+]], i[[SZ]] 1
  // CHECK:       getelementptr %struct.kmp_depend_info, %struct.kmp_depend_info* [[DEP_START]], i[[SZ]] 2
  // CHECK:       [[DEP:%.+]] = bitcast %struct.kmp_depend_info* [[DEP_START]] to i8*
  // CHECK:       call i32 @__kmpc_omp_task_with_deps(%struct.ident_t* @1, i32 [[GTID]], i8* [[TASK]], i32 3, i8* [[DEP]], i32 0, i8* null)
  // CHECK:       br label %[[EXIT:.+]]
  // CHECK:       [[EXIT]]:

#pragma omp target device(global + a) nowait depend(inout                                          \
                                                    : global, a, bn) if (a) map(mapper(id), tofrom \
                                                                                : d)
  {
    static int local1;
    *plocal = global;
    local1 = global;
  }

// CHECK:       [[TASK:%.+]] = call i8* @__kmpc_omp_task_alloc(%struct.ident_t* @1, i32 [[GTID]], i32 1, i[[SZ]] {{48|24}}, i[[SZ]] 4, i32 (i32, i8*)* bitcast (i32 (i32, %{{.+}}*)* [[TASK_ENTRY2:@.+]] to i32 (i32, i8*)*))
// CHECK:       [[BC_TASK:%.+]] = bitcast i8* [[TASK]] to [[TASK_TY2:%.+]]*
// CHECK:       [[DEP:%.+]] = bitcast %struct.kmp_depend_info* %{{.+}} to i8*
// CHECK:       call void @__kmpc_omp_taskwait_deps_51(%struct.ident_t* @1, i32 [[GTID]], i32 1, i8* [[DEP]], i32 0, i8* null, i32 0)
// CHECK:       call void @__kmpc_omp_task_begin_if0(%struct.ident_t* @1, i32 [[GTID]], i8* [[TASK]])
// CHECK:       call i32 [[TASK_ENTRY2]](i32 [[GTID]], [[TASK_TY2]]* [[BC_TASK]])
// CHECK:       call void @__kmpc_omp_task_complete_if0(%struct.ident_t* @1, i32 [[GTID]], i8* [[TASK]])
#pragma omp target if (0) firstprivate(global) depend(out \
                                                      : global)
  {
    global += 1;
  }

  return a;
}

// Check that the offloading functions are emitted and that the arguments are
// correct and loaded correctly for the target regions in foo().

// CHECK:       define internal void [[HVT0:@.+]]()

// CHECK:       define internal{{.*}} i32 [[TASK_ENTRY0]](i32{{.*}}, [[TASK_TY0]]* noalias noundef %1)
// CHECK:       store void (i8*, ...)* null, void (i8*, ...)** %
// CHECK:       [[DEVICE_CAP:%.+]] = getelementptr inbounds %{{.+}}, %{{.+}}* %{{.+}}, i32 0, i32 0
// CHECK:       [[DEV:%.+]] = load i32, i32* [[DEVICE_CAP]],
// CHECK:       [[DEVICE:%.+]] = sext i32 [[DEV]] to i64
// CHECK:       [[RET:%.+]] = call i32 @__tgt_target_kernel(%struct.ident_t* @{{.+}}, i64 [[DEVICE]], i32 -1, i32 0, i8* @.[[TGT_REGION:.+]].region_id, %struct.__tgt_kernel_arguments* %[[KERNEL_ARGS:.+]])
// CHECK:       [[ERROR:%.+]] = icmp ne i32 [[RET]], 0
// CHECK:       br i1 [[ERROR]], label %[[FAIL:[^,]+]], label %[[END:[^,]+]]
// CHECK:       [[FAIL]]
// CHECK:       call void [[HVT0]]()
// CHECK:       br label %[[END]]
// CHECK:       [[END]]
// CHECK:       ret i32 0

// CHECK:       define internal void [[HVT1:@.+]](i[[SZ]]* noundef %{{.+}}, i[[SZ]] noundef %{{.+}})

// CHECK:       define internal void [[MAPPER_ID]](i8* noundef %{{.+}}, i8* noundef %{{.+}}, i8* noundef %{{.+}}, i64 noundef %{{.+}}, i64 noundef %{{.+}})

// CHECK:       define internal{{.*}} i32 [[TASK_ENTRY1_]](i32{{.*}}, [[TASK_TY1_]]* noalias noundef %{{.+}})
// CHECK:       [[FN:%.+]] = bitcast void (i8*, ...)* %{{.+}} to void (i8*,
// CHECK:       call void [[FN]](i8* %{{.+}}, i[[SZ]]*** %{{.+}}, i32** %{{.+}}, [3 x i8*]** [[BPTR_ADDR:%.+]], [3 x i8*]** [[PTR_ADDR:%.+]], [3 x i64]** [[SZ_ADDR:%.+]], [3 x i8*]** [[M_ADDR:%.+]])
// CHECK:       [[BPTR_REF:%.+]] = load [3 x i8*]*, [3 x i8*]** [[BPTR_ADDR]],
// CHECK:       [[PTR_REF:%.+]] = load [3 x i8*]*, [3 x i8*]** [[PTR_ADDR]],
// CHECK:       [[SZ_REF:%.+]] = load [3 x i64]*, [3 x i64]** [[SZ_ADDR]],
// CHECK:       [[M_REF:%.+]] = load [3 x i8*]*, [3 x i8*]** [[M_ADDR]],
// CHECK:       [[BPR:%.+]] = getelementptr inbounds [3 x i8*], [3 x i8*]* [[BPTR_REF]], i[[SZ]] 0, i[[SZ]] 0
// CHECK:       [[PR:%.+]] = getelementptr inbounds [3 x i8*], [3 x i8*]* [[PTR_REF]], i[[SZ]] 0, i[[SZ]] 0
// CHECK:       [[SZT:%.+]] = getelementptr inbounds [3 x i64], [3 x i64]* [[SZ_REF]], i[[SZ]] 0, i[[SZ]] 0
// CHECK:       [[M:%.+]] = getelementptr inbounds [3 x i8*], [3 x i8*]* [[M_REF]], i[[SZ]] 0, i[[SZ]] 0
// CHECK:       [[DEVICE_CAP:%.+]] = getelementptr inbounds %{{.+}}, %{{.+}}* %{{.+}}, i32 0, i32 2
// CHECK:       [[DEV:%.+]] = load i32, i32* [[DEVICE_CAP]],
// CHECK:       [[DEVICE:%.+]] = sext i32 [[DEV]] to i64
// CHECK:       [[RET:%.+]] = call i32 @__tgt_target_kernel(%struct.ident_t* @{{.+}}, i64 [[DEVICE]], i32 -1, i32 0, i8* @.[[TGT_REGION:.+]].region_id, %struct.__tgt_kernel_arguments* %[[KERNEL_ARGS:.+]])

// CHECK:       [[ERROR:%.+]] = icmp ne i32 [[RET]], 0
// CHECK:       br i1 [[ERROR]], label %[[FAIL:[^,]+]], label %[[END:[^,]+]]
// CHECK:       [[FAIL]]
// CHECK:       [[BP0:%.+]] = load i[[SZ]]*, i[[SZ]]** %
// CHECK:       [[BP1_I32:%.+]] = load i32, i32* @
// CHECK-64:    [[BP1_CAST:%.+]] = bitcast i[[SZ]]* [[BP1_PTR:%.+]] to i32*
// CHECK-64:    store i32 [[BP1_I32]], i32* [[BP1_CAST]],
// CHECK-32:    store i32 [[BP1_I32]], i32* [[BP1_PTR:%.+]],
// CHECK:       [[BP1:%.+]] = load i[[SZ]], i[[SZ]]* [[BP1_PTR]],
// CHECK:       call void [[HVT1]](i[[SZ]]* [[BP0]], i[[SZ]] [[BP1]])
// CHECK:       br label %[[END]]
// CHECK:       [[END]]
// CHECK:       ret i32 0

// CHECK:       define internal{{.*}} i32 [[TASK_ENTRY1__]](i32{{.*}}, [[TASK_TY1__]]* noalias noundef %1)
// CHECK:       [[FN:%.+]] = bitcast void (i8*, ...)* {{%.*}} to void (i8*,
// CHECK:       call void [[FN]](
// CHECK:       [[DEVICE_CAP:%.+]] = getelementptr inbounds %{{.+}}, %{{.+}}* %{{.+}}, i32 0, i32 2
// CHECK:       [[BP0:%.+]] = load i[[SZ]]*, i[[SZ]]** %
// CHECK:       [[BP1_I32:%.+]] = load i32, i32* @
// CHECK-64:    [[BP1_CAST:%.+]] = bitcast i[[SZ]]* [[BP1_PTR:%.+]] to i32*
// CHECK-64:    store i32 [[BP1_I32]], i32* [[BP1_CAST]],
// CHECK-32:    store i32 [[BP1_I32]], i32* [[BP1_PTR:%.+]],
// CHECK:       [[BP1:%.+]] = load i[[SZ]], i[[SZ]]* [[BP1_PTR]],
// CHECK:       call void [[HVT1]](i[[SZ]]* [[BP0]], i[[SZ]] [[BP1]])
// CHECK:       ret i32 0

// CHECK:       define internal void [[HVT2:@.+]](i[[SZ]] noundef %{{.+}})
// Create stack storage and store argument in there.
// CHECK:       [[AA_ADDR:%.+]] = alloca i[[SZ]], align
// CHECK:       store i[[SZ]] %{{.+}}, i[[SZ]]* [[AA_ADDR]], align
// CHECK-64:    [[AA_CADDR:%.+]] = bitcast i[[SZ]]* [[AA_ADDR]] to i32*
// CHECK-64:    load i32, i32* [[AA_CADDR]], align
// CHECK-32:    load i32, i32* [[AA_ADDR]], align

// CHECK:       define internal{{.*}} i32 [[TASK_ENTRY2]](i32{{.*}}, [[TASK_TY2]]* noalias noundef %1)
// CHECK:       [[FN:%.+]] = bitcast void (i8*, ...)* {{%.*}} to void (i8*,
// CHECK:       call void [[FN]](
// CHECK:       [[BP1_I32:%.+]] = load i32, i32* %
// CHECK-64:    [[BP1_CAST:%.+]] = bitcast i[[SZ]]* [[BP1_PTR:%.+]] to i32*
// CHECK-64:    store i32 [[BP1_I32]], i32* [[BP1_CAST]],
// CHECK-32:    store i32 [[BP1_I32]], i32* [[BP1_PTR:%.+]],
// CHECK:       [[BP1:%.+]] = load i[[SZ]], i[[SZ]]* [[BP1_PTR]],
// CHECK:       call void [[HVT2]](i[[SZ]] [[BP1]])
// CHECK:       ret i32 0

// CHECK:     define internal void @.omp_offloading.requires_reg()
// CHECK:     call void @__tgt_register_requires(i64 1)
// CHECK:     ret void

#endif
