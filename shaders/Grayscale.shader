shader_type canvas_item;

uniform float scale : hint_range(0.0,1.0);
uniform float grayscale : hint_range(0.0,100.0);

void fragment() {
    COLOR = texture(SCREEN_TEXTURE, SCREEN_UV) * scale;
    float avg = (COLOR.r + COLOR.g + COLOR.b) / grayscale;
    COLOR.rgb = vec3(avg);
}