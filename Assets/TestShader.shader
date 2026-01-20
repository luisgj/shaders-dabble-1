Shader "Custom/TestShader"
{
    Properties
    {
        [MainColor] _BaseColor("Base Color", Color) = (1, 1, 1, 1)
        [MainTexture] _BaseMap("Base Map", 2D) = "white" {}
    }

    SubShader
    {
        Tags { "RenderType" = "Opaque" "RenderPipeline" = "UniversalPipeline" }

        Pass
        {
            HLSLPROGRAM

            #pragma vertex vert
            #pragma fragment frag

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

            struct Attributes
            {
                float4 positionOS : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct Varyings
            {
                float4 positionHCS : SV_POSITION;
                float2 uv : TEXCOORD0;
            };

            sampler2D _BaseMap;
            // Unity built-in variable to get the texture scale and offset
            float4 _BaseMap_ST;
            half4 _BaseColor;
            float _AnimationSpeed;

            Varyings vert(Attributes IN)
            {
                Varyings OUT;
                OUT.positionHCS = TransformObjectToHClip(IN.positionOS.xyz);
                //Unity built-in function to transform UV coordinates to the correct texture space
                //_BaseMap_ST is the texture scale and offset
                //This can be used thru the inspector to scale and offset the texture
                OUT.uv = TRANSFORM_TEX(IN.uv, _BaseMap);
                //_Time.y is the time in seconds since the game started
                //float2(_Time.y, 0) is the time in seconds since the game started in the x direction
                //1.4f is the speed of the animation in the x direction
                //OUT.uv += float2(_Time.y, 0) * 1.4f; is the animation in the x direction
                OUT.uv += float2(_Time.y, 0) * 1.4f;
                //OUT.uv += float2(0, _Time.y) * 1.4f; is the animation in the y direction
                OUT.uv += float2(0, _Time.y) * 1.4f;
                return OUT;
            }

            half4 frag(Varyings IN) : SV_Target
            {
                half4 color = tex2D(_BaseMap, IN.uv) * _BaseColor;
                return color;
            }
            ENDHLSL
        }
    }
}
