#include "Intersections.hlsl"

float3 RTL_Get_Ray_Color(float3 origin, float3 direction) 
{
    if (RTL_Sphere_Intersection(origin, direction, float3(0,0,-1), 0.5))
        return float3(1, 0, 0);
    float t = 0.5 * (direction.y + 1.0);
    return (1.0 - t) * float3(1.0, 1.0, 1.0) + t * float3(0.5, 0.7, 1.0);
}