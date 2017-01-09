#import "METAR.h"

@implementation METAR

@synthesize date;
@synthesize remarks;

- (NSString *) description {
    return [NSString stringWithFormat:@"%02ld%02ld%02ld %@", (long)self.date.day, (long)self.self.date.hour, (long)self.date.minute, self.remarks];
}

@end
