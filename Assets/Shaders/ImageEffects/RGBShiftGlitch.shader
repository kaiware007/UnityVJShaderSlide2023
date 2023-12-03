Shader "Hidden/RGBShiftGlitch"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
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
			#include "../Libs/Noise.cginc"
			#include "../Libs/Random.cginc"

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
			float _RGBShiftPower;
			float _RGBNoiseSpeed;
			float _RGBNoiseScale;

			fixed4 frag (v2f i) : SV_Target
			{
				//float2 shiftpow = float2(_ShiftPower * (1.0 / _ScreenParams.x), 0);
				//float2 shiftpow = float2(snoise(float3(i.uv, _Time.y * _NoiseSpeed)) * _ShiftPower * (1.0 / _ScreenParams.x), 0);
				float2 shiftpow = float2(snoise(float2(i.uv.y * _RGBNoiseScale, _Time.y * _RGBNoiseSpeed)), snoise(float2((i.uv.y + 16615.156) * _RGBNoiseScale, _Time.y * _RGBNoiseSpeed))) * 100;
			
				shiftpow = step(-0.25, shiftpow) * floor(shiftpow * 4) * 0.25 * _RGBShiftPower;

				fixed2 rg = tex2D(_MainTex, i.uv - float2(shiftpow.x, shiftpow.y * 3)).rg;
				fixed2 gb = tex2D(_MainTex, i.uv + float2(shiftpow.y, shiftpow.x * 3)).gb;
				fixed2 rb = tex2D(_MainTex, i.uv + float2(shiftpow.x, shiftpow.x * 3)).rb;

				return fixed4((rg.x + rb.x)/2, (rg.y + gb.x)/2, (rb.y + gb.y)/2, 1);
			}
			ENDCG
		}
	}
}
