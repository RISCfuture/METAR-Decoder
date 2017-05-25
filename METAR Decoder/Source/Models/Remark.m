#import "Remark.h"

@implementation Remark

@synthesize parent;
@dynamic urgency;

static NSMutableSet *subclasses = nil;
+ (void) registerSubclass:(Class)klass {
    if (!subclasses) subclasses = [NSMutableSet new];
    [subclasses addObject:NSStringFromClass(klass)];
}

+ (NSSet *) subclasses {
    return [NSSet setWithSet:subclasses];
}

- (id) initFromRemarks:(NSMutableArray *)remarks forMETAR:(METAR *)METAR {
    if (self = [super init]) {
        self.parent = METAR;
    }
    return self;
}

- (RemarkUrgency) urgency {
    return UrgencyUnknown;
}

- (NSString *) stringValue {
    return MDLocalizedString(@"METAR.Remark.Unknown", nil);
}

- (NSTextCheckingResult *) matchRemarks:(NSString *)remarks withRegex:(NSString *)regexString {
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexString
                                                                           options:0
                                                                             error:&error];
    if (error) return nil;
    
    return [regex firstMatchInString:remarks
                             options:0
                               range:NSMakeRange(0, remarks.length)];
}

@end
