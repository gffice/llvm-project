; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -passes=mergeicmps -S | FileCheck %s --check-prefix=NOEXPANSION

%"struct.std::pair" = type { i32, i32 }

define zeroext i1 @opeq1(
; NOEXPANSION-LABEL: @opeq1(
; NOEXPANSION-NEXT:  entry:
; NOEXPANSION-NEXT:    [[TMP0:%.*]] = load i32, ptr [[A:%.*]], align 4
; NOEXPANSION-NEXT:    [[TMP1:%.*]] = load i32, ptr [[B:%.*]], align 4
; NOEXPANSION-NEXT:    [[CMP_I:%.*]] = icmp eq i32 [[TMP0]], [[TMP1]]
; NOEXPANSION-NEXT:    br i1 [[CMP_I]], label [[LAND_RHS_I:%.*]], label [[OPEQ1_EXIT:%.*]]
; NOEXPANSION:       land.rhs.i:
; NOEXPANSION-NEXT:    [[SECOND_I:%.*]] = getelementptr inbounds %"struct.std::pair", ptr [[A]], i64 0, i32 1
; NOEXPANSION-NEXT:    [[TMP2:%.*]] = load i32, ptr [[SECOND_I]], align 4
; NOEXPANSION-NEXT:    [[SECOND2_I:%.*]] = getelementptr inbounds %"struct.std::pair", ptr [[B]], i64 0, i32 1
; NOEXPANSION-NEXT:    [[TMP3:%.*]] = load i32, ptr [[SECOND2_I]], align 4
; NOEXPANSION-NEXT:    [[CMP3_I:%.*]] = icmp eq i32 [[TMP2]], [[TMP3]]
; NOEXPANSION-NEXT:    br label [[OPEQ1_EXIT]]
; NOEXPANSION:       opeq1.exit:
; NOEXPANSION-NEXT:    [[TMP4:%.*]] = phi i1 [ false, [[ENTRY:%.*]] ], [ [[CMP3_I]], [[LAND_RHS_I]] ]
; NOEXPANSION-NEXT:    ret i1 [[TMP4]]
;
  ptr nocapture readonly dereferenceable(8) %a,
  ptr nocapture readonly dereferenceable(8) %b) local_unnamed_addr #0 {
entry:
  %0 = load i32, ptr %a, align 4
  %1 = load i32, ptr %b, align 4
  %cmp.i = icmp eq i32 %0, %1
  br i1 %cmp.i, label %land.rhs.i, label %opeq1.exit

land.rhs.i:
  %second.i = getelementptr inbounds %"struct.std::pair", ptr %a, i64 0, i32 1
  %2 = load i32, ptr %second.i, align 4
  %second2.i = getelementptr inbounds %"struct.std::pair", ptr %b, i64 0, i32 1
  %3 = load i32, ptr %second2.i, align 4
  %cmp3.i = icmp eq i32 %2, %3
  br label %opeq1.exit

opeq1.exit:
  %4 = phi i1 [ false, %entry ], [ %cmp3.i, %land.rhs.i ]
  ret i1 %4
}

; Same as above, but the two blocks are in inverse order.
define zeroext i1 @opeq1_inverse(
; NOEXPANSION-LABEL: @opeq1_inverse(
; NOEXPANSION-NEXT:  entry:
; NOEXPANSION-NEXT:    [[FIRST_I:%.*]] = getelementptr inbounds %"struct.std::pair", ptr [[A:%.*]], i64 0, i32 1
; NOEXPANSION-NEXT:    [[TMP0:%.*]] = load i32, ptr [[FIRST_I]], align 4
; NOEXPANSION-NEXT:    [[FIRST1_I:%.*]] = getelementptr inbounds %"struct.std::pair", ptr [[B:%.*]], i64 0, i32 1
; NOEXPANSION-NEXT:    [[TMP1:%.*]] = load i32, ptr [[FIRST1_I]], align 4
; NOEXPANSION-NEXT:    [[CMP_I:%.*]] = icmp eq i32 [[TMP0]], [[TMP1]]
; NOEXPANSION-NEXT:    br i1 [[CMP_I]], label [[LAND_RHS_I:%.*]], label [[OPEQ1_EXIT:%.*]]
; NOEXPANSION:       land.rhs.i:
; NOEXPANSION-NEXT:    [[TMP2:%.*]] = load i32, ptr [[A]], align 4
; NOEXPANSION-NEXT:    [[TMP3:%.*]] = load i32, ptr [[B]], align 4
; NOEXPANSION-NEXT:    [[CMP3_I:%.*]] = icmp eq i32 [[TMP2]], [[TMP3]]
; NOEXPANSION-NEXT:    br label [[OPEQ1_EXIT]]
; NOEXPANSION:       opeq1.exit:
; NOEXPANSION-NEXT:    [[TMP4:%.*]] = phi i1 [ false, [[ENTRY:%.*]] ], [ [[CMP3_I]], [[LAND_RHS_I]] ]
; NOEXPANSION-NEXT:    ret i1 [[TMP4]]
;
  ptr nocapture readonly dereferenceable(8) %a,
  ptr nocapture readonly dereferenceable(8) %b) local_unnamed_addr #0 {
entry:
  %first.i = getelementptr inbounds %"struct.std::pair", ptr %a, i64 0, i32 1
  %0 = load i32, ptr %first.i, align 4
  %first1.i = getelementptr inbounds %"struct.std::pair", ptr %b, i64 0, i32 1
  %1 = load i32, ptr %first1.i, align 4
  %cmp.i = icmp eq i32 %0, %1
  br i1 %cmp.i, label %land.rhs.i, label %opeq1.exit

land.rhs.i:
  %2 = load i32, ptr %a, align 4
  %3 = load i32, ptr %b, align 4
  %cmp3.i = icmp eq i32 %2, %3
  br label %opeq1.exit

opeq1.exit:
  %4 = phi i1 [ false, %entry ], [ %cmp3.i, %land.rhs.i ]
  ret i1 %4
}



