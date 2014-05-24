@interface ImproperFraction : NSObject

@property (assign) NSInteger whole;
@property (strong) Rational *fraction;

- (id) initWithWhole:(NSInteger)wholePart fraction:(Rational *)fractionalPart;

- (NSString *) stringValue;

@end
