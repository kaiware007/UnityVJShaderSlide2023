Shader "Hidden/Distortion"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_DistortionNoiseScale("Noise Scale", Range(0,10)) = 0.1
		_DistortionNoisePosition("Noise Position", vector) = (0,0,0,0)
		_DistortionPower ("Power", Range(0,10)) = 0.1
//		_DistortionRGBShiftPower("RGB Shift Power", float) = 1.5
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
			#include "Assets/Shaders/Libs/SimplexNoiseGrad3D.cginc"

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
			float4  _MainTex_TexelSize;

			float _DistortionNoiseScale;
			float3 _DistortionNoisePosition;
			float _DistortionPower;
			float4 _DistortionRGBShiftPower;
			
			float2 getRotationUV(float2 uv, float angle, float power) {
				float2 v = (float2)0;
				//float rad = angle * 6.28318530718;
				float rad = angle * 3.14159265359;
				//v.x = uv.x + cos(rad) * power * _MainTex_TexelSize.x;
				//v.y = uv.y + sin(rad) * power * _MainTex_TexelSize.y;

				v.x = uv.x + cos(rad) * power;
				v.y = uv.y + sin(rad) * power;

				return v;
			}

			fixed4 frag (v2f i) : SV_Target
			{
				//float3 uv3 = float3(i.uv.x + _DistortionNoisePosition.x, i.uv.y + _DistortionNoisePosition.y, _DistortionNoisePosition.z);
				float3 uv1 = float3(i.uv * _DistortionNoiseScale,0);
				float3 noise = snoise_grad(uv1 + _DistortionNoisePosition);
				
				float2 uvR = getRotationUV(i.uv, noise.x*_DistortionRGBShiftPower.x, noise.y * _DistortionPower * _DistortionRGBShiftPower.y);
				float2 uvG = getRotationUV(i.uv, noise.x, noise.y * _DistortionPower);
				float2 uvB = getRotationUV(i.uv, noise.x*_DistortionRGBShiftPower.z, noise.y * _DistortionPower * _DistortionRGBShiftPower.w);
				
				fixed colR = tex2D(_MainTex, uvR).r;
				fixed colG = tex2D(_MainTex, uvG).g;
				fixed colB = tex2D(_MainTex, uvB).b;
				
				return fixed4(colR, colG, colB, 1);
			}
			ENDCG
		}
	}
}
