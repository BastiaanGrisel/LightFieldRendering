Shader "3-Specular" {
	Properties{
		_Color("Color", Color) = (1.0,1.0,1.0,1.0)
		_SpecColor ("SpecColor", Color) = (1.0,1.0,1.0,1.0)
		_Shininess ("Shininess", Float) = 10
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
			uniform float4 _SpecColor;
			uniform float _Shininess;

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
				float3 viewDirection = normalize(float3(float4(_WorldSpaceCameraPos.xyz, 0.0) - mul(_Object2World, v.vertex).xyz));
				float atten = 1.0;

				float3 diffuse = atten * _LightColor0.rgb * max(0.0, dot(normalDirection, lightDirection));
				float3 specular = atten * _SpecColor.rgb * max(0.0, dot(normalDirection, lightDirection)) * pow(max(0.0, dot(reflect(-lightDirection, normalDirection), viewDirection)), _Shininess);
				float3 final = diffuse + specular + UNITY_LIGHTMODEL_AMBIENT.xyz;

				o.col = float4(final * _Color, 1.0);
				o.pos = mul(UNITY_MATRIX_MVP, v.vertex);

				return o;
			}

			float4 frag(vertexOutput v) : COLOR {
				return v.col;
			}

			ENDCG
		}
	}
}