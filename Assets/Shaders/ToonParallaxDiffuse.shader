Shader "Toonity/Toon Parallax Diffuse" {
    Properties {
        _Color ("Main Color", Color) = (1,1,1,1)
        _Parallax ("Height", Range (0.005, 0.08)) = 0.02
        _MainTex ("Base (RGB)", 2D) = "white" {}
        _BumpMap ("Normalmap", 2D) = "bump" {}
        _ParallaxMap ("Heightmap (A)", 2D) = "black" {}
    }

    CGINCLUDE
    sampler2D _MainTex;
    sampler2D _BumpMap;
    sampler2D _ParallaxMap;
    fixed4 _Color;
    float _Parallax;

    struct Input {
        float2 uv_MainTex;
        float2 uv_BumpMap;
        float3 viewDir;
    };

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

    void surf (Input IN, inout SurfaceOutput o) {
        half h = tex2D (_ParallaxMap, IN.uv_BumpMap).w;
        float2 offset = ParallaxOffset (h, _Parallax, IN.viewDir);
        IN.uv_MainTex += offset;
        IN.uv_BumpMap += offset;

        fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
        o.Albedo = c.rgb;
        o.Alpha = c.a;
        o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap));
    }
    ENDCG

    SubShader {
        Tags { "RenderType"="Opaque" }
        LOD 500

        CGPROGRAM
        #pragma surface surf LambertToon
        #pragma target 3.0
        ENDCG
    }

    SubShader {
        Tags { "RenderType"="Opaque" }
        LOD 500

        CGPROGRAM
        #pragma surface surf LambertToon nodynlightmap
        ENDCG
    }

    FallBack "Toonity/Toon Bumped Diffuse"
}
