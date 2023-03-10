; RUN: llvm-mc -triple avr -show-encoding < %s | FileCheck %s
; RUN: llvm-mc -filetype=obj -triple avr < %s \
; RUN:     | llvm-objdump -d - | FileCheck --check-prefix=INST %s

foo:

  brbs 3, .+8
  brbs 0, .-12
  .short 0xf359
  .short 0xf352
  .short 0xf34c
  .short 0xf077

; CHECK: brvs .Ltmp0+8              ; encoding: [0bAAAAA011,0b111100AA]
; CHECK:                            ; fixup A - offset: 0, value: .Ltmp0+8, kind: fixup_7_pcrel
; CHECK: brcs .Ltmp1-12             ; encoding: [0bAAAAA000,0b111100AA]
; CHECK:                            ; fixup A - offset: 0, value: .Ltmp1-12, kind: fixup_7_pcrel

; INST: brvs .+0
; INST: brlo .+0
; INST: breq .-42
; INST  brmi .-44
; INST  brlt .-46
; InST: brie .+28
