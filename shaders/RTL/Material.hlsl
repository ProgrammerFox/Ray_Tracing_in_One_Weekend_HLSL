#ifndef MATERIAL
#define MATERIAL

#define RTL_Materials_Count 5

//#define TRL_Material_Lambertian 1
//#define TRL_Material_Metal 2

float reflectance(float cosine, float ref_idx) 
{

    float r0 = (1 - ref_idx) / (1 + ref_idx);
    r0 = r0 * r0;

	float c0 = 1 - cosine;

    return r0 + (1 - r0) * (c0 * c0 * c0 * c0 * c0);
}


struct RTL_Material
{
	float4 color; // r g b _
	float4 parameters; // albedo reflection refraction _

	float3 scatter(float3 rd, RTL_Random rand, RTL_Hit_Record rec)
	{
		float3 albedo_direction = rec.normal + rand.randomInSphere();
		float3 reflected = reflect(rd, rec.normal);
		float3 metal_direction = length(rd) < 1e-3 ? rec.normal : reflected + parameters.y * rand.randomInSphere();

		float refraction_ratio = abs(parameters.w) < 1e-3 ? 1 : (rec.front_face ? (1.0 / parameters.w) : parameters.w);

		if (parameters.z > 0)
		{

			float cos_theta = min(dot(-rd, rec.normal), 1.0);
            float sin_theta = sqrt(1.0 - cos_theta * cos_theta);

            bool cannot_refract = refraction_ratio * sin_theta > 1.0;


			float3 refracted;
			
			if (cannot_refract || reflectance(cos_theta, refraction_ratio) > rand.randomFloat()) refracted = reflected;
			else refracted = refract(rd, rec.normal, refraction_ratio);
			

			return refracted;
		}

		float cos_theta = min(dot(-rd, rec.normal), 1.0);
		float3 scatter_direction = rand.randomFloat() < parameters.x || reflectance(cos_theta, refraction_ratio) < rand.randomFloat() ? albedo_direction : metal_direction;

		return normalize(scatter_direction);

	}


};

RTL_Material RTL_Create_Lambertian_Material(float3 color)
{
	RTL_Material newMaterial;

	newMaterial.color = float4(color, 1);
	newMaterial.parameters = float4(1, 0, 0, 1);

	return newMaterial;
}

RTL_Material RTL_Create_Metal_Material(float3 color, float fuzz)
{
	RTL_Material newMaterial;

	newMaterial.color = float4(color, 1);
	newMaterial.parameters = float4(0, fuzz, 0, 50);

	return newMaterial;
}

RTL_Material RTL_Create_Dielectric_Material(float3 color, float ir)
{
	RTL_Material newMaterial;

	newMaterial.color = float4(color, 1);
	newMaterial.parameters = float4(0, 0, 1, ir);

	return newMaterial;
}

RTL_Material RTL_Create_Ceramic_Material(float3 color, float fuzz, float ir)
{
	RTL_Material newMaterial;

	newMaterial.color = float4(color, 1);
	newMaterial.parameters = float4(0, fuzz, 0, ir);

	return newMaterial;
}


#endif