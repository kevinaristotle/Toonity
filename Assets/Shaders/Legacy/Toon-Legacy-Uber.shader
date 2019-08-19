Shader "Toonity/Legacy Shaders/Uber" {
    Properties {
        _Color ("Main Color", Color) = (1,1,1,1)
        _MainTex ("Base (RGB) Gloss (A)", 2D) = "white" {}
        [Toggle(ENABLE_SPECULAR)] _SpecularEnabled ("Specular?", Float) = 0
        _SpecColor ("Specular Color", Color) = (0.5, 0.5, 0.5, 1)
        [PowerSlider(5.0)] _Shininess ("Shininess", Range (0.01, 1)) = 0.078125
        [Toggle(ENABLE_NORMALMAP)] _NormalMapEnabled ("Normal Map?", Float) = 0
        _BumpMap ("Normalmap", 2D) = "bump" {}
        [Toggle(ENABLE_REFLECTION)] _ReflectionEnabled ("Reflection?", Float) = 0
        _ReflectColor ("Reflection Color", Color) = (1,1,1,0.5)
        _Cube ("Reflection Cubemap", Cube) = "" {}
        [Toggle(ENABLE_EMISSION)] _EmissionEnabled ("Emission?", Float) = 0
        _Illum ("Illumin (A)", 2D) = "white" {}
        _Emission ("Emission (Lightmapper)", Float) = 1.0
        [Toggle(ENABLE_DECAL)] _DecalEnabled ("Decal?", Float) = 0
        _DecalTex ("Decal (RGBA)", 2D) = "black" {}
        [Toggle(ENABLE_PARALLAX)] _ParallaxEnabled ("Parallax?", Float) = 0
        _Parallax ("Height", Range (0.005, 0.08)) = 0.02
        _ParallaxMap ("Heightmap (A)", 2D) = "black" {}
    }
    
    SubShader {
        Tags { "RenderType"="Opaque" }
        LOD 400
        CGPROGRAM
        #include "CGIncludes/Toon-Lighting.cginc"
        #pragma surface surf BlinnPhongToon
        #pragma target 3.5
        #pragma shader_feature ENABLE_SPECULAR
        #pragma shader_feature ENABLE_NORMALMAP
        #pragma shader_feature ENABLE_REFLECTION
        #pragma shader_feature ENABLE_EMISSION
        #pragma shader_feature ENABLE_DECAL
        #pragma shader_feature ENABLE_PARALLAX

        fixed4 _Color;
        sampler2D _MainTex;
    #if ENABLE_SPECULAR
        half _Shininess;
    #endif
    #if ENABLE_NORMALMAP
        sampler2D _BumpMap;
    #endif
    #if ENABLE_REFLECTION
        fixed4 _ReflectColor;
        samplerCUBE _Cube;
    #endif
    #if ENABLE_EMISSION
        fixed _Emission;
        sampler2D _Illum;
    #endif
    #if ENABLE_DECAL
        sampler2D _DecalTex;
    #endif
    #if ENABLE_PARALLAX
        float _Parallax;
        sampler2D _ParallaxMap;
    #endif

        struct Input {
            float2 uv_MainTex;
        #if ENABLE_NORMALMAP
            float2 uv_BumpMap;
        #endif
        #if ENABLE_REFLECTION
            float3 worldRefl;
            INTERNAL_DATA
        #endif
        #if ENABLE_EMISSION
            float2 uv_Illum;
        #endif
        #if ENABLE_DECAL
            float2 uv_DecalTex;
        #endif
        #if ENABLE_PARALLAX
            float2 uv_ParallaxMap;
            float3 viewDir;
        #endif
        };

        void surf (Input IN, inout SurfaceOutput o) {
        #if ENABLE_PARALLAX
            half h = tex2D (_ParallaxMap, IN.uv_ParallaxMap).w;
            float2 offset = ParallaxOffset (h, _Parallax, IN.viewDir);
            IN.uv_MainTex += offset;
            #if ENABLE_NORMALMAP
                IN.uv_BumpMap += offset;
            #endif
            #if ENABLE_EMISSION
                IN.uv_Illum += offset;
            #endif
        #endif
            fixed4 tex = tex2D(_MainTex, IN.uv_MainTex);
            fixed4 c = tex;
        #if ENABLE_DECAL
            half4 decal = tex2D(_DecalTex, IN.uv_DecalTex);
            c.rgb = lerp (c.rgb, decal.rgb, decal.a);
        #endif
            c *= _Color;
            o.Albedo = c.rgb;
        #if ENABLE_EMISSION
            o.Emission = c.rgb * tex2D(_Illum, IN.uv_Illum).a;
            #if defined (UNITY_PASS_META)
                o.Emission *= _Emission.rrr;
            #endif
        #endif
            o.Alpha = c.a;
        #if ENABLE_SPECULAR
            o.Gloss = tex.a;
            o.Specular = _Shininess;
        #endif
        #if ENABLE_NORMALMAP
            o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap));
        #endif
        #if ENABLE_REFLECTION
            float3 worldRefl = WorldReflectionVector (IN, o.Normal);
            fixed4 reflcol = texCUBE (_Cube, worldRefl);
            reflcol *= tex.a;
            o.Emission += reflcol.rgb * _ReflectColor.rgb;
            o.Alpha *= reflcol.a * _ReflectColor.a;
        #endif
        }
        ENDCG
    }

    FallBack "Toonity/Legacy Shaders/Diffuse"
    CustomEditor "ToonLegacyUberShaderGUI"
}