#ifndef RANDOM
#define RANDOM

#define RTL_UINT_MAX 4294967295.0


// Hash function from H. Schechter & R. Bridson, goo.gl/RXiKaH
uint _rtlGenHash(uint s)
{
    s ^= 2747636419u;
    s *= 2654435769u;
    s ^= s >> 16;
    s *= 2654435769u;
    s ^= s >> 16;
    s *= 2654435769u;
    return s;
}

float _rtlRandom(uint seed)
{
    return float(_rtlGenHash(seed)) / RTL_UINT_MAX; // 2^32-1
}

float _rtlUVrand(float2 uv)
{
    return frac(sin(dot(uv, float2(12.9898, 78.233))) * 43758.5453);
}


struct RTL_Random
{
    uint hash;
    float randomFloat()
    {
        hash = _rtlGenHash(hash);
        return _rtlRandom(hash);
    }
    float3 randomInSphere()
    {
	    float3 rand = float3(randomFloat(), randomFloat(), randomFloat());
	    float theta = rand.x * 2.0 * 3.14159265;
	    float v = rand.y;
	    float phi = acos(2.0 * v - 1.0);
	    float r = pow(rand.z, 1.0 / 3.0);
	    float x = r * sin(phi) * cos(theta);
	    float y = r * sin(phi) * sin(theta);
	    float z = r * cos(phi);
	    return float3(x, y, z);
    }
};

RTL_Random RTL_Create_Random(int hash = 1337);

RTL_Random RTL_Create_Random(int hash)
{
    RTL_Random newRandom;
    newRandom.hash = hash;
    return newRandom;
}

uint RTL_Generate_Hash(float2 uv)
{
    return _rtlGenHash(uint(_rtlUVrand(uv) * RTL_UINT_MAX));
}

#endif