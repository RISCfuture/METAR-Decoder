#import "TemperatureDewpointRemark.h"

// T00261015
// T0026
static NSString *TemperatureDewpointRegex = @"\\bT(0|1)(\\d{3})(?:(0|1)(\\d{3}))?\\b\\s*";

@implementation TemperatureDewpointRemark

@synthesize temperature;
@synthesize dewpoint;
@synthesize dewpointUnknown;

+ (void) load {
    [Remark registerSubclass:self];
}

- (id) initFromRemarks:(NSMutableString *)remarks forMETAR:(METAR *)METAR {
    if (self = [super initFromRemarks:remarks forMETAR:METAR]) {
        NSTextCheckingResult *match = [self matchRemarks:remarks withRegex:TemperatureDewpointRegex];
        if (!match) return (self = nil);
        
        NSString *codedTempSign = [remarks substringWithRange:[match rangeAtIndex:1]];
        NSInteger tempMultiplier = ([codedTempSign isEqualToString:@"0"] ? 1 : -1);
        NSString *codedTemp = [remarks substringWithRange:[match rangeAtIndex:2]];
        self.temperature = [codedTemp integerValue]/10.0*tempMultiplier;
        
        if ([match rangeAtIndex:3].location != NSNotFound) {
            NSString *codedDewpointSign = [remarks substringWithRange:[match rangeAtIndex:3]];
            NSInteger dewpointMultiplier = ([codedDewpointSign isEqualToString:@"0"] ? 1 : -1);
            NSString *codedDewpoint = [remarks substringWithRange:[match rangeAtIndex:4]];
            self.dewpoint = [codedDewpoint integerValue]/10.0*dewpointMultiplier;
            self.dewpointUnknown = NO;
        } else
            self.dewpointUnknown = YES;
        
        [remarks deleteCharactersInRange:match.range];
    }
    return self;
}

- (RemarkUrgency) urgency {
    return UrgencyRoutine;
}

- (NSString *) stringValue {
    if (self.dewpointUnknown)
        return [NSString localizedStringWithFormat:MDLocalizedString(@"METAR.Remark.TemperatureDewpoint.TempOnly", @"{temperature}"),
                self.temperature];
    else
        return [NSString localizedStringWithFormat:MDLocalizedString(@"METAR.Remark.TemperatureDewpoint.TempDewpoint", @"{temperature}, {dewpoint}"),
                self.temperature, self.dewpoint];
}

@end
