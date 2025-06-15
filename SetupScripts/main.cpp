#include <iostream>
#include "bg3se_macos.h"

__attribute__((constructor))
void onLoad() {
    std::cout << "[bg3se-macos] dylib loaded.\n";
    initialize_extender();
}