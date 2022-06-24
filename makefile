MKCWD=mkdir -p $(@D)

CXX ?= g++

SANITIZERS = 			\
	-fsanitize=address 	\
	-fsanitize=undefined


CFLAGS_WARNS ?= 	\
		-Werror 	\
		-Wextra 	\
		-Wall 		\
		-Wundef 	\
		-Wshadow 	\
		-Wvla

CXXFLAGS = 			\
		-O2 		\
		-g 		 	\
		-std=c++2a 	\
		--analyzer 	\
		-Isrc/      \
		$(CFLAGS_WARNS)

LDFLAGS=$(SANITIZERS)

# some people likes to use sources/source instead of src
PROJECT_NAME = test
BUILD_DIR = build
# you may want to update compile_flags.txt after changing this value
SRC_DIR = src

# avoid using '**' because in some cases it may not work
CXXFILES = $(wildcard $(SRC_DIR)/*.cpp) $(wildcard $(SRC_DIR)/*/*.cpp) $(wildcard $(SRC_DIR)/*/*/*.cpp)
DFILES = $(patsubst $(SRC_DIR)/%.cpp, $(BUILD_DIR)/%.d, $(CXXFILES))
OFILES = $(patsubst $(SRC_DIR)/%.cpp, $(BUILD_DIR)/%.o, $(CXXFILES))

OUTPUT = build/$(PROJECT_NAME)


$(OUTPUT): $(OFILES)
	@$(MKCWD)
	@echo " LD  [ $@ ] $<"
	@$(CXX) -o $@ $^ $(LDFLAGS)

$(BUILD_DIR)/%.o: $(SRC_DIR)/%.cpp
	@$(MKCWD)
	@echo " CXX [ $@ ] $<"
	@$(CXX) $(CXXFLAGS) -MMD -MP $< -c -o $@ 

run: $(OUTPUT)
	@$(OUTPUT)

all: $(OUTPUT)

clean:
	@rm -rf build/

.PHONY: clean all run

-include $(DFILES)
