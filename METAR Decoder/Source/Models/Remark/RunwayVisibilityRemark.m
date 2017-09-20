#import "RunwayVisibilityRemark.h"

// VIS 2 1/2 RWY11
static NSString *RunwayVisibilityRegex = @"\\bVIS " METAR_VISIBILITY_REGEX @" RWY ?(\\d{1,2}[LCR]?)\\b\\s*";

@implementation RunwayVisibilityRemark

@synthesize runway;
@synthesize distance;

+ (void) load {
    [Remark registerSubclass:self];
}

- (instancetype) initFromRemarks:(NSMutableString *)remarks forMETAR:(METAR *)METAR {
    if (self = [super initFromRemarks:remarks forMETAR:METAR]) {
        NSTextCheckingResult *match = [self matchRemarks:remarks withRegex:RunwayVisibilityRegex];
        if (!match) return (self = nil);
        
        self.distance = [self.parent parseVisibilityFromMatch:match index:1 inString:remarks];
        self.runway = [remarks substringWithRange:[match rangeAtIndex:7]];
        
        [remarks deleteCharactersInRange:match.range];
    }
    return self;
}

- (NSString *) stringValue {
    return [NSString localizedStringWithFormat:MDLocalizedString(@"METAR.Remark.RunwayVisibility", @"{runway}, {visibility}"),
            self.runway, [self.distance stringValue]];
}

- (RemarkUrgency) urgency {
    return UrgencyRoutine;
}

@end
