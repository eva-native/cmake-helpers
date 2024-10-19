function(generate_ui_headers_qt5 UI_FILES OUT_HEADERS_VAR_NAME OUTPUT_DIR)
  set(ui_headers "")
  if (NOT EXISTS ${OUTPUT_DIR})
    file(MAKE_DIRECTORY ${OUTPUT_DIR})
  endif()
  foreach(ui_file ${UI_FILES})
    get_filename_component(ui_file_we ${ui_file} NAME_WE)
    set(ui_header ${OUTPUT_DIR}/ui_${ui_file_we}.hpp)
    add_custom_command(OUTPUT ${ui_header}
                       COMMAND ${Qt5Widgets_UIC_EXECUTABLE} ${ui_file} -o ${ui_header}
                       MAIN_DEPENDENCY ${ui_file}
                       WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
                       COMMENT "Generate ${ui_header}")
    list(APPEND ui_headers ${ui_header})
  endforeach()
  set(${OUT_HEADERS_VAR_NAME} ${ui_headers} PARENT_SCOPE)
endfunction()
