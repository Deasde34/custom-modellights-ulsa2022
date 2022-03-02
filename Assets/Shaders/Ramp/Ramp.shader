Shader "Custom/Ramp"
{
    Properties
    {
        _MainTex("Main Texture", 2D) = "white"{}
        _Albedo("Base Color", Color) = (1, 1, 1, 1)
        _RampTex("Ramp Texture", 2D) = "white"{}
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
        fixed4 _Albedo;

        #pragma surface surf Ramp

        half4 LightingRamp(SurfaceOutput s, half3 lightDir, half atten)
        {
            float Ndotl = dot(s.Normal, lightDir);
            float wrapNdotL = Ndotl * 0.5 + 0.5;
            float2 uv_ramp = float2(wrapNdotL, 0);
            half3 ramp = tex2D(_RampTex, uv_ramp).rgb;
            half4 c = half4(1, 1, 1, 1);
            c.rgb = s.Albedo * _LightColor0.rgb * atten * ramp;
            c.a = s.Alpha;
            return c;
        }

        struct Input
        {
            float2 uv_MainTex;
        };

        void surf(Input IN, inout SurfaceOutput o)
        {
            o.Albedo = _Albedo.rgb * tex2D(_MainTex, IN.uv_MainTex).rgb;
        }

        ENDCG
    }
}