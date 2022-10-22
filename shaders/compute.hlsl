#include "RTL/Random.hlsl"


RWTexture2D<float4> img_output : register(u0);

cbuffer varBuffer : register(b0) {
	float roll;
}

[numthreads(16, 16, 1)]
void main( uint3 dispatchThreadID : SV_DispatchThreadID, uint3 groupThreadID : SV_GroupThreadID, uint3 groupID : SV_GroupID )
{
	uint2 ScreenSize;
	img_output.GetDimensions(ScreenSize.x, ScreenSize.y);
	
	float2 uv = dispatchThreadID.xy / (float)ScreenSize;


	RTL_Random rand = RTL_Create_Random(RTL_Generate_Hash(uv) + uint(roll * 100));
	float l = rand.randomFloat();
	float a = _rtlUVrand(uv) * RTL_UINT_MAX;//Random(dispatchThreadID.x * 1000 + dispatchThreadID.y + roll * 100);
    img_output[dispatchThreadID.xy] = float4(l, l, l, 1);
}
