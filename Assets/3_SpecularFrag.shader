Shader "3-SpecularFrag" {
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
				float4 posWorld : TEXCOORD0;
				float3 normalDir : TEXCOORD1;
			};

			vertexOutput vert(vertexInput v) {
				vertexOutput o;

				o.posWorld = mul(_Object2World, v.vertex);
				o.normalDir = normalize(mul(float4(v.normal, 0.0), _World2Object).xyz);
				o.pos = mul(UNITY_MATRIX_MVP, v.vertex);

				return o;
			}

			float4 frag(vertexOutput o) : COLOR {
				float3 lightDirection = normalize(_WorldSpaceLightPos0.xyz);
				float3 viewDirection = normalize(float3(float4(_WorldSpaceCameraPos.xyz, 0.0) - o.posWorld.xyz));
				float atten = 2.0;

				float3 diffuse = atten * _LightColor0.rgb * max(0.0, dot(o.normalDir, lightDirection));
				float3 specular = atten * _SpecColor.rgb * max(0.0, dot(o.normalDir, lightDirection)) * pow(max(0.0, dot(reflect(-lightDirection, o.normalDir), viewDirection)), _Shininess);
				float3 final = diffuse + specular + UNITY_LIGHTMODEL_AMBIENT;

				return float4(final * _Color.rgb, 1.0);
			}

			ENDCG
		}
	}
}