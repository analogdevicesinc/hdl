
help:
	@echo ""
	@echo "Please specify a target."
	@echo ""
	@echo "To make libraries:"
	@echo "    make all"
	@echo ""
	@echo "To build a project:"
	@echo "    make proj.board"
	@echo "e.g.,"
	@echo "    make fmcomms1.zed"

# Library definitions
NO_LIB := axi_fifo common ip_pid_controller prcfg 
LIBRARIES := $(filter-out $(NO_LIB), $(shell ls library))
define LIBRARY_RULE
$1:
	cd library/$1; vivado -mode batch -source $1_ip.tcl 
endef

# Project definitions
NO_PROJ := 
PROJECTS := $(filter-out $(NO_PROJ), $(shell ls projects))
define PROJECT_RULE
$1.$2:
	cd projects/$1/$2; vivado -mode batch -source system_project.tcl 
endef
define APROJECT_RULE
    $(foreach archname,$(shell ls projects/$1), $(eval $(call PROJECT_RULE,$1,$(archname))))
endef

all:
	for libname in $(LIBRARIES) ; do \
	    make $$libname; \
	done

# Generate Makefile rules for libraries and projects
$(foreach libname,$(LIBRARIES), $(eval $(call LIBRARY_RULE,$(libname))))
$(foreach projname,$(PROJECTS), $(eval $(call APROJECT_RULE,$(projname))))

GITIGNORE := *.cache *.data *.xpr *.log component.xml *.jou xgui *.runs \
    *.srcs *.sdk .Xil *_INFO.txt *_dump.txt db *.asm.rpt *.done *.eda.rpt \
    *.fit.* *.map.* *.sta.* *.qsf *.qpf *.qws *.sof hc_output hps_isw_handoff \
    hps_sdram_*.csv incremental_db reconfig_mif *.sopcinfo *.jdi *.pin

distclean: clean
	@for name in $(LIBRARIES) ; do \
	    for templ in $(GITIGNORE) ; do \
	        rm -rf library/$$name/$$templ; \
	    done \
	done

clean:
	@for name in $(PROJECTS) ; do \
	    for templ in $(GITIGNORE) ; do \
	        rm -rf projects/$$name/$$templ; \
	    done \
	done
	@rm -f vivado.log vivado.jou
