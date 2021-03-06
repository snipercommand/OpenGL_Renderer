#version 330 core

// Input vertex data, different for all executions of this shader.
layout(location = 0) in vec3 vertexPosition_modelspace;
layout(location = 1) in vec2 vertexUV;
layout(location = 2) in vec3 vertexNormal_modelSpace;
//layout(location = 1) in vec3 vertexColor;



// Values that stay constant for the whole mesh.
uniform mat4 MVP;

uniform mat4 Model;
uniform mat4 View;
uniform mat4 Projection;
uniform mat4 directionalLightSpaceTransform; // projection (ortho) * view

out vec4 vCol;
out vec2 vUV;
out vec3 vNormal;
out vec3 FragPos;
out vec4 DirectionalLightSpacePos;

void main()
{
    gl_Position = Projection * View * Model * vec4(vertexPosition_modelspace ,1);
    DirectionalLightSpacePos = directionalLightSpaceTransform * Model * vec4(vertexPosition_modelspace,1);
    FragPos = (Model * vec4(vertexPosition_modelspace,1)).xyz;
    vCol = vec4( clamp(vertexPosition_modelspace, 0, 1),1);

    vUV = vertexUV;

    //To cancel out the normal direction change when the object get's scaled in a non uniform way (1 or 2 axes), we must
    // perform the inverse and the transpose of the matrix.
    // Since the normal is a direction , we don't need the W parameter of the 4x4 matrix, in fact we only need the first 3 columns & rows, 
    //so we convert the matrix to a mat3x3
    vNormal = mat3( transpose(inverse(Model)) ) * vertexNormal_modelSpace;
}

