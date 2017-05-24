typedef enum _ObservationType {
    ObservationTypeAutomated = 1,
    ObservationTypeAutomatedWithPrecipitation = 2,
} ObservationType;

@interface ObservationTypeRemark : Remark

@property (assign) ObservationType type;
@property (assign) bool augmented;

@end
