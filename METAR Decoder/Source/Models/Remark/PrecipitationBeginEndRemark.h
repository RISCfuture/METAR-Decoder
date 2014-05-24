typedef enum _EventType {
    EventBegan = 0,
    EventEnded
} EventType;

@interface PrecipitationEvent : NSObject

@property (assign) EventType eventType;
@property (assign) PrecipitationType precipitationType;
@property (assign) PrecipitationDescriptor descriptor;
@property (strong) NSDateComponents *time;

@end

@interface PrecipitationBeginEndRemark : Remark

@property (strong) NSArray *events;

@end
