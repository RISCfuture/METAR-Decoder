@interface Remark (Localization)

- (NSString *) localizedDirection:(RemarkDirection)direction;
- (NSString *) localizedDirections:(DirectionMask)directions;
- (NSString *) localizedFrequency:(RemarkFrequency)frequency;
- (NSString *) localizedProximity:(RemarkProximity)proximity;

@end
