//= Z80KnightInstPrinter.h - Convert MSP430 Z80 to assembly syntax -------*- C++ -*-//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// This class prints a Z80 MCInst to a .s file.
//
//===----------------------------------------------------------------------===//

#ifndef Z80KNIGHTINSTPRINTER_H
#define Z80KNIGHTINSTPRINTER_H

#include "llvm/MC/MCInstPrinter.h"

namespace llvm {
  class Z80KnightInstPrinter : public MCInstPrinter {
  public:
    Z80KnightInstPrinter(const MCAsmInfo &MAI, const MCInstrInfo &MII, const MCRegisterInfo &MRI)
      : MCInstPrinter(MAI, MII, MRI) 
    {}
    ~Z80KnightInstPrinter() {}

    void printInst(const MCInst *MI, raw_ostream &OS, StringRef Annot,
                         const MCSubtargetInfo &STI) override;

    void printRegName(raw_ostream &OS, unsigned RegNo) const override;
    bool applyTargetSpecificCLOption(StringRef Opt) override { return false; }

    // Autogenerated by tblgen
    void printInstruction(const MCInst *MI, raw_ostream &O);
    static const char *getRegisterName(unsigned RegNo);

private:
    void printOperand(const MCInst *MI, unsigned OpNo, raw_ostream &O);
    void printCCOperand(const MCInst *MI, unsigned OpNo, raw_ostream &O);
    void printXMemOperand(const MCInst *MI, unsigned OpNo, raw_ostream &O);
  }; // end class Z80KnightInstPrinter
} // end namespace llvm

#endif
