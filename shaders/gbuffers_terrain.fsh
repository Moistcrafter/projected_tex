#version 150 compatibility

#define TEX_RES 16 // [2 4 8 16 32 64 128 256 512 1024 2048 4096] Resolution of each block in the texture atlas
#define SCALE 8 // [1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16] Scale of the texture atlas

#define USE_BLOCK_LIGHTING
#define USE_TERRAIN_COLOR

#define USE_FOG

uniform sampler2D texture;
uniform sampler2D lightmap;

varying vec2 texCoord0;
varying vec2 lmcoord;
varying vec4 glcolor;
varying float vertexDistance;

void main() {
    vec2 texSize = textureSize(texture, 0);
    vec2 offset = floor(texCoord0 * texSize / 16.0) * 16.0;

    vec2 scale = vec2(SCALE, -SCALE); //define here for easier manipulation
    ivec2 coords = ivec2(mod((gl_FragCoord.xy / scale), TEX_RES) + offset);

    vec4 color = texelFetch(texture, coords, 0);

    #ifdef USE_TERRAIN_COLOR
        color *= glcolor;
    #endif

    #ifdef USE_BLOCK_LIGHTING
        color *= texture2D(lightmap, lmcoord);
    #endif

    #ifdef USE_FOG
        float fogFactor = clamp((gl_Fog.end - vertexDistance) / (gl_Fog.end - gl_Fog.start), 0.0, 1.0);
        color.rgb = mix(gl_Fog.color.rgb, color.rgb, fogFactor);
    #endif

    gl_FragData[0] = color;
}