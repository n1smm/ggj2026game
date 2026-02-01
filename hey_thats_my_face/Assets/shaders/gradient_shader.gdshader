shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, filter_nearest;
uniform float contrast : hint_range(1.0, 3.0) = 2.2;

void fragment() {
    vec4 screen_color = texture(screen_texture, SCREEN_UV);
    
    float lum = dot(screen_color.rgb, vec3(0.299, 0.587, 0.114));
    lum = pow(lum, contrast);
    
    vec3 base_color = vec3(lum);
    
    COLOR = vec4(base_color, 1.0);
}
```

## Fix 2: Controlla le impostazioni del ColorRect

**Importante:** Il ColorRect potrebbe non avere accesso a `SCREEN_TEXTURE` per default in Godot 4.

Nel ColorRect, vai su **CanvasItem → Texture** e assicurati che sia **vuoto** (nessuna texture assegnata).

## Fix 3: Usa BackBufferCopy (soluzione garantita)

Se continua a essere bianco, serve un nodo intermedio:

**Struttura:**
```
- CanvasLayer
  - BackBufferCopy (Mode: Full Rect)
  - ColorRect (con shader)