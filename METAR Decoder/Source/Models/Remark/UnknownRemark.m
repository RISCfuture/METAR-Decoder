#import "UnknownRemark.h"

@implementation UnknownRemark

@synthesize remark;

- (instancetype) initFromRemarks:(NSMutableString *)remarks forMETAR:(METAR *)METAR {
    if (self = [super initFromRemarks:remarks forMETAR:METAR]) {
        self.remark = [NSMutableString new];
    }
    return self;
}

- (RemarkUrgency) urgency {
    return UrgencyUnknown;
}

- (NSString *) stringValue {
    return [NSString stringWithString:self.remark];
}

- (void) appendWord:(NSString *)word {
    if (self.remark.length > 0) [self.remark appendString:@" "];
    [self.remark appendString:word];
}

@end
