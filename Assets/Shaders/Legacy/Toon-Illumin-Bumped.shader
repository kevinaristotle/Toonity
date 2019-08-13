Shader "Toonity/Legacy Shaders/Self-Illumin/Bumped Diffuse" {
    Properties {
        _Color ("Main Color", Color) = (1,1,1,1)
        _MainTex ("Base (RGB)", 2D) = "white" {}
        _Illum ("Illumin (A)", 2D) = "white" {}
        _BumpMap ("Normalmap", 2D) = "bump" {}
        _Emission ("Emission (Lightmapper)", Float) = 1.0
    }

    CGINCLUDE
    sampler2D _MainTex;
    sampler2D _BumpMap;
    sampler2D _Illum;
    fixed4 _Color;
    fixed _Emission;

    struct Input {
        float2 uv_MainTex;
        float2 uv_Illum;
        float2 uv_BumpMap;
    };

    void surf (Input IN, inout SurfaceOutput o) {
        fixed4 tex = tex2D(_MainTex, IN.uv_MainTex);
        fixed4 c = tex * _Color;
        o.Albedo = c.rgb;
        o.Emission = c.rgb * tex2D(_Illum, IN.uv_Illum).a;
    #if defined (UNITY_PASS_META)
        o.Emission *= _Emission.rrr;
    #endif
        o.Alpha = c.a;
        o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap));
    }
    ENDCG

    SubShader {
        Tags { "RenderType"="Opaque" }
        LOD 300

        CGPROGRAM
        #include "CGIncludes/Toon-Lighting.cginc"
        #pragma surface surf LambertToon
        #pragma target 3.0
        ENDCG
    }

    SubShader {
        Tags { "RenderType"="Opaque" }
        LOD 300

        CGPROGRAM
        #include "CGIncludes/Toon-Lighting.cginc"
        #pragma surface surf LambertToon nodynlightmap
        ENDCG
    }

    FallBack "Toonity/Legacy Shaders/Self-Illumin/Diffuse"
    CustomEditor "LegacyIlluminShaderGUI"
}
