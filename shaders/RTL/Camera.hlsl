#ifndef CAMERA
#define CAMERA

#include "Random.hlsl"

struct RTL_Camera
{
    float3 origin;
    float3 horizontal;
    float3 vertical;
    float3 lower_left_corner;
    float3 w, u, v;
    float lens_radius;
	void Gen_Camera(float3 lookfrom, float3 lookat, float3 vup, float vfov, float aspect_ratio, float aperture, float focus_dist)
    {
	    //const float aspect_ratio = 1;//16.0 / 9.0;
        //const int image_width = 400;
        //const int image_height = int(image_width / aspect_ratio);

        // Camera

        float theta = vfov * 3.14159265 / 180.0;
        float h = tan(theta / 2);
        float viewport_height = 2.0 * h;
        float viewport_width = aspect_ratio * viewport_height;
        //float focal_length = 1.0;

        w = normalize(lookfrom - lookat);
        u = normalize(cross(vup, w));
        v = cross(w, u);

        origin = lookfrom;
        horizontal = focus_dist * viewport_width * u;
        vertical = focus_dist * viewport_height * v;
        lower_left_corner = origin - horizontal / 2 - vertical / 2 - focus_dist * w;

        lens_radius = aperture / 2;
    }
    void Get_Ray(float2 uv, RTL_Random rand, float antialiasing, out float3 outOrigin, out float3 outDirection)
    {
        float3 rd = lens_radius * rand.randomInDisk();
        float3 offset = u * rd.x + v * rd.y;

        outOrigin = origin + offset;
        outDirection = lower_left_corner + (uv.x + (rand.randomFloat() - 0.5) * antialiasing) * horizontal + (uv.y + (rand.randomFloat() - 0.5) * antialiasing) * vertical - origin - offset;
    }
};




#endif