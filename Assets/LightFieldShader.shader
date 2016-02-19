Shader "Custom/LightFieldShader" {
	Properties {
		_Color("Color", Color) = (1,1,1,1)
		//_MainTex ("Albedo (RGB)", 2D) = "white" {}
	}
	SubShader {
		Pass {
			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag

			uniform float4 _Color;

			struct vertexInput {
				float4 vertex: POSITION;
			};

			struct vertexOutput {
				float4 pos: SV_POSITION;
				float4 worldSpacePosition: TEXCOORD0;
				float4 tex: TEXCOORD1;
			};

			vertexOutput vert(vertexInput v) {
				vertexOutput o;
				o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
				o.worldSpacePosition = mul(_Object2World, v.vertex);
				return o;
			}

			float4 frag(vertexOutput o) : COLOR {
				float4 worldSpacePixelPosition = o.worldSpacePosition;
				float4 worldSpaceCameraPosition = float4(_WorldSpaceCameraPos, 0.0);
				return _Color;
			}

			ENDCG
		}
	}
	FallBack "Diffuse"
}
