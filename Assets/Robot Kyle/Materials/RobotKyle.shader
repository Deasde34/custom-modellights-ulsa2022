Shader "Custom/RobotKyle"
{
    Properties
    {
        _MainTex("Main Texture", 2D) = "white"{}
        _Albedo("Base Color", Color) = (1, 1, 1, 1)
        _RampTex("Ramp Texture", 2D) = "white"{}
        _Steps("Steps", Range(2.0, 100.0)) = 4.0
        _RimColor ("Rim Color", Color) = (0.26,0.19,0.16,0.0)
        _RimPower ("Rim Power", Range(0.5,8.0)) = 3.0
        _BumpMap ("Bumpmap", 2D) = "bump" {}
        _NormalStrength("Normal Strength",Range (-4.0,4.0))=1.0
    }

    SubShader
    {
        Tags
        {
            "Queue" = "Geometry"
            "RenderType" = "Opaque"
        }

        CGPROGRAM

        sampler2D _MainTex;
        sampler2D _RampTex;
        sampler2D _BumpMap;
        float _NormalStrength;
        half4 _Albedo;
        half _Steps;
        float4 _RimColor;
        float _RimPower;
        #pragma surface surf Banded


        
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
            float2 uv_MainTex;
            float3 viewDir;
            float2 uv_BumpMap;
        };

        void surf(Input IN, inout SurfaceOutput o)
        {
            o.Albedo = _Albedo.rgb * tex2D(_MainTex, IN.uv_MainTex).rgb;
            half rim = 1.0 - saturate(dot (normalize(IN.viewDir), o.Normal));
            o.Emission = _RimColor.rgb * pow (rim, _RimPower);
            o.Normal = UnpackNormal (tex2D (_BumpMap, IN.uv_BumpMap));
            o.Normal.z/= _NormalStrength;

        }

        ENDCG
    }
}