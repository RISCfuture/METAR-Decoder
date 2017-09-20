#import "MaintenanceRemark.h"

static NSString *MaintenanceRegex = @"\\$$";

@implementation MaintenanceRemark

+ (void) load {
    [Remark registerSubclass:self];
}

- (instancetype) initFromRemarks:(NSMutableString *)remarks forMETAR:(METAR *)METAR {
    if (self = [super initFromRemarks:remarks forMETAR:METAR]) {
        NSTextCheckingResult *match = [self matchRemarks:remarks withRegex:MaintenanceRegex];
        if (!match) return (self = nil);
        
        [remarks deleteCharactersInRange:match.range];
    }
    return self;
}

- (RemarkUrgency) urgency {
    return UrgencyRoutine;
}

- (NSString *) stringValue {
    return MDLocalizedString(@"METAR.Remark.Maintenance", nil);
}

@end
