#include "Intersections.hlsl"

#define RTL_Figures_Count 3

#define RTL_Shape_Sphere 1
#define RTL_Shape_Box 2


struct RTL_Figure
{
	uint4 info;
	float4 position;
	float4 shape;
	//uint4 indices;
	
	bool Hit(float3 origin, float3 direction, out RTL_Hit_Record rec)
	{
		if (info.x == RTL_Shape_Sphere)
		{
			return RTL_Sphere_Intersection(origin, direction, float3(position.x, position.y, position.z), shape.x, rec);
		}
		else if (info.x == RTL_Shape_Box)
		{
			return RTL_Box_Intersection(origin, direction, float3(position.x, position.y, position.z), float3(shape.x, shape.y, shape.z), rec);
		}

		return false;
	}
	
};



bool RTL_World_Hit(float3 ro, float3 rd, RTL_Figure figures[RTL_Figures_Count], out RTL_Hit_Record rec)
{
    RTL_Hit_Record tmp_rec;

    bool wasHit = false;
    float max_dist = 1e+10, min_dist = 1e-4;


    for (int i = 0; i < RTL_Figures_Count; i++)
    {
        if (figures[i].Hit(ro, rd, tmp_rec) && tmp_rec.t < max_dist && tmp_rec.t > min_dist)
		{
			max_dist = tmp_rec.t;
			wasHit = true;
			rec = tmp_rec;
		}
    }


    return wasHit;
}



RTL_Figure RTL_Create_Sphere(float3 position, float radius, uint materialIndex)
{
	RTL_Figure newFigure;
	newFigure.info = uint4(RTL_Shape_Sphere, 0, 0, materialIndex);
	//newFigure.info = uint4(RTL_Shape_Sphere, 0, 0, materialIndex);
	newFigure.position = float4(position.x, position.y, position.z, 1);
	newFigure.shape = float4(radius, 1, 1, 1);
	return newFigure;
}

RTL_Figure RTL_Create_Box(float3 position, float3 size, uint materialIndex)
{
	RTL_Figure newFigure;
	newFigure.info = uint4(RTL_Shape_Box, 0, 0, materialIndex);

	newFigure.position = float4(position.x, position.y, position.z, 1);
	newFigure.shape = float4(size.x, size.y, size.z, 1);
	return newFigure;
}


/*



static const RTL_Figure RTL_Figures_Array[3] = 
{
	RTL_Create_Sphere(float3( 0, 0, -1), 1, 0),
	RTL_Create_Sphere(float3(-2, 0, -1), 1, 0),
	RTL_Create_Sphere(float3( 2, 0, -1), 1, 0)
};

*/
