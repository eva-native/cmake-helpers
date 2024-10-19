function(embed_file)
  set(oneValueArgs PATH VARIABLE_NAME)
  set(options)
  set(multiValueArgs)

  cmake_parse_arguments(ARG "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

  message(STATUS "Embed file: called for ${ARG_PATH}")

  if(NOT ARG_PATH)
    message(FATAL_ERROR "embed_file: PATH required")
  endif()

  if(NOT EXISTS ${ARG_PATH})
    message(FATAL_ERROR "embed_file: file ${ARG_PATH} does not exist")
  endif()

  get_filename_component(FILENAME ${ARG_PATH} NAME_WE)
  set(DATA_VARIABLE_NAME "${FILENAME}")
  if(ARG_VARIABLE_NAME)
    set(DATA_VARIABLE_NAME "${ARG_VARIABLE_NAME}")
  endif()
  string(MAKE_C_IDENTIFIER "${DATA_VARIABLE_NAME}" VALID_DATA_VARIABLE_NAME)

  file(READ ${ARG_PATH} DATA HEX)
  string(REGEX REPLACE "([0-9a-f][0-9a-f])" "0x\\1, " DATA ${DATA})
  file(WRITE ${CMAKE_CURRENT_BINARY_DIR}/${FILENAME}.h
       "#ifndef ${FILENAME}_H_\n"
       "#define ${FILENAME}_H_\n"
       "#include <stddef.h>\n"
       "#include <stdint.h>\n"
       "#define EMBED_QUALIFIERS static constexpr\n"
       "alignas(16) EMBED_QUALIFIERS uint8_t ${VALID_DATA_VARIABLE_NAME}[] = {${DATA}};\n"
       "EMBED_QUALIFIERS size_t ${VALID_DATA_VARIABLE_NAME}Size = sizeof(${VALID_DATA_VARIABLE_NAME});\n"
       "#endif // ${FILENAME}_H_")

  message(STATUS "Embeded file: ${ARG_PATH} => ${CMAKE_CURRENT_BINARY_DIR}/${FILENAME}.h as ${VALID_DATA_VARIABLE_NAME}")
endfunction()
