#import "SnowDepthRemark.h"

// 4/021
static NSString *SnowDepthRegex = @"\\b4\\/(\\d{3})\\b\\s*";

@implementation SnowDepthRemark

@synthesize depth;

+ (void) load {
    [Remark registerSubclass:self];
}

- (id) initFromRemarks:(NSMutableString *)remarks forMETAR:(METAR *)METAR {
    if (self = [super initFromRemarks:remarks forMETAR:METAR]) {
        NSTextCheckingResult *match = [self matchRemarks:remarks withRegex:SnowDepthRegex];
        if (!match) return (self = nil);
        
        NSString *codedDepth = [remarks substringWithRange:[match rangeAtIndex:1]];
        self.depth = [codedDepth integerValue];
        
        [remarks deleteCharactersInRange:match.range];
    }
    return self;
}

- (RemarkUrgency) urgency {
    return UrgencyRoutine;
}

- (NSString *) stringValue {
    return [NSString localizedStringWithFormat:NSLocalizedString(@"snow depth %lu inches", @"depth in inches"),
            self.depth];
}

@end
