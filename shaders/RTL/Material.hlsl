#ifndef MATERIAL
#define MATERIAL

#define RTL_Materials_Count 3

//#define TRL_Material_Lambertian 1
//#define TRL_Material_Metal 2


struct RTL_Material
{
	float4 color; // r g b _
	float4 parameters; // albedo reflection refraction _

	float3 scatter(float3 rd, RTL_Random rand, RTL_Hit_Record rec)
	{
		float3 scatter_direction = rec.normal + rand.randomInSphere();

		return scatter_direction;

	}


};

RTL_Material RTL_Create_Lambertian_Material(float3 color)
{
	RTL_Material newMaterial;

	newMaterial.color = float4(color, 1);
	newMaterial.parameters = float4(1, 0, 0, 0);

	return newMaterial;
}


#endif