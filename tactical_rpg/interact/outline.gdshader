shader_type spatial;
render_mode cull_front, unshaded;

uniform vec4 outline_color : source_color;
uniform float outline_width_px = 2.0;   // wanted width in screen pixels

// Helper: size of one screen pixel in clip‑space at the current depth
float pixel_factor(in float depth, vec2 viewport_size) {
    // 2.0 / viewport height gives the clip‑space height of one pixel.
    // After perspective division ( / depth ) we need to multiply back by depth.
    return (2.0 / viewport_size.y) * depth;
}

void vertex() {
    vec4 view_pos   = MODELVIEW_MATRIX * vec4(VERTEX, 1.0);
    vec3 view_norm  = normalize((MODELVIEW_MATRIX * vec4(NORMAL, 0.0)).xyz);

    float depth = -view_pos.z;                     // view‑space depth (positive forward)
    float pix = pixel_factor(depth, VIEWPORT_SIZE);              // clip‑space per‑pixel

    vec2 screen_offset = normalize(view_norm.xy) * pix * outline_width_px;

    view_pos.xy += screen_offset;                  // move in view space
    vec4 clip_pos = PROJECTION_MATRIX * view_pos;   // final clip‑space position

    POSITION = clip_pos;
}

void fragment() {
    ALBEDO = outline_color.rgb;
    ALPHA  = outline_color.a;
}
