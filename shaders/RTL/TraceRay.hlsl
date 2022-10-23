#ifndef TRACERAY
#define TRACERAY

#include "Figures.hlsl"
#include "Random.hlsl"

RWStructuredBuffer<RTL_Figure> RTL_Figures : register(u1);

struct RTL_World
{
    
	float3 Get_Ray_Color(float3 origin, float3 direction, RTL_Random rand, RTL_Figure figures[RTL_Figures_Count], RTL_Material materials[RTL_Materials_Count])
    {
        float3 color = 1;

        bool wasntHit = false;

        RTL_Hit_Record rec;

        for (int i = 0; i < 5; i++)
        {
            if (!wasntHit && RTL_World_Hit(origin, direction, figures, rec))
            {
                //color *= 0.5;
                //float3 target = rec.p + rec.normal + rand.randomInSphere();
                origin = rec.p;

                direction = materials[rec.material_index].scatter(direction, rand, rec);
                color *= materials[rec.material_index].color.xyz;
                //direction = normalize(target - origin);

                //origin = rec.p;
                //return rec.normal * 0.5 + 0.5;
            }
            else wasntHit = true;
        }

        
        if (!wasntHit) return 0;

       // if (RTL_Sphere_Intersection(origin, direction, float3(0,0,-1), 0.5, rec))
       //    return rec.normal * 0.5 + 0.5;
       float t = 0.5 * (direction.y + 1.0);
       return color * ( (1.0 - t) * float3(1.0, 1.0, 1.0) + t * float3(0.5, 0.7, 1.0) );
    }
};





#endif