Shader "2-Lambert" {
	Properties{
		_Color("Color", Color) = (1.0,1.0,1.0,1.0)
	}
	SubShader {
		Pass {
			Tags {
				"LightMode" = "ForwardBase"
			}

			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag

			// User vars
			uniform float4 _Color;

			// Unity vars
			uniform float4 _LightColor0;

			struct vertexInput {
				float4 vertex : POSITION;
				float3 normal: NORMAL;
			};
			struct vertexOutput {
				float4 pos : SV_POSITION;
				float4 col : COLOR;
			};

			vertexOutput vert(vertexInput v) {
				vertexOutput o;

				float3 normalDirection = normalize(mul(float4(v.normal,0.0), _World2Object).xyz);
				float3 lightDirection = normalize(_WorldSpaceLightPos0.xyz);
				float atten = 1.0;

				float3 diffuse = atten * _LightColor0.xyz * max(0.0, dot(normalDirection, lightDirection)) + UNITY_LIGHTMODEL_AMBIENT.xyz;

				o.col = float4(diffuse * _Color.rgb, 1.0);
				o.pos = mul(UNITY_MATRIX_MVP, v.vertex);

				return o;
			}

			float4 frag(vertexOutput v) : COLOR{
				return v.col;
			}

			ENDCG
		}
	}
}