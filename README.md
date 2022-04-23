### Directory Structure
```
ultra_core
├── doc
├── constraints
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
Vivado 2021.2
riscv32 tool chain
```

### Commands to run sanity test
```bash
cd scripts
make run_all
```

### Constaint file is for Arty 7