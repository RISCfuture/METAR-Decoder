@interface ImproperFraction : NSObject

@property (assign) NSInteger whole;
@property (strong) Rational *fraction;

- (instancetype) init NS_UNAVAILABLE;
- (instancetype) initWithWhole:(NSInteger)wholePart fraction:(Rational *)fractionalPart NS_DESIGNATED_INITIALIZER;

@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSString *stringValue;

@end
