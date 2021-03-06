#import "SensorStatusRemark.h"

// RVRNO
// VISNO RWY11
static NSString *SensorStatusRegex = @"\\b(?:(RVRNO|PWINO|PNO|FZRANO|TSNO)|VISNO ([A-Z0-9]+)|CHINO ([A-Z0-9]+))\\b\\s*";

@implementation SensorStatusRemark

@synthesize type;
@synthesize secondaryLocation;

+ (void) load {
    [Remark registerSubclass:self];
}

- (instancetype) initFromRemarks:(NSMutableString *)remarks forMETAR:(METAR *)METAR {
    if (self = [super initFromRemarks:remarks forMETAR:METAR]) {
        NSTextCheckingResult *match = [self matchRemarks:remarks withRegex:SensorStatusRegex];
        if (!match) return (self = nil);
        
        if ([match rangeAtIndex:1].location != NSNotFound) {
            NSString *codedType = [remarks substringWithRange:[match rangeAtIndex:1]];
            self.type = [self decodeSensorType:codedType];
            self.secondaryLocation = nil;
        } else if ([match rangeAtIndex:2].location != NSNotFound) {
            self.type = SensorSecondaryVisibility;
            self.secondaryLocation = [remarks substringWithRange:[match rangeAtIndex:2]];
            
        } else if ([match rangeAtIndex:3].location != NSNotFound) {
            self.type = SensorSecondaryCeiling;
            self.secondaryLocation = [remarks substringWithRange:[match rangeAtIndex:3]];
        }
        else return (self = nil);
        
        [remarks deleteCharactersInRange:match.range];
    }
    return self;
}

- (RemarkUrgency) urgency {
    return UrgencyCaution;
}

- (NSString *) stringValue {
    switch (self.type) {
        case SensorSecondaryCeiling:
            return [NSString localizedStringWithFormat:MDLocalizedString(@"METAR.Remark.SensorStatus.CHI", @"{location}"),
                    self.secondaryLocation];
        case SensorSecondaryVisibility:
            return [NSString localizedStringWithFormat:MDLocalizedString(@"METAR.Remark.SensorStatus.VIS", @"{location}"),
                    self.secondaryLocation];
        case SensorFreezingRain:
            return MDLocalizedString(@"METAR.Remark.SensorStatus.FZRA", nil);
        case SensorLightning:
            return MDLocalizedString(@"METAR.Remark.SensorStatus.TS", nil);
        case SensorPresentWeather:
            return MDLocalizedString(@"METAR.Remark.SensorStatus.PWI", nil);
        case SensorRain:
            return MDLocalizedString(@"METAR.Remark.SensorStatus.P", nil);
        case SensorRVR:
            return MDLocalizedString(@"METAR.Remark.SensorStatus.RVR", nil);
    }
}

- (SensorType) decodeSensorType:(NSString *)string {
    if ([string isEqualToString:@"RVRNO"]) return SensorRVR;
    else if ([string isEqualToString:@"PWINO"]) return SensorPresentWeather;
    else if ([string isEqualToString:@"PNO"]) return SensorRain;
    else if ([string isEqualToString:@"FZRANO"]) return SensorFreezingRain;
    else if ([string isEqualToString:@"TSNO"]) return SensorLightning;
    else if ([string isEqualToString:@"VISNO"]) return SensorSecondaryVisibility;
    else if ([string isEqualToString:@"CHINO"]) return SensorSecondaryCeiling;
    else {
        [[NSException exceptionWithName:@"METARException" reason:@"unknown sensor" userInfo:nil] raise];
        return -1;
    }
}

@end
