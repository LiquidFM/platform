project (platform)

# Target - platform
add_custom_target (platform)

# Include files
generate_include_file (platform "platform/compiler.h" "include/compiler.h")
generate_include_file (platform "platform/platform.h" "include/platform.h")
generate_include_file (platform "platform/utils.h"    "include/utils.h")
