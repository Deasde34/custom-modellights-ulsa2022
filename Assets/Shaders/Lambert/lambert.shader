
Shader "Custom/Lambert"
{
    Properties
    {
        _Albedo("Albedo color", Color) = (1, 1, 1, 1)
        _FallOff("Max falloff", Range(0.0, 0.5)) = 0.5
    }

    SubShader
    {
        Tags
        {
            "Queue" = "Geometry"
            "RenderType" = "Opaque"
        }

        CGPROGRAM

            #pragma surface surf DiffuseWrap

            float _FallOff;

            half4 LightingDiffuseWrap(SurfaceOutput s, half3 lightDir, half atten)
            {
                half NdotL = dot(s.Normal, lightDir);
                half diff = NdotL * _FallOff + _FallOff;
                half4 c;
                c.rgb = s.Albedo * _LightColor0.rgb * NdotL * atten * diff;
                c.a = s.Alpha;
                return c;
            }

            half4 _Albedo;

            struct Input
            {
                float a;
            };

            void surf(Input IN, inout SurfaceOutput o)
            {
                o.Albedo = _Albedo.rgb;
            }
        ENDCG
    }
}