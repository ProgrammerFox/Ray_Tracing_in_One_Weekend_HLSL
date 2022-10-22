// The formulas were taken from the site: https://iquilezles.org/articles/intersectors/

struct RTL_Hit_Record 
{
    float3 p;
    float3 normal;
    float t;
};

bool RTL_Sphere_Intersection(float3 ro, float3 rd, float3 ce, float ra)//, out RTL_Hit_Record rec)
{
    float3 oc = ro - ce;
    float b = dot(oc, rd);
    float c = dot(oc, oc) - ra * ra;
    float d = b * b - c;
    if (d < 0.0) return false; // no intersection
    d = sqrt(d);

    //rec.t = -b - d;
    //rec.p = ro + rd * rec.t;
    //rec.normal = (rec.p - ce) / ra; 

    return true;
}



