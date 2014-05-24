#import "VariablePrevailingVisibilityRemark.h"

// VIS 1/2V1 1/2
static NSString *VariablePrevailingVisibilityRegex = @"\\bVIS " METAR_VISIBILITY_REGEX @"V" METAR_VISIBILITY_REGEX @"\\b\\s*";

@implementation VariablePrevailingVisibilityRemark

@synthesize low;
@synthesize high;

+ (void) load {
    [Remark registerSubclass:self];
}

- (id) initFromRemarks:(NSMutableString *)remarks forMETAR:(METAR *)METAR {
    if (self = [super initFromRemarks:remarks forMETAR:METAR]) {
        NSTextCheckingResult *match = [self matchRemarks:remarks withRegex:VariablePrevailingVisibilityRegex];
        if (!match) return (self = nil);
        
        self.low = [self.parent parseVisibilityFromMatch:match index:1 inString:remarks];
        self.high = [self.parent parseVisibilityFromMatch:match index:4 inString:remarks];
        
        [remarks deleteCharactersInRange:match.range];
    }
    return self;
}

- (RemarkUrgency)urgency {
    return UrgencyRoutine;
}

- (NSString *) stringValue {
    return [NSString localizedStringWithFormat:NSLocalizedString(@"prevailing visibility varying from %@ to %@ SM", @"remark"),
            [self.low stringValue], [self.high stringValue]];
}

@end
