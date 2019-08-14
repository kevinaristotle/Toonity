Shader "Toonity/Legacy Shaders/Uber" {
    Properties {
        _Color ("Main Color", Color) = (1,1,1,1)
        _SpecColor ("Specular Color", Color) = (0.5, 0.5, 0.5, 1)
        [PowerSlider(5.0)] _Shininess ("Shininess", Range (0.01, 1)) = 0.078125
		_Parallax ("Height", Range (0.005, 0.08)) = 0.02
		_ReflectColor ("Reflection Color", Color) = (1,1,1,0.5)
        _MainTex ("Base (RGB) Gloss (A)", 2D) = "white" {}
        _Illum ("Illumin (A)", 2D) = "white" {}
		_Cube ("Reflection Cubemap", Cube) = "" {}
        _BumpMap ("Normalmap", 2D) = "bump" {}
		_ParallaxMap ("Heightmap (A)", 2D) = "black" {}
        _Emission ("Emission (Lightmapper)", Float) = 1.0
    }
    
    SubShader {
        Tags { "RenderType"="Opaque" }
        LOD 400
        CGPROGRAM
        #include "CGIncludes/Toon-Lighting.cginc"
        #pragma surface surf BlinnPhongToon
        #pragma target 3.0

        sampler2D _MainTex;
        sampler2D _BumpMap;
		sampler2D _ParallaxMap;
        sampler2D _Illum;
		samplerCUBE _Cube;
        fixed4 _Color;
		fixed4 _ReflectColor;
		float _Parallax;
        half _Shininess;
        fixed _Emission;

        struct Input {
            float2 uv_MainTex;
            float2 uv_Illum;
            float2 uv_BumpMap;
			float3 viewDir;
			float3 worldRefl;
            INTERNAL_DATA
        };

        void surf (Input IN, inout SurfaceOutput o) {
			half h = tex2D (_ParallaxMap, IN.uv_BumpMap).w;
            float2 offset = ParallaxOffset (h, _Parallax, IN.viewDir);
            IN.uv_MainTex += offset;
            IN.uv_BumpMap += offset;
            IN.uv_Illum += offset;

            fixed4 tex = tex2D(_MainTex, IN.uv_MainTex);
            fixed4 c = tex * _Color;
            o.Albedo = c.rgb;
            o.Emission = c.rgb * tex2D(_Illum, IN.uv_Illum).a;
        #if defined (UNITY_PASS_META)
            o.Emission *= _Emission.rrr;
        #endif
            o.Gloss = tex.a;
            o.Alpha = c.a;
            o.Specular = _Shininess;
            o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap));
			float3 worldRefl = WorldReflectionVector (IN, o.Normal);
            fixed4 reflcol = texCUBE (_Cube, worldRefl);
            reflcol *= tex.a;
            o.Emission += reflcol.rgb * _ReflectColor.rgb;
            o.Alpha *= reflcol.a * _ReflectColor.a;
        }
        ENDCG
    }

    FallBack "Toonity/Legacy Shaders/Diffuse"
}
