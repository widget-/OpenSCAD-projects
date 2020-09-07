BOTTOM_ROWS := 1 2 3 4
TOP_ROWS := 1 2 3 4 5 6 7 8
COLUMNS := 1 2 3 4
STACKSIZE := tall short

BOTTOM_JOBS := $(foreach row,$(BOTTOM_ROWS), \
$(foreach column,$(COLUMNS), \
$(foreach stacksize,$(STACKSIZE), \
	openscad\ "drawer-organizer.scad"\ -D\ "layer=\"bottom\""\ -D\ "rows=$(row)"\ -D\ "columns=$(column)"\ -D\ "stack_size=\"$(stacksize)\""\ -o\ "bottom\ $(stacksize)\ $(row)x$(column).stl"; \
)))

TOP_JOBS := $(foreach row,$(TOP_ROWS), \
$(foreach column,$(COLUMNS), \
$(foreach stacksize,$(STACKSIZE), \
	openscad\ "drawer-organizer.scad"\ -D\ "layer=\"top\""\ -D\ "rows=$(row)"\ -D\ "columns=$(column)"\ -D\ "stack_size=\"$(stacksize)\""\ -o\ "top\ $(stacksize)\ $(row)x$(column).stl"; \
)))

$(BOTTOM_JOBS): %: ; $*
$(TOP_JOBS): %: ; $*

bottom: ${BOTTOM_JOBS}; echo "$@ success"

top: ${TOP_JOBS}; echo "$@ success"

all: bottom top ; echo "$@ success"
