#import "SignificantCloudsRemark.h"

// CB W MOV E
// CB DSNT W
// TCU W
// ACC NW
// ACSL SW-W
// APRNT ROTOR CLD NE
// CCSL S
static NSString *SignificantCloudsRegex = @"\\b(APRNT )?" CLOUD_TYPE_REGEX @" (DSNT )?" REMARK_DIRECTION_REGEX @"(?:-" REMARK_DIRECTION_REGEX @")?(?: MOV " REMARK_DIRECTION_REGEX @")?\\b\\s*";

@implementation SignificantCloudsRemark

@synthesize type;
@synthesize direction1;
@synthesize direction2;
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
        
        NSString *codedDirection = [remarks substringWithRange:[match rangeAtIndex:4]];
        self.direction1 = [self decodeDirection:codedDirection];
        
        if ([match rangeAtIndex:5].location != NSNotFound) {
            NSString *codedDirection2 = [remarks substringWithRange:[match rangeAtIndex:5]];
            self.direction2 = [self decodeDirection:codedDirection2];
        }
        else self.direction2 = DirectionNone;
        
        if ([match rangeAtIndex:6].location != NSNotFound) {
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
    BOOL hasDir2 = (self.direction2 != DirectionNone);
    
    NSString *string = nil;
    if (self.apparent && hasDir2 && hasMoving)
        string = [NSString localizedStringWithFormat:NSLocalizedString(@"apparent %@ %@ to %@ moving %@", @"cloud type, direction to direction, moving direction"),
                  [self localizedCloudType:self.type],
                  [self localizedDirection:self.direction1],
                  [self localizedDirection:self.direction2],
                  [self localizedDirection:self.movingDirection]];
    else if (self.apparent && hasDir2)
        string = [NSString localizedStringWithFormat:NSLocalizedString(@"apparent %@ %@ to %@", @"cloud type, direction to direction"),
                  [self localizedCloudType:self.type],
                  [self localizedDirection:self.direction1],
                  [self localizedDirection:self.direction2]];
    else if (hasDir2 && hasMoving)
        string = [NSString localizedStringWithFormat:NSLocalizedString(@"%@ %@ to %@ moving %@", @"cloud type, direction to direction, moving direction"),
                  [self localizedCloudType:self.type],
                  [self localizedDirection:self.direction1],
                  [self localizedDirection:self.direction2],
                  [self localizedDirection:self.movingDirection]];
    else if (self.apparent && hasMoving)
        string = [NSString localizedStringWithFormat:NSLocalizedString(@"apparent %@ %@ moving %@", @"cloud type, direction, moving direction"),
                  [self localizedCloudType:self.type],
                  [self localizedDirection:self.direction1],
                  [self localizedDirection:self.movingDirection]];
    else if (self.apparent)
        string = [NSString localizedStringWithFormat:NSLocalizedString(@"apparent %@ %@", @"cloud type, direction"),
                  [self localizedCloudType:self.type],
                  [self localizedDirection:self.direction1]];
    else if (hasDir2)
        string = [NSString localizedStringWithFormat:NSLocalizedString(@"%@ %@ to %@", @"cloud type, direction to direction"),
                  [self localizedCloudType:self.type],
                  [self localizedDirection:self.direction1],
                  [self localizedDirection:self.direction2]];
    else if (hasMoving)
        string = [NSString localizedStringWithFormat:NSLocalizedString(@"%@ %@ moving %@", @"cloud type, direction, moving direction"),
                  [self localizedCloudType:self.type],
                  [self localizedDirection:self.direction1],
                  [self localizedDirection:self.movingDirection]];
    else
        string = [NSString localizedStringWithFormat:NSLocalizedString(@"%@ %@", @"cloud type, direction"),
                  [self localizedCloudType:self.type],
                  [self localizedDirection:self.direction1]];
    
    if (self.distant)
        return [string stringByAppendingString:NSLocalizedString(@" (distant)", @"appended to significant clouds remark")];
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
            return NSLocalizedString(@"rotor cloud", @"significant cloud type");
        case SignificantTypeCirrocumulusStandingLenticular:
            return NSLocalizedString(@"standing lenticular cirrocumulus", @"significant cloud type");
        case SignificantTypeAltocumulusStandingLenticular:
            return NSLocalizedString(@"standing lenticular altocumulus", @"significant cloud type");
        case SignificantTypeStratocumulusStandingLenticular:
            return NSLocalizedString(@"standing lenticular stratocumulus", @"significant cloud type");
        case SignificantTypeAltocumulusCastellanus:
            return NSLocalizedString(@"altocumulus castellanus", @"significant cloud type");
        case SignificantTypeToweringCumulus:
            return NSLocalizedString(@"towering cumulus", @"significant cloud type");
        case SignificantTypeCumulonimbusMammatus:
            return NSLocalizedString(@"cumulonimbus mammatus", @"significant cloud type");
        case SignificantTypeCumulonimbus:
            return NSLocalizedString(@"cumulonimbus", @"significant cloud type");
    }
}

@end
