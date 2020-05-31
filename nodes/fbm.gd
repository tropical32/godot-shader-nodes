# https://thebookofshaders.com/13/

tool
extends VisualShaderNodeCustom
class_name VisualShaderNodefBm

func _get_name():
	return "fBm"

func _get_category():
	return "CustomNodes"

func _get_description():
	return "Brownian motion"

func _get_return_icon_type():
	return VisualShaderNode.PORT_TYPE_SCALAR

func _get_input_port_count():
	return 1

func _get_input_port_name(port):
	match port:
		0:
			return "x"

func _get_input_port_type(port):
	match port:
		0:
			return VisualShaderNode.PORT_TYPE_VECTOR

func _get_output_port_count():
	return 1

func _get_output_port_name(_port):
	return "result"

func _get_output_port_type(_port):
	return VisualShaderNode.PORT_TYPE_SCALAR

func _get_global_code(_mode):
	return """
		float random(vec2 st) {
			return fract(sin(dot(st.xy, vec2(12.9898, 78.233))) * 43758.5453123);
		}

		float noise(vec2 st) {
			vec2 p = floor(st);
			vec2 f = fract(st);

			float a = random(p);
			float b = random(p + vec2(1.0, 0.0));
			float c = random(p + vec2(0.0, 1.0));
			float d = random(p + vec2(1.0, 1.0));

			vec2 u = f * f * (3.0 - 2.0 * f);

			return mix(a, b, u.x) +
				(c - a)* u.y * (1.0 - u.x) +
				(d - b) * u.x * u.y;
		}

		float fbm(vec2 st) {
			float value = 0.0;
			float amplitude = .5;
			float frequency = 0.;

			for (int i = 0; i < 6; i++) {
				value += amplitude * noise(st);
				st *= 2.;
				amplitude *= .5;
			}
			return value;
		}
	"""

func _get_code(input_vars, output_vars, _mode, _type):
	return output_vars[0] + " = fbm(%s.yx)" % input_vars[0]
