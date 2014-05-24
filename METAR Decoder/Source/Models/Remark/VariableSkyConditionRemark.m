#import "VariableSkyConditionRemark.h"

static NSInteger HeightNotSpecified = -1;

// BKN014 V OVC
// BKN V OVC
static NSString *VariableSkyConditionRegex = @"\\b" COVERAGE_REGEX @"(\\d{3})? V " COVERAGE_REGEX;

@implementation VariableSkyConditionRemark

@synthesize coverage1;
@synthesize coverage2;
@synthesize height;

+ (void) load {
    [Remark registerSubclass:self];
}

- (id) initFromRemarks:(NSMutableString *)remarks forMETAR:(METAR *)METAR {
    if (self = [super initFromRemarks:remarks forMETAR:METAR]) {
        NSTextCheckingResult *match = [self matchRemarks:remarks withRegex:VariableSkyConditionRegex];
        if (!match) return (self = nil);
        
        NSString *codedCoverage1 = [remarks substringWithRange:[match rangeAtIndex:1]];
        self.coverage1 = [self.parent decodeCoverage:codedCoverage1];
        
        if ([match rangeAtIndex:2].location != NSNotFound) {
            NSString *codedHeight = [remarks substringWithRange:[match rangeAtIndex:2]];
            self.height = [codedHeight integerValue]*100;
        }
        else self.height = HeightNotSpecified;
        
        NSString *codedCoverage2 = [remarks substringWithRange:[match rangeAtIndex:3]];
        self.coverage2 = [self.parent decodeCoverage:codedCoverage2];
        
        [remarks deleteCharactersInRange:match.range];
    }
    return self;
}

- (RemarkUrgency) urgency {
    return UrgencyRoutine;
}

- (NSString *) stringValue {
    if (self.height == HeightNotSpecified)
        return [NSString localizedStringWithFormat:NSLocalizedString(@"sky coverage varies between %@ and %@", @"coverages"),
                [self.parent localizedCoverage:self.coverage1],
                [self.parent localizedCoverage:self.coverage2]];
    else
        return [NSString localizedStringWithFormat:NSLocalizedString(@"sky coverage varies between %@ and %@ at %ld feet", @"coverages and height"),
                [self.parent localizedCoverage:self.coverage1],
                [self.parent localizedCoverage:self.coverage2],
                self.height];
}

@end
