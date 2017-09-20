#import "SectorVisibilityRemark.h"

// VIS NE 2 1/2
static NSString *SectorVisibilityRegex = @"\\bVIS " REMARK_DIRECTION_REGEX @" " METAR_VISIBILITY_REGEX @"\\b\\s*";

@implementation SectorVisibilityRemark

@synthesize direction;
@synthesize distance;

+ (void) load {
    [Remark registerSubclass:self];
}

- (instancetype) initFromRemarks:(NSMutableString *)remarks forMETAR:(METAR *)METAR {
    if (self = [super initFromRemarks:remarks forMETAR:METAR]) {
        NSTextCheckingResult *match = [self matchRemarks:remarks withRegex:SectorVisibilityRegex];
        if (!match) return (self = nil);
        
        NSString *directionString = [remarks substringWithRange:[match rangeAtIndex:1]];
        self.direction = [self decodeDirection:directionString];
        self.distance = [self.parent parseVisibilityFromMatch:match index:2 inString:remarks];
        
        [remarks deleteCharactersInRange:match.range];
    }
    return self;
}

- (NSString *) stringValue {
    return [NSString localizedStringWithFormat:MDLocalizedString(@"METAR.Remark.SectorVisibility", @"{direction}, {visibility}"),
            [self localizedDirection:self.direction], [self.distance stringValue]];
}

- (RemarkUrgency) urgency {
    return UrgencyRoutine;
}

@end
