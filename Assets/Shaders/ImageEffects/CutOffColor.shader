Shader "Hidden/CutOffColor"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_MaskTex("Mask Texture", 2D) = "white" {}
	}
	SubShader
	{
		// No culling or depth
		Cull Off ZWrite Off ZTest Always

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				return o;
			}
			
			sampler2D _MainTex;
			sampler2D _MaskTex;
			float4 _OpaqueColor;
			float4 _TransparentColor;
			float2 _MaskPosition;
			int _IsReverse;

			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 col = tex2D(_MainTex, i.uv);
				fixed4 mask = tex2D(_MaskTex, i.uv + _MaskPosition);
				
				fixed4 trans = _TransparentColor;
				fixed4 opaq = _OpaqueColor;

				if (_IsReverse == 1) {
					trans = _OpaqueColor;
					opaq = _TransparentColor;
				}

				fixed3 transCol = lerp(col.rgb, col.rgb * trans.rgb, trans.a);
				fixed3 opaqueCol = lerp(col.rgb, col.rgb * opaq.rgb, opaq.a);
				col.rgb = lerp(transCol, opaqueCol, mask.a);

				return col;
			}
			ENDCG
		}
	}
}
