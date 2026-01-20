Shader "Custom/TestBlendShader"
{
    Properties
    {
        [MainColor] _BaseColor("Base Color", Color) = (1, 1, 1, 1)
        [MainTexture] _BaseMap("Base Map", 2D) = "white" {}
        [Enum(UnityEngine.Rendering.BlendMode)] 
        _SrcBlendFactor("Src Blend Factor", Float) = 1
        [Enum(UnityEngine.Rendering.BlendMode)] 
        _DstBlendFactor("Dst Blend Factor", Float) = 1
        [Enum(UnityEngine.Rendering.BlendOp)] 
        _BlendOp("Blend Op", Float) = 1
    }

    SubShader
    {
        Tags { 
            "RenderType" = "Opaque" 
            "RenderPipeline" = "UniversalPipeline" 
            "Queue" = "Transparent"
        }

        // Alpha Blend Formula (make transparent objects): 
        // source: color this shader is rendering
        // destination: color already on the screen
        // formula: source * sourceAlpha + destination * (1 - sourceAlpha)
        Blend [_SrcBlendFactor] [_DstBlendFactor]
        BlendOp [_BlendOp]

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

            TEXTURE2D(_BaseMap);
            SAMPLER(sampler_BaseMap);

            CBUFFER_START(UnityPerMaterial)
                half4 _BaseColor;
                float4 _BaseMap_ST;
            CBUFFER_END

            Varyings vert(Attributes IN)
            {
                Varyings OUT;
                OUT.positionHCS = TransformObjectToHClip(IN.positionOS.xyz);
                OUT.uv = TRANSFORM_TEX(IN.uv, _BaseMap);
                return OUT;
            }

            half4 frag(Varyings IN) : SV_Target
            {
                half4 color = SAMPLE_TEXTURE2D(_BaseMap, sampler_BaseMap, IN.uv) * _BaseColor;
                return color;
            }
            ENDHLSL
        }
    }
}
