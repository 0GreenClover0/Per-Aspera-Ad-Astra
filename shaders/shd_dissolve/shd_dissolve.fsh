//
// Simple passthrough fragment shader
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform sampler2D dissolveTexture;
uniform float dissolveValue;
uniform float burnSize;
uniform vec4 burnColor;

void main()
{
    vec4 mainTexture = texture2D(gm_BaseTexture, v_vTexcoord);
    vec4 noiseTexture = texture2D(dissolveTexture, v_vTexcoord);
    
    float burnSizeStep = burnSize * step(0.001, dissolveValue) * step(dissolveValue, 0.999);
    float threshold = smoothstep(noiseTexture.x - burnSizeStep, noiseTexture.x, dissolveValue);
    float border = smoothstep(noiseTexture.x, noiseTexture.x + burnSizeStep, dissolveValue);
    
    vec4 col = mainTexture;
    col.a *= threshold;
    col.rgb = mix(burnColor.rgb, mainTexture.rgb, border);
    gl_FragColor = col;
}
