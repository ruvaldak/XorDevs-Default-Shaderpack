#version 120

#include "settings.glsl"

uniform sampler2D lightmap;
uniform sampler2D texture;

uniform sampler2D colortex9;
/*
const int colortex9Format = R32F;
*/

varying vec2 lmcoord;
varying vec2 texcoord;
varying vec3 bufferNormal;
varying vec4 glcolor;
varying float entity;

//RGB/intensity for hurt entities and flashing creepers.
uniform vec4 entityColor;
//0-1 amount of blindness.
uniform float blindness;

#include "/lib/fog.glsl"

void main() {
	vec4 color = texture2D(texture, texcoord) * glcolor;
	color *= texture2D(lightmap, lmcoord);
	
	//Combine lightmap with blindness.
    vec3 lightmapBlind = (1.-blindness) * texture2D(lightmap,lmcoord).rgb;
	color *= vec4(lightmapBlind,1);
    //Sample texture times lighting.
    //vec4 color = glcolor * texture2D(texture,texcoord);
    //Apply entity flashes.
    //color.rgb = mix(color.rgb,entityColor.rgb,entityColor.a);

	//vec3 light = (1.-blindness) * texture2D(lightmap, lmcoord).rgb;
	//vec4 color = glcolor * vec4(light, 1) * texture2D(texture, texcoord);

	//Apply fog
    //#include "/lib/fog.glsl"
    vec4 fog;
    doFog(color, fog, FOG_OFFSET_DEFAULT);

/* DRAWBUFFERS:03689 */
	gl_FragData[0] = color; //gcolor
	gl_FragData[1] = fog;
	gl_FragData[2] = vec4(entity/255, 0.0f,vec2(1.0f));
	gl_FragData[3] = vec4(bufferNormal, 1.0f);
	gl_FragData[4] = vec4(1.0f, 0.0f, 0.0f, 1.0f);
}
