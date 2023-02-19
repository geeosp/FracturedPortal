void LoopParalaxRandom_float(float3 ViewDirection, float2 UV, Texture2D TextureToLoop,
                             float Deepness, float Steps, float maxOffsetDistance,
                             SamplerState SS, float2 TilingDensity, out float4 Color)
{
    float stepSize = Deepness / Steps;
    float maskStep = 1.0 / Steps;

    float3 inverseView = 1 - ViewDirection;
    ViewDirection = normalize(ViewDirection);
    Color = float4(0, 0, 0, 0);

    //UV*=.3;
    float2 newUV;
    float2 distance;
    float mask;
    float filter;
    for (int currentStep = 0; currentStep < Steps; currentStep++)
    {
        distance = inverseView.xy * stepSize * currentStep;
        newUV = UV * TilingDensity + distance + 113.0 / currentStep;
        float4 sample = SAMPLE_TEXTURE2D(TextureToLoop, SS, newUV);
        mask = sample.a;
        filter = 1;
        if (mask < currentStep * maskStep || mask >= (currentStep + 1) * maskStep)
        {
            filter = 0;
        }
        float4 c = sample * (filter);
        // c/= dst(distance, float2(1,1));
        Color += c;
    }


    //Color = stepSize* float4(1, 1, 1, 1);
}
