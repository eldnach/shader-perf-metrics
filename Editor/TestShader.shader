Shader "Unlit/TestShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            struct output
            {
                fixed4 col : SV_Target;
                float depth : SV_Depth;
            };
            
            sampler2D _MainTex;
            float4 _MainTex_ST;


            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }
            #define NUM 32

            output frag (v2f i) 
            {
                output o;

                int index = int(NUM % 2);
                // uncomment netxt line to introduce dynamic indexing and disable compiler optimizations:
                index = (i.uv.x * NUM) % NUM; 
        
                float arr[NUM];   
                arr[0] = 0.0;
                arr[NUM-1] = 1.0;
                arr[index] = 0.5;

                o.col = float4( arr[0], arr[NUM-1], arr[index], 1.0);
                o.depth = 1.0;

                return o;
            }
            ENDCG
        }
    }
}
