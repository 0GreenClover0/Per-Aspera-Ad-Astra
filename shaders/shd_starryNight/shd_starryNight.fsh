varying vec2 v_vTexcoord;

uniform highp float u_time;
uniform       vec2  u_screen_size; // pass display_get_width/height from GML
uniform float u_alpha;

// ── Hardcoded values (from original uniforms) ────────────────────────────────
const float HORIZONTAL_MOVEMENT = 0.1;
const float VERTICAL_MOVEMENT   = 0.1;
const float FREQUENCY_STAR      = 0.02;   // prob = 1.0 - 0.1 = 0.9
const float SIZE_STAR           = 50.0;
const float BRIGHTNESS_STAR     = 3.0;
const float SHINE_FREQ_STAR     = 8.0;
const float FREQUENCY_BG_STAR   = 0.996;
const float SHINE_FREQ_BG_STAR  = 1.0;
const float SEED                = 0.0;
// starIterations = 3 → loop runs i = 1, 2, 3 (unrolled-friendly, hardcoded as < 4)
// ─────────────────────────────────────────────────────────────────────────────

float rand(vec2 st) {
    return fract(sin(dot(st, vec2(SEED + 12.9898, 78.233))) * 43758.5453123);
}

float remap(float prob, float starValue) {
    return (starValue - prob) / (1.0 - prob);
}

// Replaces gradientA texture: warm white → cool blue-white based on star brightness
vec4 gradientA(float t) {
    return vec4(1.0 - 0.1 * t, 1.0 - 0.05 * t, 1.0, 1.0);
}

// Replaces gradientB texture: dim blue-white tint for background stars
vec4 gradientB(float t) {
    return vec4(0.75 + 0.25 * t, 0.8 + 0.2 * t, 1.0, 1.0);
}

void main() {
    // Reconstruct FRAGCOORD and SCREEN_UV equivalents
    vec2 fragcoord = v_vTexcoord * u_screen_size;
    vec2 screen_uv = v_vTexcoord;

    float prob    = 1.0 - FREQUENCY_STAR;
    float travelx = u_time * HORIZONTAL_MOVEMENT;
    float travely = u_time * VERTICAL_MOVEMENT;
    float color   = 0.0;

    vec4 OUT = vec4(0.05, 0.04, 0.20, 1.0); // colorBackground hardcoded

    // starIterations = 3 → i in {1, 2, 3}
    for (int i = 1; i < 4; i++) {
        float fi   = float(i);
        float size = SIZE_STAR / fi;

        vec2  pos       = vec2(floor((1.0 / size * fragcoord.x) + travelx),
                               floor((1.0 / size * fragcoord.y) + travely));
        float starValue = rand(pos);

        if (starValue > prob) {
            vec2  center        = size * pos + vec2(size, size) * 0.5;
            float t             = 0.9 + 0.2 * sin(u_time * SHINE_FREQ_STAR
                                    + (starValue - prob) / (1.0 - prob) * 45.0);
            vec2  modifiedCoords = vec2(fragcoord.x + travelx * size,
                                        fragcoord.y + travely * size);

            color = t * t * BRIGHTNESS_STAR / fi
                  / clamp(distance(modifiedCoords.y, center.y), 0.5, size / 2.0 - 1.0)
                  / clamp(distance(modifiedCoords.x, center.x), 0.5, size / 2.0 - 1.0);

            OUT += gradientA(remap(prob, starValue)) * color;
        }
    }

    if (rand(screen_uv / 20.0) > FREQUENCY_BG_STAR) {
        float r = rand(screen_uv);
        color   = r * (0.85 * sin(u_time * SHINE_FREQ_BG_STAR * (r * 5.0) + 720.0 * r) + 0.95);
        OUT    += color * gradientB(r);
    }

    gl_FragColor = OUT;
    gl_FragColor.a = u_alpha;
}