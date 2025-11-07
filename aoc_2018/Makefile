NAME=aoc.exe
INC=-Ilib -I"E:\vcpkg\installed\x64-windows\include" 
LIB="E:\vcpkg\installed\x64-windows\lib\libssl.lib" "E:\vcpkg\installed\x64-windows\lib\libcrypto.lib" "E:\vcpkg\installed\x64-windows\lib\sfml-graphics.lib" "E:\vcpkg\installed\x64-windows\lib\sfml-window.lib" "E:\vcpkg\installed\x64-windows\lib\sfml-system.lib"
V=-std=c++23
SRC= src/main.cpp



CC=clang

VCPKG_BIN_PATH="E:\vcpkg\installed\x64-windows\bin"
CRYPTO="\libcrypto-3-x64.dll"
SSL="\libssl-3-x64.dll"
SFML_GRAPHICS="\sfml-graphics-3.dll"
SFML_WINDOW="\sfml-window-3.dll"
SFML_SYSTEM="\sfml-system-3.dll"

NAME:
	$(CC) $(SRC) -o $(NAME) $(V) $(INC) $(LIB)
	cp $(VCPKG_BIN_PATH)$(CRYPTO) .
	cp $(VCPKG_BIN_PATH)$(SSL) .
	cp $(VCPKG_BIN_PATH)$(SFML_GRAPHICS) .
	cp $(VCPKG_BIN_PATH)$(SFML_WINDOW) .
	cp $(VCPKG_BIN_PATH)$(SFML_SYSTEM) .
