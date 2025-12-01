NAME=aoc.exe
INC=-Ilib -I"E:/vcpkg/installed/x64-windows/include" 
LIB="E:/vcpkg/installed/x64-windows/lib/libssl.lib" "E:/vcpkg/installed/x64-windows/lib/libcrypto.lib" "E:/vcpkg/installed/x64-windows/lib/sfml-graphics.lib" "E:/vcpkg/installed/x64-windows/lib/sfml-window.lib" "E:/vcpkg/installed/x64-windows/lib/sfml-system.lib"
V=-std=c++23
SRC= src/main.cpp

CC=clang

VCPKG_BIN_PATH=E:/vcpkg/installed/x64-windows/bin

# List of DLLs that need to be present in the build directory
DLLS = libcrypto-3-x64.dll libssl-3-x64.dll sfml-graphics-3.dll sfml-window-3.dll sfml-system-3.dll

all: $(NAME) $(DLLS)

$(NAME): $(SRC)
	$(CC) $(SRC) -o $(NAME) $(V) $(INC) $(LIB)

$(DLLS): %: $(VCPKG_BIN_PATH)/%
	cp $< .

.PHONY: all clean

clean:
	@rm -f $(NAME) $(DLLS)
