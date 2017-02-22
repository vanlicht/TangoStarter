// Shader created with Shader Forge v1.32 
// Shader Forge (c) Neat Corporation / Joachim Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:1.32;sub:START;pass:START;ps:flbk:,iptp:0,cusa:False,bamd:0,lico:1,lgpr:1,limd:0,spmd:1,trmd:0,grmd:0,uamb:True,mssp:True,bkdf:False,hqlp:False,rprd:False,enco:False,rmgx:True,rpth:0,vtps:0,hqsc:True,nrmq:1,nrsp:0,vomd:0,spxs:False,tesm:0,olmd:1,culm:0,bsrc:3,bdst:7,dpts:2,wrdp:False,dith:0,rfrpo:True,rfrpn:Refraction,coma:15,ufog:False,aust:True,igpj:True,qofs:0,qpre:3,rntp:2,fgom:False,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0.5,fgcg:0.5,fgcb:0.5,fgca:1,fgde:0.01,fgrn:0,fgrf:300,stcl:False,stva:128,stmr:255,stmw:255,stcp:6,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:False,fnfb:False;n:type:ShaderForge.SFN_Final,id:3138,x:32719,y:32712,varname:node_3138,prsc:2|emission-9624-OUT,alpha-8343-OUT;n:type:ShaderForge.SFN_Color,id:7241,x:32118,y:32803,ptovrint:False,ptlb:Color,ptin:_Color,varname:node_7241,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:0.07843138,c2:0.3921569,c3:0.7843137,c4:1;n:type:ShaderForge.SFN_TexCoord,id:2245,x:31678,y:33110,varname:node_2245,prsc:2,uv:0;n:type:ShaderForge.SFN_RemapRange,id:8239,x:31852,y:33110,varname:node_8239,prsc:2,frmn:0,frmx:1,tomn:-1,tomx:1|IN-2245-UVOUT;n:type:ShaderForge.SFN_Length,id:265,x:32064,y:33127,varname:node_265,prsc:2|IN-8239-OUT;n:type:ShaderForge.SFN_Tex2d,id:9260,x:32082,y:32571,ptovrint:False,ptlb:MainTex,ptin:_MainTex,varname:node_9260,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:4e08971242de56a49ab245ef12b91e6a,ntxv:0,isnm:False;n:type:ShaderForge.SFN_OneMinus,id:7739,x:32255,y:33156,varname:node_7739,prsc:2|IN-265-OUT;n:type:ShaderForge.SFN_Multiply,id:9624,x:32336,y:32602,varname:node_9624,prsc:2|A-9260-RGB,B-7241-RGB;n:type:ShaderForge.SFN_Slider,id:1083,x:31946,y:33026,ptovrint:False,ptlb:Visibility,ptin:_Visibility,varname:node_1083,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:1,max:1;n:type:ShaderForge.SFN_Multiply,id:8343,x:32365,y:33023,varname:node_8343,prsc:2|A-1083-OUT,B-7739-OUT;proporder:7241-9260-1083;pass:END;sub:END;*/

Shader "8ninths/CircularGrid" {
    Properties {
        _Color ("Color", Color) = (0.07843138,0.3921569,0.7843137,1)
        _MainTex ("MainTex", 2D) = "white" {}
        _Visibility ("Visibility", Range(0, 1)) = 1
        [HideInInspector]_Cutoff ("Alpha cutoff", Range(0,1)) = 0.5
    }
    SubShader {
        Tags {
            "IgnoreProjector"="True"
            "Queue"="Transparent"
            "RenderType"="Transparent"
        }
        Pass {
            Name "FORWARD"
            Tags {
                "LightMode"="ForwardBase"
            }
            Blend SrcAlpha OneMinusSrcAlpha
            ZWrite Off
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_FORWARDBASE
            #include "UnityCG.cginc"
            #pragma multi_compile_fwdbase
            #pragma only_renderers d3d9 d3d11 glcore gles gles3 
            #pragma target 3.0
            uniform float4 _Color;
            uniform sampler2D _MainTex; uniform float4 _MainTex_ST;
            uniform float _Visibility;
            struct VertexInput {
                float4 vertex : POSITION;
                float2 texcoord0 : TEXCOORD0;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.pos = mul(UNITY_MATRIX_MVP, v.vertex );
                return o;
            }
            float4 frag(VertexOutput i) : COLOR {
////// Lighting:
////// Emissive:
                float4 _MainTex_var = tex2D(_MainTex,TRANSFORM_TEX(i.uv0, _MainTex));
                float3 emissive = (_MainTex_var.rgb*_Color.rgb);
                float3 finalColor = emissive;
                return fixed4(finalColor,(_Visibility*(1.0 - length((i.uv0*2.0+-1.0)))));
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
    CustomEditor "ShaderForgeMaterialInspector"
}
