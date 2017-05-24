#define THUNDERSTORM_BEGIN_END_EVENT_REGEX @"([BE])" REMARK_TIME_REGEX

@interface ThunderstormBeginEndRemark : Remark

@property (strong) NSMutableArray *events;

@property (strong) NSDateComponents *begin;
@property (strong) NSDateComponents *end;

@end
