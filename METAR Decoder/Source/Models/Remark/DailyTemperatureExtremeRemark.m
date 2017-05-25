#import "DailyTemperatureExtremeRemark.h"

// 401001015
// 401120084
static NSString *DailyTemperatureExtremeRegex = @"\\b4(0|1)(\\d{3})(0|1)(\\d{3})\\b\\s*";

@implementation DailyTemperatureExtremeRemark

@synthesize low;
@synthesize high;

+ (void) load {
    [Remark registerSubclass:self];
}

- (id) initFromRemarks:(NSMutableString *)remarks forMETAR:(METAR *)METAR {
    if (self = [super initFromRemarks:remarks forMETAR:METAR]) {
        NSTextCheckingResult *match = [self matchRemarks:remarks withRegex:DailyTemperatureExtremeRegex];
        if (!match) return (self = nil);
        
        NSString *codedMaxSign = [remarks substringWithRange:[match rangeAtIndex:1]];
        NSInteger maxMultiplier = ([codedMaxSign isEqualToString:@"0"] ? 1 : -1);
        NSString *codedMax = [remarks substringWithRange:[match rangeAtIndex:2]];
        self.high = [codedMax integerValue]/10.0*maxMultiplier;
        
        NSString *codedMinSign = [remarks substringWithRange:[match rangeAtIndex:3]];
        NSInteger minMultiplier = ([codedMinSign isEqualToString:@"0"] ? 1 : -1);
        NSString *codedMin = [remarks substringWithRange:[match rangeAtIndex:4]];
        self.low = [codedMin integerValue]/10.0*minMultiplier;
        
        [remarks deleteCharactersInRange:match.range];
    }
    return self;
}

- (RemarkUrgency) urgency {
    return UrgencyRoutine;
}

- (NSString *) stringValue {
    return [NSString localizedStringWithFormat:MDLocalizedString(@"METAR.Remark.DailyTemperatureExtreme", @"{low}, {high}"),
            self.low, self.high];
}

@end
