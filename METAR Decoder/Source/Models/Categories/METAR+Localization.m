#import "METAR+Localization.h"

@implementation METAR (Localization)

- (NSString *) localizedPrecipitationDescriptor:(PrecipitationDescriptor)descriptor {
    switch (descriptor) {
        case DescriptorThunderstorm:
            return NSLocalizedString(@"thunderstorm", @"precipitation descriptor");
        case DescriptorShower:
            return NSLocalizedString(@"showering", @"precipitation descriptor");
        case DescriptorShallow:
            return NSLocalizedString(@"shallow", @"precipitation descriptor");
        case DescriptorPatches:
            return NSLocalizedString(@"patchy", @"precipitation descriptor");
        case DescriptorPartial:
            return NSLocalizedString(@"partial", @"precipitation descriptor");
        case DescriptorLowDrifting:
            return NSLocalizedString(@"low, drifting", @"precipitation descriptor");
        case DescriptorFreezing:
            return NSLocalizedString(@"freezing", @"precipitation descriptor");
        case DescriptorBlowing:
            return NSLocalizedString(@"blowing", @"precipitation descriptor");
        default:
            return nil;
    }
}

- (NSString *) localizedPrecipitationType:(PrecipitationType)type {
    switch (type) {
        case PrecipitationRain:
            return NSLocalizedString(@"rain", @"precipitation type");
        case PrecipitationDrizzle:
            return NSLocalizedString(@"drizzle", @"precipitation type");
        case PrecipitationSnow:
            return NSLocalizedString(@"snow", @"precipitation type");
        case PrecipitationSnowGrains:
            return NSLocalizedString(@"snow grains", @"precipitation type");
        case PrecipitationIceCrystals:
            return NSLocalizedString(@"ice crystals", @"precipitation type");
        case PrecipitationIcePellets:
            return NSLocalizedString(@"ice pellets", @"precipitation type");
        case PrecipitationHail:
            return NSLocalizedString(@"hail", @"precipitation type");
        case PrecipitationSmallHail:
            return NSLocalizedString(@"small hail", @"precipitation type");
        case PrecipitationUnknown:
            return NSLocalizedString(@"unknown precipitation", @"precipitation type");
        default:
            return nil;
    }
}

- (NSString *) localizedCoverage:(CoverageAmount)coverage {
    switch (coverage) {
        case CoverageFew:
            return NSLocalizedString(@"few", @"coverage amount");
        case CoverageScattered:
            return NSLocalizedString(@"scattered", @"coverage amount");
        case CoverageBroken:
            return NSLocalizedString(@"broken", @"coverage amount");
        case CoverageOvercast:
            return NSLocalizedString(@"overcast", @"coverage amount");
        default:
            return nil;
    }
}

- (NSString *) localizedObscuration:(ObscurationType)obscuration {
    switch (obscuration) {
        case ObscurationSpray:
            return NSLocalizedString(@"spray", @"obscuration type");
        case ObscurationSand:
            return NSLocalizedString(@"sand", @"obscuration type");
        case ObscurationFog:
            return NSLocalizedString(@"fog", @"obscuration type");
        case ObscurationHaze:
            return NSLocalizedString(@"haze", @"obscuration type");
        case ObscurationMist:
            return NSLocalizedString(@"mist", @"obscuration type");
        case ObscurationSmoke:
            return NSLocalizedString(@"smoke", @"obscuration type");
        case ObscurationVolcanicAsh:
            return NSLocalizedString(@"volcanic ash", @"obscuration type");
        case ObscurationWidespreadDust:
            return NSLocalizedString(@"widespread dust", @"obscuration type");
    }
}

@end
