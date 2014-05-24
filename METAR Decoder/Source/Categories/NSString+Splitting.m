#import "NSString+Splitting.h"

@implementation NSString (Splitting)

- (NSArray *) componentsPartitionedByLength:(NSUInteger)length {
    NSMutableArray *components = [[NSMutableArray alloc] initWithCapacity:self.length/length];
    
    NSRange range = NSMakeRange(0, length);
    while (range.location + range.length < self.length) {
        [components addObject:[self substringWithRange:range]];
        range.location += length;
    }
    
    if (range.location < self.length) {
        range.length = self.length - range.location;
        [components addObject:[self substringWithRange:range]];
    }
    
    return components;
}

@end
