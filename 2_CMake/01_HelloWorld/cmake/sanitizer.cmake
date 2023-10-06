function(add_sanitizer_flags)
    if (NOT ${ENABLE_SANITIZE_ADDR} AND NOT ${ENABLE_SANITIZE_UNDEF})
        message(STATUS "Sanitizers deactivated.")
        return()
    endif()
    
    if(CMAKE_CXX_COMPILER_ID MATCHES "Clang" OR CMAKE_CXX_COMPILER_ID MATCHES "GNU")
        add_compile_options("-fno-omit-frame-pointer")
        add_link_options("-fno-omit-frame-pointer")

        if(${ENABLE_SANITIZE_ADDR})
            add_compile_options("-fsanitize=address")
            add_link_options("-fsanitize=address")
        endif(${ENABLE_SANITIZE_ADDR})

        if(${ENABLE_SANITIZE_UNDEF})
            add_compile_options("-fsanitize=undefined")
            add_link_options("-fsanitize=undefined")
        endif(${ENABLE_SANITIZE_UNDEF})
        
        


    elseif(CMAKE_CXX_COMPILER_ID MATCHES "MSVC")
        if(${ENABLE_SANITIZE_ADDR})
            add_compile_options("-/fsanitize=address")
        endif()

        if(${ENABLE_SANITIZE_UNDEF})
            message(STATUS "Undefined sanitizer not implemented for MSVC")
        endif()

    else()
        message(ERROR "Compiler not supported for Sanitizers")
    endif()
    
endfunction(add_sanitizer_flags)

