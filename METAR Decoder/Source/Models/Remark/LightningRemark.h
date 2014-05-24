typedef enum _LightningType {
    LightningCloudToGround = 0,
    LightningWithinCloud,
    LightningCloudToCloud,
    LightningCloudToAir
} LightningType;

@interface LightningRemark : Remark

@property (assign) RemarkFrequency frequency;
@property (strong) NSSet *types;
@property (assign) RemarkProximity proximity;
@property (assign) DirectionMask directions;

- (NSString *) localizedType:(LightningType)type;

@end
