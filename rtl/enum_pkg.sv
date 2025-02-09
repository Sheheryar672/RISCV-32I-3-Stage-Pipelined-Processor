package enum_pkg;

  typedef enum logic [6:0] {
    ALU_REG = 7'b0110011,  // R-type
    LOAD    = 7'b0000011,  // I-type
    ALU_IMM = 7'b0010011,  // I-type
    JALR    = 7'b1100111,  // I-type
    STORE   = 7'b0100011,  // S-type
    JAL     = 7'b1101111,  // J-type
    BRANCH  = 7'b1100011,  // B-type
    AUIPC   = 7'b0010111,  // U-type
    LUI     = 7'b0110111   // U-type
  } opcode_t;

  typedef enum logic [3:0] {
    // ALU operations
    ADD     = 4'b0000,
    SUB     = 4'b0001,
    SLL     = 4'b0010,
    SLT     = 4'b0011,
    SLTU    = 4'b0100,
    XOR     = 4'b0101,
    SRL     = 4'b0110,
    SRA     = 4'b0111,
    OR      = 4'b1000,
    AND     = 4'b1001,
    LUI_ALU = 4'b1010
  } alu_t;

  typedef enum logic [2:0] {
    // Load instruction funct3 values
    LB  = 3'b000,  // Load Byte
    LH  = 3'b001,  // Load Halfword
    LW  = 3'b010,  // Load Word
    LBU = 3'b100,  // Load Byte Unsigned
    LHU = 3'b101   // Load Halfword Unsigned
  } load_funct3_t;

  typedef enum logic [2:0] {
    // Store instruction funct3 values
    SB = 3'b000,  // Store Byte
    SH = 3'b001,  // Store Halfword
    SW = 3'b010   // Store Word
  } store_funct3_t;

  typedef enum logic [2:0] {
    // Branch instruction funct3 values
    BEQ  = 3'b000,  // Branch if Equal
    BNE  = 3'b001,  // Branch if Not Equal
    BLT  = 3'b100,  // Branch if Less Than
    BGE  = 3'b101,  // Branch if Greater Than or Equal
    BLTU = 3'b110,  // Branch if Less Than Unsigned
    BGEU = 3'b111,  // Branch if Greater Than or Equal Unsigned
    NB   = 3'b010,   // Not Branch 
    J    = 3'b011    // Jal instrusction
  } branch_funct3_t;

  typedef enum logic [1:0] {
    // write back mux
    J_WB    = 2'b00,  // J-type writeback
    ALU_WB  = 2'b01,  // ALU Result Writeback
    DMEM_WB = 2'b10  // Data Memory Writeback
  } wb_mux_t;

endpackage

