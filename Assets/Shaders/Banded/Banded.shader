Shader "Custom/Banded"
{
    Properties
    {
        _Albedo("Albedo Color", Color) = (1, 1, 1, 1)
        _Steps("Steps", Range(2.0, 100.0)) = 4.0
    }

    SubShader
    {
        Tags
        {
            "Queue" = "Geometry"
            "RenderType" = "Opaque"
        }

        CGPROGRAM

            #pragma surface surf Banded

            half4 _Albedo;
            half _Steps;

            half4 LightingBanded(SurfaceOutput s, half3 lightDir, half atten)
            {
                half NdotL = saturate(dot(s.Normal, lightDir));
                half4 c;
                half BandsMultiplier = _Steps / 256;
                half BandsAdditive = _Steps / 2;
                fixed banded = (floor((NdotL * 256 + BandsAdditive) / _Steps)) * BandsMultiplier;
                c.rgb = s.Albedo * banded * _LightColor0.rgb * atten *NdotL;
                c.a = s.Alpha;
                return c;
            }
        
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