@interface Rational : NSObject

@property (assign) NSInteger numerator;
@property (assign) NSUInteger denominator;

- (instancetype) initWith:(NSInteger)numerator over:(NSUInteger)denominator;

@property (NS_NONATOMIC_IOSONLY, readonly) float floatValue;
@property (NS_NONATOMIC_IOSONLY, readonly) double doubleValue;
@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSString *stringValue;
@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSString *ASCIIStringValue;

@end
