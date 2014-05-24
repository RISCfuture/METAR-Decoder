#import "PressureTendencyRemark.h"

// 52032
static NSString *PressureTendencyRegex = @"\\b5(\\d)(\\d{3})\\b\\s*";

@implementation PressureTendencyRemark

@synthesize character;
@synthesize pressureChange;

+ (void) load {
    [Remark registerSubclass:self];
}

- (id) initFromRemarks:(NSMutableString *)remarks forMETAR:(METAR *)METAR {
    if (self = [super initFromRemarks:remarks forMETAR:METAR]) {
        NSTextCheckingResult *match = [self matchRemarks:remarks withRegex:PressureTendencyRegex];
        if (!match) return (self = nil);
        
        NSString *codedCharacter = [remarks substringWithRange:[match rangeAtIndex:1]];
        self.character = (PressureCharacter)[codedCharacter integerValue];
        
        NSString *codedPressure = [remarks substringWithRange:[match rangeAtIndex:2]];
        self.pressureChange = [codedPressure integerValue]/10.0;
        
        [remarks deleteCharactersInRange:match.range];
    }
    return self;
}

- (RemarkUrgency) urgency {
    return UrgencyRoutine;
}

- (NSString *) stringValue {
    switch (self.character) {
        case PressureChangeAcceleratingDown:
            return [NSString localizedStringWithFormat:NSLocalizedString(@"barometric pressure %0.1f hPa lower than three hours ago and decreasing more rapidly",
                                                                @"pressure tendency remark"),
                    self.pressureChange];
        case PressureChangeAcceleratingUp:
            return [NSString localizedStringWithFormat:NSLocalizedString(@"barometric pressure %0.1f hPa higher than three hours ago and increasing more rapidly",
                                                                @"pressure tendency remark"),
                    self.pressureChange];
        case PressureChangeDeceleratingDown:
            return [NSString localizedStringWithFormat:NSLocalizedString(@"barometric pressure %0.1f hPa lower than three hours ago and decreasing more slowly",
                                                                @"pressure tendency remark"),
                    self.pressureChange];
        case PressureChangeDeceleratingUp:
            return [NSString localizedStringWithFormat:NSLocalizedString(@"barometric pressure %0.1f hPa higher than three hours ago and increasing more slowly",
                                                                @"pressure tendency remark"),
                    self.pressureChange];
        case PressureChangeInflectedDown:
            if (self.pressureChange == 0)
                return [NSString localizedStringWithFormat:NSLocalizedString(@"barometric pressure same as three hours ago after increasing then decreasing",
                                                                    @"pressure tendency remark"),
                        self.pressureChange];
            else
                return [NSString localizedStringWithFormat:NSLocalizedString(@"barometric pressure still %0.1f hPa higher than three hours ago despite decreasing",
                                                                    @"pressure tendency remark"),
                        self.pressureChange];
        case PressureChangeInflectedUp:
            if (self.pressureChange == 0)
                return [NSString localizedStringWithFormat:NSLocalizedString(@"barometric pressure same as three hours ago after decreasing then increasing",
                                                                    @"pressure tendency remark"),
                        self.pressureChange];
            else
                return [NSString localizedStringWithFormat:NSLocalizedString(@"barometric pressure still %0.1f hPa lower than three hours ago despite increasing",
                                                                    @"pressure tendency remark"),
                        self.pressureChange];
        case PressureChangeSteadyDown:
            return [NSString localizedStringWithFormat:NSLocalizedString(@"barometric pressure %0.1f hPa lower than three hours ago and decreasing",
                                                                @"pressure tendency remark"),
                    self.pressureChange];
        case PressureChangeSteadyUp:
            return [NSString localizedStringWithFormat:NSLocalizedString(@"barometric pressure %0.1f hPa higher than three hours ago and increasing",
                                                                @"pressure tendency remark"),
                    self.pressureChange];
        case PressureChangeZero:
            return NSLocalizedString(@"barometric pressure stable", @"pressure tendency remark");
    }
}

@end
