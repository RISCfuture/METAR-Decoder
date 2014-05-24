#import "WaterEquivalentDepthRemark.h"

// 933036
static NSString *WaterEquivalentDepthRegex = @"\\b933(\\d{3})\\b\\s*";

@implementation WaterEquivalentDepthRemark

@synthesize depth;

+ (void) load {
    [Remark registerSubclass:self];
}

- (id) initFromRemarks:(NSMutableString *)remarks forMETAR:(METAR *)METAR {
    if (self = [super initFromRemarks:remarks forMETAR:METAR]) {
        NSTextCheckingResult *match = [self matchRemarks:remarks withRegex:WaterEquivalentDepthRegex];
        if (!match) return (self = nil);
        
        NSString *codedDepth = [remarks substringWithRange:[match rangeAtIndex:1]];
        self.depth = [codedDepth integerValue]/10.0;
        
        [remarks deleteCharactersInRange:match.range];
    }
    return self;
}

- (RemarkUrgency) urgency {
    return UrgencyRoutine;
}

- (NSString *) stringValue {
    return [NSString localizedStringWithFormat:NSLocalizedString(@"%0.1f inches water equivalent snow depth", @"depth in inches"),
            self.depth];
}

@end