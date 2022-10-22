void RTL_Camera(out float3 origin, out float3 horizontal, out float3 vertical, out float3 lower_left_corner)
{
	const float aspect_ratio = 16.0 / 9.0;
    const int image_width = 400;
    const int image_height = int(image_width / aspect_ratio);

    // Camera

    float viewport_height = 2.0;
    float viewport_width = aspect_ratio * viewport_height;
    float focal_length = 1.0;

    origin = float3(0, 0, 0);
    horizontal = float3(viewport_width, 0, 0);
    vertical = float3(0, viewport_height, 0);
    lower_left_corner = origin - horizontal/2 - vertical/2 - float3(0, 0, focal_length);
}