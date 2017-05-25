#import "ObservedVisibilityRemark.h"

// TWR VIS 1 1/2
// SFC VIS 1/4
static NSString *ObservedVisibilityRegex = @"\\b(TWR|SFC) VIS " METAR_VISIBILITY_REGEX @"\\b\\s*";

@implementation ObservedVisibilityRemark

@synthesize source;
@synthesize distance;

+ (void) load {
    [Remark registerSubclass:self];
}

- (id) initFromRemarks:(NSMutableString *)remarks forMETAR:(METAR *)METAR {
    if (self = [super initFromRemarks:remarks forMETAR:METAR]) {
        NSTextCheckingResult *match = [self matchRemarks:remarks withRegex:ObservedVisibilityRegex];
        if (!match) return (self = nil);
        
        NSString *codedType = [remarks substringWithRange:[match rangeAtIndex:1]];
        if ([codedType isEqualToString:@"TWR"]) self.source = VisibilitySourceTower;
        else if ([codedType isEqualToString:@"SFC"]) self.source = VisibilitySourceSurface;
        else return (self = nil);
        
        self.distance = [self.parent parseVisibilityFromMatch:match index:2 inString:remarks];
        
        [remarks deleteCharactersInRange:match.range];
    }
    return self;
}

- (RemarkUrgency) urgency {
    return UrgencyRoutine;
}

- (NSString *) stringValue {
    switch (self.source) {
        case VisibilitySourceTower:
            return [NSString localizedStringWithFormat:MDLocalizedString(@"METAR.Remark.ObservedVisibility.Tower", @"{distance}"), [self.distance stringValue]];
        case VisibilitySourceSurface:
            return [NSString localizedStringWithFormat:MDLocalizedString(@"METAR.Remark.ObservedVisibility.Surface", @"{distance}"), [self.distance stringValue]];
    }
    
    return nil;
}

@end
