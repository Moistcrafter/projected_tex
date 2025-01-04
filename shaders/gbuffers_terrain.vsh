#version 150 compatibility

varying float vertexDistance;
varying vec2 texCoord0;
varying vec2 lmcoord;
varying vec4 glcolor;

void main() {
    gl_Position = ftransform();
    vertexDistance = length((gl_ModelViewMatrix * gl_Vertex).xyz);
    texCoord0 = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;
    lmcoord  = (gl_TextureMatrix[1] * gl_MultiTexCoord1).xy;
    glcolor = gl_Color;
}