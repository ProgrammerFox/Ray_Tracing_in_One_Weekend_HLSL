#ifndef INTERSECTION
#define INTERSECTION

struct RTL_Hit_Record 
{
    float3 p;
    float3 normal;
    float t;
    bool front_face;
    uint material_index;

    void set_face_normal(float3 direction, const float3 outward_normal) 
    {
        front_face = dot(direction, outward_normal) < 0;
        normal = front_face ? outward_normal :-outward_normal;
    }
};

// The formulas were taken from the site: https://iquilezles.org/articles/intersectors/

bool RTL_Sphere_Intersection(float3 ro, float3 rd, float3 ce, float ra, out RTL_Hit_Record rec)
{
    float3 oc = ro - ce;
    float b = dot(oc, rd);
    float c = dot(oc, oc) - ra * ra;
    float d = b * b - c;
    if (d < 0.0) return false; // no intersection
    d = sqrt(d);

    rec.t = -b - d;
    rec.p = ro + rd * rec.t;

    float3 outward_normal = (rec.p - ce) / ra; 
    rec.set_face_normal(rd, outward_normal);

    return true;
}

bool RTL_Box_Intersection(float3 ro1, float3 rd, float3 boxPos, float3 boxSize, out RTL_Hit_Record rec) 
{
    float3 ro = ro1 - boxPos;
    float3 m = 1.0 / rd; // can precompute if traversing a set of aligned boxes
    m = float3(rd.x == 0 ? 1e+12 : m.x, rd.y == 0 ? 1e+12 : m.y, rd.z == 0 ? 1e+12 : m.z);
    float3 n = m * ro;   // can precompute if traversing a set of aligned boxes
    float3 k = abs(m) * boxSize;
    float3 t1 = -n - k;
    float3 t2 = -n + k;
    float tN = max(max(t1.x, t1.y), t1.z);
    float tF = min(min(t2.x, t2.y), t2.z);
    if( tN >= tF || tF < 0.0) return false; // no intersection
    
    rec.t = tN;
    rec.p = ro1 + rd * rec.t;
    
    float3 outward_normal = -sign(rd) * step(t1.yzx, t1.xyz) * step(t1.zxy, t1.xyz);
    rec.set_face_normal(rd, outward_normal);
    
    return true;

}

// The formulas were taken from the site: https://raytracing.github.io/books/RayTracingTheNextWeek.html

bool RTL_AABB_Intersection(float3 ro, float3 rd, float3 vec_minimum, float3 vec_maximum, out RTL_Hit_Record rec)
{
    float t_min = 1e-4;
    float t_max = 1e+10;

    float minimum[3] = { vec_minimum.x, vec_minimum.y, vec_minimum.z };
    float maximum[3] = { vec_maximum.x, vec_maximum.y, vec_maximum.z };

    float origin[3] = { ro.x, ro.y, ro.z };
    float direction[3] = { rd.x, rd.y, rd.z };

    for (int a = 0; a < 3; a++) 
    {
        float t0 = min((minimum[a] - origin[a]) / direction[a],
                       (maximum[a] - origin[a]) / direction[a]);
        float t1 = max((minimum[a] - origin[a]) / direction[a],
                       (maximum[a] - origin[a]) / direction[a]);
        t_min = max(t0, t_min);
        t_max = min(t1, t_max);
        if (t_max <= t_min)
            return false;
    }
    return true;
}

#endif