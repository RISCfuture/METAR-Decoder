#import "VariablePrevailingVisibilityRemark.h"

// VIS 1/2V1 1/2
static NSString *VariablePrevailingVisibilityRegex = @"\\bVIS " METAR_VISIBILITY_REGEX @"V" METAR_VISIBILITY_REGEX @"\\b\\s*";

@implementation VariablePrevailingVisibilityRemark

@synthesize low;
@synthesize high;

+ (void) load {
    [Remark registerSubclass:self];
}

- (instancetype) initFromRemarks:(NSMutableString *)remarks forMETAR:(METAR *)METAR {
    if (self = [super initFromRemarks:remarks forMETAR:METAR]) {
        NSTextCheckingResult *match = [self matchRemarks:remarks withRegex:VariablePrevailingVisibilityRegex];
        if (!match) return (self = nil);
        
        self.low = [self.parent parseVisibilityFromMatch:match index:1 inString:remarks];
        self.high = [self.parent parseVisibilityFromMatch:match index:7 inString:remarks];
        
        [remarks deleteCharactersInRange:match.range];
    }
    return self;
}

- (RemarkUrgency)urgency {
    return UrgencyRoutine;
}

- (NSString *) stringValue {
    return [NSString localizedStringWithFormat:MDLocalizedString(@"METAR.Remark.VariablePrevailingVisibility", @"{low viz}, {high viz}"),
            [self.low stringValue], [self.high stringValue]];
}

@end
