#include "RTL/Random.hlsl"
#include "RTL/Camera.hlsl"
#include "RTL/TraceRay.hlsl"



RWTexture2D<float4> img_output : register(u0);
RWStructuredBuffer<RTL_Figure> Figures : register(u1);

cbuffer varBuffer : register(b0) {
	float roll;
}



[numthreads(16, 16, 1)]
void main( uint3 dispatchThreadID : SV_DispatchThreadID, uint3 groupThreadID : SV_GroupThreadID, uint3 groupID : SV_GroupID )
{
	uint2 ScreenSize;
	img_output.GetDimensions(ScreenSize.x, ScreenSize.y);
	
	float2 uv = dispatchThreadID.xy / (float)ScreenSize;
	
	//float3 origin;
    //float3 horizontal;
    //float3 vertical;
    //float3 lower_left_corner;
	//RTL_Camera(origin, horizontal, vertical, lower_left_corner);
	
	RTL_Camera camera;
	camera.Gen_Camera();
	
	float3 origin = camera.origin;
	origin += 0.0001;
	float3 direction = camera.Get_Ray(uv);//lower_left_corner + uv.x*horizontal + uv.y*vertical - origin;
	
	direction = normalize(direction);
	
	RTL_World world;
	//RTL_Figures = Figures;
	
	RTL_Figure RTL_Figures_Array[3];
	RTL_Figures_Array[0] = RTL_Create_Sphere(Figures[0].position.xyz, Figures[0].shape.x, 0);
	RTL_Figures_Array[1] = RTL_Create_Box(Figures[1].position.xyz, Figures[1].shape.xyz, 0);
	RTL_Figures_Array[2] = RTL_Create_Sphere(Figures[2].position.xyz, Figures[2].shape.x, 0);
	
	float3 color = world.Get_Ray_Color(origin, direction, RTL_Figures_Array);
	
	//RTL_Random rand = RTL_Create_Random(RTL_Generate_Hash(uv) + uint(roll * 100));
	//float l = rand.randomFloat();
	

    img_output[dispatchThreadID.xy] = float4(color.x, color.y, color.z, 1);
}
