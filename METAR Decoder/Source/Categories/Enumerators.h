@interface NSSet (Enumeration)

- (NSSet *) map:(id (^)(id object))block;

@end

@interface NSArray (Enumeration)

- (NSArray *) map:(id (^)(id object))block;

@end
