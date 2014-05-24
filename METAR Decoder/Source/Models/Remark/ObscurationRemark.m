#import "ObscurationRemark.h"

// FG SCT000
// FU BKN020
static NSString *ObscurationRegex = @"\\b" OBSCURATION_TYPE_REGEX @" " COVERAGE_REGEX @"?(\\d{3})\\b\\s*";

@implementation ObscurationRemark

@synthesize type;
@synthesize coverage;
@synthesize height;

+ (void) load {
    [Remark registerSubclass:self];
}

- (id) initFromRemarks:(NSMutableString *)remarks forMETAR:(METAR *)METAR {
    if (self = [super initFromRemarks:remarks forMETAR:METAR]) {
        NSTextCheckingResult *match = [self matchRemarks:remarks withRegex:ObscurationRegex];
        if (!match) return (self = nil);
        
        NSString *codedType = [remarks substringWithRange:[match rangeAtIndex:1]];
        self.type = [self.parent decodeObscurationType:codedType];
        
        if ([match rangeAtIndex:2].location != NSNotFound) {
            NSString *codedCoverage = [remarks substringWithRange:[match rangeAtIndex:2]];
            self.coverage = [self.parent decodeCoverage:codedCoverage];
        }
        
        NSString *heightString = [remarks substringWithRange:[match rangeAtIndex:3]];
        self.height = [heightString integerValue]*100;
        
        [remarks deleteCharactersInRange:match.range];
    }
    return self;
}

- (RemarkUrgency) urgency {
    return UrgencyRoutine;
}

- (NSString *) stringValue {
    NSString *heightString;
    if (self.height == 0)
        heightString = NSLocalizedString(@"surface", @"obscurations with height = 0");
    else
        heightString = [NSString localizedStringWithFormat:NSLocalizedString(@"%lu feet", @"height"), self.height];
    
    if (self.coverage == CoverageUnspecified)
        return [NSString localizedStringWithFormat:NSLocalizedString(@"%@ at %@", @"obscuration, height"),
                [self.parent localizedObscuration:self.type], heightString];
    else
        return [NSString localizedStringWithFormat:NSLocalizedString(@"%@ %@ at %@", @"coverage amount, obscuration, height"),
                [self.parent localizedCoverage:self.coverage],
                [self.parent localizedObscuration:self.type],
                heightString];
}

@end
