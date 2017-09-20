#import "METAR.h"

@implementation METAR

@synthesize airport;
@synthesize date;
@synthesize codedData;
@synthesize remarks;

- (instancetype) initWithString:(NSString *)METARString {
    if (self = [super init]) {
        NSArray *components = [METARString componentsSeparatedByString:@" "];

        self.airport = components[0];
        self.date = [self decodeDate:components[1]];

        NSUInteger remarksIndex = [components indexOfObject:@"RMK"];
        if (remarksIndex == NSNotFound)
            self.codedData = [[components subarrayWithRange:NSMakeRange(2, components.count-2)] componentsJoinedByString:@" "];
        else {
            self.codedData = [[components subarrayWithRange:NSMakeRange(2, components.count-remarksIndex-2)] componentsJoinedByString:@" "];
            self.remarks = [[components subarrayWithRange:NSMakeRange(remarksIndex+1, (components.count-remarksIndex)-1)] componentsJoinedByString:@" "];
        }
    }
    return self;
}

- (NSString *) description {
    return [NSString stringWithFormat:@"%@ %02ld%02ld%02ld %@ RMK %@",
            self.airport,
            (long)self.date.day, (long)self.self.date.hour, (long)self.date.minute,
            self.codedData, self.remarks];
}

@end
