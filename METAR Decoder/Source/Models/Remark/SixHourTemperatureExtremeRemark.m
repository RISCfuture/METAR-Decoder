#import "SixHourTemperatureExtremeRemark.h"

// 10142
// 11021
// 21001
// 20012
static NSString *SixHourTempertureExtremeRegex = @"\\b(1|2)(0|1)(\\d{3})\\b\\s*";

@implementation SixHourTemperatureExtremeRemark

@synthesize type;
@synthesize temperature;

+ (void) load {
    [Remark registerSubclass:self];
}

- (id) initFromRemarks:(NSMutableString *)remarks forMETAR:(METAR *)METAR {
    if (self = [super initFromRemarks:remarks forMETAR:METAR]) {
        NSTextCheckingResult *match = [self matchRemarks:remarks withRegex:SixHourTempertureExtremeRegex];
        if (!match) return (self = nil);
        
        NSString *codedType = [remarks substringWithRange:[match rangeAtIndex:1]];
        if ([codedType isEqualToString:@"1"]) self.type = ExtremeHigh;
        else if ([codedType isEqualToString:@"2"]) self.type = ExtremeLow;
        
        NSString *codedSign = [remarks substringWithRange:[match rangeAtIndex:2]];
        NSInteger multiplier = ([codedSign isEqualToString:@"0"] ? 1 : -1);
        NSString *codedTemp = [remarks substringWithRange:[match rangeAtIndex:3]];
        self.temperature = [codedTemp integerValue]/10.0*multiplier;
        
        [remarks deleteCharactersInRange:match.range];
    }
    return self;
}

- (RemarkUrgency) urgency {
    return UrgencyRoutine;
}

- (NSString *) stringValue {
    switch (self.type) {
        case ExtremeLow:
            return [NSString localizedStringWithFormat:MDLocalizedString(@"METAR.Remark.SixHourTemperature.Minimum", @"{temperature}"),
                    self.temperature];
        case ExtremeHigh:
            return [NSString localizedStringWithFormat:MDLocalizedString(@"METAR.Remark.SixHourTemperature.Maximum", @"{temperature}"),
                    self.temperature];
    }
}

@end
