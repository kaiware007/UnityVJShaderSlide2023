Shader "Hidden/FoldRotate"
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
			float4 _MainTex_TexelSize;
			float _DivNum;
			float _RotateTime;

			//mat2 rot(float th) { vec2 a = sin(vec2(RAD90, 0) + th); return mat2(a, -a.y, a.x); }
			float2x2 rotate(float a)
			{
				float2 s = sin(float2(UNITY_HALF_PI, 0) + a);
				return float2x2(s.x, s.y, -s.y, s.x);

				//float s = sin(a), c = cos(a);
				//return float2x2(c, s, -s, c);
			}

			float2 foldRotate(float2 p, float s)
			{
				float a = UNITY_PI / s - atan2(p.x, p.y);
				float n = UNITY_TWO_PI / s;
				a = floor(a / n) * n;
				//p = mul(p, rotate(a));
				p = mul(rotate(a), p);

				return p;
			}

			//https://www.shadertoy.com/view/NdS3Dh
			//SmoothSymmetricPolarMod aka smoothRot
			//
			//s repetitions
			//m smoothness (0-1)
			//c correction (0-1)
			//d object displace from center
			//
			float2 smoothRot(float2 p, float s, float m, float c, float d) {
				s *= 0.5;
				float k = length(p);
				float x = asin(sin(atan2(p.x, p.y)*s) * (1.0 - m)) * k;
				float ds = k * s;
				float y = lerp(ds, 2.0*ds - sqrt(x*x + ds * ds), c);
				return float2(x / s, y / s - d);
			}

            fixed4 frag (v2f i) : SV_Target
            {
				float2 uv = (i.uv - 0.5) * 2;
				/*float aspect = _MainTex_TexelSize.x / _MainTex_TexelSize.y;
				uv.y *= aspect;
				uv.y += aspect*0.175;*/
				uv = (uv / 2) + 0.5;

				float2 offset = float2(0.5, 0.5);
				//float2 offset = 0;
				//offset.x /= aspect;
				//offset.y = _MainTex_TexelSize.y / _MainTex_TexelSize.x;
				uv = mul(uv - offset, rotate(_RotateTime)) + offset;
				//uv = mul(uv, rotate(_RotateTime));
				uv = smoothRot(uv - float2(0.5,0.5), _DivNum, 0.0125, 0.0125, 0) + float2(0.5,0.125);
				//uv = smoothRot(uv, _DivNum, 0.0125, 0.0125, 0);
				fixed4 col = tex2D(_MainTex, uv);
                return col;
            }
            ENDCG
        }
    }
}
