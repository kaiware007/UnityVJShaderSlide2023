#ifndef RANDOM_INCLUDED
#define RANDOM_INCLUDED

float hash(float n)
{
	return frac(sin(n) * 43758.5453123);
}

float rand( float2 co ){
  return frac(sin(dot(co.xy, float2(12.9898, 78.233))) * 43758.5453);
}

float2 rand2( float2 p ) {
    return frac(sin(float2(dot(p,float2(127.1,311.7)),dot(p,float2(269.5,183.3))))*43758.5453);
}

float3 rand3( float2 seed ){
	float t = sin(seed.x + seed.y * 1e3);
	return float3(frac(t*1e4), frac(t*1e6), frac(t*1e5));
}

float3 randInsideUnitSphere(float2 seed) {
	return (rand3(seed) - 0.5) * 2.0;
}

// Hash without Sine
// MIT License...
/* Copyright (c)2014 David Hoskins.

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.*/
//----------------------------------------------------------------------------------------
//  1 out, 1 in...
float hash11(float p)
{
	p = frac(p * .1031);
	p *= p + 33.33;
	p *= p + p;
	return frac(p);
}

//----------------------------------------------------------------------------------------
//  1 out, 2 in...
float hash12(float2 p)
{
	float3 p3 = frac(float3(p.xyx) * .1031);
	p3 += dot(p3, p3.yzx + 33.33);
	return frac((p3.x + p3.y) * p3.z);
}

//----------------------------------------------------------------------------------------
//  1 out, 3 in...
float hash13(float3 p3)
{
	p3 = frac(p3 * .1031);
	p3 += dot(p3, p3.yzx + 33.33);
	return frac((p3.x + p3.y) * p3.z);
}

//----------------------------------------------------------------------------------------
//  1 out, 4 in...
float hash14(float4 p4)
{
	p4 = frac(p4 * .1031);
	p4 += dot(p4, p4.yzwx + 33.33);
	return frac((p4.x + p4.z) * (p4.y + p4.w));
}

//----------------------------------------------------------------------------------------
//  2 out, 1 in...
float2 hash21(float p)
{
	float3 p3 = frac(float3(p,p,p) * float3(.1031, .1030, .0973));
	p3 += dot(p3, p3.yzx + 33.33);
	return frac((p3.xx + p3.yz)*p3.zy);

}

//----------------------------------------------------------------------------------------
///  2 out, 2 in...
float2 hash22(float2 p)
{
	float3 p3 = frac(float3(p.xyx) * float3(.1031, .1030, .0973));
	p3 += dot(p3, p3.yzx + 33.33);
	return frac((p3.xx + p3.yz)*p3.zy);

}

//----------------------------------------------------------------------------------------
///  2 out, 3 in...
float2 hash23(float3 p3)
{
	p3 = frac(p3 * float3(.1031, .1030, .0973));
	p3 += dot(p3, p3.yzx + 33.33);
	return frac((p3.xx + p3.yz)*p3.zy);
}

//----------------------------------------------------------------------------------------
//  3 out, 1 in...
float3 hash31(float p)
{
	float3 p3 = frac(float3(p,p,p) * float3(.1031, .1030, .0973));
	p3 += dot(p3, p3.yzx + 33.33);
	return frac((p3.xxy + p3.yzz)*p3.zyx);
}


//----------------------------------------------------------------------------------------
///  3 out, 2 in...
float3 hash32(float2 p)
{
	float3 p3 = frac(float3(p.xyx) * float3(.1031, .1030, .0973));
	p3 += dot(p3, p3.yxz + 33.33);
	return frac((p3.xxy + p3.yzz)*p3.zyx);
}

//----------------------------------------------------------------------------------------
///  3 out, 3 in...
float3 hash33(float3 p3)
{
	p3 = frac(p3 * float3(.1031, .1030, .0973));
	p3 += dot(p3, p3.yxz + 33.33);
	return frac((p3.xxy + p3.yxx)*p3.zyx);

}

//----------------------------------------------------------------------------------------
// 4 out, 1 in...
float4 hash41(float p)
{
	float4 p4 = frac(float4(p,p,p,p) * float4(.1031, .1030, .0973, .1099));
	p4 += dot(p4, p4.wzxy + 33.33);
	return frac((p4.xxyz + p4.yzzw)*p4.zywx);

}

//----------------------------------------------------------------------------------------
// 4 out, 2 in...
float4 hash42(float2 p)
{
	float4 p4 = frac(float4(p.xyxy) * float4(.1031, .1030, .0973, .1099));
	p4 += dot(p4, p4.wzxy + 33.33);
	return frac((p4.xxyz + p4.yzzw)*p4.zywx);

}

//----------------------------------------------------------------------------------------
// 4 out, 3 in...
float4 hash43(float3 p)
{
	float4 p4 = frac(float4(p.xyzx)  * float4(.1031, .1030, .0973, .1099));
	p4 += dot(p4, p4.wzxy + 33.33);
	return frac((p4.xxyz + p4.yzzw)*p4.zywx);
}

//----------------------------------------------------------------------------------------
// 4 out, 4 in...
float4 hash44(float4 p4)
{
	p4 = frac(p4  * float4(.1031, .1030, .0973, .1099));
	p4 += dot(p4, p4.wzxy + 33.33);
	return frac((p4.xxyz + p4.yzzw)*p4.zywx);
}

// return distance, and cell id
float2 voronoi(float2 pos, float2 distortion )
{
	float2 n = floor( pos );
	float2 f = frac( pos );

	float3 m = float3(8,0,0);
	for( int j=-1; j<=1; j++ )
		for( int i=-1; i<=1; i++ )
		{
			float2  g = float2( float(i), float(j) );
			float2  o = hash22( n + g );
			float2  r = g - f + (0.5 + 0.5 * sin(distortion * o));
			//float2  r = g - f + (0.5+0.5*sin(_Time.y+6.2831*o));
			float d = dot( r, r );
			if( d<m.x )
				m = float3( d, o );
		}

	return float2( sqrt(m.x), m.y+m.z );
}
#endif // RANDOM_INCLUDED
