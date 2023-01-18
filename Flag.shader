Shader "Unlit/Flag"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Amplitude ("Amplitude", Range(0, 1)) = .2
        _Frequency ("Frequency", Float) = 2
        _WaveSpeed ("Wave Speed", Float) = 1
        
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define TAU 6.28318530718
            #include "UnityCG.cginc"

            struct meshdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 normal : NORMAL;
            };
            float1 _Amplitude;
            float1 _Frequency;
            float1 _WaveSpeed;

            struct interpolators
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            interpolators vert (meshdata v)
            {
                interpolators o;
                float1 yOffset = sin((v.uv.y - _Time.y * .1))*.5+.5;
                float1 tx = cos((v.uv.x + yOffset - _Time.y * _WaveSpeed) * TAU*_Frequency) *_Amplitude;
                tx *= v.uv.x;
                v.vertex.xyz += tx.x + (tx.x * v.normal) * 2;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed4 frag (interpolators i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);
                return col;
            }
            ENDCG
        }
    }
}
