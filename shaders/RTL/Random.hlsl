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
    return uint(_rtlUVrand(uv) * RTL_UINT_MAX);
}