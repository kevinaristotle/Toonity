Shader "Toonity/Toon Bumped Specular" {
	Properties {
		_Color ("Main Color", Color) = (1,1,1,1)
		_SpecColor ("Specular Color", Color) = (0.5, 0.5, 0.5, 1)
		[PowerSlider(5.0)] _Shininess ("Shininess", Range (0.01, 1)) = 0.078125
		_MainTex ("Base (RGB) Gloss (A)", 2D) = "white" {}
		_BumpMap ("Normalmap", 2D) = "bump" {}
	}

	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 300

		CGPROGRAM
		#pragma surface surf BlinnPhongToon

		sampler2D _MainTex;
		sampler2D _BumpMap;
		fixed4 _Color;
		half _Shininess;

		inline fixed4 UnityBlinnPhongLightToon(SurfaceOutput s, half3 viewDir, UnityLight light) {
			half3 n = normalize(s.Normal);
			half3 h = normalize(light.dir + viewDir);

			fixed diff = max(0, ceil(dot(n, light.dir)));

			float nh = max(0, dot(n, h));
			float spec = max(0, ceil(pow(nh, s.Specular * 8192.0) * s.Gloss));

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

		struct Input {
			float2 uv_MainTex;
			float2 uv_BumpMap;
		};

		void surf(Input IN, inout SurfaceOutput o) {
			fixed4 tex = tex2D(_MainTex, IN.uv_MainTex);
			o.Albedo = tex.rgb * _Color.rgb;
			o.Gloss = tex.a;
			o.Alpha = tex.a * _Color.a;
			o.Specular = _Shininess;
			o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap));
		}
		ENDCG
	}

	Fallback "Toonity/Toon Specular"
}
