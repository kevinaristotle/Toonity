Shader "Toonity/Toon Bumped Diffuse" {
    Properties {
        _Color ("Main Color", Color) = (1,1,1,1)
        _MainTex ("Base (RGB)", 2D) = "white" {}
        _BumpMap ("Normalmap", 2D) = "bump" {}
    }
    
    SubShader {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        #pragma surface surf LambertToon
        
        sampler2D _MainTex;
        sampler2D _BumpMap;
        fixed4 _Color;

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

        struct Input {
            float2 uv_MainTex;
            float2 uv_BumpMap;
        };

        void surf(Input IN, inout SurfaceOutput o) {
            fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
            o.Albedo = c.rgb;
            o.Alpha = c.a;
            o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap));
        }
        ENDCG
    }

    FallBack "Toonity/Toon Diffuse"
}
