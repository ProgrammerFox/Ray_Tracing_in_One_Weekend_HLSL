#include "RTL/Random.hlsl"
#include "RTL/Camera.hlsl"
#include "RTL/TraceRay.hlsl"



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
	
	float3 origin;
    float3 horizontal;
    float3 vertical;
    float3 lower_left_corner;
	RTL_Camera(origin, horizontal, vertical, lower_left_corner);
	
	float3 direction = lower_left_corner + uv.x*horizontal + uv.y*vertical - origin;
	
	direction = normalize(direction);
	
	float3 color = RTL_Get_Ray_Color(origin, direction);
	
	//RTL_Random rand = RTL_Create_Random(RTL_Generate_Hash(uv) + uint(roll * 100));
	//float l = rand.randomFloat();
	

    img_output[dispatchThreadID.xy] = float4(color.x, color.y, color.z, 1);
}
