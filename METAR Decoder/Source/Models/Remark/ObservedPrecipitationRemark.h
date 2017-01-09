typedef enum ObservedPrecipitationType {
    ObservedPrecipitationTypeVirga = 0,
    ObservedPrecipitationTypeShowers,
    ObservedPrecipitationTypeShoweringRain,
} ObservedPrecipitationType;

@interface ObservedPrecipitationRemark : Remark

@property (assign) ObservedPrecipitationType type;
@property (assign) RemarkProximity proximity;
@property (assign) DirectionMask directions;

@end
