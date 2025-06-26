# Get current directory
MKFILE_PATH := $(abspath $(lastword $(MAKEFILE_LIST)))
MKFILE_DIR := $(dir $(MKFILE_PATH))

# Docker Container Build Setup
DOCKER_IMAGE = ghcr.io/yliu-hashed/sm-eda-bundle:latest
DOCKER_MOUNT_ARGS := --mount type=bind,source="$(MKFILE_DIR)",target=/working
DOCKER_ARGS := run --rm $(DOCKER_MOUNT_ARGS) $(DOCKER_IMAGE)
CMD_RUN = docker $(DOCKER_ARGS) bash -l -c "cd working && timeout 500 $(1)"

EXTRACT_REPORT_FROM_BP = $(subst blueprints/,reports/,$(1))

# Command Pallette
PLACE_ARGS := --pack --double-sided --lz4-path /usr/bin/lz4
SYNTH     = $(call CMD_RUN,yosys $(1) -q -s resources/script_$(2).ys -o tmp/$(3)_synth.json -D GEN $(4))
PLACE     = $(call CMD_RUN,sm-eda flow      -q $(PLACE_ARGS) $(1) $(2) -R $(call EXTRACT_REPORT_FROM_BP,$(2)))
PLACE_RAW = $(call CMD_RUN,sm-eda autoplace -q $(PLACE_ARGS) $(1) $(2) -R $(call EXTRACT_REPORT_FROM_BP,$(2)))

# --- BIN MATH COMB MODULES ----------------------------------------------------
BIN_MATH_COMB_WIDTHS := 8 16 24 32
# ADD COMB 2I
ADD_C2_WIDTHS := $(BIN_MATH_COMB_WIDTHS)
ADD_C2_SYNTH_FILES := $(foreach w,$(ADD_C2_WIDTHS),tmp/add_comb_2i_$(w)_synth.json)
ADD_C2_COMMAND = $(call SYNTH,-D LEN=$(1) -D ARG2I,comb,add_comb_2i_$(1),src/add_comb.v)
ADD_C2_EXTRACT_WIDTH = $(subst tmp/add_comb_2i_,,$(subst _synth.json,,$(1)))
# ADD COMB 3I
ADD_C3_WIDTHS := $(BIN_MATH_COMB_WIDTHS)
ADD_C3_SYNTH_FILES := $(foreach w,$(ADD_C3_WIDTHS),tmp/add_comb_3i_$(w)_synth.json)
ADD_C3_COMMAND = $(call SYNTH,-D LEN=$(1) -D ARG3I,comb,add_comb_3i_$(1),src/add_comb.v)
ADD_C3_EXTRACT_WIDTH = $(subst tmp/add_comb_3i_,,$(subst _synth.json,,$(1)))
# ADD COMB 4I
ADD_C4_WIDTHS := $(BIN_MATH_COMB_WIDTHS)
ADD_C4_SYNTH_FILES := $(foreach w,$(ADD_C4_WIDTHS),tmp/add_comb_4i_$(w)_synth.json)
ADD_C4_COMMAND = $(call SYNTH,-D LEN=$(1) -D ARG4I,comb,add_comb_4i_$(1),src/add_comb.v)
ADD_C4_EXTRACT_WIDTH = $(subst tmp/add_comb_4i_,,$(subst _synth.json,,$(1)))
# MUL COMB TRUNC
MUL_CT_WIDTHS := $(BIN_MATH_COMB_WIDTHS)
MUL_CT_SYNTH_FILES := $(foreach w,$(MUL_CT_WIDTHS),tmp/mul_comb_trunc_$(w)_synth.json)
MUL_CT_COMMAND = $(call SYNTH,-D LEN=$(1) -D TRUNC,comb,mul_comb_trunc_$(1),src/mul_comb.v)
MUL_CT_EXTRACT_WIDTH = $(subst tmp/mul_comb_trunc_,,$(subst _synth.json,,$(1)))
# MUL COMB FULL SIGNED
MUL_CFS_WIDTHS := $(BIN_MATH_COMB_WIDTHS)
MUL_CFS_SYNTH_FILES := $(foreach w,$(MUL_CFS_WIDTHS),tmp/mul_comb_full_signed_$(w)_synth.json)
MUL_CFS_COMMAND = $(call SYNTH,-D LEN=$(1) -D FULL_SIGNED,comb,mul_comb_full_signed_$(1),src/mul_comb.v)
MUL_CFS_EXTRACT_WIDTH = $(subst tmp/mul_comb_full_signed_,,$(subst _synth.json,,$(1)))
# MUL COMB FULL UNSIGNED
MUL_CFU_WIDTHS := $(BIN_MATH_COMB_WIDTHS)
MUL_CFU_SYNTH_FILES := $(foreach w,$(MUL_CFU_WIDTHS),tmp/mul_comb_full_unsigned_$(w)_synth.json)
MUL_CFU_COMMAND = $(call SYNTH,-D LEN=$(1) -D FULL_UNSIGNED,comb,mul_comb_full_unsigned_$(1),src/mul_comb.v)
MUL_CFU_EXTRACT_WIDTH = $(subst tmp/mul_comb_full_unsigned_,,$(subst _synth.json,,$(1)))
# MUL COMB FULL MIXED
MUL_CFM_WIDTHS := $(BIN_MATH_COMB_WIDTHS)
MUL_CFM_SYNTH_FILES := $(foreach w,$(MUL_CFM_WIDTHS),tmp/mul_comb_full_mixed_$(w)_synth.json)
MUL_CFM_COMMAND = $(call SYNTH,-D LEN=$(1) -D FULL_MIXED,comb,mul_comb_full_mixed_$(1),src/mul_comb.v)
MUL_CFM_EXTRACT_WIDTH = $(subst tmp/mul_comb_full_mixed_,,$(subst _synth.json,,$(1)))
# DIV COMB SIGNED
DIV_CS_WIDTHS := $(BIN_MATH_COMB_WIDTHS)
DIV_CS_SYNTH_FILES := $(foreach w,$(DIV_CS_WIDTHS),tmp/div_comb_signed_$(w)_synth.json)
DIV_CS_COMMAND = $(call SYNTH,-D LEN=$(1) -D SIGNED,comb,div_comb_signed_$(1),src/div_comb.v)
DIV_CS_EXTRACT_WIDTH = $(subst tmp/div_comb_signed_,,$(subst _synth.json,,$(1)))
# DIV COMB UNSIGNED
DIV_CU_WIDTHS := $(BIN_MATH_COMB_WIDTHS)
DIV_CU_SYNTH_FILES := $(foreach w,$(DIV_CU_WIDTHS),tmp/div_comb_unsigned_$(w)_synth.json)
DIV_CU_COMMAND = $(call SYNTH,-D LEN=$(1) -D UNSIGNED,comb,div_comb_unsigned_$(1),src/div_comb.v)
DIV_CU_EXTRACT_WIDTH = $(subst tmp/div_comb_unsigned_,,$(subst _synth.json,,$(1)))
# REM COMB SIGNED
REM_CS_WIDTHS := $(BIN_MATH_COMB_WIDTHS)
REM_CS_SYNTH_FILES := $(foreach w,$(REM_CS_WIDTHS),tmp/rem_comb_signed_$(w)_synth.json)
REM_CS_COMMAND = $(call SYNTH,-D LEN=$(1) -D SIGNED,comb,rem_comb_signed_$(1),src/rem_comb.v)
REM_CS_EXTRACT_WIDTH = $(subst tmp/rem_comb_signed_,,$(subst _synth.json,,$(1)))
# REM COMB UNSIGNED
REM_CU_WIDTHS := $(BIN_MATH_COMB_WIDTHS)
REM_CU_SYNTH_FILES := $(foreach w,$(REM_CU_WIDTHS),tmp/rem_comb_unsigned_$(w)_synth.json)
REM_CU_COMMAND = $(call SYNTH,-D LEN=$(1) -D UNSIGNED,comb,rem_comb_unsigned_$(1),src/rem_comb.v)
REM_CU_EXTRACT_WIDTH = $(subst tmp/rem_comb_unsigned_,,$(subst _synth.json,,$(1)))
# SQRT COMB
SQRT_C_WIDTHS := $(BIN_MATH_COMB_WIDTHS)
SQRT_C_SYNTH_FILES := $(foreach w,$(SQRT_C_WIDTHS),tmp/sqrt_comb_$(w)_synth.json)
SQRT_C_COMMAND = $(call SYNTH,-D LEN=$(1),comb,sqrt_comb_$(1),src/sqrt_comb.v)
SQRT_C_EXTRACT_WIDTH = $(subst tmp/sqrt_comb_,,$(subst _synth.json,,$(1)))
# SQR COMB TRUNC
SQR_CT_WIDTHS := $(BIN_MATH_COMB_WIDTHS)
SQR_CT_SYNTH_FILES := $(foreach w,$(SQR_CT_WIDTHS),tmp/sqr_comb_trunc_$(w)_synth.json)
SQR_CT_COMMAND = $(call SYNTH,-D LEN=$(1) -D TRUNC,comb,sqr_comb_trunc_$(1),src/sqr_comb.v)
SQR_CT_EXTRACT_WIDTH = $(subst tmp/sqr_comb_trunc_,,$(subst _synth.json,,$(1)))
# SQR COMB FULL SIGNED
SQR_CFS_WIDTHS := $(BIN_MATH_COMB_WIDTHS)
SQR_CFS_SYNTH_FILES := $(foreach w,$(SQR_CFS_WIDTHS),tmp/sqr_comb_full_signed_$(w)_synth.json)
SQR_CFS_COMMAND = $(call SYNTH,-D LEN=$(1) -D FULL_SIGNED,comb,sqr_comb_full_signed_$(1),src/sqr_comb.v)
SQR_CFS_EXTRACT_WIDTH = $(subst tmp/sqr_comb_full_signed_,,$(subst _synth.json,,$(1)))
# SQR COMB FULL UNSIGNED
SQR_CFU_WIDTHS := $(BIN_MATH_COMB_WIDTHS)
SQR_CFU_SYNTH_FILES := $(foreach w,$(SQR_CFU_WIDTHS),tmp/sqr_comb_full_unsigned_$(w)_synth.json)
SQR_CFU_COMMAND = $(call SYNTH,-D LEN=$(1) -D FULL_UNSIGNED,comb,sqr_comb_full_unsigned_$(1),src/sqr_comb.v)
SQR_CFU_EXTRACT_WIDTH = $(subst tmp/sqr_comb_full_unsigned_,,$(subst _synth.json,,$(1)))
# CMP COMB
CMP_C_WIDTHS := 8 16 24 32 48 64
CMP_C_SYNTH_FILES := $(foreach w,$(CMP_C_WIDTHS),tmp/cmp_comb_$(w)_synth.json)
CMP_C_COMMAND = $(call SYNTH,-D LEN=$(1),comb,cmp_comb_$(1),src/cmp_comb.v)
CMP_C_EXTRACT_WIDTH = $(subst tmp/cmp_comb_,,$(subst _synth.json,,$(1)))
# PENC COMB MAX
PENC_CX_WIDTHS := 3 4 5 6
PENC_CX_SYNTH_FILES := $(foreach w,$(PENC_CX_WIDTHS),tmp/penc_comb_max_$(w)_synth.json)
PENC_CX_COMMAND = $(call SYNTH,-D LEN=$(1) -D MAX,comb,penc_comb_max_$(1),src/penc_comb.v)
PENC_CX_EXTRACT_WIDTH = $(subst tmp/penc_comb_max_,,$(subst _synth.json,,$(1)))
# PENC COMB MIN
PENC_CN_WIDTHS := 3 4 5 6
PENC_CN_SYNTH_FILES := $(foreach w,$(PENC_CN_WIDTHS),tmp/penc_comb_min_$(w)_synth.json)
PENC_CN_COMMAND = $(call SYNTH,-D LEN=$(1) -D MIN,comb,penc_comb_min_$(1),src/penc_comb.v)
PENC_CN_EXTRACT_WIDTH = $(subst tmp/penc_comb_min_,,$(subst _synth.json,,$(1)))
# --- BIN MATH SEQ MODULES -----------------------------------------------------
BIN_MATH_SEQ_WIDTHS := 16 24 #32 64
# MUL SEQ TRUNC
MUL_ST_WIDTHS := $(BIN_MATH_SEQ_WIDTHS)
MUL_ST_SYNTH_FILES := $(foreach w,$(MUL_ST_WIDTHS),tmp/mul_seq_trunc_$(w)_synth.json)
MUL_ST_COMMAND = $(call SYNTH,-D LEN=$(1) -D TRUNC,seq,mul_seq_trunc_$(1),src/mul_seq.v)
MUL_ST_EXTRACT_WIDTH = $(subst tmp/mul_seq_trunc_,,$(subst _synth.json,,$(1)))
# DIV SEQ TRUNC
DIV_SU_WIDTHS := $(BIN_MATH_SEQ_WIDTHS)
DIV_SU_SYNTH_FILES := $(foreach w,$(DIV_SU_WIDTHS),tmp/div_seq_unsigned_$(w)_synth.json)
DIV_SU_COMMAND = $(call SYNTH,-D LEN=$(1) -D TRUNC,seq,div_seq_unsigned_$(1),src/div_seq.v)
DIV_SU_EXTRACT_WIDTH = $(subst tmp/div_seq_unsigned_,,$(subst _synth.json,,$(1)))
# --- BCD CONV MODULES ---------------------------------------------------------
# BCD2BIN COMB
BIN_BCD_WIDTHS := 8B2D 8B3D 16B4D 16B5D 24B7D 24B8D 32B9D 32B10D
BCD2BIN_C_SYNTH_FILES := $(foreach w,$(BIN_BCD_WIDTHS),tmp/bcd2bin_comb_$(w)_synth.json)
BCD2BIN_C_COMMAND = $(call SYNTH,-D MODE_$(1),comb,bcd2bin_comb_$(1),src/bcd2bin_comb.v)
BCD2BIN_C_EXTRACT_WIDTH = $(subst tmp/bcd2bin_comb_,,$(subst _synth.json,,$(1)))
# BIN2BCD COMB
BIN2BCD_C_SYNTH_FILES := $(foreach w,$(BIN_BCD_WIDTHS),tmp/bin2bcd_comb_$(w)_synth.json)
BIN2BCD_C_COMMAND = $(call SYNTH,-D MODE_$(1),comb,bin2bcd_comb_$(1),src/bcd2bin_comb.v)
BIN2BCD_C_EXTRACT_WIDTH = $(subst tmp/bin2bcd_comb_,,$(subst _synth.json,,$(1)))
# --- TIMER MEM MODULES --------------------------------------------------------
MEM_TIMER_WIDTHS := 8
MEM_TIMER_DEPTHS := 6 7 8 9 10 11
MEM_TIMER_TYPES := $(foreach w,$(MEM_TIMER_WIDTHS),$(foreach d,$(MEM_TIMER_DEPTHS),$(w)x$(d)))
MEM_TIMER_TYPE_EXTRACT_WIDTH = $(word 1,$(subst x, ,$(1)))
MEM_TIMER_TYPE_EXTRACT_DEPTH = $(word 2,$(subst x, ,$(1)))
MEM_TIMER_ARGS_FROM_TYPE = --dbits $(call MEM_TIMER_TYPE_EXTRACT_WIDTH,$(1)) --abits $(call MEM_TIMER_TYPE_EXTRACT_DEPTH,$(1))
# MEM 1R1W
MEM_TIMER_1R1W_SYNTH_FILES := $(foreach t,$(MEM_TIMER_TYPES),tmp/mem_timer_1r1w_$(t)_synth.json)
MEM_TIMER_1R1W_PORTS := --port w --port r
MEM_TIMER_1R1W_EXTRACT_TYPE = $(subst tmp/mem_timer_1r1w_,,$(subst _synth.json,,$(1)))
MEM_TIMER_1R1W_COMMAND = $(call CMD_RUN,sm-eda bram --timer --max-loop-delay 16 -q $(MEM_TIMER_1R1W_PORTS) $(call MEM_TIMER_ARGS_FROM_TYPE,$(1)) tmp/mem_timer_1r1w_$(1)_synth.json)
# MEM 2R1W
MEM_TIMER_2R1W_SYNTH_FILES := $(foreach t,$(MEM_TIMER_TYPES),tmp/mem_timer_2r1w_$(t)_synth.json)
MEM_TIMER_2R1W_PORTS := --port w --port r --port r
MEM_TIMER_2R1W_EXTRACT_TYPE = $(subst tmp/mem_timer_2r1w_,,$(subst _synth.json,,$(1)))
MEM_TIMER_2R1W_COMMAND = $(call CMD_RUN,sm-eda bram --timer --max-loop-delay 16 -q $(MEM_TIMER_2R1W_PORTS) $(call MEM_TIMER_ARGS_FROM_TYPE,$(1)) tmp/mem_timer_2r1w_$(1)_synth.json)
# MEM 3R1W
MEM_TIMER_3R1W_SYNTH_FILES := $(foreach t,$(MEM_TIMER_TYPES),tmp/mem_timer_3r1w_$(t)_synth.json)
MEM_TIMER_3R1W_PORTS := --port w --port r --port r --port r
MEM_TIMER_3R1W_EXTRACT_TYPE = $(subst tmp/mem_timer_3r1w_,,$(subst _synth.json,,$(1)))
MEM_TIMER_3R1W_COMMAND = $(call CMD_RUN,sm-eda bram --timer --max-loop-delay 16 -q $(MEM_TIMER_3R1W_PORTS) $(call MEM_TIMER_ARGS_FROM_TYPE,$(1)) tmp/mem_timer_3r1w_$(1)_synth.json)
# MEM 4R1W
MEM_TIMER_4R1W_SYNTH_FILES := $(foreach t,$(MEM_TIMER_TYPES),tmp/mem_timer_4r1w_$(t)_synth.json)
MEM_TIMER_4R1W_PORTS := --port w --port r --port r --port r --port r
MEM_TIMER_4R1W_EXTRACT_TYPE = $(subst tmp/mem_timer_4r1w_,,$(subst _synth.json,,$(1)))
MEM_TIMER_4R1W_COMMAND = $(call CMD_RUN,sm-eda bram --timer --max-loop-delay 16 -q $(MEM_TIMER_4R1W_PORTS) $(call MEM_TIMER_ARGS_FROM_TYPE,$(1)) tmp/mem_timer_4r1w_$(1)_synth.json)
# --- XOR MEM MODULES ----------------------------------------------------------
MEM_XORDFF_WIDTHS := 8
MEM_XORDFF_DEPTHS := 4 5 6 7
MEM_XORDFF_TYPES := $(foreach w,$(MEM_XORDFF_WIDTHS),$(foreach d,$(MEM_XORDFF_DEPTHS),$(w)x$(d)))
MEM_XORDFF_TYPE_EXTRACT_WIDTH = $(word 1,$(subst x, ,$(1)))
MEM_XORDFF_TYPE_EXTRACT_DEPTH = $(word 2,$(subst x, ,$(1)))
MEM_XORDFF_ARGS_FROM_TYPE = --dbits $(call MEM_TIMER_TYPE_EXTRACT_WIDTH,$(1)) --abits $(call MEM_XORDFF_TYPE_EXTRACT_DEPTH,$(1))
# MEM 1R1W
MEM_XORDFF_1R1W_SYNTH_FILES := $(foreach t,$(MEM_XORDFF_TYPES),tmp/mem_xordff_1r1w_$(t)_synth.json)
MEM_XORDFF_1R1W_PORTS := --port w --port r
MEM_XORDFF_1R1W_EXTRACT_TYPE = $(subst tmp/mem_xordff_1r1w_,,$(subst _synth.json,,$(1)))
MEM_XORDFF_1R1W_COMMAND = $(call CMD_RUN,sm-eda bram --dff -q $(MEM_XORDFF_1R1W_PORTS) $(call MEM_XORDFF_ARGS_FROM_TYPE,$(1)) tmp/mem_xordff_1r1w_$(1)_synth.json)
# MEM 2R1W
MEM_XORDFF_2R1W_SYNTH_FILES := $(foreach t,$(MEM_XORDFF_TYPES),tmp/mem_xordff_2r1w_$(t)_synth.json)
MEM_XORDFF_2R1W_PORTS := --port w --port r --port r
MEM_XORDFF_2R1W_EXTRACT_TYPE = $(subst tmp/mem_xordff_2r1w_,,$(subst _synth.json,,$(1)))
MEM_XORDFF_2R1W_COMMAND = $(call CMD_RUN,sm-eda bram --dff -q $(MEM_XORDFF_2R1W_PORTS) $(call MEM_XORDFF_ARGS_FROM_TYPE,$(1)) tmp/mem_xordff_2r1w_$(1)_synth.json)
# MEM 3R1W
MEM_XORDFF_3R1W_SYNTH_FILES := $(foreach t,$(MEM_XORDFF_TYPES),tmp/mem_xordff_3r1w_$(t)_synth.json)
MEM_XORDFF_3R1W_PORTS := --port w --port r --port r --port r
MEM_XORDFF_3R1W_EXTRACT_TYPE = $(subst tmp/mem_xordff_3r1w_,,$(subst _synth.json,,$(1)))
MEM_XORDFF_3R1W_COMMAND = $(call CMD_RUN,sm-eda bram --dff -q $(MEM_XORDFF_3R1W_PORTS) $(call MEM_XORDFF_ARGS_FROM_TYPE,$(1)) tmp/mem_xordff_3r1w_$(1)_synth.json)
# MEM 4R1W
MEM_XORDFF_4R1W_SYNTH_FILES := $(foreach t,$(MEM_XORDFF_TYPES),tmp/mem_xordff_4r1w_$(t)_synth.json)
MEM_XORDFF_4R1W_PORTS := --port w --port r --port r --port r --port r
MEM_XORDFF_4R1W_EXTRACT_TYPE = $(subst tmp/mem_xordff_4r1w_,,$(subst _synth.json,,$(1)))
MEM_XORDFF_4R1W_COMMAND = $(call CMD_RUN,sm-eda bram --dff -q $(MEM_XORDFF_4R1W_PORTS) $(call MEM_XORDFF_ARGS_FROM_TYPE,$(1)) tmp/mem_xordff_4r1w_$(1)_synth.json)
# ------------------------------------------------------------------------------

ALL_SYNTH_FILES := $(ADD_C2_SYNTH_FILES) $(ADD_C3_SYNTH_FILES) $(ADD_C4_SYNTH_FILES)
ALL_SYNTH_FILES += $(MUL_CT_SYNTH_FILES) $(MUL_CFS_SYNTH_FILES) $(MUL_CFU_SYNTH_FILES) $(MUL_CFM_SYNTH_FILES)
ALL_SYNTH_FILES += $(REM_CS_SYNTH_FILES) $(REM_CU_SYNTH_FILES)
ALL_SYNTH_FILES += $(DIV_CS_SYNTH_FILES) $(DIV_CU_SYNTH_FILES)
ALL_SYNTH_FILES += $(SQRT_C_SYNTH_FILES)
ALL_SYNTH_FILES += $(SQR_CT_SYNTH_FILES) $(SQR_CFS_SYNTH_FILES) $(SQR_CFU_SYNTH_FILES)
ALL_SYNTH_FILES += $(CMP_C_SYNTH_FILES)
ALL_SYNTH_FILES += $(PENC_CX_SYNTH_FILES) $(PENC_CN_SYNTH_FILES)

ALL_SYNTH_FILES += $(MUL_ST_SYNTH_FILES) $(DIV_SU_SYNTH_FILES)

ALL_SYNTH_FILES += $(BCD2BIN_C_SYNTH_FILES) $(BIN2BCD_C_SYNTH_FILES)

ALL_SYNTH_FILES += $(MEM_TIMER_1R1W_SYNTH_FILES) $(MEM_TIMER_2R1W_SYNTH_FILES) $(MEM_TIMER_3R1W_SYNTH_FILES) $(MEM_TIMER_4R1W_SYNTH_FILES)
ALL_SYNTH_FILES += $(MEM_XORDFF_1R1W_SYNTH_FILES) $(MEM_XORDFF_2R1W_SYNTH_FILES) $(MEM_XORDFF_3R1W_SYNTH_FILES) $(MEM_XORDFF_4R1W_SYNTH_FILES)

ALL_BLUEPRINTS_FILES = $(subst _synth,,$(subst tmp/,blueprints/,$(ALL_SYNTH_FILES)))

all:  $(ALL_BLUEPRINTS_FILES)

# --- BIN MATH COMB MODULES ----------------------------------------------------
# --- ADD ----------------------------------------------------------------------
# Synthesis
$(ADD_C2_SYNTH_FILES): src/add_comb.v resources/script_comb.ys
	$(call ADD_C2_COMMAND,$(call ADD_C2_EXTRACT_WIDTH,$@))

$(ADD_C3_SYNTH_FILES): src/add_comb.v resources/script_comb.ys
	$(call ADD_C3_COMMAND,$(call ADD_C3_EXTRACT_WIDTH,$@))

$(ADD_C4_SYNTH_FILES): src/add_comb.v resources/script_comb.ys
	$(call ADD_C4_COMMAND,$(call ADD_C4_EXTRACT_WIDTH,$@))

# Conversion & Implementation
blueprints/add_comb_%.json: tmp/add_comb_%_synth.json
	$(call PLACE,$?,$@)

# --- MUL ----------------------------------------------------------------------
# Synthesis
$(MUL_CT_SYNTH_FILES): src/mul_comb.v resources/script_comb.ys
	$(call MUL_CT_COMMAND,$(call MUL_CT_EXTRACT_WIDTH,$@))

$(MUL_CFS_SYNTH_FILES): src/mul_comb.v resources/script_comb.ys
	$(call MUL_CFS_COMMAND,$(call MUL_CFS_EXTRACT_WIDTH,$@))

$(MUL_CFU_SYNTH_FILES): src/mul_comb.v resources/script_comb.ys
	$(call MUL_CFU_COMMAND,$(call MUL_CFU_EXTRACT_WIDTH,$@))

$(MUL_CFM_SYNTH_FILES): src/mul_comb.v resources/script_comb.ys
	$(call MUL_CFM_COMMAND,$(call MUL_CFM_EXTRACT_WIDTH,$@))

# Conversion & Implementation
blueprints/mul_comb_%.json: tmp/mul_comb_%_synth.json
	$(call PLACE,$?,$@)

# --- DIV ----------------------------------------------------------------------
# Synthesis
$(DIV_CS_SYNTH_FILES): src/div_comb.v resources/script_comb.ys
	$(call DIV_CS_COMMAND,$(call DIV_CS_EXTRACT_WIDTH,$@))

$(DIV_CU_SYNTH_FILES): src/div_comb.v resources/script_comb.ys
	$(call DIV_CU_COMMAND,$(call DIV_CU_EXTRACT_WIDTH,$@))

# Conversion & Implementation
blueprints/div_comb_%.json: tmp/div_comb_%_synth.json
	$(call PLACE,$?,$@)

# --- REM ----------------------------------------------------------------------
# Synthesis
$(REM_CS_SYNTH_FILES): src/rem_comb.v resources/script_comb.ys
	$(call REM_CS_COMMAND,$(call REM_CS_EXTRACT_WIDTH,$@))

$(REM_CU_SYNTH_FILES): src/rem_comb.v resources/script_comb.ys
	$(call REM_CU_COMMAND,$(call REM_CU_EXTRACT_WIDTH,$@))

# Conversion & Implementation
blueprints/rem_comb_%.json: tmp/rem_comb_%_synth.json
	$(call PLACE,$?,$@)

# --- SQRT ---------------------------------------------------------------------
# Synthesis
$(SQRT_C_SYNTH_FILES): src/sqrt_comb.v resources/script_comb.ys
	$(call SQRT_C_COMMAND,$(call SQRT_C_EXTRACT_WIDTH,$@))

# Conversion & Implementation
blueprints/sqrt_comb_%.json: tmp/sqrt_comb_%_synth.json
	$(call PLACE,$?,$@)

# --- SQR ----------------------------------------------------------------------
# Synthesis
$(SQR_CT_SYNTH_FILES): src/sqr_comb.v resources/script_comb.ys
	$(call SQR_CT_COMMAND,$(call SQR_CT_EXTRACT_WIDTH,$@))

$(SQR_CFS_SYNTH_FILES): src/sqr_comb.v resources/script_comb.ys
	$(call SQR_CFS_COMMAND,$(call SQR_CFS_EXTRACT_WIDTH,$@))

$(SQR_CFU_SYNTH_FILES): src/sqr_comb.v resources/script_comb.ys
	$(call SQR_CFU_COMMAND,$(call SQR_CFU_EXTRACT_WIDTH,$@))

# Conversion & Implementation
blueprints/sqr_comb_%.json: tmp/sqr_comb_%_synth.json
	$(call PLACE,$?,$@)

# --- CMP ----------------------------------------------------------------------
# Synthesis
$(CMP_C_SYNTH_FILES): src/cmp_comb.v resources/script_comb.ys
	$(call CMP_C_COMMAND,$(call CMP_C_EXTRACT_WIDTH,$@))

# Conversion & Implementation
blueprints/cmp_comb_%.json: tmp/cmp_comb_%_synth.json
	$(call PLACE,$?,$@)

# --- PRIORITY-ENCODER ---------------------------------------------------------
# Synthesis
$(PENC_CX_SYNTH_FILES): src/penc_comb.v resources/script_comb.ys
	$(call PENC_CX_COMMAND,$(call PENC_CX_EXTRACT_WIDTH,$@))

$(PENC_CN_SYNTH_FILES): src/penc_comb.v resources/script_comb.ys
	$(call PENC_CN_COMMAND,$(call PENC_CN_EXTRACT_WIDTH,$@))

# Conversion & Implementation
blueprints/penc_comb_%.json: tmp/penc_comb_%_synth.json
	$(call PLACE,$?,$@)

# --- BIN MATH SEQ MODULES -----------------------------------------------------
# --- MUL ----------------------------------------------------------------------
# Synthesis
$(MUL_ST_SYNTH_FILES): src/mul_seq.v resources/script_seq.ys
	$(call MUL_ST_COMMAND,$(call MUL_ST_EXTRACT_WIDTH,$@))

# Conversion & Implementation
blueprints/mul_seq_%.json: tmp/mul_seq_%_synth.json
	$(call PLACE,$?,$@)

# --- DIV ----------------------------------------------------------------------
# Synthesis
$(DIV_SU_SYNTH_FILES): src/div_seq.v resources/script_seq.ys
	$(call DIV_SU_COMMAND,$(call DIV_SU_EXTRACT_WIDTH,$@))

# Conversion & Implementation
blueprints/div_seq_%.json: tmp/div_seq_%_synth.json
	$(call PLACE,$?,$@)

# --- BCD COMB MODULES ---------------------------------------------------------
# --- BCD2BIN ------------------------------------------------------------------
# Synthesis
$(BCD2BIN_C_SYNTH_FILES): src/bcd2bin_comb.v resources/script_comb.ys
	$(call BCD2BIN_C_COMMAND,$(call BCD2BIN_C_EXTRACT_WIDTH,$@))

# Conversion & Implementation
blueprints/bcd2bin_comb_%.json: tmp/bcd2bin_comb_%_synth.json
	$(call PLACE,$?,$@)

# --- BIN2BCD ------------------------------------------------------------------
# Synthesis
$(BIN2BCD_C_SYNTH_FILES): src/bin2bcd_comb.v resources/script_comb.ys
	$(call BIN2BCD_C_COMMAND,$(call BIN2BCD_C_EXTRACT_WIDTH,$@))

# Conversion & Implementation
blueprints/bin2bcd_comb_%.json: tmp/bin2bcd_comb_%_synth.json
	$(call PLACE,$?,$@)

# --- MEM TIMER MODULES --------------------------------------------------------
# Synthesis
$(MEM_TIMER_1R1W_SYNTH_FILES):
	$(call MEM_TIMER_1R1W_COMMAND,$(call MEM_TIMER_1R1W_EXTRACT_TYPE,$@))

$(MEM_TIMER_2R1W_SYNTH_FILES):
	$(call MEM_TIMER_2R1W_COMMAND,$(call MEM_TIMER_2R1W_EXTRACT_TYPE,$@))

$(MEM_TIMER_3R1W_SYNTH_FILES):
	$(call MEM_TIMER_3R1W_COMMAND,$(call MEM_TIMER_3R1W_EXTRACT_TYPE,$@))

$(MEM_TIMER_4R1W_SYNTH_FILES):
	$(call MEM_TIMER_4R1W_COMMAND,$(call MEM_TIMER_4R1W_EXTRACT_TYPE,$@))

# Conversion & Implementation
blueprints/mem_timer_%.json: tmp/mem_timer_%_synth.json
	$(call PLACE_RAW,$?,$@)

# --- MEM XORDFF MODULES -------------------------------------------------------
# Synthesis
$(MEM_XORDFF_1R1W_SYNTH_FILES):
	$(call MEM_XORDFF_1R1W_COMMAND,$(call MEM_XORDFF_1R1W_EXTRACT_TYPE,$@))

$(MEM_XORDFF_2R1W_SYNTH_FILES):
	$(call MEM_XORDFF_2R1W_COMMAND,$(call MEM_XORDFF_2R1W_EXTRACT_TYPE,$@))

$(MEM_XORDFF_3R1W_SYNTH_FILES):
	$(call MEM_XORDFF_3R1W_COMMAND,$(call MEM_XORDFF_3R1W_EXTRACT_TYPE,$@))

$(MEM_XORDFF_4R1W_SYNTH_FILES):
	$(call MEM_XORDFF_4R1W_COMMAND,$(call MEM_XORDFF_4R1W_EXTRACT_TYPE,$@))

# Conversion & Implementation
blueprints/mem_xordff_%.json: tmp/mem_xordff_%_synth.json
	$(call PLACE_RAW,$?,$@)

# Subcommands ------------------------------------------------------------------
synth: $(ALL_SYNTH_FILES)

# setup the empty folders ignored by github
setup:
	mkdir -p tmp
	mkdir -p blueprints
	mkdir -p reports

clean:
	rm -rf tmp
	rm -rf blueprints
	rm -rf reports
	mkdir -p tmp
	mkdir -p blueprints
	mkdir -p reports

# test if all dependencies can be ran
try-deps:
	docker -v
	swift -version
