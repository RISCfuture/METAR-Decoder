#import "Enumerators.h"

@implementation NSSet (Enumeration)

- (NSSet *) map:(id (^)(id object))block {
    NSMutableSet *result = [NSMutableSet setWithCapacity:self.count];
    [self enumerateObjectsUsingBlock:^(id object, BOOL *stop) {
        [result addObject:block(object)];
    }];
    return result;
}

@end

@implementation NSArray (Enumeration)

- (NSArray *) map:(id (^)(id object))block {
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:self.count];
    [self enumerateObjectsUsingBlock:^(id object, NSUInteger index, BOOL *stop) {
        [result addObject:block(object)];
    }];
    return result;
}

@end