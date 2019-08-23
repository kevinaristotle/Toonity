// Toonified version of a built-in Unity shader
// Unity built-in shader source. Copyright (c) 2016 Unity Technologies. MIT license (see license.txt)

Shader "Toonity/Legacy Shaders/Parallax Diffuse" {
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
		#include "CGIncludes/Toon-Lighting.cginc"
        #pragma surface surf LambertToon
        #pragma target 3.0
        ENDCG
    }

    SubShader {
        Tags { "RenderType"="Opaque" }
        LOD 500

        CGPROGRAM
		#include "CGIncludes/Toon-Lighting.cginc"
        #pragma surface surf LambertToon nodynlightmap
        ENDCG
    }

    FallBack "Toonity/Legacy Shaders/Bumped Diffuse"
}
