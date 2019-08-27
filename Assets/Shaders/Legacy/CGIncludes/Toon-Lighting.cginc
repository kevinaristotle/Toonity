// Toonified version of a built-in Unity shader
// Unity built-in shader source. Copyright (c) 2016 Unity Technologies. MIT license (see license.txt)

#ifndef TOONITY_LIGHTING_INCLUDED
#define TOONITY_LIGHTING_INCLUDED

#if ENABLE_TOONRAMP
    sampler2D _ToonRampTex;
#endif

inline fixed4 UnityLambertLightToon(SurfaceOutput s, UnityLight light) {
    fixed diff = max(0, ceil(dot(s.Normal, light.dir)));

    fixed4 c;
    c.rgb = s.Albedo * light.color * diff;
    c.a = s.Alpha;
    return c;
}

inline fixed4 LightingLambertToon(SurfaceOutput s, UnityGI gi) {
    fixed4 c;
    c = UnityLambertLightToon(s, gi.light);

    #ifdef UNITY_LIGHT_FUNCTION_APPLY_INDIRECT
        c.rgb += s.Albedo * gi.indirect.diffuse;
    #endif

    return c;
}

inline void LightingLambertToon_GI (
    SurfaceOutput s,
    UnityGIInput data,
    inout UnityGI gi)
{
    gi = UnityGlobalIllumination(data, 1.0, s.Normal);
}

inline fixed4 UnityBlinnPhongLightToon(SurfaceOutput s, half3 viewDir, UnityLight light) {
    half3 n = normalize(s.Normal);
    half3 h = normalize(light.dir + viewDir);

    #if ENABLE_TOONRAMP
        half rampLocation = dot(n, light.dir) * 0.5 + 0.5;
        fixed diff = tex2D(_ToonRampTex, half2(rampLocation, 0));
    #else
        fixed diff = max(0, ceil(dot(n, light.dir)));
    #endif

    float nh = max(0, dot(n, h));
    float spec = max(0, ceil(pow(nh, s.Specular * 32768.0)) * s.Gloss);

    fixed4 c;
    c.rgb = s.Albedo * light.color * diff + light.color * _SpecColor.rgb * spec;
    c.a = s.Alpha;

    return c;
}

inline fixed4 LightingBlinnPhongToon(SurfaceOutput s, half3 viewDir, UnityGI gi) {
    fixed4 c;
    c = UnityBlinnPhongLightToon(s, viewDir, gi.light);

    #ifdef UNITY_LIGHT_FUNCTION_APPLY_INDIRECT
        c.rgb += s.Albedo * gi.indirect.diffuse;
    #endif

    return c;
}

inline void LightingBlinnPhongToon_GI (
    SurfaceOutput s,
    UnityGIInput data,
    inout UnityGI gi)
{
    gi = UnityGlobalIllumination(data, 1.0, s.Normal);
}

#endif