#!/usr/bin/env python2
# -*- coding: utf-8 -*-

import glob

sv_files  = []
pkg_files = []

RTL_SOC   = "../rtl/core/*.sv"
RTL_CORE  = "../rtl/soc/*.sv"
TB        = "../sim/tb/*.sv"
SEQ_LIB   = "../sim/env/agent/sequence_lib/*.sv"
REGS      = "../sim/env/agent/regs/*.sv"
AGT       = "../sim/env/agent/*.sv"
ENV       = "../sim/env/*.sv"
TESTS     = "../sim/tests/*.sv"

def add_to_list(file_path):
    all_files_in_path = glob.glob(file_path)

    for _file in all_files_in_path:
        if "pkg" in _file:
            pkg_files.append(_file)
        else:
            sv_files.append(_file)    

if __name__ == "__main__":    
    add_to_list(RTL_CORE)
    add_to_list(RTL_SOC)    
    add_to_list(TB)
    add_to_list(SEQ_LIB)
    add_to_list(REGS)    
    add_to_list(AGT)
    add_to_list(ENV)
    add_to_list(TESTS)
    
    f = open('input_pkg.f','w')    
    for _file in pkg_files:
        f.write(_file+'\n')
    f.close()

    f = open('input_sv.f','w')    
    for _file in sv_files:
        f.write(_file+'\n')
    f.close()
