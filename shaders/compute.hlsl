#include "RTL/RTL.hlsl"
//#include "RTL/Camera.hlsl"
//#include "RTL/TraceRay.hlsl"



RWTexture2D<float4> img_output : register(u0);
RWStructuredBuffer<RTL_Figure> Figures : register(u1);
RWTexture2D<float4> res_img : register(u2);

cbuffer varBuffer : register(b0) {
	float roll;
	int RefreshImage;
	float4 CameraPos;
	float4 LastCameraPos;
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
	
	
	RTL_World world;
	//RTL_Figures = Figures;
	
	RTL_Material RTL_Materials_Array[4];
	RTL_Materials_Array[0] = RTL_Create_Metal_Material(float3(0.1, 0.3, 0.8), 0.2);
	RTL_Materials_Array[1] = RTL_Create_Lambertian_Material(float3(0.7, 0.1, 0.1));
	RTL_Materials_Array[2] = RTL_Create_Lambertian_Material(float3(0.3, 0.8, 0.15));
	RTL_Materials_Array[3] = RTL_Create_Dielectric_Material(float3(1, 1, 1), 1.5);
	/*
	RTL_Figure RTL_Figures_Array[50];
	RTL_Figures_Array[0] = RTL_Create_Box(float3(0, 0, 0), float3(0.5, 0.5, 0.5), 0);
	RTL_Figures_Array[1] = RTL_Create_Sphere(float3(0, 1.5, 0), 0.5, 0);
	RTL_Figures_Array[2] = RTL_Create_Box(float3(0, 0, 1.5), float3(0.5, 0.5, 0.5), 0);
	RTL_Figures_Array[3] = RTL_Create_Sphere(float3(0, 1.5, 1.5), 0.5, 0);
	RTL_Figures_Array[4] = RTL_Create_Box(float3(0, 0, 3), float3(0.5, 0.5, 0.5), 0);
	RTL_Figures_Array[5] = RTL_Create_Sphere(float3(0, 1.5, 3), 0.5, 0);
	RTL_Figures_Array[6] = RTL_Create_Box(float3(0, 0, 4.5), float3(0.5, 0.5, 0.5), 0);
	RTL_Figures_Array[7] = RTL_Create_Sphere(float3(0, 1.5, 4.5), 0.5, 0);
	RTL_Figures_Array[8] = RTL_Create_Box(float3(0, 0, 6), float3(0.5, 0.5, 0.5), 0);
	RTL_Figures_Array[9] = RTL_Create_Sphere(float3(0, 1.5, 6), 0.5, 0);
	RTL_Figures_Array[10] = RTL_Create_Box(float3(1.5, 0, 0), float3(0.5, 0.5, 0.5), 0);
	RTL_Figures_Array[11] = RTL_Create_Sphere(float3(1.5, 1.5, 0), 0.5, 0);
	RTL_Figures_Array[12] = RTL_Create_Box(float3(1.5, 0, 1.5), float3(0.5, 0.5, 0.5), 0);
	RTL_Figures_Array[13] = RTL_Create_Sphere(float3(1.5, 1.5, 1.5), 0.5, 0);
	RTL_Figures_Array[14] = RTL_Create_Box(float3(1.5, 0, 3), float3(0.5, 0.5, 0.5), 0);
	RTL_Figures_Array[15] = RTL_Create_Sphere(float3(1.5, 1.5, 3), 0.5, 0);
	RTL_Figures_Array[16] = RTL_Create_Box(float3(1.5, 0, 4.5), float3(0.5, 0.5, 0.5), 0);
	RTL_Figures_Array[17] = RTL_Create_Sphere(float3(1.5, 1.5, 4.5), 0.5, 0);
	RTL_Figures_Array[18] = RTL_Create_Box(float3(1.5, 0, 6), float3(0.5, 0.5, 0.5), 0);
	RTL_Figures_Array[19] = RTL_Create_Sphere(float3(1.5, 1.5, 6), 0.5, 0);
	RTL_Figures_Array[20] = RTL_Create_Box(float3(3, 0, 0), float3(0.5, 0.5, 0.5), 0);
	RTL_Figures_Array[21] = RTL_Create_Sphere(float3(3, 1.5, 0), 0.5, 0);
	RTL_Figures_Array[22] = RTL_Create_Box(float3(3, 0, 1.5), float3(0.5, 0.5, 0.5), 0);
	RTL_Figures_Array[23] = RTL_Create_Sphere(float3(3, 1.5, 1.5), 0.5, 0);
	RTL_Figures_Array[24] = RTL_Create_Box(float3(3, 0, 3), float3(0.5, 0.5, 0.5), 0);
	RTL_Figures_Array[25] = RTL_Create_Sphere(float3(3, 1.5, 3), 0.5, 0);
	RTL_Figures_Array[26] = RTL_Create_Box(float3(3, 0, 4.5), float3(0.5, 0.5, 0.5), 0);
	RTL_Figures_Array[27] = RTL_Create_Sphere(float3(3, 1.5, 4.5), 0.5, 0);
	RTL_Figures_Array[28] = RTL_Create_Box(float3(3, 0, 6), float3(0.5, 0.5, 0.5), 0);
	RTL_Figures_Array[29] = RTL_Create_Sphere(float3(3, 1.5, 6), 0.5, 0);
	RTL_Figures_Array[30] = RTL_Create_Box(float3(4.5, 0, 0), float3(0.5, 0.5, 0.5), 0);
	RTL_Figures_Array[31] = RTL_Create_Sphere(float3(4.5, 1.5, 0), 0.5, 0);
	RTL_Figures_Array[32] = RTL_Create_Box(float3(4.5, 0, 1.5), float3(0.5, 0.5, 0.5), 0);
	RTL_Figures_Array[33] = RTL_Create_Sphere(float3(4.5, 1.5, 1.5), 0.5, 0);
	RTL_Figures_Array[34] = RTL_Create_Box(float3(4.5, 0, 3), float3(0.5, 0.5, 0.5), 0);
	RTL_Figures_Array[35] = RTL_Create_Sphere(float3(4.5, 1.5, 3), 0.5, 0);
	RTL_Figures_Array[36] = RTL_Create_Box(float3(4.5, 0, 4.5), float3(0.5, 0.5, 0.5), 0);
	RTL_Figures_Array[37] = RTL_Create_Sphere(float3(4.5, 1.5, 4.5), 0.5, 0);
	RTL_Figures_Array[38] = RTL_Create_Box(float3(4.5, 0, 6), float3(0.5, 0.5, 0.5), 0);
	RTL_Figures_Array[39] = RTL_Create_Sphere(float3(4.5, 1.5, 6), 0.5, 0);
	RTL_Figures_Array[40] = RTL_Create_Box(float3(6, 0, 0), float3(0.5, 0.5, 0.5), 0);
	RTL_Figures_Array[41] = RTL_Create_Sphere(float3(6, 1.5, 0), 0.5, 0);
	RTL_Figures_Array[42] = RTL_Create_Box(float3(6, 0, 1.5), float3(0.5, 0.5, 0.5), 0);
	RTL_Figures_Array[43] = RTL_Create_Sphere(float3(6, 1.5, 1.5), 0.5, 0);
	RTL_Figures_Array[44] = RTL_Create_Box(float3(6, 0, 3), float3(0.5, 0.5, 0.5), 0);
	RTL_Figures_Array[45] = RTL_Create_Sphere(float3(6, 1.5, 3), 0.5, 0);
	RTL_Figures_Array[46] = RTL_Create_Box(float3(6, 0, 4.5), float3(0.5, 0.5, 0.5), 0);
	RTL_Figures_Array[47] = RTL_Create_Sphere(float3(6, 1.5, 4.5), 0.5, 0);
	RTL_Figures_Array[48] = RTL_Create_Box(float3(6, 0, 6), float3(0.5, 0.5, 0.5), 0);
	RTL_Figures_Array[49] = RTL_Create_Sphere(float3(6, 1.5, 6), 0.5, 0);
	*/
	
	RTL_Figure RTL_Figures_Array[5];
	RTL_Figures_Array[0] = RTL_Create_Box(Figures[0].position.xyz, Figures[0].shape.xyz, 1);
	RTL_Figures_Array[1] = RTL_Create_Sphere(Figures[1].position.xyz, Figures[1].shape.x, 0);
	RTL_Figures_Array[2] = RTL_Create_Sphere(Figures[2].position.xyz, Figures[2].shape.x, 2);
	RTL_Figures_Array[3] = RTL_Create_Sphere(Figures[3].position.xyz, Figures[3].shape.x, 3);
	RTL_Figures_Array[4] = RTL_Create_Box(Figures[4].position.xyz, Figures[4].shape.xyz, 1);
	
	
	float3 setOrigin = float3(0, -0.5, 0);
	
	//int tmp_id;
	//RTL_Hit_Record rec;
	float focus_dist = world.Get_Focus_Dist(CameraPos.xyz + setOrigin, normalize(-CameraPos.xyz), RTL_Figures_Array, 10);
	
	//RTL_Figures_Array[4] = RTL_Create_Sphere(float3(rec.p.x, rec.p.y, rec.p.z), 0.1, 0);
	
	//RTL_Materials_Array[tmp_id].color = 0;
	
	RTL_Camera camera;
	camera.Gen_Camera(CameraPos.xyz + setOrigin, setOrigin, float3(0, 1, 0), 45, 1, 0.15, focus_dist);
	
	float3 origin;
	//origin += 0.00001;
	float3 direction;
	camera.Get_Ray(uv + float2(0, 0.219), rand, 1e-3, origin, direction);//lower_left_corner + uv.x*horizontal + uv.y*vertical - origin;
	
	direction = normalize(direction);
	

	
	float3 color = world.Get_Ray_Color(origin, direction, rand, RTL_Figures_Array, RTL_Materials_Array);
	
	//RTL_Random rand = RTL_Create_Random(RTL_Generate_Hash(uv) + uint(roll * 100));
	//float l = rand.randomFloat();
	
	if (length(LastCameraPos - CameraPos) > 0)
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
