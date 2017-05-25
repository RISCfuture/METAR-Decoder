#import "SignificantCloudsRemark.h"

// CB W MOV E
// CB DSNT W
// TCU W
// ACC NW
// ACSL SW-W
// APRNT ROTOR CLD NE
// CCSL S
// CB DSNT N AND NE
static NSString *SignificantCloudsRegex = @"\\b(APRNT )?" CLOUD_TYPE_REGEX @" (DSNT )?" REMARK_DIRECTIONS_REGEX @"(?: MOV " REMARK_DIRECTION_REGEX @")?\\b\\s*";

@implementation SignificantCloudsRemark

@synthesize type;
@synthesize directions;
@synthesize movingDirection;
@synthesize distant;
@synthesize apparent;

+ (void) load {
    [Remark registerSubclass:self];
}

- (id) initFromRemarks:(NSMutableString *)remarks forMETAR:(METAR *)METAR {
    if (self = [super initFromRemarks:remarks forMETAR:METAR]) {
        NSTextCheckingResult *match = [self matchRemarks:remarks withRegex:SignificantCloudsRegex];
        if (!match) return (self = nil);
        
        self.apparent = ([match rangeAtIndex:1].location != NSNotFound);
        
        NSString *codedType = [remarks substringWithRange:[match rangeAtIndex:2]];
        self.type = [self decodeCloudType:codedType];
        
        self.distant = ([match rangeAtIndex:3].location != NSNotFound);
        
        self.directions = [self parseDirectionsFromMatch:match index:4 inString:remarks];

        if (match.numberOfRanges > 8 && [match rangeAtIndex:8].location != NSNotFound) {
            NSString *codedTrend = [remarks substringWithRange:[match rangeAtIndex:6]];
            self.movingDirection = [self decodeDirection:codedTrend];
        }
        else self.movingDirection = DirectionNone;
        
        [remarks deleteCharactersInRange:match.range];
    }
    return self;
}

- (RemarkUrgency) urgency {
    return UrgencyCaution;
}


// big if statements to make it easier for translation
- (NSString *) stringValue {
    BOOL hasMoving = (self.movingDirection != DirectionNone);
    NSString *string = nil;

    if (self.apparent && hasMoving) {
        string = [NSString localizedStringWithFormat:MDLocalizedString(@"METAR.Remark.SignificantClouds.ApparentMoving", @"{type}, {direction}, {moving direction}"),
                  [self localizedCloudType:self.type],
                  [self localizedDirections:self.directions],
                  [self localizedDirection:self.movingDirection]];
    }
    else if (self.apparent) {
        string = [NSString localizedStringWithFormat:MDLocalizedString(@"METAR.Remark.SignificantClouds.Apparent", @"{type}, {direction}"),
                  [self localizedCloudType:self.type],
                  [self localizedDirections:self.directions]];

    }
    else if (hasMoving) {
        string = [NSString localizedStringWithFormat:MDLocalizedString(@"METAR.Remark.SignificantClouds.Moving", @"{type}, {direction}, {moving direction}"),
                  [self localizedCloudType:self.type],
                  [self localizedDirections:self.directions],
                  [self localizedDirection:self.movingDirection]];

    }
    else {
        string = [NSString localizedStringWithFormat:MDLocalizedString(@"METAR.Remark.SignificantClouds.NotMoving", @"{type}, {direction}"),
                  [self localizedCloudType:self.type],
                  [self localizedDirections:self.directions]];
    }
    
    if (self.distant)
        return [string stringByAppendingString:MDLocalizedString(@"METAR.Remark.SignificantClouds.Distant", @"appended to significant clouds remark")];
    else return string;
}

- (SignificantCloudType) decodeCloudType:(NSString *)string {
    if ([string isEqualToString:@"CB"]) return SignificantTypeCumulonimbus;
    else if ([string isEqualToString:@"CBMAM"]) return SignificantTypeCumulonimbusMammatus;
    else if ([string isEqualToString:@"TCU"]) return SignificantTypeToweringCumulus;
    else if ([string isEqualToString:@"ACC"]) return SignificantTypeAltocumulusCastellanus;
    else if ([string isEqualToString:@"SCSL"]) return SignificantTypeStratocumulusStandingLenticular;
    else if ([string isEqualToString:@"ACSL"]) return SignificantTypeAltocumulusStandingLenticular;
    else if ([string isEqualToString:@"CCSL"]) return SignificantTypeCirrocumulusStandingLenticular;
    else if ([string isEqualToString:@"ROTOR CLD"]) return SignificantTypeRotor;
    else {
        [[NSException exceptionWithName:@"METARException" reason:@"Unknown cloud type" userInfo:nil] raise];
        return -1;
    }
}

- (NSString *) localizedCloudType:(SignificantCloudType)cloudType {
    switch (cloudType) {
        case SignificantTypeRotor:
            return MDLocalizedString(@"METAR.Remark.SignificantClouds.Type.ROTORCLD", nil);
        case SignificantTypeCirrocumulusStandingLenticular:
            return MDLocalizedString(@"METAR.Remark.SignificantClouds.Type.CCSL", nil);
        case SignificantTypeAltocumulusStandingLenticular:
            return MDLocalizedString(@"METAR.Remark.SignificantClouds.Type.ACSL", nil);
        case SignificantTypeStratocumulusStandingLenticular:
            return MDLocalizedString(@"METAR.Remark.SignificantClouds.Type.SCSL", nil);
        case SignificantTypeAltocumulusCastellanus:
            return MDLocalizedString(@"METAR.Remark.SignificantClouds.Type.ACC", nil);
        case SignificantTypeToweringCumulus:
            return MDLocalizedString(@"METAR.Remark.SignificantClouds.Type.TCU", nil);
        case SignificantTypeCumulonimbusMammatus:
            return MDLocalizedString(@"METAR.Remark.SignificantClouds.Type.CBMAM", nil);
        case SignificantTypeCumulonimbus:
            return MDLocalizedString(@"METAR.Remark.SignificantClouds.Type.CB", nil);
    }
}

@end
