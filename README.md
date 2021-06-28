### Directory Structure
```
ultra_core
├── docs
├── firmware
├── README.md
├── rtl
│   └── rtl files
├── scripts
│   └── scripts to run tests
├── sim
│   ├── env
│   │   ├── agent
│   │   │   ├── driver
│   │   │   ├── monitor
│   │   │   ├── interace
│   │   │   ├── sequencer
│   │   │   ├── regs
│   │   │   └── sequence_lib
│   │   ├── scoreboard
│   │   └── coverage
│   ├── tb
└───└── tests
```

### prereqs
```
Vivado 2020.2
riscv32 tool chain
```

### Commands to run sanity test
```bash
cd scripts
make run_all
```