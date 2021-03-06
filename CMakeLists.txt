# CMake entry point
cmake_minimum_required (VERSION 3.0)
project (Quentin_Warnant_OpenGL_Renderer)

find_package(OpenGL REQUIRED)


if( CMAKE_BINARY_DIR STREQUAL CMAKE_SOURCE_DIR )
    message( FATAL_ERROR "Please select another Build Directory ! (and give it a clever name, like bin_Visual2012_64bits/)" )
endif()
if( CMAKE_SOURCE_DIR MATCHES " " )
	message( "Your Source Directory contains spaces. If you experience problems when compiling, this can be the cause." )
endif()
if( CMAKE_BINARY_DIR MATCHES " " )
	message( "Your Build Directory contains spaces. If you experience problems when compiling, this can be the cause." )
endif()

set (CMAKE_CXX_STANDARD 11)


# Compile external dependencies 
add_subdirectory (external)

# On Visual 2005 and above, this module can set the debug working directory
#  if(POLICY CMP0026)
#  cmake_policy(SET CMP0026 NEW)
#  endif()

list(APPEND CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/external/rpavlik-cmake-modules-fe2273")
include(CreateLaunchers)
include(MSVCMultipleProcessCompile) # /MP

if(INCLUDE_DISTRIB)
	add_subdirectory(distrib)
endif(INCLUDE_DISTRIB)



include_directories(
	external/AntTweakBar-1.16/include/
	external/glfw-3.1.2/include/
	external/glm-0.9.7.1/
	external/glew-1.13.0/include/
	external/assimp-3.0.1270/include/
	external/bullet-2.81-rev2613/src/
	.
)

set(ALL_LIBS
	${OPENGL_LIBRARY}
	glfw
	GLEW_1130
)

add_definitions(
	-DTW_STATIC
	-DTW_NO_LIB_PRAGMA
	-DTW_NO_DIRECT3D
	-DGLEW_STATIC
	-D_CRT_SECURE_NO_WARNINGS
)

# User playground
add_executable(playground 

	playground/QWindow.cpp playground/QWindow.hpp
	
	playground/playground.cpp

	playground/Settings.hpp
	
	playground/stb_image.h
	playground/Texture.cpp playground/Texture.hpp

	playground/Camera.cpp playground/Camera.hpp

	playground/OBJLoader.hpp playground/OBJLoader.cpp

	playground/Mesh.cpp playground/Mesh.hpp

	playground/Shader.cpp playground/Shader.hpp

	playground/Material.cpp playground/Material.hpp

	playground/Model.cpp playground/Model.hpp

	playground/Lighting/Light.cpp playground/Lighting/Light.hpp
	playground/Lighting/LightDirectional.cpp playground/Lighting/LightDirectional.hpp
	playground/Lighting/PointLight.cpp 	playground/Lighting/PointLight.hpp
	playground/Lighting/SpotLight.cpp playground/Lighting/SpotLight.hpp
	playground/Lighting/ShadowMap.cpp playground/Lighting/ShadowMap.h

	playground/Shaders/SimpleShader_Frag.glsl
	playground/Shaders/SimpleShader_Vert.glsl
	playground/Shaders/directionalShadowMap_Frag.glsl
	playground/Shaders/directionalShadowMap_Vert.glsl
        playground/Lighting/OmniShadowMap.cpp playground/Lighting/OmniShadowMap.hpp)
target_link_libraries(playground
	${ALL_LIBS}
	assimp
)
set_target_properties(playground PROPERTIES COMPILE_DEFINITIONS "USE_ASSIMP")

# Xcode and Visual working directories
set_target_properties(playground PROPERTIES XCODE_ATTRIBUTE_CONFIGURATION_BUILD_DIR "${CMAKE_CURRENT_SOURCE_DIR}/playground/")
create_target_launcher(playground WORKING_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/playground/")




SOURCE_GROUP(common REGULAR_EXPRESSION ".*/common/.*" )
SOURCE_GROUP(shaders REGULAR_EXPRESSION ".*/.*shader$" )


add_custom_command(
   TARGET playground POST_BUILD
   COMMAND ${CMAKE_COMMAND} -E copy "${CMAKE_CURRENT_BINARY_DIR}/${CMAKE_CFG_INTDIR}/playground${CMAKE_EXECUTABLE_SUFFIX}" "${CMAKE_CURRENT_SOURCE_DIR}/playground/"
)
