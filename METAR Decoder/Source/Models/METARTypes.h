#ifndef METAR_Decoder_METARTypes_h
#define METAR_Decoder_METARTypes_h

typedef struct _Wind {
    NSUInteger direction;
    NSUInteger speed;
} Wind;

typedef enum _PrecipitationDescriptor {
    DescriptorUnspecified = -1,
    DescriptorShallow = 0,
    DescriptorPartial,
    DescriptorPatches,
    DescriptorLowDrifting,
    DescriptorBlowing,
    DescriptorShower,
    DescriptorThunderstorm,
    DescriptorFreezing
} PrecipitationDescriptor;

typedef enum _PrecipitationType {
    PrecipitationUnspecified = -1,
    PrecipitationDrizzle = 0,
    PrecipitationRain,
    PrecipitationSnow,
    PrecipitationSnowGrains,
    PrecipitationIceCrystals,
    PrecipitationIcePellets,
    PrecipitationHail,
    PrecipitationSmallHail,
    PrecipitationUnknown
} PrecipitationType;

typedef enum _ObscurationType {
    ObscurationMist = 0,
    ObscurationFog,
    ObscurationSmoke,
    ObscurationVolcanicAsh,
    ObscurationWidespreadDust,
    ObscurationSand,
    ObscurationHaze,
    ObscurationSpray
} ObscurationType;

typedef enum _CoverageAmount {
    CoverageUnspecified = -1,
    CoverageClear = 0,
    CoverageFew = 1,
    CoverageScattered = 3,
    CoverageBroken = 5,
    CoverageOvercast = 8
} CoverageAmount;

#endif
