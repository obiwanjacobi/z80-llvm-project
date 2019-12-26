//===-- Z80MCTargetDesc.h - Z80 Target Descriptions -------------*- C++ -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// This file provides Z80 specific target descriptions.
//
//===----------------------------------------------------------------------===//

#ifndef Z80MCTARGETDESC_H
#define Z80MCTARGETDESC_H

#include "llvm/MC/MCTargetOptions.h"

namespace llvm {
  class MCAsmBackend;
  class MCCodeEmitter;
  class MCContext;
  class MCInstrInfo;
  class MCRegisterInfo;
  class MCSubtargetInfo;
  class Target;
  class StringRef;
  class Triple;

  extern Target TheZ80Target;

  MCCodeEmitter *createZ80MCCodeEmitter(const MCInstrInfo &MCII,
    const MCRegisterInfo &MRI, MCContext &Ctx);
  MCAsmBackend *createZ80AsmBackend(const Target &T, 
    const MCSubtargetInfo &STI, const MCRegisterInfo &MRI, 
    const MCTargetOptions &Options);
} // end namespace llvm

#define GET_REGINFO_ENUM
#include "Z80GenRegisterInfo.inc"

#define GET_INSTRINFO_ENUM
#include "Z80GenInstrInfo.inc"

#define GET_SUBTARGETINFO_ENUM
#include "Z80GenSubtargetInfo.inc"

#endif
