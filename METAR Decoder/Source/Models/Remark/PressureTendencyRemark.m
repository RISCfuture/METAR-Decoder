#import "PressureTendencyRemark.h"

// 52032
static NSString *PressureTendencyRegex = @"\\b5(\\d)(\\d{3})\\b\\s*";

@implementation PressureTendencyRemark

@synthesize character;
@synthesize pressureChange;

+ (void) load {
    [Remark registerSubclass:self];
}

- (instancetype) initFromRemarks:(NSMutableString *)remarks forMETAR:(METAR *)METAR {
    if (self = [super initFromRemarks:remarks forMETAR:METAR]) {
        NSTextCheckingResult *match = [self matchRemarks:remarks withRegex:PressureTendencyRegex];
        if (!match) return (self = nil);
        
        NSString *codedCharacter = [remarks substringWithRange:[match rangeAtIndex:1]];
        self.character = (PressureCharacter)codedCharacter.integerValue;
        
        NSString *codedPressure = [remarks substringWithRange:[match rangeAtIndex:2]];
        self.pressureChange = codedPressure.integerValue/10.0;
        
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
            return [NSString localizedStringWithFormat:MDLocalizedString(@"METAR.Remark.PressureTendency.AcceleratingDown",
                                                                @"{pressure change}"),
                    self.pressureChange];
        case PressureChangeAcceleratingUp:
            return [NSString localizedStringWithFormat:MDLocalizedString(@"METAR.Remark.PressureTendency.AcceleratingUp",
                                                                @"{pressure change}"),
                    self.pressureChange];
        case PressureChangeDeceleratingDown:
            return [NSString localizedStringWithFormat:MDLocalizedString(@"METAR.Remark.PressureTendency.DeceleratingDown",
                                                                @"{pressure change}"),
                    self.pressureChange];
        case PressureChangeDeceleratingUp:
            return [NSString localizedStringWithFormat:MDLocalizedString(@"METAR.Remark.PressureTendency.DeceleratingUp",
                                                                @"{pressure change}"),
                    self.pressureChange];
        case PressureChangeInflectedDown:
            if (self.pressureChange == 0)
                return [NSString localizedStringWithFormat:MDLocalizedString(@"METAR.Remark.PressureTendency.InflectedDownNoChange",
                                                                    nil)];
            else
                return [NSString localizedStringWithFormat:MDLocalizedString(@"METAR.Remark.PressureTendency.InflectedDown",
                                                                    @"{pressure change}"),
                        self.pressureChange];
        case PressureChangeInflectedUp:
            if (self.pressureChange == 0)
                return [NSString localizedStringWithFormat:MDLocalizedString(@"METAR.Remark.PressureTendency.InflectedUpNoChange",
                                                                    nil)];
            else
                return [NSString localizedStringWithFormat:MDLocalizedString(@"METAR.Remark.PressureTendency.InflectedUp",
                                                                    @"{pressure change}"),
                        self.pressureChange];
        case PressureChangeSteadyDown:
            return [NSString localizedStringWithFormat:MDLocalizedString(@"METAR.Remark.PressureTendency.SteadyDown",
                                                                @"{pressure change}"),
                    self.pressureChange];
        case PressureChangeSteadyUp:
            return [NSString localizedStringWithFormat:MDLocalizedString(@"METAR.Remark.PressureTendency.SteadyUp",
                                                                @"{pressure change}"),
                    self.pressureChange];
        case PressureChangeZero:
            return MDLocalizedString(@"METAR.Remark.PressureTendency.Stable", nil);
    }
}

@end
