shader_type canvas_item;

// Original colors
uniform vec4 target_color : source_color;
uniform vec4 replace_color : source_color;
uniform float tolerance : hint_range(0, 1);

uniform bool master;
uniform float hue_shift;
uniform float sat_shift;
uniform float val_shift;

//Converts RGB to HSV
vec3 rgb2hsv(vec3 c)
{
	// Get the max and min value of each color 
	float cmax = max(c.r, max(c.g, c.b));
	float cmin = min(c.r, min(c.g, c.b));
	
	float diff = cmax - cmin;
	
	float h = 0.0; // hue
	if (diff != 0.0)
	{
		if (cmax == c.r)
		{
			h = mod((c.g - c.b) / diff, 6.0);
		}
		else if (cmax == c.g)
		{
			h = (c.b - c.r) / diff + 2.0;
		}
		else
		{
			h = (c.r - c.g) / diff + 4.0;
		}
		
		h /= 6.0;
	}
	
	float s = (cmax == 0.0) ? 0.0 : diff / cmax;
	float v = cmax;
	return vec3(h, s, v);
}

// Converts HSV to RGB
vec3 hsv2rgb(vec3 c)
{
	float h = c.x * 6.0;
	float s = c.y;
	float v = c.z;
	
	int i = int(floor(h));
	float f = h - float(i);
	float p = v * (1.0 - s);
	float q = v * (1.0 - f * s);
	float t = v * (1.0 - (1.0 - f) * s);
	
	if (i == 0) return vec3(v, t, p);
	else if (i == 1) return vec3(q, v, p);
	else if (i == 2) return vec3(p, v, t);
	else if (i == 3) return vec3(p, q, v);
	else if (i == 4) return vec3(t, p, v);
	else return vec3(v, p, q);
}

void fragment()
{
	vec4 tex_color = texture(TEXTURE, UV);
	vec3 hsv = rgb2hsv(tex_color.rgb);
	
	float dist = distance(tex_color.rgb, target_color.rgb);
	
	hsv.x = mod(hsv.x + hue_shift, 1.0);
	hsv.y = clamp(hsv.y + sat_shift, 0.0, 1.0);
	hsv.z = clamp(hsv.z + val_shift, 0.0, 1.0);
	
	if (dist < tolerance)
	{
		// Convert both to HSV
		vec3 hsv_tex = rgb2hsv(tex_color.rgb);
		vec3 hsv_replace = rgb2hsv(replace_color.rgb);
		
		// Replace hue only
		hsv_tex.x = hsv_replace.x;
		
		//Cpnvert back
		tex_color.rgb = hsv2rgb(hsv_tex);
	}
	
	if (master) {
		COLOR.rgb = hsv2rgb(hsv);
		COLOR.a = tex_color.a;
	}else 
	{
		COLOR = tex_color;
	}
	
}
