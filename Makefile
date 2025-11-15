VERSION_TAG ?= UNKNOWN_OR_CUSTOM_VERSION

# Get current directory
MKFILE_PATH := $(abspath $(lastword $(MAKEFILE_LIST)))
MKFILE_DIR := $(dir $(MKFILE_PATH))

# Docker Container Build Setup
DOCKER_IMAGE = ghcr.io/yliu-hashed/sm-eda-bundle:latest
DOCKER_MOUNT_ARGS := --mount type=bind,source="$(MKFILE_DIR)",target=/working
DOCKER_ARGS := run --rm $(DOCKER_MOUNT_ARGS) $(DOCKER_IMAGE)
DOCKER_CMD_RUN = docker $(DOCKER_ARGS) bash -l -c "cd working && $(1)"

EXTRACT_REPORT_FROM_BP = $(subst blueprints/,reports/,$(1))

NUM_CORES = 4

# Command Pallette
PLACE_ARGS := --pack --double-sided --lz4-path /usr/bin/lz4
SYNTH     = timeout 30m yosys $(1) -q -s resources/script_$(2).ys -o tmp/$(3)_synth.json -D GEN $(4)
PLACE     = timeout  5m sm-eda flow      -q $(PLACE_ARGS) $(1) $(2) -R $(call EXTRACT_REPORT_FROM_BP,$(2))
PLACE_RAW = timeout  5m sm-eda autoplace -q $(PLACE_ARGS) $(1) $(2) -R $(call EXTRACT_REPORT_FROM_BP,$(2))

# Common Sizes
BIN_MATH_COMB_WIDTHS := 8 16 24 32
BIN_MATH_SEQ_WIDTHS := 16 24 32 64

# --- BIN MATH COMB MODULES ----------------------------------------------------
# --- ADD ----------------------------------------------------------------------
# Synthesis

# ADD COMB 2I
ADD_C2_WIDTHS := $(BIN_MATH_COMB_WIDTHS)
ADD_C2_BP_FILES := $(foreach w,$(ADD_C2_WIDTHS),blueprints/add_comb_2i_$(w).json)
ADD_C2_COMMAND = $(call SYNTH,-D LEN=$(1) -D ARG2I,comb,add_comb_2i_$(1),src/add_comb.v)
ADD_C2_EXTRACT_WIDTH = $(subst tmp/add_comb_2i_,,$(subst _synth.json,,$(1)))

tmp/add_comb_2i_%_synth.json: src/add_comb.v resources/script_comb.ys
	$(call ADD_C2_COMMAND,$(call ADD_C2_EXTRACT_WIDTH,$@))

# ADD COMB 3I
ADD_C3_WIDTHS := $(BIN_MATH_COMB_WIDTHS)
ADD_C3_BP_FILES := $(foreach w,$(ADD_C3_WIDTHS),blueprints/add_comb_3i_$(w).json)
ADD_C3_COMMAND = $(call SYNTH,-D LEN=$(1) -D ARG3I,comb,add_comb_3i_$(1),src/add_comb.v)
ADD_C3_EXTRACT_WIDTH = $(subst tmp/add_comb_3i_,,$(subst _synth.json,,$(1)))

tmp/add_comb_3i_%_synth.json: src/add_comb.v resources/script_comb.ys
	$(call ADD_C3_COMMAND,$(call ADD_C3_EXTRACT_WIDTH,$@))

# ADD COMB 4I
ADD_C4_WIDTHS := $(BIN_MATH_COMB_WIDTHS)
ADD_C4_BP_FILES := $(foreach w,$(ADD_C4_WIDTHS),blueprints/add_comb_4i_$(w).json)
ADD_C4_COMMAND = $(call SYNTH,-D LEN=$(1) -D ARG4I,comb,add_comb_4i_$(1),src/add_comb.v)
ADD_C4_EXTRACT_WIDTH = $(subst tmp/add_comb_4i_,,$(subst _synth.json,,$(1)))

tmp/add_comb_4i_%_synth.json: src/add_comb.v resources/script_comb.ys
	$(call ADD_C4_COMMAND,$(call ADD_C4_EXTRACT_WIDTH,$@))

# Conversion & Implementation
blueprints/add_comb_%.json: tmp/add_comb_%_synth.json
	$(call PLACE,$^,$@)

# --- MUL ----------------------------------------------------------------------
# Synthesis

# MUL COMB TRUNC
MUL_CT_WIDTHS := $(BIN_MATH_COMB_WIDTHS)
MUL_CT_BP_FILES := $(foreach w,$(MUL_CT_WIDTHS),blueprints/mul_comb_trunc_$(w).json)
MUL_CT_COMMAND = $(call SYNTH,-D LEN=$(1) -D TRUNC,comb,mul_comb_trunc_$(1),src/mul_comb.v)
MUL_CT_EXTRACT_WIDTH = $(subst tmp/mul_comb_trunc_,,$(subst _synth.json,,$(1)))

tmp/mul_comb_trunc_%_synth.json: src/mul_comb.v resources/script_comb.ys
	$(call MUL_CT_COMMAND,$(call MUL_CT_EXTRACT_WIDTH,$@))

# MUL COMB FULL SIGNED
MUL_CFS_WIDTHS := $(BIN_MATH_COMB_WIDTHS)
MUL_CFS_BP_FILES := $(foreach w,$(MUL_CFS_WIDTHS),blueprints/mul_comb_full_signed_$(w).json)
MUL_CFS_COMMAND = $(call SYNTH,-D LEN=$(1) -D FULL_SIGNED,comb,mul_comb_full_signed_$(1),src/mul_comb.v)
MUL_CFS_EXTRACT_WIDTH = $(subst tmp/mul_comb_full_signed_,,$(subst _synth.json,,$(1)))

tmp/mul_comb_full_signed_%_synth.json: src/mul_comb.v resources/script_comb.ys
	$(call MUL_CFS_COMMAND,$(call MUL_CFS_EXTRACT_WIDTH,$@))

# MUL COMB FULL UNSIGNED
MUL_CFU_WIDTHS := $(BIN_MATH_COMB_WIDTHS)
MUL_CFU_BP_FILES := $(foreach w,$(MUL_CFU_WIDTHS),blueprints/mul_comb_full_unsigned_$(w).json)
MUL_CFU_COMMAND = $(call SYNTH,-D LEN=$(1) -D FULL_UNSIGNED,comb,mul_comb_full_unsigned_$(1),src/mul_comb.v)
MUL_CFU_EXTRACT_WIDTH = $(subst tmp/mul_comb_full_unsigned_,,$(subst _synth.json,,$(1)))

tmp/mul_comb_full_unsigned_%_synth.json: src/mul_comb.v resources/script_comb.ys
	$(call MUL_CFU_COMMAND,$(call MUL_CFU_EXTRACT_WIDTH,$@))

# MUL COMB FULL MIXED
MUL_CFM_WIDTHS := $(BIN_MATH_COMB_WIDTHS)
MUL_CFM_BP_FILES := $(foreach w,$(MUL_CFM_WIDTHS),blueprints/mul_comb_full_mixed_$(w).json)
MUL_CFM_COMMAND = $(call SYNTH,-D LEN=$(1) -D FULL_MIXED,comb,mul_comb_full_mixed_$(1),src/mul_comb.v)
MUL_CFM_EXTRACT_WIDTH = $(subst tmp/mul_comb_full_mixed_,,$(subst _synth.json,,$(1)))

tmp/mul_comb_full_mixed_%_synth.json: src/mul_comb.v resources/script_comb.ys
	$(call MUL_CFM_COMMAND,$(call MUL_CFM_EXTRACT_WIDTH,$@))

# Conversion & Implementation
blueprints/mul_comb_%.json: tmp/mul_comb_%_synth.json
	$(call PLACE,$^,$@)

# --- DIV ----------------------------------------------------------------------
# Synthesis

# DIV COMB SIGNED
DIV_CS_WIDTHS := $(BIN_MATH_COMB_WIDTHS)
DIV_CS_BP_FILES := $(foreach w,$(DIV_CS_WIDTHS),blueprints/div_comb_signed_$(w).json)
DIV_CS_COMMAND = $(call SYNTH,-D LEN=$(1) -D SIGNED,comb,div_comb_signed_$(1),src/div_comb.v)
DIV_CS_EXTRACT_WIDTH = $(subst tmp/div_comb_signed_,,$(subst _synth.json,,$(1)))

tmp/div_comb_signed_%_synth.json: src/div_comb.v resources/script_comb.ys
	$(call DIV_CS_COMMAND,$(call DIV_CS_EXTRACT_WIDTH,$@))

# DIV COMB UNSIGNED
DIV_CU_WIDTHS := $(BIN_MATH_COMB_WIDTHS)
DIV_CU_BP_FILES := $(foreach w,$(DIV_CU_WIDTHS),blueprints/div_comb_unsigned_$(w).json)
DIV_CU_COMMAND = $(call SYNTH,-D LEN=$(1) -D UNSIGNED,comb,div_comb_unsigned_$(1),src/div_comb.v)
DIV_CU_EXTRACT_WIDTH = $(subst tmp/div_comb_unsigned_,,$(subst _synth.json,,$(1)))

tmp/div_comb_unsigned_%_synth.json: src/div_comb.v resources/script_comb.ys
	$(call DIV_CU_COMMAND,$(call DIV_CU_EXTRACT_WIDTH,$@))

# Conversion & Implementation
blueprints/div_comb_%.json: tmp/div_comb_%_synth.json
	$(call PLACE,$^,$@)

# --- REM ----------------------------------------------------------------------
# Synthesis

# REM COMB SIGNED
REM_CS_WIDTHS := $(BIN_MATH_COMB_WIDTHS)
REM_CS_BP_FILES := $(foreach w,$(REM_CS_WIDTHS),blueprints/rem_comb_signed_$(w).json)
REM_CS_COMMAND = $(call SYNTH,-D LEN=$(1) -D SIGNED,comb,rem_comb_signed_$(1),src/rem_comb.v)
REM_CS_EXTRACT_WIDTH = $(subst tmp/rem_comb_signed_,,$(subst _synth.json,,$(1)))

tmp/rem_comb_signed_%_synth.json: src/rem_comb.v resources/script_comb.ys
	$(call REM_CS_COMMAND,$(call REM_CS_EXTRACT_WIDTH,$@))

# REM COMB UNSIGNED
REM_CU_WIDTHS := $(BIN_MATH_COMB_WIDTHS)
REM_CU_BP_FILES := $(foreach w,$(REM_CU_WIDTHS),blueprints/rem_comb_unsigned_$(w).json)
REM_CU_COMMAND = $(call SYNTH,-D LEN=$(1) -D UNSIGNED,comb,rem_comb_unsigned_$(1),src/rem_comb.v)
REM_CU_EXTRACT_WIDTH = $(subst tmp/rem_comb_unsigned_,,$(subst _synth.json,,$(1)))

tmp/rem_comb_unsigned_%_synth.json: src/rem_comb.v resources/script_comb.ys
	$(call REM_CU_COMMAND,$(call REM_CU_EXTRACT_WIDTH,$@))

# Conversion & Implementation
blueprints/rem_comb_%.json: tmp/rem_comb_%_synth.json
	$(call PLACE,$^,$@)

# --- SQRT ---------------------------------------------------------------------
# Synthesis

# SQRT COMB
SQRT_C_WIDTHS := $(BIN_MATH_COMB_WIDTHS)
SQRT_C_BP_FILES := $(foreach w,$(SQRT_C_WIDTHS),blueprints/sqrt_comb_$(w).json)
SQRT_C_COMMAND = $(call SYNTH,-D LEN=$(1),comb,sqrt_comb_$(1),src/sqrt_comb.v)
SQRT_C_EXTRACT_WIDTH = $(subst tmp/sqrt_comb_,,$(subst _synth.json,,$(1)))

tmp/sqrt_comb_%_synth.json: src/sqrt_comb.v resources/script_comb.ys
	$(call SQRT_C_COMMAND,$(call SQRT_C_EXTRACT_WIDTH,$@))

# Conversion & Implementation
blueprints/sqrt_comb_%.json: tmp/sqrt_comb_%_synth.json
	$(call PLACE,$^,$@)

# --- SQR ----------------------------------------------------------------------
# Synthesis

# SQR COMB TRUNC
SQR_CT_WIDTHS := $(BIN_MATH_COMB_WIDTHS)
SQR_CT_BP_FILES := $(foreach w,$(SQR_CT_WIDTHS),blueprints/sqr_comb_trunc_$(w).json)
SQR_CT_COMMAND = $(call SYNTH,-D LEN=$(1) -D TRUNC,comb,sqr_comb_trunc_$(1),src/sqr_comb.v)
SQR_CT_EXTRACT_WIDTH = $(subst tmp/sqr_comb_trunc_,,$(subst _synth.json,,$(1)))

tmp/sqr_comb_trunc_%_synth.json: src/sqr_comb.v resources/script_comb.ys
	$(call SQR_CT_COMMAND,$(call SQR_CT_EXTRACT_WIDTH,$@))

# SQR COMB FULL SIGNED
SQR_CFS_WIDTHS := $(BIN_MATH_COMB_WIDTHS)
SQR_CFS_BP_FILES := $(foreach w,$(SQR_CFS_WIDTHS),blueprints/sqr_comb_full_signed_$(w).json)
SQR_CFS_COMMAND = $(call SYNTH,-D LEN=$(1) -D FULL_SIGNED,comb,sqr_comb_full_signed_$(1),src/sqr_comb.v)
SQR_CFS_EXTRACT_WIDTH = $(subst tmp/sqr_comb_full_signed_,,$(subst _synth.json,,$(1)))

tmp/sqr_comb_full_signed_%_synth.json: src/sqr_comb.v resources/script_comb.ys
	$(call SQR_CFS_COMMAND,$(call SQR_CFS_EXTRACT_WIDTH,$@))

# SQR COMB FULL UNSIGNED
SQR_CFU_WIDTHS := $(BIN_MATH_COMB_WIDTHS)
SQR_CFU_BP_FILES := $(foreach w,$(SQR_CFU_WIDTHS),blueprints/sqr_comb_full_unsigned_$(w).json)
SQR_CFU_COMMAND = $(call SYNTH,-D LEN=$(1) -D FULL_UNSIGNED,comb,sqr_comb_full_unsigned_$(1),src/sqr_comb.v)
SQR_CFU_EXTRACT_WIDTH = $(subst tmp/sqr_comb_full_unsigned_,,$(subst _synth.json,,$(1)))

tmp/sqr_comb_full_unsigned_%_synth.json: src/sqr_comb.v resources/script_comb.ys
	$(call SQR_CFU_COMMAND,$(call SQR_CFU_EXTRACT_WIDTH,$@))

# Conversion & Implementation
blueprints/sqr_comb_%.json: tmp/sqr_comb_%_synth.json
	$(call PLACE,$^,$@)

# --- CMP ----------------------------------------------------------------------
# Synthesis

# CMP COMB
CMP_C_WIDTHS := 8 16 24 32 48 64
CMP_C_BP_FILES := $(foreach w,$(CMP_C_WIDTHS),blueprints/cmp_comb_$(w).json)
CMP_C_COMMAND = $(call SYNTH,-D LEN=$(1),comb,cmp_comb_$(1),src/cmp_comb.v)
CMP_C_EXTRACT_WIDTH = $(subst tmp/cmp_comb_,,$(subst _synth.json,,$(1)))

tmp/cmp_comb_%_synth.json: src/cmp_comb.v resources/script_comb.ys
	$(call CMP_C_COMMAND,$(call CMP_C_EXTRACT_WIDTH,$@))

# Conversion & Implementation
blueprints/cmp_comb_%.json: tmp/cmp_comb_%_synth.json
	$(call PLACE,$^,$@)

# --- PRIORITY-ENCODER ---------------------------------------------------------
# Synthesis

# PENC COMB MAX
PENC_CX_WIDTHS := 3 4 5 6
PENC_CX_BP_FILES := $(foreach w,$(PENC_CX_WIDTHS),blueprints/penc_comb_max_$(w).json)
PENC_CX_COMMAND = $(call SYNTH,-D LEN=$(1) -D MAX,comb,penc_comb_max_$(1),src/penc_comb.v)
PENC_CX_EXTRACT_WIDTH = $(subst tmp/penc_comb_max_,,$(subst _synth.json,,$(1)))

tmp/penc_comb_max_%_synth.json: src/penc_comb.v resources/script_comb.ys
	$(call PENC_CX_COMMAND,$(call PENC_CX_EXTRACT_WIDTH,$@))

# PENC COMB MIN
PENC_CN_WIDTHS := 3 4 5 6
PENC_CN_BP_FILES := $(foreach w,$(PENC_CN_WIDTHS),blueprints/penc_comb_min_$(w).json)
PENC_CN_COMMAND = $(call SYNTH,-D LEN=$(1) -D MIN,comb,penc_comb_min_$(1),src/penc_comb.v)
PENC_CN_EXTRACT_WIDTH = $(subst tmp/penc_comb_min_,,$(subst _synth.json,,$(1)))

tmp/penc_comb_min_%_synth.json: src/penc_comb.v resources/script_comb.ys
	$(call PENC_CN_COMMAND,$(call PENC_CN_EXTRACT_WIDTH,$@))

# Conversion & Implementation
blueprints/penc_comb_%.json: tmp/penc_comb_%_synth.json
	$(call PLACE,$^,$@)

# --- BIN MATH SEQ MODULES -----------------------------------------------------
# --- MUL ----------------------------------------------------------------------
# Synthesis

# MUL SEQ TRUNC
MUL_ST_WIDTHS := $(BIN_MATH_SEQ_WIDTHS)
MUL_ST_BP_FILES := $(foreach w,$(MUL_ST_WIDTHS),blueprints/mul_seq_trunc_$(w).json)
MUL_ST_COMMAND = $(call SYNTH,-D LEN=$(1) -D TRUNC,seq,mul_seq_trunc_$(1),src/mul_seq.v)
MUL_ST_EXTRACT_WIDTH = $(subst tmp/mul_seq_trunc_,,$(subst _synth.json,,$(1)))

tmp/mul_seq_trunc_%_synth.json: src/mul_seq.v resources/script_seq.ys
	$(call MUL_ST_COMMAND,$(call MUL_ST_EXTRACT_WIDTH,$@))

# Conversion & Implementation
blueprints/mul_seq_%.json: tmp/mul_seq_%_synth.json
	$(call PLACE,$^,$@)

# --- DIV ----------------------------------------------------------------------
# Synthesis

# DIV SEQ TRUNC
DIV_SU_WIDTHS := $(BIN_MATH_SEQ_WIDTHS)
DIV_SU_BP_FILES := $(foreach w,$(DIV_SU_WIDTHS),blueprints/div_seq_unsigned_$(w).json)
DIV_SU_COMMAND = $(call SYNTH,-D LEN=$(1) -D TRUNC,seq,div_seq_unsigned_$(1),src/div_seq.v)
DIV_SU_EXTRACT_WIDTH = $(subst tmp/div_seq_unsigned_,,$(subst _synth.json,,$(1)))

tmp/div_seq_unsigned_%_synth.json: src/div_seq.v resources/script_seq.ys
	$(call DIV_SU_COMMAND,$(call DIV_SU_EXTRACT_WIDTH,$@))

# Conversion & Implementation
blueprints/div_seq_%.json: tmp/div_seq_%_synth.json
	$(call PLACE,$^,$@)

# --- BCD COMB MODULES ---------------------------------------------------------
BIN_BCD_WIDTHS := 8B2D 8B3D 16B4D 16B5D 24B7D 24B8D 32B9D 32B10D
# --- BCD2BIN ------------------------------------------------------------------
# Synthesis

# BCD2BIN COMB
BCD2BIN_C_BP_FILES := $(foreach w,$(BIN_BCD_WIDTHS),blueprints/bcd2bin_comb_$(w).json)
BCD2BIN_C_COMMAND = $(call SYNTH,-D MODE_$(1),comb,bcd2bin_comb_$(1),src/bcd2bin_comb.v)
BCD2BIN_C_EXTRACT_WIDTH = $(subst tmp/bcd2bin_comb_,,$(subst _synth.json,,$(1)))

tmp/bcd2bin_comb_%_synth.json: src/bcd2bin_comb.v resources/script_comb.ys
	$(call BCD2BIN_C_COMMAND,$(call BCD2BIN_C_EXTRACT_WIDTH,$@))

# Conversion & Implementation
blueprints/bcd2bin_comb_%.json: tmp/bcd2bin_comb_%_synth.json
	$(call PLACE,$^,$@)

# --- BIN2BCD ------------------------------------------------------------------
# Synthesis

# BIN2BCD COMB
BIN2BCD_C_BP_FILES := $(foreach w,$(BIN_BCD_WIDTHS),blueprints/bin2bcd_comb_$(w).json)
BIN2BCD_C_COMMAND = $(call SYNTH,-D MODE_$(1),comb,bin2bcd_comb_$(1),src/bcd2bin_comb.v)
BIN2BCD_C_EXTRACT_WIDTH = $(subst tmp/bin2bcd_comb_,,$(subst _synth.json,,$(1)))

tmp/bin2bcd_comb_%_synth.json: src/bin2bcd_comb.v resources/script_comb.ys
	$(call BIN2BCD_C_COMMAND,$(call BIN2BCD_C_EXTRACT_WIDTH,$@))

# Conversion & Implementation
blueprints/bin2bcd_comb_%.json: tmp/bin2bcd_comb_%_synth.json
	$(call PLACE,$^,$@)

# --- MEM TIMER MODULES --------------------------------------------------------
# Synthesis
MEM_TIMER_WIDTHS := 8
MEM_TIMER_DEPTHS := 6 7 8 9 10 11
MEM_TIMER_TYPES := $(foreach w,$(MEM_TIMER_WIDTHS),$(foreach d,$(MEM_TIMER_DEPTHS),$(w)x$(d)))
MEM_TIMER_TYPE_EXTRACT_WIDTH = $(word 1,$(subst x, ,$(1)))
MEM_TIMER_TYPE_EXTRACT_DEPTH = $(word 2,$(subst x, ,$(1)))
MEM_TIMER_ARGS_FROM_TYPE = --dbits $(call MEM_TIMER_TYPE_EXTRACT_WIDTH,$(1)) --abits $(call MEM_TIMER_TYPE_EXTRACT_DEPTH,$(1))

# MEM 1R1W
MEM_TIMER_1R1W_BP_FILES := $(foreach t,$(MEM_TIMER_TYPES),blueprints/mem_timer_1r1w_$(t).json)
MEM_TIMER_1R1W_PORTS := --port w --port r
MEM_TIMER_1R1W_EXTRACT_TYPE = $(subst tmp/mem_timer_1r1w_,,$(subst _synth.json,,$(1)))
MEM_TIMER_1R1W_COMMAND = sm-eda bram --timer --max-loop-delay 16 -q $(MEM_TIMER_1R1W_PORTS) $(call MEM_TIMER_ARGS_FROM_TYPE,$(1)) tmp/mem_timer_1r1w_$(1)_synth.json

tmp/mem_timer_1r1w_%_synth.json:
	$(call MEM_TIMER_1R1W_COMMAND,$(call MEM_TIMER_1R1W_EXTRACT_TYPE,$@))

# MEM 2R1W
MEM_TIMER_2R1W_BP_FILES := $(foreach t,$(MEM_TIMER_TYPES),blueprints/mem_timer_2r1w_$(t).json)
MEM_TIMER_2R1W_PORTS := --port w --port r --port r
MEM_TIMER_2R1W_EXTRACT_TYPE = $(subst tmp/mem_timer_2r1w_,,$(subst _synth.json,,$(1)))
MEM_TIMER_2R1W_COMMAND = sm-eda bram --timer --max-loop-delay 16 -q $(MEM_TIMER_2R1W_PORTS) $(call MEM_TIMER_ARGS_FROM_TYPE,$(1)) tmp/mem_timer_2r1w_$(1)_synth.json

tmp/mem_timer_2r1w_%_synth.json:
	$(call MEM_TIMER_2R1W_COMMAND,$(call MEM_TIMER_2R1W_EXTRACT_TYPE,$@))

# MEM 3R1W
MEM_TIMER_3R1W_BP_FILES := $(foreach t,$(MEM_TIMER_TYPES),blueprints/mem_timer_3r1w_$(t).json)
MEM_TIMER_3R1W_PORTS := --port w --port r --port r --port r
MEM_TIMER_3R1W_EXTRACT_TYPE = $(subst tmp/mem_timer_3r1w_,,$(subst _synth.json,,$(1)))
MEM_TIMER_3R1W_COMMAND = sm-eda bram --timer --max-loop-delay 16 -q $(MEM_TIMER_3R1W_PORTS) $(call MEM_TIMER_ARGS_FROM_TYPE,$(1)) tmp/mem_timer_3r1w_$(1)_synth.json

tmp/mem_timer_3r1w_%_synth.json:
	$(call MEM_TIMER_3R1W_COMMAND,$(call MEM_TIMER_3R1W_EXTRACT_TYPE,$@))

# MEM 4R1W
MEM_TIMER_4R1W_BP_FILES := $(foreach t,$(MEM_TIMER_TYPES),blueprints/mem_timer_4r1w_$(t).json)
MEM_TIMER_4R1W_PORTS := --port w --port r --port r --port r --port r
MEM_TIMER_4R1W_EXTRACT_TYPE = $(subst tmp/mem_timer_4r1w_,,$(subst _synth.json,,$(1)))
MEM_TIMER_4R1W_COMMAND = sm-eda bram --timer --max-loop-delay 16 -q $(MEM_TIMER_4R1W_PORTS) $(call MEM_TIMER_ARGS_FROM_TYPE,$(1)) tmp/mem_timer_4r1w_$(1)_synth.json

tmp/mem_timer_4r1w_%_synth.json:
	$(call MEM_TIMER_4R1W_COMMAND,$(call MEM_TIMER_4R1W_EXTRACT_TYPE,$@))

# Conversion & Implementation
blueprints/mem_timer_%.json: tmp/mem_timer_%_synth.json
	$(call PLACE_RAW,$^,$@)

# --- MEM XORDFF MODULES -------------------------------------------------------
MEM_XORDFF_WIDTHS := 8
MEM_XORDFF_DEPTHS := 4 5 6 7
MEM_XORDFF_TYPES := $(foreach w,$(MEM_XORDFF_WIDTHS),$(foreach d,$(MEM_XORDFF_DEPTHS),$(w)x$(d)))
MEM_XORDFF_TYPE_EXTRACT_WIDTH = $(word 1,$(subst x, ,$(1)))
MEM_XORDFF_TYPE_EXTRACT_DEPTH = $(word 2,$(subst x, ,$(1)))
MEM_XORDFF_ARGS_FROM_TYPE = --dbits $(call MEM_TIMER_TYPE_EXTRACT_WIDTH,$(1)) --abits $(call MEM_XORDFF_TYPE_EXTRACT_DEPTH,$(1))
# Synthesis

# MEM 1R1W
MEM_XORDFF_1R1W_BP_FILES := $(foreach t,$(MEM_XORDFF_TYPES),blueprints/mem_xordff_1r1w_$(t).json)
MEM_XORDFF_1R1W_PORTS := --port w --port r
MEM_XORDFF_1R1W_EXTRACT_TYPE = $(subst tmp/mem_xordff_1r1w_,,$(subst _synth.json,,$(1)))
MEM_XORDFF_1R1W_COMMAND = sm-eda bram --dff -q $(MEM_XORDFF_1R1W_PORTS) $(call MEM_XORDFF_ARGS_FROM_TYPE,$(1)) tmp/mem_xordff_1r1w_$(1)_synth.json

tmp/mem_xordff_1r1w_%_synth.json:
	$(call MEM_XORDFF_1R1W_COMMAND,$(call MEM_XORDFF_1R1W_EXTRACT_TYPE,$@))

# MEM 2R1W
MEM_XORDFF_2R1W_BP_FILES := $(foreach t,$(MEM_XORDFF_TYPES),blueprints/mem_xordff_2r1w_$(t).json)
MEM_XORDFF_2R1W_PORTS := --port w --port r --port r
MEM_XORDFF_2R1W_EXTRACT_TYPE = $(subst tmp/mem_xordff_2r1w_,,$(subst _synth.json,,$(1)))
MEM_XORDFF_2R1W_COMMAND = sm-eda bram --dff -q $(MEM_XORDFF_2R1W_PORTS) $(call MEM_XORDFF_ARGS_FROM_TYPE,$(1)) tmp/mem_xordff_2r1w_$(1)_synth.json

tmp/mem_xordff_2r1w_%_synth.json:
	$(call MEM_XORDFF_2R1W_COMMAND,$(call MEM_XORDFF_2R1W_EXTRACT_TYPE,$@))

# MEM 3R1W
MEM_XORDFF_3R1W_BP_FILES := $(foreach t,$(MEM_XORDFF_TYPES),blueprints/mem_xordff_3r1w_$(t).json)
MEM_XORDFF_3R1W_PORTS := --port w --port r --port r --port r
MEM_XORDFF_3R1W_EXTRACT_TYPE = $(subst tmp/mem_xordff_3r1w_,,$(subst _synth.json,,$(1)))
MEM_XORDFF_3R1W_COMMAND = sm-eda bram --dff -q $(MEM_XORDFF_3R1W_PORTS) $(call MEM_XORDFF_ARGS_FROM_TYPE,$(1)) tmp/mem_xordff_3r1w_$(1)_synth.json

tmp/mem_xordff_3r1w_%_synth.json:
	$(call MEM_XORDFF_3R1W_COMMAND,$(call MEM_XORDFF_3R1W_EXTRACT_TYPE,$@))

# MEM 4R1W
MEM_XORDFF_4R1W_BP_FILES := $(foreach t,$(MEM_XORDFF_TYPES),blueprints/mem_xordff_4r1w_$(t).json)
MEM_XORDFF_4R1W_PORTS := --port w --port r --port r --port r --port r
MEM_XORDFF_4R1W_EXTRACT_TYPE = $(subst tmp/mem_xordff_4r1w_,,$(subst _synth.json,,$(1)))
MEM_XORDFF_4R1W_COMMAND = sm-eda bram --dff -q $(MEM_XORDFF_4R1W_PORTS) $(call MEM_XORDFF_ARGS_FROM_TYPE,$(1)) tmp/mem_xordff_4r1w_$(1)_synth.json

tmp/mem_xordff_4r1w_%_synth.json:
	$(call MEM_XORDFF_4R1W_COMMAND,$(call MEM_XORDFF_4R1W_EXTRACT_TYPE,$@))

# Conversion & Implementation
blueprints/mem_xordff_%.json: tmp/mem_xordff_%_synth.json
	$(call PLACE_RAW,$^,$@)

# ------------------------------------------------------------------------------

ALL_BLUEPRINTS_FILES := $(ADD_C2_BP_FILES) $(ADD_C3_BP_FILES) $(ADD_C4_BP_FILES)
ALL_BLUEPRINTS_FILES += $(MUL_CT_BP_FILES) $(MUL_CFS_BP_FILES) $(MUL_CFU_BP_FILES) $(MUL_CFM_BP_FILES)
ALL_BLUEPRINTS_FILES += $(REM_CS_BP_FILES) $(REM_CU_BP_FILES)
ALL_BLUEPRINTS_FILES += $(DIV_CS_BP_FILES) $(DIV_CU_BP_FILES)
ALL_BLUEPRINTS_FILES += $(SQRT_C_BP_FILES)
ALL_BLUEPRINTS_FILES += $(SQR_CT_BP_FILES) $(SQR_CFS_BP_FILES) $(SQR_CFU_BP_FILES)
ALL_BLUEPRINTS_FILES += $(CMP_C_BP_FILES)
ALL_BLUEPRINTS_FILES += $(PENC_CX_BP_FILES) $(PENC_CN_BP_FILES)

ALL_BLUEPRINTS_FILES += $(MUL_ST_BP_FILES) $(DIV_SU_BP_FILES)

ALL_BLUEPRINTS_FILES += $(BCD2BIN_C_BP_FILES) $(BIN2BCD_C_BP_FILES)

ALL_BLUEPRINTS_FILES += $(MEM_TIMER_1R1W_BP_FILES) $(MEM_TIMER_2R1W_BP_FILES) $(MEM_TIMER_3R1W_BP_FILES) $(MEM_TIMER_4R1W_BP_FILES)
ALL_BLUEPRINTS_FILES += $(MEM_XORDFF_1R1W_BP_FILES) $(MEM_XORDFF_2R1W_BP_FILES) $(MEM_XORDFF_3R1W_BP_FILES) $(MEM_XORDFF_4R1W_BP_FILES)

# Make Report ------------------------------------------------------------------
# build the stat generator
tmp/stat-generator:
	cd stat-generator; swift build
	cp stat-generator/.build/debug/stat-generator tmp/stat-generator

# run the stat generator to produce data-sheet asciidoc
tmp/%.adoc: docs/%.adoc tmp/stat-generator
	tmp/stat-generator $(MKFILE_DIR) $< $@ $(VERSION_TAG)

# convert asciidoc into pdf
ASCIIDOC_OPT := -a compress -r asciidoctor-diagram --theme resources/theme.yml
DATASHEET.pdf: $(patsubst docs/%.adoc,tmp/%.adoc,$(wildcard docs/*.adoc)) resources/theme.yml
	asciidoctor-pdf tmp/main.adoc $(ASCIIDOC_OPT) -o DATASHEET.pdf

# Make Package -----------------------------------------------------------------
package.zip: $(ALL_BLUEPRINTS_FILES) DATASHEET.pdf
	zip -r package.zip blueprints DATASHEET.pdf

# Testing ----------------------------------------------------------------------

# obtain a list of test bench files
SRC_FILES := $(wildcard src/*.v)
TB_SRC_FILES := $(wildcard tb/tb_*.v)
TB_SIM_FILES := $(foreach w,$(TB_SRC_FILES),tmp/sim/$(subst tb/,,$(subst .v,.vvp,$(w))))

# compile test bench into vvp sim files
tmp/sim/tb_%.vvp: tb/tb_%.v $(SRC_FILES)
	iverilog -Wall -s tb -o $@ $<

# run test bench one by one
test: $(TB_SIM_FILES)
	$(foreach f,$(TB_SIM_FILES),vvp -N $(f) || exit 1;)

# Subcommands ------------------------------------------------------------------
.PHONY: package test synth setup clean cleantmp try-deps

all: blueprint

package: package.zip

blueprint-local: $(ALL_BLUEPRINTS_FILES)

blueprint: # open up a docker container and run the actual jobs
	$(call DOCKER_CMD_RUN,make -j $(NUM_CORES) blueprint-local)

# build the datasheet
datasheet: DATASHEET.pdf

# setup the empty folders ignored by github
setup:
	mkdir -p tmp
	mkdir -p tmp/sim
	mkdir -p blueprints
	mkdir -p reports

clean:
	rm -rf tmp
	rm -rf blueprints
	rm -rf reports
	mkdir -p tmp
	mkdir -p tmp/sim
	mkdir -p blueprints
	mkdir -p reports
	rm -rf stat-generator/.build
	rm -f DATASHEET.pdf
	rm -f package.zip

# test if all dependencies can be ran
try-deps:
	docker -v
	swift -version
	asciidoctor -v
	asciidoctor-pdf -v
	wavedrom-cli --version
	zip -v
