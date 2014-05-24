@interface Rational : NSObject

@property (assign) NSInteger numerator;
@property (assign) NSUInteger denominator;

- (id) initWith:(NSInteger)numerator over:(NSUInteger)denominator;

- (float) floatValue;
- (double) doubleValue;
- (NSString *) stringValue;
- (NSString *) ASCIIStringValue;

@end
