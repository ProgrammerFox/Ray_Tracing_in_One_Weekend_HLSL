#include "RTL/RTL.hlsl"
//#include "RTL/Camera.hlsl"
//#include "RTL/TraceRay.hlsl"



RWTexture2D<float4> img_output : register(u0);
RWStructuredBuffer<RTL_Figure> Figures : register(u1);
RWTexture2D<float4> res_img : register(u2);

cbuffer varBuffer : register(b0) {
	float roll;
	int RefreshImage;
}



[numthreads(16, 16, 1)]
void main( uint3 dispatchThreadID : SV_DispatchThreadID, uint3 groupThreadID : SV_GroupThreadID, uint3 groupID : SV_GroupID )
{
	uint2 ScreenSize;
	img_output.GetDimensions(ScreenSize.x, ScreenSize.y);
	
	float2 uv = dispatchThreadID.xy / (float)ScreenSize;
	
	RTL_Random rand = RTL_Create_Random(RTL_Generate_Hash(uv) + uint(roll * 100));
	
	//float3 origin;
    //float3 horizontal;
    //float3 vertical;
    //float3 lower_left_corner;
	//RTL_Camera(origin, horizontal, vertical, lower_left_corner);
	
	RTL_Camera camera;
	camera.Gen_Camera();
	
	float3 origin = camera.origin;
	origin += 0.0001;
	float3 direction = camera.Get_Ray(uv, rand);//lower_left_corner + uv.x*horizontal + uv.y*vertical - origin;
	
	direction = normalize(direction);
	
	RTL_World world;
	//RTL_Figures = Figures;
	
	RTL_Material RTL_Materials_Array[4];
	RTL_Materials_Array[0] = RTL_Create_Metal_Material(float3(0.1, 0.3, 0.8), 0.2);
	RTL_Materials_Array[1] = RTL_Create_Lambertian_Material(float3(0.7, 0.1, 0.1));
	RTL_Materials_Array[2] = RTL_Create_Lambertian_Material(float3(0.3, 0.8, 0.15));
	RTL_Materials_Array[3] = RTL_Create_Dielectric_Material(float3(1, 1, 1), 1.5);
	
	
	RTL_Figure RTL_Figures_Array[4];
	RTL_Figures_Array[0] = RTL_Create_Sphere(Figures[0].position.xyz, Figures[0].shape.x, 0);
	RTL_Figures_Array[1] = RTL_Create_Box(Figures[1].position.xyz, Figures[1].shape.xyz, 1);
	RTL_Figures_Array[2] = RTL_Create_Sphere(Figures[2].position.xyz, Figures[2].shape.x, 2);
	RTL_Figures_Array[3] = RTL_Create_Sphere(Figures[3].position.xyz, Figures[3].shape.x, 3);
	
	float3 color = world.Get_Ray_Color(origin, direction, rand, RTL_Figures_Array, RTL_Materials_Array);
	
	//RTL_Random rand = RTL_Create_Random(RTL_Generate_Hash(uv) + uint(roll * 100));
	//float l = rand.randomFloat();
	
	if (RefreshImage > 0)
	{
		img_output[dispatchThreadID.xy] = float4(color.x, color.y, color.z, 1);
		res_img[dispatchThreadID.xy] = sqrt(img_output[dispatchThreadID.xy]);
	}
	else
	{
		img_output[dispatchThreadID.xy] += float4(color.x, color.y, color.z, 1);
		float4 res_color = img_output[dispatchThreadID.xy];
		res_img[dispatchThreadID.xy] = sqrt(res_color / res_color.w);
	}
    
}
