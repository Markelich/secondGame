shader_type canvas_item;

// Настройки, которые можно менять в инспекторе
uniform vec4 key_color : source_color = vec4(0.0, 1.0, 0.0, 1.0); // Зеленый цвет
uniform float tolerance : hint_range(0.0, 1.0) = 0.1; // Чувствительность

void fragment() {
    vec4 tex_color = texture(TEXTURE, UV);
    
    // Вычисляем разницу между цветом пикселя и ключевым цветом
    float diff = distance(tex_color.rgb, key_color.rgb);
    
    // Если пиксель близок к зеленому, делаем его прозрачным
    if (diff < tolerance) {
        tex_color.a = 0.0;
    }
    
    COLOR = tex_color;
}