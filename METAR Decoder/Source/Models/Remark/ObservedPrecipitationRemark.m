#import "ObservedPrecipitationRemark.h"

// VIRGA SW
// SH N THRU NE
static NSString *VirgaRegex = @"\\b(VIRGA|SHRA|SH)(?: " REMARK_PROXIMITY_REGEX ")?(?: " REMARK_DIRECTIONS_REGEX ")?\\b\\s*";

@implementation ObservedPrecipitationRemark

@synthesize type;
@synthesize proximity;
@synthesize directions;

+ (void) load {
    [Remark registerSubclass:self];
}

- (id) initFromRemarks:(NSMutableString *)remarks forMETAR:(METAR *)METAR {
    if (self = [super initFromRemarks:remarks forMETAR:METAR]) {
        NSTextCheckingResult *match = [self matchRemarks:remarks withRegex:VirgaRegex];
        if (!match) return (self = nil);

        NSString *codedType = [remarks substringWithRange:[match rangeAtIndex:1]];
        if ([codedType isEqualToString:@"VIRGA"]) self.type = ObservedPrecipitationTypeVirga;
        else if ([codedType isEqualToString:@"SH"]) self.type = ObservedPrecipitationTypeShowers;
        else if ([codedType isEqualToString:@"SHRA"]) self.type = ObservedPrecipitationTypeShoweringRain;
        else return (self = nil);


        if ([match rangeAtIndex:2].location != NSNotFound)
            self.proximity = [self decodeProximity:[remarks substringWithRange:[match rangeAtIndex:2]]];
        if ([match rangeAtIndex:3].location != NSNotFound)
            self.directions = [self parseDirectionsFromMatch:match index:3 inString:remarks];
        else self.directions = DirectionNone;
        
        [remarks deleteCharactersInRange:match.range];
    }
    return self;
}

- (RemarkUrgency) urgency {
    return UrgencyRoutine;
}

- (NSString *) stringValue {
    if (self.directions && self.proximity) {
        return [NSString localizedStringWithFormat:MDLocalizedString(@"METAR.Remark.ObservedPrecipitation.ProximityDirection", @"{type}, {proximity}, {direction}"),
                [self localizedType],
                [self localizedProximity:self.proximity],
                [self localizedDirections:self.directions]];
    }
    else if (self.directions) {
        return [NSString localizedStringWithFormat:MDLocalizedString(@"METAR.Remark.ObservedPrecipitation.Direction", @"{type}, {direction}"),
                [self localizedType],
                [self localizedDirections:self.directions]];

    }
    else {
        return [NSString localizedStringWithFormat:MDLocalizedString(@"%METAR.Remark.ObservedPrecipitation.TypeOnly", @"{type}"), [self localizedType]];

    }
}

- (NSString *) localizedType {
    switch (self.type) {
        case ObservedPrecipitationTypeVirga:
            return MDLocalizedString(@"METAR.Remark.ObservedPrecipitation.Type.VIRGA", nil);
        case ObservedPrecipitationTypeShowers:
            return MDLocalizedString(@"METAR.Remark.ObservedPrecipitation.Type.SH", nil);
        case ObservedPrecipitationTypeShoweringRain:
            return MDLocalizedString(@"METAR.Remark.ObservedPrecipitation.Type.SHRA", nil);
    }
}

@end
