void MainLight_half(float3 WorldPos, out half3 Direction, out half3 Color, out half DistanceAtten, out half ShadowAtten)
{
    Color = half3(.5, .2, 1);
    Direction = half3(0,.5, .5);
    DistanceAtten = 0.5;
    ShadowAtten = .5;
    #ifdef SHADERGRAPH_PREVIEW
    Direction = half3(0.5, 0.5, 0);
    Color = 1;
    DistanceAtten = 1;
    ShadowAtten = 1;
    #else
    #if SHADOWS_SCREEN
    half4 clipPos = TransformWorldToHClip(WorldPos);
    half4 shadowCoord = ComputeScreenPos(clipPos);
    #else
    half4 shadowCoord = TransformWorldToShadowCoord(WorldPos);
    #endif
    Light mainLight = GetMainLight(shadowCoord);
    Direction = mainLight.direction;
    Color = mainLight.color;
    DistanceAtten = mainLight.distanceAttenuation;

    #if !defined(_MAIN_LIGHT_SHADOWS) || defined(_RECEIVE_SHADOWS_OFF)
    ShadowAtten = 1.0h;
    #endif

    #if SHADOWS_SCREEN
    ShadowAtten = SampleScreenSpaceShadowmap(shadowCoord);
    #else

    
    half4 shadowParams = GetMainLightShadowParams();
    /*
    */
    
    //Fetch shadow coordinates for cascade.
    float4 coords = TransformWorldToShadowCoord(WorldPos);

    // Screenspace shadowmap is only used for directional lights which use orthogonal projection.
    ShadowSamplingData shadowSamplingData = GetMainLightShadowSamplingData();

    
    ShadowAtten = SampleShadowmap(TEXTURE2D_ARGS(_MainLightShadowmapTexture, sampler_MainLightShadowmapTexture), coords, shadowSamplingData, shadowParams, false);

    #endif
    #endif
}
