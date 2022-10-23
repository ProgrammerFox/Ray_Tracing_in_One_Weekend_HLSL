#include "Figures.hlsl"


RWStructuredBuffer<RTL_Figure> RTL_Figures : register(u1);

struct RTL_World
{
    
	float3 Get_Ray_Color(float3 origin, float3 direction, RTL_Figure figures[RTL_Figures_Count]) 
    {
        
        RTL_Hit_Record rec;

        if (RTL_World_Hit(origin, direction, figures, rec))
        {
            return rec.normal * 0.5 + 0.5;
        }
        

       // if (RTL_Sphere_Intersection(origin, direction, float3(0,0,-1), 0.5, rec))
       //    return rec.normal * 0.5 + 0.5;
       float t = 0.5 * (direction.y + 1.0);
       return (1.0 - t) * float3(1.0, 1.0, 1.0) + t * float3(0.5, 0.7, 1.0);
    }
};

