# UiPath-specific configuration for libcurl

# Add MACHINE and P_ARCH definitions if specified
if(DEFINED MACHINE)
    add_compile_definitions(MACHINE=${MACHINE})
    message(STATUS "UiPath: MACHINE=${MACHINE}")
endif()

if(DEFINED P_ARCH)
    add_compile_definitions(P_ARCH=${P_ARCH})
    message(STATUS "UiPath: P_ARCH=${P_ARCH}")
endif()

# Enable PDB generation for Release builds
set(CMAKE_C_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE} /Zi")
set(CMAKE_SHARED_LINKER_FLAGS_RELEASE "${CMAKE_SHARED_LINKER_FLAGS_RELEASE} /DEBUG /OPT:REF /OPT:ICF")

# Set custom output name for libcurl if specified
if(DEFINED LIBCURL_OUTPUT_NAME)
    set(CMAKE_SHARED_LIBRARY_PREFIX "")
    set(LIB_NAME "${LIBCURL_OUTPUT_NAME}")
    message(STATUS "UiPath: Library name=${LIBCURL_OUTPUT_NAME}")
endif()
