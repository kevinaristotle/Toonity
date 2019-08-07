Shader "Toonity/Toon Diffuse" {
    Properties {
        _Color ("Main Color", Color) = (1,1,1,1)
        _MainTex ("Base (RGB)", 2D) = "white" {}
    }
    
    SubShader {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        #pragma surface surf LambertToon
        
        inline fixed4 UnityLambertLightToon (SurfaceOutput s, UnityLight light) {
            fixed diff = max (0, ceil(dot(s.Normal, light.dir)));

            fixed4 c;
            c.rgb = s.Albedo * light.color * diff;
            c.a = s.Alpha;
            return c;
        }
        
        inline fixed4 LightingLambertToon (SurfaceOutput s, UnityGI gi) {
            fixed4 c;
            c = UnityLambertLightToon (s, gi.light);

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
            gi = UnityGlobalIllumination (data, 1.0, s.Normal);
        }

        sampler2D _MainTex;
        fixed4 _Color;

        struct Input {
            float2 uv_MainTex;
        };

        void surf (Input IN, inout SurfaceOutput o) {
            fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
            o.Albedo = c.rgb;
            o.Alpha = c.a;
        }
        ENDCG
    }

    Fallback "Legacy Shaders/VertexLit"
}
