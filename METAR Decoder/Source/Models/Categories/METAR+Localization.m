#import "METAR+Localization.h"

@implementation METAR (Localization)

- (NSString *) localizedPrecipitationDescriptor:(PrecipitationDescriptor)descriptor {
    switch (descriptor) {
        case DescriptorThunderstorm:
            return MDLocalizedString(@"METAR.Common.Precipitation.Descriptor.TS", nil);
        case DescriptorShower:
            return MDLocalizedString(@"METAR.Common.Precipitation.Descriptor.SH", nil);
        case DescriptorShallow:
            return MDLocalizedString(@"METAR.Common.Precipitation.Descriptor.MI", nil);
        case DescriptorPatches:
            return MDLocalizedString(@"METAR.Common.Precipitation.Descriptor.BC", nil);
        case DescriptorPartial:
            return MDLocalizedString(@"METAR.Common.Precipitation.Descriptor.PR", nil);
        case DescriptorLowDrifting:
            return MDLocalizedString(@"METAR.Common.Precipitation.Descriptor.DR", nil);
        case DescriptorFreezing:
            return MDLocalizedString(@"METAR.Common.Precipitation.Descriptor.FZ", nil);
        case DescriptorBlowing:
            return MDLocalizedString(@"METAR.Common.Precipitation.Descriptor.BL", nil);
        default:
            return nil;
    }
}

- (NSString *) localizedPrecipitationType:(PrecipitationType)type {
    switch (type) {
        case PrecipitationRain:
            return MDLocalizedString(@"METAR.Common.Precipitation.Type.RA", nil);
        case PrecipitationDrizzle:
            return MDLocalizedString(@"METAR.Common.Precipitation.Type.DZ", nil);
        case PrecipitationSnow:
            return MDLocalizedString(@"METAR.Common.Precipitation.Type.SN", nil);
        case PrecipitationSnowGrains:
            return MDLocalizedString(@"METAR.Common.Precipitation.Type.SG", nil);
        case PrecipitationIceCrystals:
            return MDLocalizedString(@"METAR.Common.Precipitation.Type.IC", nil);
        case PrecipitationIcePellets:
            return MDLocalizedString(@"METAR.Common.Precipitation.Type.PE", nil);
        case PrecipitationHail:
            return MDLocalizedString(@"METAR.Common.Precipitation.Type.GR", nil);
        case PrecipitationSmallHail:
            return MDLocalizedString(@"METAR.Common.Precipitation.Type.GS", nil);
        case PrecipitationUnknown:
            return MDLocalizedString(@"METAR.Common.Precipitation.Type.UP", nil);
        default:
            return nil;
    }
}

- (NSString *) localizedCoverage:(CoverageAmount)coverage {
    switch (coverage) {
        case CoverageFew:
            return MDLocalizedString(@"METAR.Common.Coverage.FEW", nil);
        case CoverageScattered:
            return MDLocalizedString(@"METAR.Common.Coverage.SCT", nil);
        case CoverageBroken:
            return MDLocalizedString(@"METAR.Common.Coverage.BKN", nil);
        case CoverageOvercast:
            return MDLocalizedString(@"METAR.Common.Coverage.OVC", nil);
        default:
            return nil;
    }
}

- (NSString *) localizedObscuration:(ObscurationType)obscuration {
    switch (obscuration) {
        case ObscurationSpray:
            return MDLocalizedString(@"METAR.Common.Obscuration.PY", nil);
        case ObscurationSand:
            return MDLocalizedString(@"METAR.Common.Obscuration.SA", nil);
        case ObscurationFog:
            return MDLocalizedString(@"METAR.Common.Obscuration.FG", nil);
        case ObscurationHaze:
            return MDLocalizedString(@"METAR.Common.Obscuration.HZ", nil);
        case ObscurationMist:
            return MDLocalizedString(@"METAR.Common.Obscuration.BR", nil);
        case ObscurationSmoke:
            return MDLocalizedString(@"METAR.Common.Obscuration.FU", nil);
        case ObscurationVolcanicAsh:
            return MDLocalizedString(@"METAR.Common.Obscuration.VA", nil);
        case ObscurationWidespreadDust:
            return MDLocalizedString(@"METAR.Common.Obscuration.DU", nil);
    }
}

@end
